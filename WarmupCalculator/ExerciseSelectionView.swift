import SwiftUI

struct ExerciseSelectionView: View {
    @EnvironmentObject private var exerciseLibrary: ExerciseLibrary
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedExercise: Exercise?

    @State private var showAddExercise = false
    @State private var alertMessage: String?

    var body: some View {
        List {
            ForEach(ExerciseType.allCases) { type in
                let exercises = exerciseLibrary.exercises(by: type)
                if !exercises.isEmpty {
                    Section(header: Label(type.displayName, systemImage: type.sfSymbolName)) {
                        ForEach(exercises) { exercise in
                            Button {
                                selectedExercise = exercise
                                dismiss()
                            } label: {
                                HStack {
                                    Label(exercise.name, systemImage: exercise.iconName)
                                        .labelStyle(.titleAndIcon)
                                    Spacer()
                                    if exercise.id == selectedExercise?.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Section {
                Button {
                    showAddExercise = true
                } label: {
                    Label("Ajouter un exercice", systemImage: "plus.circle")
                }
            } footer: {
                Text("Impossible de trouver votre mouvement ? Ajoutez-le et indiquez sa catégorie.")
            }

            Section {
                NavigationLink(destination: ExerciseTypeInfoView()) {
                    Label("Polyarticulaire vs Isolation", systemImage: "questionmark.circle")
                }
            }
        }
        .navigationTitle("Choisir un exercice")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Fermer") { dismiss() }
            }
        }
        .sheet(isPresented: $showAddExercise) {
            AddExerciseView { name, type, equipment in
                do {
                    try exerciseLibrary.addCustomExercise(name: name, type: type, equipment: equipment)
                } catch {
                    alertMessage = error.localizedDescription
                }
            }
        }
        .alert(item: $alertMessage) { message in
            Alert(title: Text("Erreur"), message: Text(message), dismissButton: .default(Text("OK")))
        }
    }
}

extension String: Identifiable {
    var id: String { self }
}

struct ExerciseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseSelectionView(selectedExercise: .constant(nil))
                .environmentObject(ExerciseLibrary())
        }
    }
}
