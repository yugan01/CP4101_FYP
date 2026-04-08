//
//  comparison.swift
//  beta2
//
//  Created by admin on 8/4/26.
//

import Foundation
import MLXLLM
import MLXLMCommon
import FoundationModels

// MARK: - Config

let trials = 100
let maxRetries = 5
let sampledPerCategory = 15
let ragTopK = 15
let systemPrompt = "You have to answer, do not ask follow-up questions"

let llamaModelID = "mlx-community/Llama-3.2-1B-Instruct-4bit"
let gemmaModelID = "mlx-community/gemma-2-2b-it-4bit"

// MARK: - CSV row

struct BenchmarkRow {
    let trial: Int
    let model: String
    let successfulValidResponse: Int
    let firstTryValid: Int
    let retriesNeeded: Int
    let attemptsUsed: Int
    let totalHallucinationsSeenAcrossAttempts: Int
    let firstAttemptHallucinations: Int
    let finalHallucinations: Int
    let tokenLimitExceeded: Int
    let finalDuplicateCount: Int

    static let header =
        "trial,model,successful_valid_response,first_try_valid,retries_needed,attempts_used,total_hallucinations_seen_across_attempts,first_attempt_hallucinations,final_hallucinations,token_limit_exceeded,final_duplicate_count"

    func csvLine() -> String {
        [
            String(trial),
            csvEscape(model),
            String(successfulValidResponse),
            String(firstTryValid),
            String(retriesNeeded),
            String(attemptsUsed),
            String(totalHallucinationsSeenAcrossAttempts),
            String(firstAttemptHallucinations),
            String(finalHallucinations),
            String(tokenLimitExceeded),
            String(finalDuplicateCount)
        ].joined(separator: ",")
    }
}

func csvEscape(_ s: String) -> String {
    if s.contains(",") || s.contains("\"") || s.contains("\n") {
        return "\"\(s.replacingOccurrences(of: "\"", with: "\"\""))\""
    }
    return s
}

func appendCSVLine(_ line: String, to url: URL) throws {
    if !FileManager.default.fileExists(atPath: url.path) {
        try (BenchmarkRow.header + "\n" + line + "\n").write(to: url, atomically: true, encoding: .utf8)
        return
    }

    let handle = try FileHandle(forWritingTo: url)
    defer { try? handle.close() }
    try handle.seekToEnd()
    if let data = (line + "\n").data(using: .utf8) {
        try handle.write(contentsOf: data)
    }
}

func resetCSV(_ url: URL) {
    if FileManager.default.fileExists(atPath: url.path) {
        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: - Catalogue helpers

func uniqueExercisesByCategory() -> [ExerciseCategory: [String]] {
    var out: [ExerciseCategory: [String]] = [:]

    for cat in ExerciseCategory.allCases {
        var seen = Set<String>()
        var names: [String] = []

        for ex in AppConstants.allExercises where ex.category == cat {
            let key = ex.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if seen.insert(key).inserted {
                names.append(ex.name)
            }
        }

        names.sort { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        out[cat] = names
    }

    return out
}

func sampledCatalogueByCategory(sampleSize: Int) -> [ExerciseCategory: [String]] {
    let grouped = uniqueExercisesByCategory()
    var sampled: [ExerciseCategory: [String]] = [:]

    for cat in ExerciseCategory.allCases {
        let names = grouped[cat, default: []]
        sampled[cat] = Array(names.shuffled().prefix(sampleSize))
    }

    return sampled
}

func makeExerciseCatalogueText(from grouped: [ExerciseCategory: [String]]) -> String {
    func block(_ title: String, _ names: [String]) -> String {
        "\(title)\n" + names.joined(separator: "\n")
    }

    return [
        block("Warmup Exercises", grouped[.warmup, default: []]),
        block("Strength Exercises", grouped[.strength, default: []]),
        block("Cardio Exercises", grouped[.cardio, default: []]),
        block("Core Exercises", grouped[.core, default: []])
    ].joined(separator: "\n\n")
}

func makeBaselinePrompt(catalogueText: String, patientInfo: String? = nil) -> String {
    return
    //        Patient information:
    //        \(patientInfo)
        """
        There are 4 exercise categories: Warmup, Strength, Cardio and Core.
        
        Select exactly 5 exercises for each category from the master list below.
        You must only use exercise names from the provided list.
        Do not create new exercises.
        Do not include duplicates within a category.
        Do not use bullet points, numbering, markdown, or extra commentary.
        
        MASTER EXERCISE LIST:
        \(catalogueText)
        """
}

func makeRAGPrompt(patientInfo: String, topK: Int) -> String {
    let tags = loadExerciseTags()

    let warm = retrieveCandidates(
        all: AppConstants.allExercises,
        category: .warmup,
        topK: topK,
        tags: tags,
        patientInfo: patientInfo
    )
    let str = retrieveCandidates(
        all: AppConstants.allExercises,
        category: .strength,
        topK: topK,
        tags: tags,
        patientInfo: patientInfo
    )
    let car = retrieveCandidates(
        all: AppConstants.allExercises,
        category: .cardio,
        topK: topK,
        tags: tags,
        patientInfo: patientInfo
    )
    let cor = retrieveCandidates(
        all: AppConstants.allExercises,
        category: .core,
        topK: topK,
        tags: tags,
        patientInfo: patientInfo
    )

    return selectionPrompt(
        patientInfo: patientInfo,
        warmup: warm,
        strength: str,
        cardio: car,
        core: cor
    )
}

func correctionMessage(for usesCandidateList: Bool) -> String {
    if usesCandidateList {
        return """
        Please correct your previous answer.
        Use only exercise names from the provided candidate lists already in this conversation.
        Give exactly 5 exercises for each of Warmup, Strength, Cardio, and Core.
        Do not include duplicates.
        Do not hallucinate new exercise names.
        Keep the same plain format with one exercise per line.
        """
    } else {
        return """
        Please correct your previous answer.
        Use only exercise names from the provided master list already in this conversation.
        Give exactly 5 exercises for each of Warmup, Strength, Cardio, and Core.
        Do not include duplicates.
        Do not hallucinate new exercise names.
        Keep the same plain format with one exercise per line.
        """
    }
}


// MARK: - Shared runner

func runModel(
    trial: Int,
    modelName: String,
    session: Session,
    buildInitialPrompt: () -> String,
    correctionPrompt: String
) async -> BenchmarkRow {
    session.reset()
var prompt = buildInitialPrompt()
    var retriesNeeded = 0
    var attemptsUsed = 0

    var successfulValidResponse = 0
    var firstTryValid = 0

    var totalHallucinationsSeenAcrossAttempts = 0
    var firstAttemptHallucinations = 0
    var finalHallucinations = 0
    var finalDuplicateCount = 0
    var tokenLimitExceeded = 0

    while true {
        attemptsUsed += 1

        do {
            let text = try await session.respond(to: prompt)
            
            if text == "Token limit Exceeded" {
                tokenLimitExceeded = 1
                successfulValidResponse = 0
                finalHallucinations = 0
                finalDuplicateCount = 0
                break
            }

            let result = validityCheck(text)

            totalHallucinationsSeenAcrossAttempts += result.hallucinationCount
            finalHallucinations = result.hallucinationCount
            finalDuplicateCount = result.duplicateCount

            if attemptsUsed == 1 {
                firstTryValid = result.isValid ? 1 : 0
                firstAttemptHallucinations = result.hallucinationCount
            }

            if result.isValid {
                successfulValidResponse = 1
                break
            }

            if retriesNeeded >= maxRetries {
                successfulValidResponse = 0
                break
            }

            retriesNeeded += 1
            prompt = result.issues.joined(separator: "; ") + "\n" + correctionPrompt
        } catch {
            successfulValidResponse = 0
            break
        }
    }

    return BenchmarkRow(
        trial: trial,
        model: modelName,
        successfulValidResponse: successfulValidResponse,
        firstTryValid: firstTryValid,
        retriesNeeded: retriesNeeded,
        attemptsUsed: attemptsUsed,
        totalHallucinationsSeenAcrossAttempts: totalHallucinationsSeenAcrossAttempts,
        firstAttemptHallucinations: firstAttemptHallucinations,
        finalHallucinations: finalHallucinations,
        tokenLimitExceeded: tokenLimitExceeded,
        finalDuplicateCount: finalDuplicateCount
    )
}

func runRagModel(
    trial: Int,
    modelName: String,
    session: () async throws -> String,
    buildInitialPrompt: () -> String,
    correctionPrompt: String
) async -> BenchmarkRow {
    
    var prompt = buildInitialPrompt()
    var retriesNeeded = 0
    var attemptsUsed = 0

    var successfulValidResponse = 0
    var firstTryValid = 0

    var totalHallucinationsSeenAcrossAttempts = 0
    var firstAttemptHallucinations = 0
    var finalHallucinations = 0
    var finalDuplicateCount = 0
    var tokenLimitExceeded = 0

    while true {
        attemptsUsed += 1

        do {
            let text = try await session()
            
            if text == "Token limit Exceeded" {
                tokenLimitExceeded = 1
                successfulValidResponse = 0
                finalHallucinations = 0
                finalDuplicateCount = 0
                break
            }

            let result = validityCheck(text)

            totalHallucinationsSeenAcrossAttempts += result.hallucinationCount
            finalHallucinations = result.hallucinationCount
            finalDuplicateCount = result.duplicateCount

            if attemptsUsed == 1 {
                firstTryValid = result.isValid ? 1 : 0
                firstAttemptHallucinations = result.hallucinationCount
            }

            if result.isValid {
                successfulValidResponse = 1
                break
            }

            if retriesNeeded >= maxRetries {
                successfulValidResponse = 0
                break
            }

            retriesNeeded += 1
            prompt = result.issues.joined(separator: "; ") + "\n" + correctionPrompt
        } catch {
            successfulValidResponse = 0
            break
        }
    }

    return BenchmarkRow(
        trial: trial,
        model: modelName,
        successfulValidResponse: successfulValidResponse,
        firstTryValid: firstTryValid,
        retriesNeeded: retriesNeeded,
        attemptsUsed: attemptsUsed,
        totalHallucinationsSeenAcrossAttempts: totalHallucinationsSeenAcrossAttempts,
        firstAttemptHallucinations: firstAttemptHallucinations,
        finalHallucinations: finalHallucinations,
        tokenLimitExceeded: tokenLimitExceeded,
        finalDuplicateCount: finalDuplicateCount
    )
}


// MARK: - Sessions

let appleSession = Session(
    appleModel: .default,
    tools: [],
    instructions: nil
)

let llamaSession = try await Session.makeMLX(
    id: llamaModelID,
    systemPrompt: systemPrompt
)

let gemmaSession = try await Session.makeMLX(
    id: gemmaModelID,
    systemPrompt: systemPrompt
)

func ragSession() async throws -> String {
    appleSession.reset()
    let selection = try await ragSelectExercises(
        session: appleSession,
        allExercises: AppConstants.allExercises,
        patientInfo: "",
        topK: 15
    )
    return formatSelection(selection)
}

// MARK: - CSV output

let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let baselineCSVURL = docs.appendingPathComponent("2703_baseline_llm_results.csv")
let appleVsRagCSVURL = docs.appendingPathComponent("2803_apple_vs_rag_results.csv")

resetCSV(baselineCSVURL)
resetCSV(appleVsRagCSVURL)

print("Saving baseline results to: \(baselineCSVURL.path)")
print("Saving Apple vs RAG results to: \(appleVsRagCSVURL.path)")

for trial in 1...trials {
    print("=== Trial \(trial) / \(trials) ===")

    // One sampled catalogue per trial, reused across Apple/Llama/Gemma baseline
    // and also reused for the normal Apple arm of Apple-vs-RAG.
    let sampledCatalogue = sampledCatalogueByCategory(sampleSize: sampledPerCategory)
    let sampledCatalogueText = makeExerciseCatalogueText(from: sampledCatalogue)

    // ---------------------------
    // BASELINE: Apple / Llama / Gemma
    // ---------------------------
    let baselinePrompt = makeBaselinePrompt(catalogueText: sampledCatalogueText, patientInfo: nil)
    appleSession.reset()
    gemmaSession.reset()
    llamaSession.reset()
    let appleBaseline = await runModel(
        trial: trial,
        modelName: "apple_system_language_model",
        session: appleSession,
        buildInitialPrompt: { baselinePrompt },
        correctionPrompt: correctionMessage(for: false)
    )
    try appendCSVLine(appleBaseline.csvLine(), to: baselineCSVURL)
    print("Baseline Apple done")

    let gemmaBaseline = await runModel(
        trial: trial,
        modelName: "gemma_2_2b_it_4bit",
        session: gemmaSession,
        buildInitialPrompt: { baselinePrompt },
        correctionPrompt: correctionMessage(for: false)
    )
    try
appendCSVLine(gemmaBaseline.csvLine(), to: baselineCSVURL)
    print("Baseline Gemma done")

    let llamaBaseline = await runModel(
        trial: trial,
        modelName: "llama_3_2_1b_instruct_4bit",
        session: llamaSession,
        buildInitialPrompt: { baselinePrompt },
        correctionPrompt: correctionMessage(for: false)
    )
    try appendCSVLine(llamaBaseline.csvLine(), to: baselineCSVURL)
    print("Baseline Llama done")

    // ---------------------------
    // APPLE vs RAG APPLE
    // ---------------------------
    let patient = MockData.mockPatients[(trial - 1) % MockData.mockPatients.count]
    let patientInfo = patient.condensedString
    appleSession.reset()
    let appleNormal = await runModel(
        trial: trial,
        modelName: "normal_apple",
        session: appleSession,
        buildInitialPrompt: {
            makeBaselinePrompt(catalogueText: sampledCatalogueText, patientInfo: patientInfo)
        },
        correctionPrompt: correctionMessage(for: false)
    )
    try appendCSVLine(appleNormal.csvLine(), to: appleVsRagCSVURL)
    print("Apple normal done")
    appleSession.reset()
    let appleRAG = await runRagModel(
        trial: trial,
        modelName: "rag_apple",
        session: ragSession,
        buildInitialPrompt: {
            makeRAGPrompt(patientInfo: patientInfo, topK: ragTopK)
        },
        correctionPrompt: correctionMessage(for: true)
    )
    try appendCSVLine(appleRAG.csvLine(), to: appleVsRagCSVURL)
    print("Apple RAG done")
}

print("Finished.")
print("Baseline CSV: \(baselineCSVURL.path)")
print("Apple vs RAG CSV: \(appleVsRagCSVURL.path)")
