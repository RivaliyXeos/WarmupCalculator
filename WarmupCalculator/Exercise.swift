import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var type: ExerciseType
    var equipment: EquipmentType

    init(id: UUID = UUID(), name: String, type: ExerciseType, equipment: EquipmentType) {
        self.id = id
        self.name = name
        self.type = type
        self.equipment = equipment
    }

    var iconName: String {
        type.sfSymbolName
    }
}

extension Array where Element == Exercise {
    func sortedAlphabetically() -> [Exercise] {
        sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
