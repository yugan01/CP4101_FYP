# ImmersiFit LLM Evaluation 

This repository contains a restricted subset of source files from the *ImmersiFit* project — a mixed-reality exercise recommendation system developed for the Apple Vision Pro (AVP).  
The full codebase cannot be shared as it is an ongoing restricted project.  
The files here demonstrate the **LLM evaluation and validation framework** used to test and compare **Apple Intelligence’s System Language Model (SLM)**, **Llama 3.2** and **Gemma 2** for generating valid, structured exercise prescriptions.

---

## Project Overview

*ImmersiFit* leverages **extended reality (XR)** and **on-device AI** to recommend exercises that help address adolescent obesity.  
Within this repository, the focus is on the **AI experimentation pipeline** that benchmarks several large language models (LLMs) in Swift using **MLX Swift**.  
The experiment evaluates how well each model can:

- Generate **valid exercise recommendations** (5 per category: *Warm-up*, *Strength*, *Cardio*, *Core*).  
- Maintain format consistency and avoid duplicates.  
- Operate efficiently under memory and token-limit constraints.  

---

## Files Included

| File | Description |
|------|--------------|
| [main.swift](main.swift) | Main file for running model comparisons. Builds prompt variants (minimal, normal, verbose) and initialises chat sessions with Apple SLM, Llama 3.2, and Gemma 2. Iteratively re-prompts models until a valid output is achieved or retries are exhausted. |
| [llmclass.swift](llmclass.swift) | Defines the `Session` abstraction layer. Unifies Apple’s `LanguageModelSession` and MLX-based `ChatSession` APIs so that different LLMs can be queried through a single interface. Includes async response handling and optional system prompts. |
| [validity.swift](validity.swift) | Implements `validityCheck()` and `improveResponse()`, which parse model outputs, verify that each category has exactly five unique exercises, detect duplicates, and generate concise corrective prompts for invalid responses. This forms the foundation of the **critique-and-revise** mechanism. |

---

## Execution Summary

1. **Prompt Construction:** Three prompt templates (minimal, normal, verbose) are defined.  
2. **Model Invocation:** Each LLM runs five trials per prompt type using the `Session` interface.  
3. **Validation:** The `validityCheck()` function analyzes model outputs.  
4. **Correction Loop:** Invalid responses trigger generated corrective prompts for up to five iterations.  
5. **Metrics Logged:** Validity percentage and memory usage are recorded for comparison.

---

## Dependencies

- **Swift 5.9+**  
- **Xcode 26 Beta**  
- **MLX Swift** (`mlx-community` models)  
- **FoundationModels** (Apple Intelligence APIs)
