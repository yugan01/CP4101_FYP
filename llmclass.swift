//
//  llmclass.swift
//  beta2
//
//  Created by admin on 28/9/25.
//
import FoundationModels
import Foundation
import MLXLLM
import MLXLMCommon

protocol SessionStub {
    func respond(to prompt: String) async throws -> String
}

enum SessionBackend {
    case apple(LanguageModelSession)
    case mlx(ChatSession)
}

class Session: SessionStub {
    let backend: SessionBackend
    let systemPrompt: String?
    
    init(
        appleModel: SystemLanguageModel = .default,
        tools: [any FoundationModels.Tool] = [],
        instructions: String? = nil
    ) {
        self.backend = .apple(LanguageModelSession(model: appleModel,
                                                   tools: tools,
                                                   instructions: instructions))
        self.systemPrompt = nil
    }
    
    init(mlxModel: MLXLMCommon.ModelContext, systemPrompt: String? = nil) {
        let chat = ChatSession(mlxModel)
        self.backend = .mlx(chat)
        self.systemPrompt = systemPrompt
    }
    
    static func makeMLX(id: String, systemPrompt: String? = nil) async throws -> Session {
        let mdl = try await loadModel(id: id)
        return Session(mlxModel: mdl, systemPrompt: systemPrompt)
    }
    
    func respond(to prompt: String) async throws -> String {
            switch backend {
            case .apple(let s):
                let r = try await s.respond(to: prompt)
                return r.content
            case .mlx(let s):
                // Prepend optional system prompt
                if let sys = systemPrompt, !sys.isEmpty {
                    let combined = sys + "\n\n" + prompt
                    return try await s.respond(to: combined)
                }
                return try await s.respond(to: prompt)
            }
        }
}

