import Foundation
import SwiftUI

struct WarmupSet: Identifiable, Equatable {
    let id = UUID()
    let setNumber: Int
    let weight: Double
    let reps: Int
    let percentage: Int
    let note: String?

    init(setNumber: Int, weight: Double, reps: Int, percentage: Int, note: String? = nil) {
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.percentage = percentage
        self.note = note
    }
}

enum ExerciseType: String, CaseIterable, Codable, Identifiable {
    case compound
    case secondaryCompound
    case isolation
    case machine

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .compound: return Localization.localizedString("Polyarticulaire")
        case .secondaryCompound: return Localization.localizedString("Assistance")
        case .isolation: return Localization.localizedString("Isolation")
        case .machine: return Localization.localizedString("Machine")
        }
    }

    var sfSymbolName: String {
        switch self {
        case .compound: return "figure.strengthtraining.traditional"
        case .secondaryCompound: return "figure.core.training"
        case .isolation: return "dumbbell"
        case .machine: return "gearshape.2"
        }
    }

    var helpText: String {
        switch self {
        case .compound:
            return Localization.localizedString("Mobilise plusieurs articulations et groupes musculaires (ex: squat, développé couché).")
        case .secondaryCompound:
            return Localization.localizedString("Mouvements d'assistance polyarticulaires ou variantes plus légères.")
        case .isolation:
            return Localization.localizedString("Cible un muscle ou une articulation spécifique (ex: curl biceps, extension triceps).")
        case .machine:
            return Localization.localizedString("Exercices guidés sur machine. Classer selon la dominante polyarticulaire ou isolation.")
        }
    }

    var isCompoundFocused: Bool {
        switch self {
        case .compound: return true
        case .secondaryCompound: return true
        case .machine: return true
        case .isolation: return false
        }
    }
}

enum EquipmentType: String, CaseIterable, Codable, Identifiable {
    case barbell
    case dumbbell
    case machine

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .barbell: return Localization.localizedString("Barre")
        case .dumbbell: return Localization.localizedString("Haltère")
        case .machine: return Localization.localizedString("Machine")
        }
    }

    var sfSymbolName: String {
        switch self {
        case .barbell: return "barbell"
        case .dumbbell: return "dumbbell"
        case .machine: return "figure.core.training"
        }
    }
}

enum WeightUnit: String, CaseIterable, Identifiable {
    case kg
    case lbs

    var id: String { rawValue }

    var displayName: String {
        rawValue.uppercased()
    }

    var conversionFactor: Double {
        switch self {
        case .kg: return 1.0
        case .lbs: return 2.20462262
        }
    }
}

enum WarmupModel: String, CaseIterable, Identifiable {
    case progressive
    case potentiation80

    var id: String { rawValue }

    var title: String {
        switch self {
        case .progressive: return Localization.localizedString("Progressif")
        case .potentiation80: return Localization.localizedString("Potentiation 80%")
        }
    }

    var icon: String {
        switch self {
        case .progressive: return "chart.line.uptrend.xyaxis"
        case .potentiation80: return "bolt.fill"
        }
    }

    var summary: String {
        switch self {
        case .progressive:
            return Localization.localizedString("Montée graduelle en charge avec single lourd pour activer le système nerveux.")
        case .potentiation80:
            return Localization.localizedString("Deux séries rapides pour un échauffement court mais puissant.")
        }
    }
}

enum UserLevel: String, CaseIterable, Identifiable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .beginner: return Localization.localizedString("Débutant")
        case .intermediate: return Localization.localizedString("Intermédiaire")
        case .advanced: return Localization.localizedString("Avancé")
        }
    }

    var description: String {
        switch self {
        case .beginner:
            return Localization.localizedString("Moins d'un an de pratique régulière. Travail technique prioritaire et charges modérées.")
        case .intermediate:
            return Localization.localizedString("1 à 3 ans d'entraînement sérieux. Technique stable, charges modérées à lourdes.")
        case .advanced:
            return Localization.localizedString("Plus de 3 ans de pratique. Charges lourdes maîtrisées et programmation personnalisée.")
        }
    }
}

enum StorageKeys {
    static let userLevel = "userLevel"
    static let preferredUnit = "preferredUnit"
    static let selectedLanguage = "selectedLanguage"
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case french = "fr"
    case english = "en"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .french:
            return Localization.localizedString("Français")
        case .english:
            return Localization.localizedString("English")
        }
    }

    var localeIdentifier: String { rawValue }
}
