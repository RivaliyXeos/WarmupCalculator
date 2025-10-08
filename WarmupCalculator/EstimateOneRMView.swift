import SwiftUI

struct EstimateOneRMView: View {
    let unit: WeightUnit
    let onUseEstimate: (Double) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var weightInput: String = ""
    @State private var reps: Int = 5

    private let calculator = WarmupCalculator()

    private var estimate: Double? {
        let normalized = weightInput.replacingOccurrences(of: ",", with: ".")
        guard let weight = Double(normalized), weight > 0 else { return nil }
        return calculator.estimateOneRepMax(weight: weight, reps: reps)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Performance récente")) {
                    TextField("Poids soulevé", text: $weightInput)
                        .keyboardType(.decimalPad)

                    Stepper(value: $reps, in: 1...20) {
                        Text(Localization.localizedString("Répétitions: %d", arguments: reps))
                    }
                }

                Section(header: Text("Estimation")) {
                    if let estimate {
                        Text(Localization.localizedString("1RM estimé : %.1f %@", arguments: estimate, unit.displayName))
                            .font(.title3.weight(.semibold))
                            .padding(.vertical, 4)

                        Text("Formule de Brzycki – résultat indicatif, votre 1RM réel peut varier.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Entrez un poids et des répétitions valides pour obtenir une estimation.")
                            .foregroundColor(.secondary)
                    }
                }

                if let estimate {
                    Button {
                        onUseEstimate(estimate)
                        dismiss()
                    } label: {
                        Label("Utiliser comme charge de travail", systemImage: "arrow.down.circle")
                    }
                }
            }
            .navigationTitle("Estimer mon 1RM")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }
}

struct EstimateOneRMView_Previews: PreviewProvider {
    static var previews: some View {
        EstimateOneRMView(unit: .kg) { _ in }
    }
}
