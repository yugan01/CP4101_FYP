//
//  main.swift
//  beta2
//
//  Created by admin on 27/9/25.
//

import Foundation
import MLXLLM
import MLXLMCommon
import FoundationModels


/// Prompts
let systemPrompt = "You have to answer, do not ask follow-up questions"

let tool = GetExercisesAndPatientInformationTool()
let exerciseAndPatientInfo = try await tool.call(arguments: .init()).jsonString


let verbosePrompt = AppConstants.intelligenceInstructions + "\n" + "The following is a mock patient's health information and available exercises. First, you should extract the health information and names of exercises and group them in the exercise category. There are 4 exercise categories: Warmup, Strength, Cardio and Core. For each category, prescribe exactly 5 exercises. Consider the patient's health information in prescribing the exercises.\n" + exerciseAndPatientInfo + "\n" + "To reiterate, based solely on the available exercises in each category, and the patient information, please plan the exercise session for the patient today. The exercise selection must include 5 exercises per exercise category (warmup, strength, cardio and core)"
let normalPrompt = AppConstants.intelligenceInstructions + "\n" + exerciseAndPatientInfo + "\n" + "Based on the available exercises in each category, and the patient information, please plan the exercise session for the patient today. The exercise selection must include 5 exercises per exercise category (warmup, strength, cardio and core)"
let minimalPrompt = "There are 4 exercise categories: Warmup, Strength, Cardio and Core. For each category, prescribe exactly 5 exercises.\n" + exerciseAndPatientInfo

let structure = "\n Output the response in the sequence of Warmup exercises, strength, cardio and core. Crucially, each exercise should be on a new line. Only provide 5 exercises per category. The exercises should also be listed below its category. Never include any special characters such as * or bullet points or dashes."
let redo_msg = "\n Provide 5 categories per exercise category (warmup, strength, cardio and core) again"


/// LLMs and Sessions

// Apple
let session = Session( 
    appleModel: .default,
    tools : [GetExercisesAndPatientInformationTool()]
)

// Llama
let session = try await Session.makeMLX(id: "mlx-community/Llama-3.2-1B-Instruct-4bit", systemPrompt: systemPrompt)

// Gemma
let session = try await Session.makeMLX(id: "mlx-community/gemma-2-2b-it-4bit", systemPrompt: systemPrompt)


var text = try await session.respond(to: minimalPrompt)

text.enumerateLines { line, _ in
   print(line)
}
print("\n")
var response = validityCheck(text)
print(response)

var maxcount = 0
while (response.isValid == false && maxcount < 5) {
    // response is invalid and corrective prompt sent
   let text = try await session.respond(to: response.issues.joined(separator: "\n") + redo_msg)
   print(text)
   response = validityCheck(text)
   print(response)
   maxcount+=1
}
print(maxcount)

