//
//  validity.swift
//  beta2
//
//  Created by admin on 13/10/25.
//

import Foundation

/// Returns true only if each category has exactly 5 unique non-empty items.
/// Also returns per-category counts and a compact list of issues.
func validityCheck(_ response: String) -> (isValid: Bool,
                                           counts: [String: Int],
                                           issues: [String]) {
    let parsed = parseResponse(response)
    let required = Category.allCases
    var counts: [String: Int] = [:]
    var issues: [String] = []

    for cat in required {
        let n = parsed.items[cat, default: []].count
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
    }

    // If model invented extra categories, note it (not strictly required, but useful)
    if !parsed.extraCategories.isEmpty {
        issues.append("unexpected categories: " + parsed.extraCategories.joined(separator: ", "))
    }

    // If duplicates were removed, surface that too
    if !parsed.duplicates.isEmpty {
        let d = parsed.duplicates
            .map { "\($0.key.rawValue): " + $0.value.joined(separator: ", ") }
            .joined(separator: " | ")
        issues.append("duplicate exercise names detected (\(d))")
    }

    let isValid = issues.isEmpty &&
                  required.allSatisfy { parsed.items[$0]?.count == 5 }

    return (isValid, counts, issues)
}

/// Builds a short, model-friendly correction message from the current response.
/// Example output (single issue):  "only 1 exercise given for strength"
/// Example output (multiple):      "only 3 exercises given for cardio; more than 5 exercises for core (got 7)"
func improveResponse(_ response: String) -> String {
    let check = validityCheck(response)
    if check.isValid { return "ok" }
    // Keep message short & specific so the model can self-correct easily.
    // Join multiple issues with "; " in one turn.
    return check.issues.joined(separator: "; ")
}

// MARK: - Internal parsing

private enum Category: String, CaseIterable {
    case warmup, core, strength, cardio

    static func from(_ raw: String) -> Category? {
        let s = raw.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        switch s {
        case "warmup", "warm-up", "warm up": return .warmup
        case "core": return .core
        case "strength": return .strength
        case "cardio": return .cardio
        default: return nil
        }
    }
}

private struct ParseResult {
    var items: [Category: [String]] = [:]                // deduped, trimmed
    var extraCategories: [String] = []                   // headings that aren't one of the 4
    var duplicates: [Category: [String]] = [:]           // duplicates that were removed
}

private func parseResponse(_ text: String) -> ParseResult {

    // Prefer JSON first — handle a wide variety of shapes.
    if let jsonResult = tryParseJSON(text) {
        return jsonResult
    }

    // Fallback: Markdown/plain-text with headings and bullets/numbers.
    return parseHeadingsAndBullets(text)
}

private func tryParseJSON(_ text: String) -> ParseResult? {
    // Find the first JSON object in the text (naive but robust for typical LLM replies).
    guard let jsonRange = text.range(of: #"\{[\s\S]*\}"#, options: .regularExpression) else {
        return nil
    }
    let jsonSnippet = String(text[jsonRange])

    // Try as [String: Any]
    guard let data = jsonSnippet.data(using: .utf8),
          let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else { return nil }

    var parsed = ParseResult()

    func extractNames(_ any: Any) -> [String] {
        // Accept arrays of strings or arrays of dicts with "name"
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

    var seenForDup: [Category: Set<String>] = [:]
    var dups: [Category: [String]] = [:]

    for (key, value) in obj {
        if let cat = Category.from(key) {
            var clean: [String] = []
            var set = Set<String>()
            for raw in extractNames(value) {
                let s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !s.isEmpty else { continue }
                let k = s.lowercased()
                if set.contains(k) {
                    dups[cat, default: []].append(s)
                } else {
                    set.insert(k)
                    clean.append(s)
                }
            }
            parsed.items[cat] = clean
            seenForDup[cat] = set
        } else {
            parsed.extraCategories.append(key)
        }
    }
    parsed.duplicates = dups
    return parsed

}

private func makeRegex(_ pattern: String,_ options:NSRegularExpression.Options = []) -> NSRegularExpression {
    if let re = try? NSRegularExpression(pattern: pattern, options: options) {
        return re
    }
    return try! NSRegularExpression(pattern: #"(?!)"#)
}


// Reuse this in both JSON & text paths.
private func isMetaOrFenceLine(_ s: String) -> Bool {
    let t = s.trimmingCharacters(in: .whitespacesAndNewlines)
    if t.isEmpty { return false }
    // common chat/meta markers & code fences
    if t == "<end_of_turn>" { return true }
    if t.lowercased().replacingOccurrences(of: " ", with: "") == "<end-of-turn>" { return true }
    if t == "</s>" || t == "<eot>" || t == "<end>" || t == "<stop>" { return true }
    if t.hasPrefix("```") || t == "~~~" { return true }
    // angle-bracketed all-lower token like <something>, conservatively skip if looks meta-ish
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
    var current: Category? = nil
    var blankStreak = 0

    let headingPattern = #"(warm[\-\s]?ups?|strength|cardio|core)\b"#
    let bulletPattern  = #"^\s*(?:[-–—*•\u2022]|\d{1,2}[.)])\s*(.+?)\s*$"#
    let headingRE = makeRegex(headingPattern, [.caseInsensitive])
    let bulletRE  = makeRegex(bulletPattern)

    let lines = text.components(separatedBy: .newlines)
    var seen: [Category: Set<String>] = [:]
    var dups: [Category: [String]] = [:]

    func cleanItem(_ s: String) -> String {
        var item = s.trimmingCharacters(in: .whitespacesAndNewlines)
        if (item.hasPrefix("**") && item.hasSuffix("**")) ||
           (item.hasPrefix("__") && item.hasSuffix("__")) {
            item = String(item.dropFirst(2).dropLast(2)).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return item
    }
    var sectionCount: [Category:Int] = [:]   // how many items captured in each active section

    for rawLine in lines {
        let trimmed = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // meta / fences
        if isMetaOrFenceLine(trimmed) { continue }
        
        // blank-line handling
        if trimmed.isEmpty {
            if let cat = current {
                if sectionCount[cat, default: 0] > 0 {
                    // After capturing at least one item: a single blank ends the section
                    current = nil
                    blankStreak = 0
                    continue
                } else {
                    // Immediately after a heading (no items yet): tolerate one blank
                    blankStreak += 1
                    if blankStreak >= 2 { current = nil }   // two blanks with no items ends it
                    continue
                }
            } else {
                // outside any section, just track blanks
                blankStreak += 1
                continue
            }
        }
        blankStreak = 0
        
        // ignore setext underlines
        if trimmed.range(of: #"^[-=]{3,}$"#, options: .regularExpression) != nil { continue }
        
        // heading?
        if let m = headingRE.firstMatch(in: trimmed, range: NSRange(location: 0, length: (trimmed as NSString).length)),
           let r = Range(m.range(at: 1), in: trimmed) {
            let token = String(trimmed[r]).lowercased()
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
            current = Category.from(token)
            // reset per-section blank tolerance
            if let cat = current { sectionCount[cat] = 0 }
            continue
        }
        
        // if no active section, ignore prose
        guard let cat = current else { continue }
        
        // bullet?
        if let m = bulletRE.firstMatch(in: rawLine, range: NSRange(location: 0, length: (rawLine as NSString).length)),
           let r = Range(m.range(at: 1), in: rawLine) {
            let candidate = cleanItem(String(rawLine[r]))
            if candidate.isEmpty || isMetaOrFenceLine(candidate) { continue }
            // add (with your duplicate logic as before)
            parsed.items[cat, default: []].append(candidate)
            sectionCount[cat, default: 0] += 1
            continue
        }
        
        // plain line inside a section counts as an item
        let candidate = cleanItem(trimmed)
        if candidate.isEmpty || isMetaOrFenceLine(candidate) { continue }
        parsed.items[cat, default: []].append(candidate)
        sectionCount[cat, default: 0] += 1
        
    }
    parsed.duplicates = dups
    return parsed
}
