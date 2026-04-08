import Foundation
import CoreXLSX

// ============================================================
// MARK: - Models
// ============================================================

typealias ExerciseTagMap = [String: ExerciseDetails]

enum PainCondition: String, CaseIterable {
    case girthLimitation = "girth_limitation"
    case shortnessOfBreath = "shortness_of_breath"
    case patellaSubluxation = "patella_subluxation"
    case ankleInstability = "ankle_instability"
    case kneePain = "knee_pain"
    case wristPain = "wrist_pain"
    case lowerBackPain = "lower_back_pain"
    case footPain = "foot_pain"

    var avoidanceTag: String {
        "avoid_" + rawValue
    }

    static func fromSheetName(_ name: String) -> PainCondition? {
        let s = name.lowercased()
        if s.contains("girth") || s.contains("obese") || s.contains("obesity") { return .girthLimitation }
        if s.contains("shortness of breath") || s.contains("breath") || s.contains("asthma") { return .shortnessOfBreath }
        if s.contains("patella") || s.contains("sublux") { return .patellaSubluxation }
        if s.contains("ankle") || s.contains("rolling") { return .ankleInstability }
        if s.contains("knee") { return .kneePain }
        if s.contains("wrist") { return .wristPain }
        if s.contains("back") || s.contains("lumbar") { return .lowerBackPain }
        if s.contains("foot") || s.contains("feet") || s.contains("plantar") { return .footPain }
        return nil
    }
}

struct ExpertLabels {
    var yes: Set<String> = []
    var no: Set<String> = []
}

// ============================================================
// MARK: - Normalization / Helpers
// ============================================================

func normalizeExerciseName(_ s: String) -> String {
    s.trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: #"^\-\s*"#, with: "", options: .regularExpression)
        .lowercased()
}

func isYes(_ s: String) -> Bool {
    let t = s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    return t == "yes" || t == "y"
}

func isNo(_ s: String) -> Bool {
    let t = s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    return t == "no" || t == "n"
}

func cellString(_ cell: Cell, sharedStrings: SharedStrings?) -> String {
    if let shared = sharedStrings,
        let s = cell.stringValue(shared) {
        return s
    }
    return cell.value ?? ""
}

func loadTagMap(from url: URL) throws -> ExerciseTagMap {
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(ExerciseTagMap.self, from: data)
}

func saveTagMap(_ map: ExerciseTagMap, to url: URL) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    let data = try encoder.encode(map)
    try data.write(to: url, options: [.atomic])
}

func buildCanonicalLookup(_ tagMap: ExerciseTagMap) -> [String: String] {
    var lookup: [String: String] = [:]
    for key in tagMap.keys {
        lookup[normalizeExerciseName(key)] = key
    }
    return lookup
}

// ============================================================
// MARK: - Workbook Parsing
// ============================================================

func parseExpertWorkbook(_ workbookURL: URL) throws -> [PainCondition: ExpertLabels] {
    var result: [PainCondition: ExpertLabels] = [:]

    guard let file = XLSXFile(filepath: workbookURL.path) else {
        throw NSError(domain: "Workbook", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "Cannot open workbook"
        ])
    }

    let sharedStrings = try file.parseSharedStrings()
    let workbook = try file.parseWorkbooks().first!
    let paths = try file.parseWorksheetPathsAndNames(workbook: workbook)

    for (optionalSheetName, path) in paths {
        guard let sheetName = optionalSheetName,
                let condition = PainCondition.fromSheetName(sheetName) else { continue }
        let worksheet = try file.parseWorksheet(at: path)
        guard let rows = worksheet.data?.rows else { continue }

        var labels = ExpertLabels()

        for row in rows {
            let cells = row.cells
            guard cells.count >= 2 else { continue }

            let exerciseRaw = cellString(cells[0], sharedStrings: sharedStrings)
            let labelRaw = cellString(cells[1], sharedStrings: sharedStrings)

            let exercise = normalizeExerciseName(exerciseRaw)
            guard !exercise.isEmpty else { continue }

            if isYes(labelRaw) {
                labels.yes.insert(exercise)
            } else if isNo(labelRaw) {
                labels.no.insert(exercise)
            }
        }

        result[condition] = labels
    }

    return result
}

// ============================================================
// MARK: - Condition-specific propagation tags
// ============================================================

// These are the ONLY tags allowed to drive propagation for each condition.
// This prevents generic tags like bodyweight / low_impact from causing false propagation.
let propagationTagsByCondition: [PainCondition: Set<String>] = [
    .kneePain: [
        "jump", "run", "lunge", "squat", "deep_knee_flexion", "high_impact"
    ],
    .patellaSubluxation: [
        "jump", "run", "lunge", "squat", "deep_knee_flexion", "high_impact"
    ],
    .ankleInstability: [
        "jump", "run", "high_impact", "balance"
    ],
    .wristPain: [
        "upper_push", "overhead"
    ],
    .lowerBackPain: [
        "hinge", "core_stability"
    ],
    .footPain: [
        "jump", "run", "high_impact"
    ],
    .shortnessOfBreath: [
        "jump", "run", "high_impact"
    ],
    .girthLimitation: [
        "core_stability"
    ]
]

let stopWords: Set<String> = [
    "to", "with", "and", "the", "of", "on", "in", "a", "an"
]

func significantTokens(_ name: String) -> Set<String> {
    let cleaned = name.lowercased()
        .replacingOccurrences(of: "[^a-z0-9 ]", with: " ", options: .regularExpression)

    return Set(
        cleaned.split(separator: " ")
            .map(String.init)
            .filter { $0.count >= 3 && !stopWords.contains($0) }
    )
}

// Only uses condition-relevant tags for similarity
func similarityScore(
    condition: PainCondition,
    nameA: String,
    detailsA: ExerciseDetails,
    nameB: String,
    detailsB: ExerciseDetails
) -> Int {
    var score = 0

    let catsA = Set(detailsA.categories.map { $0.lowercased() })
    let catsB = Set(detailsB.categories.map { $0.lowercased() })
    if !catsA.isDisjoint(with: catsB) {
        score += 2
    }

    let relevantTags = propagationTagsByCondition[condition, default: []]

    let tagsA = Set(detailsA.tags).intersection(relevantTags)
    let tagsB = Set(detailsB.tags).intersection(relevantTags)
    let sharedRelevantTags = tagsA.intersection(tagsB)

    // Relevant structural tags matter most
    score += 3 * sharedRelevantTags.count

    // Name-token overlap is only a weak helper
    let tokA = significantTokens(nameA)
    let tokB = significantTokens(nameB)
    score += tokA.intersection(tokB).count

    return score
}

// ============================================================
// MARK: - Retagging with condition-aware propagation
// ============================================================

func refineTagsWithExpertLabels(
    expertLabels: [PainCondition: ExpertLabels],
    tagMap: inout ExerciseTagMap,
    similarityThreshold: Int = 4
) {
    let canonicalLookup = buildCanonicalLookup(tagMap)

    for (condition, labels) in expertLabels {
        let avoidanceTag = condition.avoidanceTag
        let relevantTags = propagationTagsByCondition[condition, default: []]

        // 1. Explicitly tag rejected exercises
        var rejectedCanonicalKeys: [String] = []

        for rejected in labels.no {
            guard let canonicalKey = canonicalLookup[rejected] else {
                print("Warning: rejected exercise not found in master list -> \(rejected)")
                continue
            }

            rejectedCanonicalKeys.append(canonicalKey)

            var details = tagMap[canonicalKey]!
            var tags = Set(details.tags)
            tags.insert(avoidanceTag)
            details.tags = Array(tags).sorted()
            tagMap[canonicalKey] = details
        }

        // 2. Propagate only through condition-relevant similarity
        for (candidateKey, candidateDetails) in tagMap {
            let normalizedCandidate = normalizeExerciseName(candidateKey)

            // Skip if explicitly approved for this condition
            if labels.yes.contains(normalizedCandidate) {
                continue
            }

            // Skip if already tagged
            if Set(candidateDetails.tags).contains(avoidanceTag) {
                continue
            }

            var shouldPropagate = false

            for rejectedKey in rejectedCanonicalKeys {
                guard let rejectedDetails = tagMap[rejectedKey] else { continue }

                // Critical protection:
                // candidate and rejected exercise must share at least one tag
                // that is actually relevant to THIS condition
                let candidateRelevant = Set(candidateDetails.tags).intersection(relevantTags)
                let rejectedRelevant = Set(rejectedDetails.tags).intersection(relevantTags)
                let sharedRelevant = candidateRelevant.intersection(rejectedRelevant)

                if sharedRelevant.isEmpty {
                    continue
                }

                let score = similarityScore(
                    condition: condition,
                    nameA: candidateKey,
                    detailsA: candidateDetails,
                    nameB: rejectedKey,
                    detailsB: rejectedDetails
                )

                if score >= similarityThreshold {
                    shouldPropagate = true
                    break
                }
            }

            if shouldPropagate {
                var details = candidateDetails
                var tags = Set(details.tags)
                tags.insert(avoidanceTag)
                details.tags = Array(tags).sorted()
                tagMap[candidateKey] = details
            }
        }
    }
}

func runRetaggingPipeline(
    workbookURL: URL,
    inputTagJSONURL: URL,
    outputTagJSONURL: URL
) throws {
    let expertLabels = try parseExpertWorkbook(workbookURL)
    var tagMap = try loadTagMap(from: inputTagJSONURL)

    refineTagsWithExpertLabels(
        expertLabels: expertLabels,
        tagMap: &tagMap,
        similarityThreshold: 4
    )

    try saveTagMap(tagMap, to: outputTagJSONURL)
}
