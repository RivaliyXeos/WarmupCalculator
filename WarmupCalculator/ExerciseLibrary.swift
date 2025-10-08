import Foundation
import Combine

final class ExerciseLibrary: ObservableObject {
    @Published private(set) var builtInExercises: [Exercise]
    @Published private(set) var customExercises: [Exercise] = []

    private let storageKey = "customExercises"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init() {
        self.builtInExercises = ExerciseLibrary.defaultExercises
        loadCustomExercises()
    }

    var allExercises: [Exercise] {
        (builtInExercises + customExercises).sortedAlphabetically()
    }

    func exercises(by type: ExerciseType) -> [Exercise] {
        allExercises.filter { $0.type == type }
    }

    func addCustomExercise(name: String, type: ExerciseType, equipment: EquipmentType) throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        if allExercises.contains(where: { $0.name.compare(trimmedName, options: .caseInsensitive) == .orderedSame }) {
            throw ExerciseLibraryError.duplicate
        }

        let exercise = Exercise(name: trimmedName, type: type, equipment: equipment)
        customExercises.append(exercise)
        customExercises = customExercises.sortedAlphabetically()
        saveCustomExercises()
    }

    private func loadCustomExercises() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoded = try decoder.decode([Exercise].self, from: data)
            customExercises = decoded.sortedAlphabetically()
        } catch {
            customExercises = []
        }
    }

    private func saveCustomExercises() {
        do {
            let data = try encoder.encode(customExercises)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // Ignore saving errors silently for now
        }
    }
}

enum ExerciseLibraryError: Error, LocalizedError {
    case duplicate

    var errorDescription: String? {
        switch self {
        case .duplicate:
            return Localization.localizedString("Cet exercice existe déjà dans la bibliothèque.")
        }
    }
}

private extension ExerciseLibrary {
    static let defaultExercises: [Exercise] = [
        Exercise(name: "Back Squat", type: .compound, equipment: .barbell),
        Exercise(name: "Front Squat", type: .compound, equipment: .barbell),
        Exercise(name: "Bench Press", type: .compound, equipment: .barbell),
        Exercise(name: "Incline Bench Press", type: .secondaryCompound, equipment: .barbell),
        Exercise(name: "Deadlift", type: .compound, equipment: .barbell),
        Exercise(name: "Romanian Deadlift", type: .secondaryCompound, equipment: .barbell),
        Exercise(name: "Overhead Press", type: .compound, equipment: .barbell),
        Exercise(name: "Barbell Row", type: .secondaryCompound, equipment: .barbell),
        Exercise(name: "Pull-Up", type: .compound, equipment: .machine),
        Exercise(name: "Lat Pulldown", type: .secondaryCompound, equipment: .machine),
        Exercise(name: "Leg Press", type: .compound, equipment: .machine),
        Exercise(name: "Hack Squat", type: .compound, equipment: .machine),
        Exercise(name: "Dip", type: .secondaryCompound, equipment: .machine),
        Exercise(name: "Seated Cable Row", type: .secondaryCompound, equipment: .machine),
        Exercise(name: "Dumbbell Bench Press", type: .secondaryCompound, equipment: .dumbbell),
        Exercise(name: "Goblet Squat", type: .secondaryCompound, equipment: .dumbbell),
        Exercise(name: "Biceps Curl", type: .isolation, equipment: .dumbbell),
        Exercise(name: "Hammer Curl", type: .isolation, equipment: .dumbbell),
        Exercise(name: "Triceps Extension", type: .isolation, equipment: .machine),
        Exercise(name: "Leg Extension", type: .isolation, equipment: .machine),
        Exercise(name: "Leg Curl", type: .isolation, equipment: .machine),
        Exercise(name: "Lateral Raise", type: .isolation, equipment: .dumbbell),
        Exercise(name: "Calf Raise", type: .isolation, equipment: .machine),
        Exercise(name: "Face Pull", type: .isolation, equipment: .machine)
    ]
}
