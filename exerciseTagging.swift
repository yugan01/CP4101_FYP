//
//  exerciseTagging.swift
//  beta2
//
//  Created by admin on 11/2/26.
//

import Foundation

//
//// MARK: - 1. Data Models
//struct ExerciseDetails: Codable {
//    let categories: [String]
//    let tags: [String]
//}
//
//// MARK: - 2. Tagging Logic
//class ExerciseTagger {
//    
//    // Define tags as string constants to avoid typos
//    enum Tag: String {
//        case lowImpact = "low_impact"
//        case highImpact = "high_impact"
//        case jump, run, lunge, squat, hinge
//        case overhead, upperPush = "upper_push", upperPull = "upper_pull"
//        case deepKneeFlexion = "deep_knee_flexion"
//        case kneeFriendly = "knee_friendly"
//        case shoulderFriendly = "shoulder_friendly"
//        case coreStability = "core_stability"
//        case balance
//        case machine, bodyweight
//    }
//    
//// Helper: Checks for whole words only (e.g. finds "run" but ignores "crunch")
//    private static func hasWord(_ text: String, _ words: [String]) -> Bool {
//        // \b matches a word boundary (start/end of word, space, punctuation)
//        // This regex looks for: \b(word1|word2|word3)\b
//        let pattern = "\\b(" + words.joined(separator: "|") + ")\\b"
//        return text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
//    }
//
//    // Helper: Keep simple 'contains' for unique partials (like "extension" or "machine")
//    private static func hasPart(_ text: String, _ part: String) -> Bool {
//        return text.localizedCaseInsensitiveContains(part)
//    }
//    
//    static func generateTags(for name: String, categories: [String]) -> [String] {
//        var tags = Set<String>()
//        // Note: Regex is case-insensitive, so we don't strictly need lowerName for hasWord,
//        // but it helps for manual logic.
//        let lowerName = name.lowercased()
//        let cats = categories.map { $0.lowercased() }
//        
//        // --- 1. MOVEMENT PATTERNS (Using Whole Word Matching) ---
//        // Fixes: "Crunch" != "Run", "Throw" != "Row", "Chop" != "Hop"
//        
//        let isRun  = hasWord(name, ["run", "runs", "running", "sprint", "sprints", "jog", "jogging", "shuttle"])
//        let isJump = hasWord(name, ["jump", "jumps", "jumping", "hop", "hops", "hopping", "bound", "bounding", "skip", "skipping", "gallop", "burpee", "burpees"])
//        let isRow  = hasWord(name, ["row", "rows", "rowing"])
//        
//        if isRun { tags.insert(Tag.run.rawValue) }
//        if isJump { tags.insert(Tag.jump.rawValue) }
//        
//        // Lunge/Squat/Hinge usually don't have substring conflicts, simpler checks are fine
//        if hasPart(name, "lunge") || hasPart(name, "split") { tags.insert(Tag.lunge.rawValue) }
//        if hasPart(name, "squat") || hasPart(name, "sit") || hasPart(name, "chair") { tags.insert(Tag.squat.rawValue) }
//        if hasPart(name, "deadlift") || hasPart(name, "hinge") || hasPart(name, "scoop") || hasPart(name, "toe touch") { tags.insert(Tag.hinge.rawValue) }
//        
//        // --- 2. IMPACT ---
//        // Only tag high impact if we explicitly found a jump or run keyword
//        if isRun || isJump {
//            tags.insert(Tag.highImpact.rawValue)
//        } else {
//            tags.insert(Tag.lowImpact.rawValue)
//        }
//        
//        // --- 3. UPPER BODY ---
//        // Push
//        if hasPart(name, "press") || hasPart(name, "push") || hasPart(name, "dip") || hasPart(name, "extension") {
//            tags.insert(Tag.upperPush.rawValue)
//        }
//        // Pull (Fixes "Ball Throw" issue)
//        if isRow || hasPart(name, "pull") || hasPart(name, "curl") || hasPart(name, "chin") {
//            tags.insert(Tag.upperPull.rawValue)
//        }
//        // Overhead
//        if hasPart(name, "overhead") || hasPart(name, "shoulder press") {
//            tags.insert(Tag.overhead.rawValue)
//        }
//        
//        // --- 4. JOINTS ---
//        if tags.contains(Tag.squat.rawValue) || tags.contains(Tag.lunge.rawValue) || hasPart(name, "deep") {
//            tags.insert(Tag.deepKneeFlexion.rawValue)
//        } else if !tags.contains(Tag.highImpact.rawValue) {
//            tags.insert(Tag.kneeFriendly.rawValue)
//        }
//        
//        if !tags.contains(Tag.overhead.rawValue) && !tags.contains(Tag.upperPush.rawValue) {
//            tags.insert(Tag.shoulderFriendly.rawValue)
//        }
//        
//        // --- 5. EQUIPMENT ---
//        if (hasPart(name, "machine") || hasPart(name, "hur") || hasPart(name, "cable")) && !hasPart(name, "dumbbell") {
//             tags.insert(Tag.machine.rawValue)
//        } else if !hasPart(name, "dumbbell") && !hasPart(name, "medicine") && !hasPart(name, "band") && !hasPart(name, "racket") {
//            tags.insert(Tag.bodyweight.rawValue)
//        }
//        
//        // --- 6. CORE & BALANCE ---
//        if hasPart(name, "plank") || hasPart(name, "crunch") || hasPart(name, "rotation") || cats.contains("core") {
//            tags.insert(Tag.coreStability.rawValue)
//        }
//        if hasPart(name, "single leg") || hasPart(name, "balance") || (isJump && !hasPart(name, "burpee")) {
//            // Jumps (hops) often require balance, burpees less so
//            tags.insert(Tag.balance.rawValue)
//        }
//        
//        return tags.sorted()
//    }
//}

struct ExerciseDetails: Codable {
    let categories: [String]
    var tags: [String]
}

final class ExerciseTagger {

    enum Tag: String {
        case lowImpact = "low_impact"
        case highImpact = "high_impact"
        case jump, run, lunge, squat, hinge
        case overhead
        case upperPush = "upper_push"
        case upperPull = "upper_pull"
        case deepKneeFlexion = "deep_knee_flexion"
        case kneeFriendly = "knee_friendly"
        case shoulderFriendly = "shoulder_friendly"
        case coreStability = "core_stability"
        case balance
        case machine, bodyweight
    }

    // Whole-word matching (case-insensitive)
    private static func hasWord(_ text: String, _ words: [String]) -> Bool {
        let escaped = words.map { NSRegularExpression.escapedPattern(for: $0) }
        let pattern = "\\b(" + escaped.joined(separator: "|") + ")\\b"
        return text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    private static func hasPart(_ text: String, _ part: String) -> Bool {
        text.localizedCaseInsensitiveContains(part)
    }

    static func generateTags(for name: String, categories: [String]) -> [String] {
        var tags = Set<String>()
        let lowerName = name.lowercased()
        let cats = categories.map { $0.lowercased() }

        // ---- Movement patterns (WHOLE WORD) ----
        let isRun = hasWord(name, [
            "run","runs","running","sprint","sprints","jog","jogging","shuttle"
        ]) || hasWord(name, [
            // direction-change / field conditioning cues
            "ladder","agility","carioca","shuffle","shuffles","slides","slide"
        ]) || hasPart(name, "treadmill")

        let isJump = hasWord(name, [
            "jump","jumps","jumping","hop","hops","hopping","bound","bounding",
            "skip","skipping","gallop","burpee","burpees","jacks"
        ])

        let isRow = hasWord(name, ["row","rows","rowing"]) // prevents "throw" from matching

        if isRun { tags.insert(Tag.run.rawValue) }
        if isJump { tags.insert(Tag.jump.rawValue) }

        // Lunge: allow "split" as lunge-ish (split jumps etc.)
        if hasPart(name, "lunge") || hasPart(name, "split") { tags.insert(Tag.lunge.rawValue) }

        // Squat: DO NOT use generic "sit" (breaks V-sit, sit-ups)
        let isVSit = hasPart(lowerName, "v-sit") || hasPart(lowerName, "v sit")
        let isSitUp = hasPart(lowerName, "sit up") || hasPart(lowerName, "sit-up")
        if hasPart(name, "squat") || hasPart(name, "chair") || hasPart(lowerName, "sit to stand") || hasPart(lowerName, "sit-to-stand") {
            tags.insert(Tag.squat.rawValue)
        } else if (isVSit || isSitUp) {
            // do nothing (core will be captured later)
        }

        // Hinge cues
        if hasPart(name, "deadlift") || hasPart(name, "hinge") || hasPart(name, "scoop") || hasPart(lowerName, "toe touch") {
            tags.insert(Tag.hinge.rawValue)
        }

        // ---- Impact ----
        // High impact if explicit run/jump; otherwise low impact.
        if isRun || isJump { tags.insert(Tag.highImpact.rawValue) }
        else { tags.insert(Tag.lowImpact.rawValue) }

        // ---- Upper body ----
        if hasPart(name, "press") || hasPart(name, "push") || hasPart(name, "dip") || hasPart(name, "extension") {
            tags.insert(Tag.upperPush.rawValue)
        }
        if isRow || hasPart(name, "pull") || hasPart(name, "curl") || hasPart(name, "chin") {
            tags.insert(Tag.upperPull.rawValue)
        }
        if hasPart(name, "overhead") || hasPart(lowerName, "shoulder press") {
            tags.insert(Tag.overhead.rawValue)
        }

        // ---- Joints ----
        if tags.contains(Tag.squat.rawValue) || tags.contains(Tag.lunge.rawValue) || hasPart(name, "deep") {
            tags.insert(Tag.deepKneeFlexion.rawValue)
        } else if !tags.contains(Tag.highImpact.rawValue) {
            tags.insert(Tag.kneeFriendly.rawValue)
        }

        if !tags.contains(Tag.overhead.rawValue) && !tags.contains(Tag.upperPush.rawValue) {
            tags.insert(Tag.shoulderFriendly.rawValue)
        }

        // ---- Equipment ----
        let isMachine = (
            hasPart(name, "machine") || hasPart(name, "hur") || hasPart(name, "cable") ||
            hasPart(name, "treadmill") || hasPart(name, "rowing") || hasPart(name, "cycling") ||
            hasPart(name, "bicycle") || hasPart(name, "crosstrainer")
        ) && !hasPart(name, "dumbbell")

        if isMachine {
            tags.insert(Tag.machine.rawValue)
        } else if !hasPart(name, "dumbbell") && !hasPart(name, "medicine") && !hasPart(name, "band") && !hasPart(name, "racket") {
            tags.insert(Tag.bodyweight.rawValue)
        }

        // ---- Core & balance ----
        if hasPart(name, "plank") || hasPart(name, "crunch") || hasPart(name, "rotation") || cats.contains("core") {
            tags.insert(Tag.coreStability.rawValue)
        }
        if hasPart(lowerName, "single leg") || hasPart(name, "balance") || hasWord(name, ["shuffle","carioca","ladder","agility"]) || (isJump && !hasWord(name, ["burpee","burpees"])) {
            tags.insert(Tag.balance.rawValue)
        }

        return tags.sorted()
    }
}




// MARK: - 3. Save Function
func saveTaggedExercisesToJSON(categoryMap: [String: [String]]) throws -> URL {
    // 1. Transform the Map into a List of Objects
    var resultMap: [String: ExerciseDetails] = [:]
    
    for (name, cats) in categoryMap {
        let tags = ExerciseTagger.generateTags(for: name, categories: cats)
        let details = ExerciseDetails(categories: cats, tags: tags)
        resultMap[name] = details
    }
    
    // 2. Encode to JSON
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys] // Makes it readable
    let data = try encoder.encode(resultMap)
    
    // 3. Save to Documents Directory
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = docs.appendingPathComponent("tagged_exercises_all.json")
    
    try data.write(to: fileURL, options: [.atomic])
    
    return fileURL
}
