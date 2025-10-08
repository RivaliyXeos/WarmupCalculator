# Warmup Calculator

Warmup Calculator is a SwiftUI iOS app that builds science-backed warm-up protocols for strength training sessions. It lets lifters pick an exercise, enter their working weight, and instantly generates set-by-set guidance tailored to their experience level and the selected warm-up model.

## Features
- **Exercise-aware warm-ups** – Select from a categorized library of barbell, dumbbell, machine, and isolation movements, or add your own custom exercises when something is missing.【F:WarmupCalculator/ExerciseSelectionView.swift†L1-L63】【F:WarmupCalculator/ExerciseLibrary.swift†L5-L88】
- **Multiple warm-up models** – Compare progressive ramping and fast potentiation templates, each with contextual explanations to help you choose the right approach for your session.【F:WarmupCalculator/MainCalculatorView.swift†L77-L130】【F:WarmupCalculator/WarmupModelInfoView.swift†L1-L63】
- **Level-specific recommendations** – Store your training level and preferred unit once, then see volume, percentages, and notes that adapt to beginners, intermediates, or advanced lifters.【F:WarmupCalculator/MainCalculatorView.swift†L4-L69】【F:WarmupCalculator/ProfileView.swift†L1-L47】
- **Actionable results** – Get a detailed list of warm-up sets with rounded weights, reps, and coaching cues, plus a built-in rest timer to manage intra-set recovery.【F:WarmupCalculator/WarmupCalculator.swift†L8-L129】【F:WarmupCalculator/WarmupSetRow.swift†L1-L43】【F:WarmupCalculator/TimerView.swift†L1-L88】
- **Utilities for planning** – Estimate your one-rep max using the Brzycki formula and automatically reuse it as the working weight for new calculations.【F:WarmupCalculator/EstimateOneRMView.swift†L1-L61】

## How it works
1. Choose an exercise from the library (or create a custom one) and enter the target working weight.
2. Pick a warm-up model (Progressive or Potentiation 80%) and tap **Calculer l'échauffement**.
3. The app computes the optimal sequence of sets by combining model-specific percentages, exercise type, equipment, and your training level, rounding the loads to realistic plate or dumbbell increments.【F:WarmupCalculator/MainCalculatorViewModel.swift†L1-L44】【F:WarmupCalculator/WarmupCalculator.swift†L8-L198】
4. Review the generated protocol, optional potentiation singles, and technique notes, then start the built-in timer between sets.

## Tech stack
- **SwiftUI** for the entire interface, including navigation, forms, and custom set rows.【F:WarmupCalculator/MainCalculatorView.swift†L1-L208】【F:WarmupCalculator/ProfileView.swift†L1-L47】
- **Combine & ObservableObject** for state management of the exercise library and main calculator view model.【F:WarmupCalculator/ExerciseLibrary.swift†L1-L88】【F:WarmupCalculator/MainCalculatorViewModel.swift†L1-L45】
- **AppStorage & UserDefaults** to persist the preferred units, training level, and user-defined exercises across launches.【F:WarmupCalculator/ProfileView.swift†L1-L47】【F:WarmupCalculator/ExerciseLibrary.swift†L13-L82】
- **AudioToolbox** for rest timer completion feedback.【F:WarmupCalculator/TimerView.swift†L1-L88】

## Getting started
1. Install **Xcode 15 or later** with the iOS 17 SDK.
2. Open `WarmupCalculator.xcodeproj` in Xcode.
3. Select the **WarmupCalculator** target and run it on an iOS 17 simulator or a compatible device.

### Testing
The project is configured for the new `swift-testing` package (module `Testing`). Run tests from Xcode with **Product ▸ Test** once you add coverage to `WarmupCalculatorTests` (currently contains a placeholder test case).【F:WarmupCalculatorTests/WarmupCalculatorTests.swift†L1-L14】

## Roadmap ideas
- Support for RPE-based warm-up adjustments.
- Exportable warm-up plans for sharing with training partners or coaches.
- Additional language localizations beyond French interface strings.

---
Warmup Calculator is designed to help lifters save time on math and focus on quality repetitions before heavy work sets.
