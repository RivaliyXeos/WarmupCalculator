import Foundation
import Combine

final class MainCalculatorViewModel: ObservableObject {
    @Published var workingWeightInput: String = ""
    @Published var warmupSets: [WarmupSet] = []
    @Published var selectedExercise: Exercise?
    @Published var warmupModel: WarmupModel = .progressive

    private let calculator = WarmupCalculator()
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.decimalSeparator = Locale.current.decimalSeparator ?? "."
        return formatter
    }()

    func calculate(unit: WeightUnit, userLevel: UserLevel) {
        guard let exercise = selectedExercise else {
            warmupSets = []
            return
        }

        let normalizedInput = workingWeightInput.replacingOccurrences(of: ",", with: ".")
        guard let weight = Double(normalizedInput), weight > 0 else {
            warmupSets = []
            return
        }

        warmupSets = calculator.calculateWarmup(
            workingWeight: weight,
            exercise: exercise,
            warmupModel: warmupModel,
            userLevel: userLevel,
            unit: unit
        )
    }

    func updateWorkingWeight(with value: Double) {
        workingWeightInput = numberFormatter.string(from: NSNumber(value: value)) ?? String(format: "%.1f", value)
    }

    func reset() {
        warmupSets = []
    }
}
