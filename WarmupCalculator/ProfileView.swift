import SwiftUI

struct ProfileView: View {
    @AppStorage(StorageKeys.userLevel) private var storedLevel = UserLevel.intermediate.rawValue
    @AppStorage(StorageKeys.preferredUnit) private var storedUnit = WeightUnit.kg.rawValue

    private var userLevel: UserLevel {
        UserLevel(rawValue: storedLevel) ?? .intermediate
    }

    private var preferredUnit: WeightUnit {
        WeightUnit(rawValue: storedUnit) ?? .kg
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Niveau d'entraînement"), footer: Text(userLevel.description).font(.footnote)) {
                    Picker("Niveau", selection: $storedLevel) {
                        ForEach(UserLevel.allCases) { level in
                            Text(level.displayName).tag(level.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Unités de poids")) {
                    Picker("Unité", selection: $storedUnit) {
                        ForEach(WeightUnit.allCases) { unit in
                            Text(unit.displayName).tag(unit.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)

                    Text("Le choix est mémorisé et utilisé pour tous les calculs.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Ressources")) {
                    NavigationLink(destination: WarmupModelInfoView()) {
                        Label("Comprendre les protocoles", systemImage: "flame.fill")
                    }
                    NavigationLink(destination: ExerciseTypeInfoView()) {
                        Label("Différence polyarticulaire / isolation", systemImage: "questionmark.circle")
                    }
                }
            }
            .navigationTitle("Profil & réglages")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
