//
//  llmclass.swift
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
    private(set) var backend: SessionBackend
    private let appleModel: SystemLanguageModel
    private let mlxModel: MLXLMCommon.ModelContext?
    private let tools: [any FoundationModels.Tool]
    private let instructions: String?
    private let systemPrompt: String?
    
    init(
        appleModel: SystemLanguageModel = .default,
        tools: [any FoundationModels.Tool] = [],
        instructions: String? = nil
    ) {
        self.appleModel = appleModel
        self.tools = tools
        self.instructions = instructions
        self.systemPrompt = nil
        self.mlxModel = nil
        self.backend = .apple(LanguageModelSession(model: appleModel,
                                                   tools: tools,
                                                   instructions: instructions))
    }
    
    init(mlxModel: MLXLMCommon.ModelContext, systemPrompt: String? = nil) {
        self.appleModel = .default
        self.tools = []
        self.instructions = nil
        self.systemPrompt = systemPrompt
        self.mlxModel = mlxModel
        self.backend = .mlx(ChatSession(mlxModel))
    }
    
    // Factory: load MLX by id (awaitable like MLX examples)
    static func makeMLX(id: String, systemPrompt: String? = nil) async throws -> Session {
        let mdl = try await loadModel(id: id)
        return Session(mlxModel: mdl, systemPrompt: systemPrompt)
    }
    
    func reset() {
        switch backend {
        case .apple:
            backend = .apple(LanguageModelSession(model: appleModel,
                                                  tools: tools,
                                                  instructions: instructions))
        case .mlx:
            guard let mlxContext = mlxModel else {return}
            backend = .mlx(ChatSession(mlxContext))
        }
    }
    
    func respond(to prompt: String) async throws -> String {
            switch backend {
            case .apple(let s):
                do {
                    let r = try await s.respond(to: prompt)
                    return r.content
                } catch FoundationModels.LanguageModelSession.GenerationError.exceededContextWindowSize {
                    return "Token limit Exceeded"
                }
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

