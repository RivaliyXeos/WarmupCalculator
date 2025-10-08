import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var type: ExerciseType = .compound
    @State private var equipment: EquipmentType = .barbell

    let onAdd: (String, ExerciseType, EquipmentType) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Nom de l'exercice")) {
                    TextField("Nom", text: $name)
                }

                Section(header: Text("Catégorie")) {
                    Picker("Type", selection: $type) {
                        ForEach(ExerciseType.allCases) { exerciseType in
                            Text(exerciseType.displayName).tag(exerciseType)
                        }
                    }
                    Picker("Matériel", selection: $equipment) {
                        ForEach(EquipmentType.allCases) { equipment in
                            Label(equipment.displayName, systemImage: equipment.sfSymbolName)
                                .tag(equipment)
                        }
                    }
                }

                Section(footer: Text("Les exercices ajoutés sont sauvegardés localement sur l'appareil.")) {
                    EmptyView()
                }
            }
            .navigationTitle("Nouvel exercice")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        onAdd(name, type, equipment)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView { _, _, _ in }
    }
}
