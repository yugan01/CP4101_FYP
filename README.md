# ImmersiFit LLM Evaluation

This repository contains a restricted subset of source files from the *ImmersiFit* project — a mixed-reality exercise recommendation system developed for the Apple Vision Pro (AVP).  
The full codebase cannot be shared because it is part of an ongoing restricted project.  
The files included here demonstrate the **LLM benchmarking, retrieval, tagging, retagging, and validation framework** used to evaluate structured exercise recommendation for adolescent obesity.

---

## Project Overview

*ImmersiFit* leverages **extended reality (XR)** and **on-device AI** to support exercise recommendation for adolescents.  
This repository focuses on the **AI experimentation and retrieval pipeline** implemented in Swift, including:

- **Baseline benchmarking** of Apple Intelligence’s System Language Model (SLM), Llama 3.2, and Gemma 2.
- **Validity checking** of structured exercise recommendations.
- **Hallucination detection**, where hallucinations are defined as exercises not present in the approved master list.
- A **retrieval-augmented generation (RAG)** pipeline for condition-aware recommendation.
- A **retagging framework** that incorporates clinician feedback to refine exercise safety tags.

The experiments evaluate whether models can:

- Generate **valid exercise recommendations** with exactly 5 exercises in each category: *Warmup*, *Strength*, *Cardio*, and *Core*.
- Maintain format consistency and avoid duplicates.
- Avoid hallucinated exercise names.
- Respect patient pain-area constraints through deterministic filtering before generation.
- Operate under token and memory constraints on-device.

---

## Files Included

| File | Description |
|------|-------------|
| `comparison.swift` | Main benchmarking script. Runs 100-trial experiments for both the **baseline comparison** (Apple SLM vs Llama 3.2 vs Gemma 2) and the **Apple SLM vs Apple RAG** comparison. It builds sampled exercise catalogues, constructs prompts, runs retry loops, computes metrics such as validity and hallucinations, and writes CSV outputs. |
| `main.swift` | Entry point for the **retagging pipeline**. Loads the clinician-labelled Excel workbook, reads the existing tag database, runs `runRetaggingPipeline(...)`, and writes the refined JSON file (`retagging_2.json`). |
| `llmclass.swift` | Defines the `Session` abstraction layer. Wraps both Apple’s `LanguageModelSession` and MLX’s `ChatSession` behind a common interface, and supports resetting sessions between trials. It also converts Apple context-window failures into the string `"Token limit Exceeded"` so they can be logged consistently. |
| `validity.swift` | Implements `validityCheck()` and response parsing. Checks that each category contains exactly 5 exercises, detects duplicates, identifies hallucinated exercise names, and returns structured issues for reprompting. |
| `rag.swift` | Implements the **retrieval-augmented generation (RAG)** logic. Loads the exercise tag map, parses patient conditions, filters unsafe exercises using deterministic rules, builds candidate lists per category, and constructs the constrained prompt used for RAG-based exercise selection. |
| `retagging.swift` | Implements the **condition-aware retagging algorithm**. Parses clinician-labelled yes/no exercise appropriateness data from Excel, assigns explicit condition-specific avoidance tags, and propagates these tags to similar exercises using a condition-aware similarity score. |
| `exerciseTagging.swift` | Defines the base rule-based exercise tagging framework. Generates intrinsic biomechanical tags such as `low_impact`, `high_impact`, `jump`, `run`, `deep_knee_flexion`, `upper_push`, and `overhead` by parsing exercise names. |
| `Exercise.swift` | Defines the core exercise data structures, including `ExerciseCategory`, `Exercise`, and `ExerciseSelection`, along with related generable models used in the Apple FoundationModels workflow. |
| `Patient.swift` | Defines patient-related data structures, including demographic and body-composition information, pain areas, and a condensed patient-health string used in prompting and retrieval. |
| `AppConstants.swift` | Contains the master list of exercises used throughout the project. This list is the authoritative exercise catalogue used for prompting, validation, and retrieval. |
| `Tools.swift` | Provides helper tool definitions, including `GetExercisesAndPatientInformationTool`, which returns patient information for prompting workflows. |

The master exercise list itself is stored in `AppConstants.swift`, while the exercise model definitions are stored in `Exercise.swift`. Patient information and tool-based access to it are defined separately in `Patient.swift` and `Tools.swift`.

---

## Results and Data Files

| File | Description |
|------|-------------|
| `100_baseline_llm_results.csv` | Baseline benchmarking results for Apple SLM, Llama 3.2, and Gemma 2. Stores per-trial metrics such as validity, retries needed, hallucination counts, token-limit failures, and duplicate counts. |
| `2803_apple_vs_rag_results.csv` | Comparison results for **normal Apple SLM prompting** vs **Apple RAG prompting**. Stores the same metrics as the baseline benchmark. |
| `Appropriate exercises_Alif inputs 16032026.xlsx` | Clinician-labelled workbook containing yes/no appropriateness judgements for recommended exercises under different pain conditions. This file is used by the retagging pipeline. |
| `tagged_exercises_all.json` | Base exercise tag database generated from deterministic biomechanical tagging before clinician-informed refinement. |
| `retagging_2.json` | Refined exercise tag database after clinician-informed retagging and propagation of condition-specific avoidance tags. |

---

## Baseline Comparison

The baseline experiment compares three models:

- **Apple System Language Model**
- **Llama 3.2 1B**
- **Gemma 2 2B**

In each trial, a sampled exercise catalogue is built from the master list, and each model is asked to recommend exactly 5 exercises for each category. Responses are checked for:

- correct category counts
- correct structure
- duplicates
- hallucinated exercises
- token-limit failures

If the response is invalid, the system generates a corrective prompt and retries up to a fixed maximum. These results are logged to CSV for later statistical analysis. :contentReference[oaicite:8]{index=8} :contentReference[oaicite:9]{index=9}

---

## RAG Architecture

The RAG pipeline was introduced to reduce hallucinations and make exercise recommendations condition-aware. Instead of asking the model to select from the full master list directly, the system first performs a deterministic retrieval step:

1. Load the exercise tag map.
2. Parse patient condition tokens from the health information string.
3. Filter the master list using pain-area-specific safety rules.
4. Produce a smaller candidate list for each category.
5. Ask the language model to choose exactly 5 exercises per category from those candidates.

This changes the task from open-ended recommendation into constrained selection from a validated candidate set. The retrieval rules in `rag.swift` explicitly filter for conditions such as knee pain, patella subluxation, ankle instability, wrist pain, lower back pain, foot pain, shortness of breath, and girth-related limitations. :contentReference[oaicite:10]{index=10}

---

## Retagging Algorithm

The initial tagging scheme is rule-based and derives intrinsic biomechanical tags by parsing exercise names. Examples include:

- `run`, `jump`
- `low_impact`, `high_impact`
- `lunge`, `squat`, `hinge`
- `upper_push`, `upper_pull`, `overhead`
- `deep_knee_flexion`, `knee_friendly`, `core_stability`

To improve clinical relevance, a Human-in-the-Loop stage was introduced. The clinician labelled whether recommended exercises were appropriate for each of eight target conditions:

- girth limitation
- shortness of breath
- patella subluxation
- ankle instability
- knee pain
- wrist pain
- lower back pain
- foot pain

The retagging pipeline then:

1. parses the clinician workbook,
2. identifies exercises explicitly labelled “no,”
3. assigns condition-specific `avoid_*` tags,
4. propagates these tags to similar exercises using a condition-aware similarity function based on shared categories, shared condition-relevant tags, and shared significant name tokens.

This produces a refined exercise tag map that is then used by the RAG retrieval stage. :contentReference[oaicite:11]{index=11} :contentReference[oaicite:12]{index=12}

---

## Execution Summary

### Baseline and Apple-vs-RAG benchmarking
1. Build sampled exercise catalogue.
2. Construct baseline or RAG prompt.
3. Query the relevant model session.
4. Validate the output using `validityCheck()`.
5. Retry using a corrective prompt if needed.
6. Save per-trial metrics to CSV.

### Retagging workflow
1. Read the clinician-labelled Excel workbook.
2. Load the base exercise tag JSON.
3. Apply explicit condition-specific avoidance tags.
4. Propagate those tags to similar exercises.
5. Save the refined JSON tag database.

---

## Dependencies

- **Swift 5.9+**
- **Xcode 26 Beta**
- **MLX Swift** (`mlx-community` models)
- **FoundationModels** (Apple Intelligence APIs)
- **CoreXLSX** (used by the retagging pipeline to parse the clinician Excel workbook)

---

## Notes

This repository is intended to demonstrate the **LLM benchmarking, RAG, tagging, retagging, and validation framework** used in the ImmersiFit project, rather than the full production application.  
UI code, AVP integration, and other restricted project components are not included.
