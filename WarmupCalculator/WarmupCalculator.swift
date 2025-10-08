import Foundation

struct WarmupStep {
    let percentage: Double
    let reps: Int
    let note: String?
}

final class WarmupCalculator {
    func calculateWarmup(workingWeight: Double, exercise: Exercise?, warmupModel: WarmupModel, userLevel: UserLevel, unit: WeightUnit) -> [WarmupSet] {
        guard let exercise = exercise, workingWeight > 0 else { return [] }

        var sets: [WarmupSet] = []
        var setNumber = 1

        if exercise.equipment == .barbell {
            let barWeight = barbellWeight(for: unit)
            sets.append(WarmupSet(
                setNumber: setNumber,
                weight: barWeight,
                reps: userLevel == .advanced ? 10 : 8,
                percentage: min(percentage(for: barWeight, workingWeight: workingWeight), 100),
                note: "Barre à vide"
            ))
            setNumber += 1
        }

        let steps: [WarmupStep]
        switch warmupModel {
        case .progressive:
            steps = progressiveSteps(for: exercise.type, level: userLevel, workingWeight: workingWeight, unit: unit)
        case .potentiation80:
            steps = potentiationSteps(for: exercise.type, level: userLevel, workingWeight: workingWeight, unit: unit)
        }

        for step in steps {
            let weight = roundWeight(workingWeight * step.percentage, unit: unit, equipment: exercise.equipment)
            guard weight > 0 else { continue }
            let percentage = Int(round(step.percentage * 100))
            if let last = sets.last, abs(last.weight - weight) < 0.01 {
                continue
            }
            sets.append(WarmupSet(
                setNumber: setNumber,
                weight: weight,
                reps: step.reps,
                percentage: min(percentage, 100),
                note: step.note
            ))
            setNumber += 1
        }

        return sets
    }

    func estimateOneRepMax(weight: Double, reps: Int) -> Double? {
        guard weight > 0, reps > 0, reps <= 36 else { return nil }
        let estimated = weight * (36.0 / (37.0 - Double(reps)))
        return estimated
    }
}

private extension WarmupCalculator {
    func progressiveSteps(for type: ExerciseType, level: UserLevel, workingWeight: Double, unit: WeightUnit) -> [WarmupStep] {
        let heavyThreshold = threshold(for: unit, level: level)
        let includeHeavySingle = workingWeight >= heavyThreshold || level == .advanced

        switch type {
        case .compound:
            var steps: [WarmupStep] = [
                WarmupStep(percentage: 0.5, reps: 8, note: nil)
            ]

            if level == .advanced {
                steps.append(WarmupStep(percentage: 0.6, reps: 6, note: "Activation supplémentaire"))
            }

            steps.append(WarmupStep(percentage: 0.7, reps: level == .beginner ? 5 : 5, note: nil))
            steps.append(WarmupStep(percentage: 0.8, reps: level == .beginner ? 3 : 3, note: nil))

            if level != .beginner {
                steps.append(WarmupStep(percentage: 0.9, reps: 1, note: "Single technique"))
            }

            if includeHeavySingle {
                steps.append(WarmupStep(percentage: 0.95, reps: 1, note: "Potentiation neuromusculaire"))
            }

            return steps

        case .secondaryCompound, .machine:
            var steps: [WarmupStep] = [
                WarmupStep(percentage: 0.5, reps: 8, note: nil),
                WarmupStep(percentage: 0.7, reps: 4, note: nil)
            ]

            if level != .beginner {
                steps.append(WarmupStep(percentage: 0.8, reps: 3, note: nil))
            }

            if level == .advanced {
                steps.append(WarmupStep(percentage: 0.9, reps: 1, note: "Single léger"))
            }

            return steps

        case .isolation:
            var steps: [WarmupStep] = [WarmupStep(percentage: 0.5, reps: 12, note: nil)]

            if level != .beginner {
                steps.append(WarmupStep(percentage: 0.65, reps: 8, note: nil))
            }

            if level == .advanced {
                steps.append(WarmupStep(percentage: 0.75, reps: 6, note: nil))
            }

            return steps
        }
    }

    func potentiationSteps(for type: ExerciseType, level: UserLevel, workingWeight: Double, unit: WeightUnit) -> [WarmupStep] {
        let heavyThreshold = threshold(for: unit, level: level)
        let includeHeavySingle = level == .advanced && workingWeight >= heavyThreshold

        switch type {
        case .compound:
            var steps: [WarmupStep] = [WarmupStep(percentage: 0.5, reps: level == .advanced ? 6 : 8, note: nil)]
            let secondPercentage: Double

            switch level {
            case .beginner:
                secondPercentage = 0.7
            case .intermediate:
                secondPercentage = 0.8
            case .advanced:
                secondPercentage = 0.85
            }

            steps.append(WarmupStep(percentage: secondPercentage, reps: level == .advanced ? 3 : 5, note: nil))

            if includeHeavySingle {
                steps.append(WarmupStep(percentage: 0.92, reps: 1, note: "Single de potentiation"))
            }

            return steps

        case .secondaryCompound, .machine:
            var steps: [WarmupStep] = [WarmupStep(percentage: 0.5, reps: 8, note: nil)]
            let secondPercentage = level == .beginner ? 0.7 : 0.78
            steps.append(WarmupStep(percentage: secondPercentage, reps: level == .advanced ? 4 : 5, note: nil))
            return steps

        case .isolation:
            if level == .beginner {
                return [WarmupStep(percentage: 0.5, reps: 12, note: nil)]
            }

            let secondPercentage = level == .advanced ? 0.7 : 0.65
            return [
                WarmupStep(percentage: 0.5, reps: 12, note: nil),
                WarmupStep(percentage: secondPercentage, reps: level == .advanced ? 8 : 10, note: nil)
            ]
        }
    }

    func threshold(for unit: WeightUnit, level: UserLevel) -> Double {
        let base = unit == .lbs ? 315.0 : 143.0
        switch level {
        case .beginner:
            return base * 1.1
        case .intermediate:
            return base
        case .advanced:
            return base * 0.88
        }
    }

    func roundWeight(_ weight: Double, unit: WeightUnit, equipment: EquipmentType) -> Double {
        let increment: Double
        switch equipment {
        case .barbell:
            increment = unit == .lbs ? 5.0 : 2.5
        case .dumbbell:
            increment = unit == .lbs ? 5.0 : 2.5
        case .machine:
            increment = unit == .lbs ? 5.0 : 2.5
        }

        let rounded = (weight / increment).rounded() * increment
        return max(rounded, increment)
    }

    func barbellWeight(for unit: WeightUnit) -> Double {
        unit == .lbs ? 45.0 : 20.0
    }

    func percentage(for weight: Double, workingWeight: Double) -> Int {
        guard workingWeight > 0 else { return 0 }
        return Int(round((weight / workingWeight) * 100))
    }
}
