import Foundation
import MLXLLM
import MLXLMCommon
import FoundationModels


do {
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    let workbookURL = docs.appendingPathComponent("Appropriate exercises_Alif inputs 16032026.xlsx")
    let inputTagURL = docs.appendingPathComponent("tagged_exercises_all.json")
    let outputTagURL = docs.appendingPathComponent("retagging_2.json")

    try runRetaggingPipeline(
        workbookURL: workbookURL,
        inputTagJSONURL: inputTagURL,
        outputTagJSONURL: outputTagURL
    )

    print("Retagging complete: \(outputTagURL.path)")
} catch {
    print("Retagging failed: \(error)")
}
