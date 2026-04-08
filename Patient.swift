//
//  Patient.swift
//  NUS-SingHealth-KKH
//
//  Created by Andreas Garcia on 29/5/25.
//

import FoundationModels

struct DoubleRange: Sendable, Hashable, Equatable, Codable {
    var min: Double
    var max: Double
}

struct IntRange: Sendable, Hashable, Equatable, Codable {
    var min: Int
    var max: Int
}

struct IntMeasurement: Sendable, Hashable, Equatable, Codable {
    var value: Int
    var unit: String
    var normalRange: IntRange?

    var isNormal: Bool {
        guard let r = normalRange else { return false }
        return value >= r.min && value <= r.max
    }
}

struct DoubleMeasurement: Sendable, Hashable, Equatable, Codable {
    var value: Double
    var unit: String
    var normalRange: DoubleRange?
    
    var isNormal: Bool {
        guard let r = normalRange else { return false }
        return value >= r.min && value <= r.max
    }
}

struct BodyCompositionAnalysis: Hashable, Equatable, Codable {
    var intracellularWater: DoubleMeasurement           // (t)
    var extracellularWater: DoubleMeasurement           // (t)
    var proteinMass: DoubleMeasurement                  // (kg)
    var mineralMass: DoubleMeasurement                  // (kg)
    var bodyFatMass: DoubleMeasurement                  // (kg)
    
    var weight: DoubleMeasurement                       // (kg)
    var skeletalMuscleMass: DoubleMeasurement           // (kg)
    var percentBodyFat: DoubleMeasurement               // (%)
    var bmi: DoubleMeasurement                          // (kg/m2)
    var bcm: DoubleMeasurement          // Body Cell Mass (kg)
    var bmc: DoubleMeasurement          // Bone Mineral Content (kg)
    var ac: DoubleMeasurement           // Arm Circumference (cm)
    var amc: DoubleMeasurement          // Arm Muscle Circumference (cm)
    var waistCircumference: DoubleMeasurement // (cm)
    var vfa: DoubleMeasurement          // Visceral Fat Area (cm²)
    var bmr: IntMeasurement             // Basal Metabolic Rate (kcal)
    var tbwFfm: DoubleMeasurement       // TBW/FFM ratio (%)
    var smi: DoubleMeasurement          // Skeletal Muscle Index (kg/m²)
}

struct Patient: Identifiable, Hashable, Codable {
    
    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
    }
    
    let id: String
    let name: String
    let age: Int
    let gender: Gender
    let height: Float
    let weight: Float
    let restingHeartRate: Int
    let bodyComposition: BodyCompositionAnalysis
    let painAreas: [String]
    var currentSession: Int = 1
    var effortScores: [Double] = []
    var experiencePoints: Int = 0
    
    var level: String {
        let maxLevel = 99
        var currentLevel = 1
        while currentLevel < maxLevel {
            let requiredForNextLevel = 500 * (currentLevel * currentLevel)
            if experiencePoints < requiredForNextLevel {
                break
            }
            currentLevel += 1
        }
        return String(currentLevel)
    }
    
    var condensedString: String {
        let painString = painAreas.joined(separator: ", ")
        return "Age: \(age), Gender:\(gender), Height:\(height)cm, Weight:\(weight)kg, Resting HR:\(restingHeartRate)bpm, BMI: \(bodyComposition.bmi.value), pain Areas: \(painString)"
    }
}
