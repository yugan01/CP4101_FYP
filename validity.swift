import Foundation

struct ValidityResult {
    let isValid: Bool
    let counts: [String: Int]
    let issues: [String]
    let hallucinationsByCategory: [String: [String]]
    let hallucinationCount: Int
    let duplicateCount: Int
}

func validityCheck(_ response: String) -> ValidityResult {
    let parsed = parseResponse(response)
    let required = ExerciseCategory.allCases

    var counts: [String: Int] = [:]
    var issues: [String] = []
    var hallucinationsByCategory: [String: [String]] = [:]
    var hallucinationCount = 0

    func nameSet(for category: ExerciseCategory) -> Set<String> {
        Set(
            AppConstants.allExercises
                .filter { $0.category == category }
                .map { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        )
    }

    let warmupNames = nameSet(for: .warmup)
    let strengthNames = nameSet(for: .strength)
    let cardioNames = nameSet(for: .cardio)
    let coreNames = nameSet(for: .core)

    func lookup(for category: ExerciseCategory) -> Set<String> {
        switch category {
        case .warmup: return warmupNames
        case .strength: return strengthNames
        case .cardio: return cardioNames
        case .core: return coreNames
        }
    }

    for cat in required {
        let names = parsed.items[cat, default: []]
        let n = names.count
        counts[cat.rawValue] = n

        if n == 0 {
            issues.append("no exercises given for \(cat.rawValue)")
        } else if n == 1 {
            issues.append("only 1 exercise given for \(cat.rawValue)")
        } else if n < 5 {
            issues.append("only \(n) exercises given for \(cat.rawValue)")
        } else if n > 5 {
            issues.append("more than 5 exercises for \(cat.rawValue) (got \(n))")
        }

        let catalog = lookup(for: cat)
        let unknown = names.filter {
            !catalog.contains($0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
        }

        if !unknown.isEmpty {
            hallucinationsByCategory[cat.rawValue] = unknown
            hallucinationCount += unknown.count
            issues.append("hallucination found in \(cat.rawValue): " + unknown.joined(separator: ", "))
        }
    }

    if !parsed.extraCategories.isEmpty {
        issues.append("unexpected categories: " + parsed.extraCategories.joined(separator: ", "))
    }

    var duplicateCount = 0
    if !parsed.duplicates.isEmpty {
        duplicateCount = parsed.duplicates.values.reduce(0) { $0 + $1.count }
        let d = parsed.duplicates
            .map { "\($0.key.rawValue): " + $0.value.joined(separator: ", ") }
            .joined(separator: " | ")
        issues.append("duplicate exercise names detected (\(d))")
    }

    let isValid =
        issues.isEmpty &&
        ExerciseCategory.allCases.allSatisfy { parsed.items[$0]?.count == 5 }

    return ValidityResult(
        isValid: isValid,
        counts: counts,
        issues: issues,
        hallucinationsByCategory: hallucinationsByCategory,
        hallucinationCount: hallucinationCount,
        duplicateCount: duplicateCount
    )
}

func improveResponse(_ response: String) -> String {
    let check = validityCheck(response)
    if check.isValid { return "ok" }
    return check.issues.joined(separator: "; ")
}

// MARK: - Internal parsing

private struct ParseResult {
    var items: [ExerciseCategory: [String]] = [:]       // deduplicated items
    var extraCategories: [String] = []
    var duplicates: [ExerciseCategory: [String]] = [:]  // duplicate names removed
}

private func parseResponse(_ text: String) -> ParseResult {
    if let jsonResult = tryParseJSON(text) {
        return jsonResult
    }
    return parseHeadingsAndBullets(text)
}

private func tryParseJSON(_ text: String) -> ParseResult? {
    guard let jsonRange = text.range(of: #"\{[\s\S]*\}"#, options: .regularExpression) else {
        return nil
    }
    let jsonSnippet = String(text[jsonRange])

    guard let data = jsonSnippet.data(using: .utf8),
          let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else { return nil }

    var parsed = ParseResult()
    var seen: [ExerciseCategory: Set<String>] = [:]
    var dups: [ExerciseCategory: [String]] = [:]

    func extractNames(_ any: Any) -> [String] {
        if let arr = any as? [Any] {
            var names: [String] = []
            for elt in arr {
                if let s = elt as? String {
                    names.append(s)
                } else if let d = elt as? [String: Any], let s = d["name"] as? String {
                    names.append(s)
                }
            }
            return names
        }
        return []
    }

    func addItem(_ raw: String, to category: ExerciseCategory) {
        let item = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !item.isEmpty else { return }

        let key = item.lowercased()
        if seen[category, default: []].contains(key) {
            dups[category, default: []].append(item)
        } else {
            seen[category, default: []].insert(key)
            parsed.items[category, default: []].append(item)
        }
    }

    for (key, value) in obj {
        if let cat = ExerciseCategory.from(key) {
            for raw in extractNames(value) {
                addItem(raw, to: cat)
            }
        } else {
            parsed.extraCategories.append(key)
        }
    }

    parsed.duplicates = dups
    return parsed
}

private func isMetaOrFenceLine(_ s: String) -> Bool {
    let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
    if t.isEmpty { return false }

    if t == "<end_of_turn>" { return true }
    if t.lowercased().replacingOccurrences(of: " ", with: "") == "<end-of-turn>" { return true }
    if t == "</s>" || t == "<eot>" || t == "<end>" || t == "<stop>" { return true }
    if t.hasPrefix("```") || t == "~~~" { return true }

    if t.first == "<", t.last == ">" {
        let inner = t.dropFirst().dropLast()
        if inner.count <= 24, inner.allSatisfy({ $0.isLetter || $0 == "_" || $0 == "-" }) {
            return true
        }
    }
    return false
}

private func parseHeadingsAndBullets(_ text: String) -> ParseResult {
    var parsed = ParseResult()
    var current: ExerciseCategory? = nil

    let headingPattern = #"(warm[\-\s]?ups?|strength|cardio|core)\b"#
    let bulletPattern  = #"^\s*(?:[-–—*•\u2022]|\d{1,2}[.)])\s*(.+?)\s*$"#

    let headingRE = try! NSRegularExpression(pattern: headingPattern, options: [.caseInsensitive])
    let bulletRE = try! NSRegularExpression(pattern: bulletPattern)

    var seen: [ExerciseCategory: Set<String>] = [:]
    var dups: [ExerciseCategory: [String]] = [:]

    func cleanItem(_ s: String) -> String {
        var item = s.trimmingCharacters(in: .whitespacesAndNewlines)

        if (item.hasPrefix("**") && item.hasSuffix("**")) ||
            (item.hasPrefix("__") && item.hasSuffix("__")) {
            item = String(item.dropFirst(2).dropLast(2)).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if item.hasPrefix("- ") {
            item = String(item.dropFirst(2)).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if item.hasSuffix(".") {
            item = String(item.dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return item
    }

    func addItem(_ raw: String, to category: ExerciseCategory) {
        let item = cleanItem(raw)
        guard !item.isEmpty, !isMetaOrFenceLine(item) else { return }

        let key = item.lowercased()
        if seen[category, default: []].contains(key) {
            dups[category, default: []].append(item)
        } else {
            seen[category, default: []].insert(key)
            parsed.items[category, default: []].append(item)
        }
    }

    let lines = text.components(separatedBy: .newlines)

    for rawLine in lines {
        let trimmed = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty || isMetaOrFenceLine(trimmed) { continue }

        let headingRange = NSRange(location: 0, length: (trimmed as NSString).length)
        if let m = headingRE.firstMatch(in: trimmed, options: [], range: headingRange),
           let r = Range(m.range(at: 1), in: trimmed) {
            let token = String(trimmed[r])
                .lowercased()
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
            current = ExerciseCategory.from(token)
            continue
        }

        guard let cat = current else { continue }

        let bulletRange = NSRange(location: 0, length: (rawLine as NSString).length)
        if let m = bulletRE.firstMatch(in: rawLine, options: [], range: bulletRange),
           let r = Range(m.range(at: 1), in: rawLine) {
            addItem(String(rawLine[r]), to: cat)
        } else {
            addItem(trimmed, to: cat)
        }
    }

    parsed.duplicates = dups
    return parsed
}
