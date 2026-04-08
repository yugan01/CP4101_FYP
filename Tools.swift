//
//  Tools.swift
//  NUS-SingHealth-KKH
//
//  Created by Andreas Garcia on 6/7/25.
//

import FoundationModels

@Generable
struct GetExercisesAndPatientInformationArguments: Sendable { }

final class GetExercisesAndPatientInformationTool: Tool {
    let name = "getExercisesAndUserInformation"
    let description = "Return the categories of exercises available in the programme and the patient health metrics."
    
    typealias Arguments = GetExercisesAndPatientInformationArguments
    
    func call(arguments: Arguments) async throws -> GeneratedContent {
//        print(MockData.mockPatients.first?.name)
//        print(MockData.mockPatients.first?.condensedString)
        return GeneratedContent(properties: [
            "patientHealthInformation": MockData.mockPatients.first?.condensedString,
//            "warmupExercises": AppConstants.prunedExerciseList().1,
//            "strengthExercises": AppConstants.prunedExerciseList().2,
//            "cardioExercises": AppConstants.prunedExerciseList().3,
//            "coreExercises": AppConstants.prunedExerciseList().4,
        ])
    }
}
