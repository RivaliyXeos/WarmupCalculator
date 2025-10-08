import SwiftUI

struct ExerciseTypeInfoView: View {
    var body: some View {
        List {
            Section(header: Text("Comprendre les catégories")) {
                ForEach(ExerciseType.allCases) { type in
                    VStack(alignment: .leading, spacing: 6) {
                        Label(type.displayName, systemImage: type.sfSymbolName)
                            .font(.headline)
                        Text(type.helpText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section(header: Text("Conseils pratiques")) {
                Text("• Les mouvements polyarticulaires demandent davantage de séries d'échauffement.\n• Les exercices d'isolation se contentent d'1 à 2 séries légères avant d'attaquer le travail.\n• Si vous hésitez, pensez au nombre d'articulations impliquées et à la charge habituelle.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
            }
        }
        .navigationTitle("Types d'exercices")
    }
}

struct ExerciseTypeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseTypeInfoView()
        }
    }
}
