//
//  Exercise.swift
//  NUS-SingHealth-KKH
//
//  Created by Andreas Garcia on 6/7/25.
//



import Foundation
import FoundationModels

@Generable enum ExerciseCategory: String, Codable, Sendable, Hashable, CaseIterable {
    case warmup, strength, cardio, core
    
    static func from(_ raw: String) -> ExerciseCategory? {
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

@Generable
struct ExerciseSelection: Codable, Sendable, Hashable {
    @Guide(description: "Exercises categorised as warmup exercises", .count(5))
    var warmupExercises: [Exercise]
    
    @Guide(description: "Exercises categorised as strength exercises", .count(5))
    var strengthExercises: [Exercise]
    
    @Guide(description: "Exercises categorised as cardiovascular exercises", .count(5))
    var cardioExercises: [Exercise]
    
    @Guide(description: "Exercises categorised as core exercises", .count(5))
    var coreExercises: [Exercise]
}

/// MARK: - Main model
@Generable(description: "An exercise used in the adolescent training programme")
struct Exercise: Codable, Sendable, Hashable {

    // Basic identifiers
    let name: String
    let category: ExerciseCategory

    @Guide(description: "The duration of the exercise in seconds")
    let durationSeconds: Int?

    @Guide(description: "The number of sets to perform")
    let sets: Int?
    
    @Guide(description: "The number of reps to perform per set")
    let reps: Int?
    
    var completed: Bool = false
}

@Generable(description: "A fun overview of the patient's training session")
struct SessionOverview: Sendable {
    
    @Guide(description: "A short intro to the overview, something like 'So let's dive into today's session'")
    let introText: String
    
    @Guide(description: "A short overview of the warm up exercises they will be doing")
    let warmUpText: String
    
    @Guide(description: "A short overview of the strength exercises they will be doing")
    let strengthText: String
    
    @Guide(description: "A short overview of the cardio exercises they will be doing")
    let cardioText: String
    
    @Guide(description: "A short overview of the core exercises they will be doing")
    let coreText: String
    
    @Guide(description: "A final expression motivating the patient to train well this session")
    let finalText: String
}

@Generable(description: "A fun, coherent and motivating summary of the patient's training session")
struct SessionSummary: Sendable {
    
    @Guide(description: "A short intro sentence to the summary, format as 'Alright, let's dive right into your session summary!")
    let introText: String
    
    @Guide(description: "Give detailed praise for a maxiumum of 3 positive metrics found in the session statistics")
    let positiveFeedback: String
    
    @Guide(description: "Comment on how they can do even better in the next session")
    let affirmativeAction: String
    
    @Guide(description: "A final expression motivating the patient to continue their health journey")
    let finalText: String
}
