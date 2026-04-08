//
//  rag.swift
//  beta2
//
//  Created by admin on 20/1/26.
//

import Foundation

typealias TagMap = [String: ExerciseDetails]

func loadExerciseTags() -> TagMap {
    // Try to locate the file in Documents first (where you saved it)
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let url = docs.appendingPathComponent("tagged_exercises_all.json")
    
    do {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(TagMap.self, from: data)
    } catch {
        print("⚠️ Warning: Could not load tags from \(url.path). Using empty tags. Error: \(error)")
        // Fallback: Return empty map so the app doesn't crash, just filtering won't happen
        return [:]
    }
}

func canonKey(category: ExerciseCategory, name: String) -> String {
    "\(category.rawValue)|" + name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

func buildCanonMap(_ all:[Exercise])-> [String: Exercise] {
    var map: [String: Exercise] = [:]
    for ex in all {
        let key = canonKey(category: ex.category, name: ex.name)
        if map[key] == nil {map[key] = ex}
    }
    
    return map
}

func extractPainArea(from healthInfoString: String) -> String {
    // 1. Split the massive string at "pain areas:"
    let components = healthInfoString.components(separatedBy: "pain areas:")
    
    guard components.count > 1, let remainder = components.last else {
        return ""
    }
    
    // 2. 'remainder' now contains: " patella subluxation", "warmupexercises": [...]"
    // We split it at the next double-quote (") to discard the rest of the JSON.
    let painAreaText = remainder.components(separatedBy: "\"").first ?? ""
    
    // 3. Clean up the leftover spaces
    return painAreaText.trimmingCharacters(in: .whitespacesAndNewlines)
}

func extractConditionTokens(from lowerInfo: String) -> Set<String> {
    // Expandable keyword list
    let keywords: [String] = [
        "knee","patella","patellar","sublux","subluxation","meniscus","acl","mcl","pcl",
        "ankle","rolling ankle","rolling of the ankles","sprain","instability",
        "foot","feet",
        "wrist",
        "lower back","back",
        "shortness of breath","breathless","asthma",
        "obese","obesity","overweight","girth","large abdomen","big belly"
    ]

    var found = Set<String>()
    for k in keywords {
        if lowerInfo.contains(k) { found.insert(k) }
    }
    return found
}

func normalizeTagMap(_ tags: TagMap) -> TagMap {
    var out: TagMap = [:]
    out.reserveCapacity(tags.count)
    for (k, v) in tags {
        let nk = k.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        out[nk] = v
    }
    return out
}


//func retrieveCandidates(
//    all: [Exercise],
//    category: ExerciseCategory,
//    topK: Int,
//    tags: TagMap,
//    patientInfo: String
//) -> [Exercise] {
//    
//    // 1. Analyze Patient Info
//    let lowerInfo = patientInfo.lowercased()
//    let painArea = extractPainArea(from: lowerInfo)
//    let hasKneeIssue = painArea.contains("knee") || painArea.contains("meniscus") || painArea.contains("acl")
//    let isInjured = painArea.contains("injury") || painArea.contains("pain") || painArea.contains("recovering")
//    let needsLowImpact = painArea.contains("low impact") || hasKneeIssue || isInjured
//    
//    // Debug Print (Once per category)
//    if category == .warmup { // Just print once
//        print(lowerInfo)
//        print("--- FILTER DEBUG ---")
//        print("Patient needs low impact? \(needsLowImpact)")
//        print("Patient has knee issue? \(hasKneeIssue)")
//    }
//
//    var validCandidates: [Exercise] = []
//    var seen = Set<String>()
//
//    for ex in all where ex.category == category {
//        // Dedup
//        let k = ex.name.lowercased()
//        if seen.contains(k) { continue }
//        
//        // 🛡️ FIX: Trim whitespace before lookup
//        let cleanKey = ex.name.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        // Lookup tags
//        let exTags = tags[cleanKey]?.tags ?? []
//        
//        // 🔍 DEBUG: Print if we miss tags for a known risky exercise
//        if exTags.isEmpty && ex.name.contains("Squat") {
//             print("⚠️ WARNING: No tags found for '\(ex.name)'. Check JSON keys vs AppConstants.")
//        }
//
//        // --- FILTERING ---
//        
//        // RULE A: Low Impact
//        if needsLowImpact {
//            if exTags.contains("high_impact") { continue }
//            if exTags.contains("jump") { continue }
//            if exTags.contains("run") { continue }
//            if exTags.contains("burpee") { continue }
//        }
//        
//        // RULE B: Knee Specifics
//        if hasKneeIssue {
//            // Reject deep knee flexion unless explicitly marked friendly
//            if exTags.contains("deep_knee_flexion") && !exTags.contains("knee_friendly") {
////                 print("🚫 Rejected '\(ex.name)' due to knee issue.") // Uncomment to see rejections
//                continue
//            }
//        }
//        
//        seen.insert(k)
//        validCandidates.append(ex)
//    }
//
//    validCandidates.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
////    print(validCandidates.map{$0.name}.joined(separator: ", "))
//    return Array(validCandidates.prefix(topK))
//}
    
func retrieveCandidates(
    all: [Exercise],
    category: ExerciseCategory,
    topK: Int,
    tags rawTags: TagMap,
    patientInfo: String
) -> [Exercise] {

    let tags = normalizeTagMap(rawTags)
    let lowerInfo = patientInfo.lowercased()
    let cond = extractConditionTokens(from: lowerInfo)

    // --- condition flags ---
    let hasKneeIssue =
        cond.contains("knee") || cond.contains("meniscus") || cond.contains("acl") || cond.contains("mcl") || cond.contains("pcl") ||
        cond.contains("patella") || cond.contains("patellar") || cond.contains("sublux") || cond.contains("subluxation")

    let hasPatellaSubluxation =
        cond.contains("patella") || cond.contains("patellar") || cond.contains("sublux") || cond.contains("subluxation")

    let hasAnkleIssue =
        cond.contains("ankle") || cond.contains("rolling ankle") || cond.contains("rolling of the ankles") || cond.contains("sprain") || cond.contains("instability")

    let hasFootPain = cond.contains("foot") || cond.contains("feet")
    let hasWristPain = cond.contains("wrist")
    let hasLowerBackPain = cond.contains("lower back") || cond.contains("back")
    let hasShortnessOfBreath = cond.contains("shortness of breath") || cond.contains("breathless") || cond.contains("asthma")

    let hasGirthLimitation =
        cond.contains("obese") || cond.contains("obesity") || cond.contains("overweight") || cond.contains("girth") ||
        cond.contains("large abdomen") || cond.contains("big belly")

    // Needs low impact if *any* of these conditions are present (conservative)
    let needsLowImpact = hasShortnessOfBreath || hasKneeIssue || hasAnkleIssue || hasFootPain || lowerInfo.contains("low impact")

    // Direction-change risky keywords (for patella/ankle instability)
    func isDirectionChangeHeavy(_ name: String) -> Bool {
        let n = name.lowercased()
        return n.contains("shuffle") || n.contains("shuffles") ||
               n.contains("slide") || n.contains("slides") ||
               n.contains("carioca") ||
               n.contains("ladder") || n.contains("agility") ||
               n.contains("v-shuffle") || n.contains("v-shuffles") ||
               n.contains("side") || n.contains("lateral")
    }

    func isWristLoaded(_ name: String, exTags: [String]) -> Bool {
        let n = name.lowercased()
        if n.contains("push up") || n.contains("push-up") { return true }
        if n.contains("plank") { return true }
        if n.contains("burpee") { return true }
        if n.contains("bear crawl") || n.contains("crawling") || n.contains("crawl") { return true }
        if n.contains("dip") || n.contains("dips") { return true }
        // bodyweight upper push tends to be wrist-extending
        if exTags.contains("bodyweight") && exTags.contains("upper_push") { return true }
        return false
    }

    func isBackSensitiveCoreFlexion(_ name: String) -> Bool {
        let n = name.lowercased()
        return n.contains("crunch") || n.contains("sit up") || n.contains("sit-up") ||
               n.contains("v-sit") || n.contains("v sit") ||
               n.contains("boat") || n.contains("jack knife") || n.contains("jackknife") ||
               n.contains("roll out") || n.contains("roll-out") ||
               n.contains("toe touch") || n.contains("scoop")
    }

    func isHighVentilationInterval(_ name: String) -> Bool {
        let n = name.lowercased()
        return n.contains("interval") || n.contains("fast") || n.contains("sprint")
    }

    // --- build candidates ---
    var valid: [Exercise] = []
    var seen = Set<String>()

    for ex in all where ex.category == category {
        let dedupKey = ex.name.lowercased()
        if seen.contains(dedupKey) { continue }
        seen.insert(dedupKey)

        let lookupKey = ex.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let exTags = tags[lookupKey]?.tags ?? []
        let name = ex.name

        // RULE A: Low impact constraints
        if needsLowImpact {
            if exTags.contains("high_impact") || exTags.contains("jump") || exTags.contains("run") { continue }
            // SOB: also avoid interval/fast language even if tags missed it
            if hasShortnessOfBreath && isHighVentilationInterval(name) { continue }
        }

        // RULE B: Knee pain / knee injury
        if hasKneeIssue {
            if exTags.contains("deep_knee_flexion") && !exTags.contains("knee_friendly") { continue }
        }

        // RULE C: Patella subluxation (stricter knee instability rules)
        if hasPatellaSubluxation {
            // avoid cutting / lateral / agility
            if isDirectionChangeHeavy(name) { continue }
            // avoid jump/run regardless
            if exTags.contains("jump") || exTags.contains("run") || exTags.contains("high_impact") { continue }
        }

        // RULE D: Rolling ankles / ankle instability
        if hasAnkleIssue {
            if isDirectionChangeHeavy(name) { continue }
            if exTags.contains("jump") || exTags.contains("high_impact") { continue }
            // even “run” can be risky if stopping/starting is involved
            if exTags.contains("run") { continue }
        }

        // RULE E: Foot pain
        if hasFootPain {
            if exTags.contains("run") || exTags.contains("jump") || exTags.contains("high_impact") { continue }
            // conservative: avoid step-based cardio
            let n = name.lowercased()
            if n.contains("step") || n.contains("treadmill") || n.contains("ladder") || n.contains("shuttle") { continue }
        }

        // RULE F: Wrist pain
        if hasWristPain {
            if isWristLoaded(name, exTags: exTags) { continue }
        }

        // RULE G: Lower back pain
        if hasLowerBackPain {
            if exTags.contains("hinge") { continue }
            if exTags.contains("high_impact") { continue }
            let n = name.lowercased()
            if n.contains("rotation") || n.contains("wood chop") || n.contains("chop") { continue }
            if isBackSensitiveCoreFlexion(name) { continue }
        }

        // RULE H: Girth limiting technique (e.g., sit-ups for obese individuals)
        if hasGirthLimitation {
            // conservative exclusion of floor core flexion / long-lever core
            if isBackSensitiveCoreFlexion(name) { continue }
            // optionally exclude planks too (often hard with large abdomen)
            if name.lowercased().contains("plank") { continue }
        }

        valid.append(ex)
    }
//    if category == .core {
//        print("printing valid for core")
//        print(valid)
//    }
    valid.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    return Array(valid.prefix(topK))
}


func selectionPrompt(
    patientInfo: String,
    warmup: [Exercise], strength: [Exercise], cardio: [Exercise], core: [Exercise]
) -> String {
    func list(_ ex: [Exercise]) -> String {
        ex.map { ($0.name)}.joined(separator: "\n")
    }
//    return """
//    Patient info:
//    \(patientInfo)
//    
//    TASK:
//    Select exactly 5 exercises per category.
//    
//    IMPORTANT: Return the result strictly as a JSON object.
//    To save space, ONLY include the "name" and "category" fields. Do not include null values for sets or reps.
//    
//    Example format:
//    {
//      "warmupExercises": [ 
//          { "name": "Exercise A", "category": "warmup" }, 
//          { "name": "Exercise B", "category": "warmup" } 
//      ],
//      "strengthExercises": [ ... ],
//      "cardioExercises": [ ... ],
//      "coreExercises": [ ... ]
//    }
//    
//    CANDIDATES — Warmup:
//    \(list(warmup))
//    
//    // ... rest of prompt
//    """
//}

    return
//    Patient info:
//    \(patientInfo)
"""
    TASK:
    Choose exactly 5 exercises per category from the provided candidates.

    HARD RULES:
    Choose ONLY from the candidate lists below.
    Exactly 5 warmup, 5 strength, 5 cardio, 5 core.
    No duplicates within each category.

    CANDIDATES Warmup:
    \(list(warmup))

    CANDIDATES Strength:
    \(list(strength))

    CANDIDATES Cardio:
    \(list(cardio))

    CANDIDATES Core:
    \(list(core))
    """
}

enum SelectionError: Error {
    case notInMasterList(category: ExerciseCategory, name: String)
    case wrongCategory(name: String, expected: ExerciseCategory)
}

func canonicalize(_ selection: ExerciseSelection, canon: [String: Exercise]) throws -> ExerciseSelection {
    
    func findStrictOrPlural(name: String, category: ExerciseCategory) throws -> Exercise {
        // 1. Prepare base cleaning (lowercase, trim whitespace, condense internal spaces)
        let cleanName = name.lowercased()
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        // Helper to check a specific string against the database
        func check(_ candidateName: String) -> Exercise? {
            let key = canonKey(category: category, name: candidateName)
            return canon[key]
        }
        
        // --- ATTEMPT 1: Exact Match ---
        if let match = check(cleanName) { return match }
        
        // --- ATTEMPT 2: "Biceps" / "Triceps" / "Quadriceps" Fixes ---
        // The AI often gets the medical pluralization wrong (Bicep vs Biceps)
        var variant = cleanName
        if variant.contains("biceps") {
            variant = variant.replacingOccurrences(of: "biceps", with: "bicep")
        } else if variant.contains("bicep") {
            variant = variant.replacingOccurrences(of: "bicep", with: "biceps")
        }
        if let match = check(variant) { return match }
        
        // --- ATTEMPT 3: Simple Pluralization (Trailing 's') ---
        // Handle "Push Up" vs "Push Ups" or "Lunge" vs "Lunges"
        if cleanName.hasSuffix("s") {
            // Try removing 's' (e.g. "Lunges" -> "Lunge")
            if let match = check(String(cleanName.dropLast())) { return match }
        } else {
            // Try adding 's' (e.g. "Squat" -> "Squats")
            if let match = check(cleanName + "s") { return match }
        }
        
        // If all strictly safe variations fail, throw.
//        throw SelectionError.notInMasterList(category: category, name: name)
        print("ERROR, ERROR selection error: \(name) not in \(category)")
        return AppConstants.allExercises[0]
    }

    func fix(_ exs: [Exercise], cat: ExerciseCategory) throws -> [Exercise] {
        try exs.map { ex in
            return try findStrictOrPlural(name: ex.name, category: cat)
        }
    }

    return ExerciseSelection(
        warmupExercises:   try fix(selection.warmupExercises,   cat: .warmup),
        strengthExercises: try fix(selection.strengthExercises, cat: .strength),
        cardioExercises:   try fix(selection.cardioExercises,   cat: .cardio),
        coreExercises:     try fix(selection.coreExercises,     cat: .core)
    )
}

// A simple parser for the AI's "Numbered List" format
func parseTextList(_ text: String) -> ExerciseSelection {
    var currentCat: ExerciseCategory?
    
    // Empty containers
    var warm: [Exercise] = []
    var str: [Exercise] = []
    var car: [Exercise] = []
    var cor: [Exercise] = []
    
    let lines = text.components(separatedBy: .newlines)
    
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { continue }
        
        // 1. Detect Category Headers (e.g. "### Warmup Exercises:")
        let lower = trimmed.lowercased()
        if lower.contains("warmup") { currentCat = .warmup; continue }
        if lower.contains("strength") { currentCat = .strength; continue }
        if lower.contains("cardio") { currentCat = .cardio; continue }
        if lower.contains("core") { currentCat = .core; continue }
        
        // 2. Detect Items (e.g. "1. Exercise Name")
        // We look for lines starting with a number.
        if let cat = currentCat, trimmed.first?.isNumber == true {
            // Find the first dot "." and take everything after it
            if let dotIndex = trimmed.firstIndex(of: ".") {
                let namePart = trimmed[trimmed.index(after: dotIndex)...]
                var cleanName = String(namePart)
                                    .replacingOccurrences(of: "*", with: "") // Remove bold
                                    .trimmingCharacters(in: .whitespacesAndNewlines)
                                
                // Remove trailing period if it exists (e.g., "Exercise Name.")
                if cleanName.hasSuffix(".") {
                    cleanName = String(cleanName.dropLast())
                }
                
                // Remove Markdown bullets if the AI used "1. - Name"
                if cleanName.hasPrefix("- ") {
                    cleanName = String(cleanName.dropFirst(2))
                }
                
                // Final trim
                cleanName = cleanName.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !cleanName.isEmpty else { continue }
                // Create a temporary exercise object
                let ex = Exercise(name: cleanName, category: cat, durationSeconds: nil, sets: nil, reps: nil)
                
                switch cat {
                case .warmup: warm.append(ex)
                case .strength: str.append(ex)
                case .cardio: car.append(ex)
                case .core: cor.append(ex)
                }
            }
        }
    }
    
    return ExerciseSelection(
        warmupExercises: warm,
        strengthExercises: str,
        cardioExercises: car,
        coreExercises: cor
    )
}


func ragSelectExercises(
    session: SessionStub,
    allExercises: [Exercise],
    patientInfo: String,
    topK: Int = Int.max
) async throws -> ExerciseSelection {
    let tags = loadExerciseTags()

    let warm = retrieveCandidates(all: allExercises, category: .warmup, topK: topK, tags:tags, patientInfo: patientInfo)
    let str  = retrieveCandidates(all: allExercises, category: .strength, topK: topK, tags:tags, patientInfo: patientInfo)
    let car  = retrieveCandidates(all: allExercises, category: .cardio, topK: topK, tags:tags, patientInfo: patientInfo)
    let cor  = retrieveCandidates(all: allExercises, category: .core, topK: topK, tags:tags, patientInfo: patientInfo)
    let prompt = selectionPrompt(patientInfo: patientInfo, warmup: warm, strength: str, cardio: car, core: cor)
    
    let warm_max = retrieveCandidates(all: allExercises, category: .warmup, topK: Int.max, tags:tags, patientInfo: patientInfo)
    let str_max  = retrieveCandidates(all: allExercises, category: .strength, topK: Int.max, tags:tags, patientInfo: patientInfo)
    let car_max  = retrieveCandidates(all: allExercises, category: .cardio, topK: Int.max, tags:tags, patientInfo: patientInfo)
    let cor_max  = retrieveCandidates(all: allExercises, category: .core, topK: Int.max, tags:tags, patientInfo: patientInfo)
    let validExer = warm_max + str_max + car_max + cor_max
//    print(validExer.map{$0.name}.joined(separator: ", "))

    let canon = buildCanonMap(validExer)


    do {
        // If you have a typed/guided API, prefer it.
        // Otherwise you can ask for JSON and decode.
        let raw = try await session.respond(to: prompt)

        // Simple approach: ask model to output JSON for ExerciseSelection and decode:
        let textSelection = parseTextList(raw)
        return try canonicalize(textSelection, canon: canon)
    } catch {
        print("🛑 ERROR DETAILS: \(error)")
        // fallback: deterministic top-5 retrieved
        print("didnt work, using fallback")
        return ExerciseSelection(
            warmupExercises: Array(warm.prefix(5)),
            strengthExercises: Array(str.prefix(5)),
            cardioExercises: Array(car.prefix(5)),
            coreExercises: Array(cor.prefix(5))
        )
    }
}

func formatSelection(_ sel: ExerciseSelection) -> String {
    func block(_ title: String, _ exs: [Exercise]) -> String {
        let lines = exs.map { $0.name }.joined(separator: "\n")
        return "\(title)\n\(lines)"
    }

    return [
        block("Warmup", sel.warmupExercises),
        block("Strength", sel.strengthExercises),
        block("Cardio", sel.cardioExercises),
        block("Core", sel.coreExercises)
    ].joined(separator: "\n\n")
}

