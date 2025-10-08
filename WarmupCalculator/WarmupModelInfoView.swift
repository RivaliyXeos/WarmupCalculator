import SwiftUI

struct WarmupModelInfoView: View {
    var body: some View {
        List {
            Section {
                Label("Modèle Progressif", systemImage: WarmupModel.progressive.icon)
                    .font(.title3.weight(.semibold))
                Text("Idéal pour les charges maximales et la force. On augmente progressivement le pourcentage du poids de travail pour préparer le système nerveux et affiner la technique.")
                    .font(.body)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Protocole recommandé")
                        .font(.headline)
                    Label("50-60% × 8 répétitions", systemImage: "1.circle")
                    Label("70% × 5 répétitions", systemImage: "2.circle")
                    Label("80% × 3 répétitions", systemImage: "3.circle")
                    Label("90-95% × 1 répétition", systemImage: "4.circle")
                    Text("Les athlètes avancés peuvent ajouter une montée intermédiaire supplémentaire ou un single léger à 92%.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Quand l'utiliser ?")
                        .font(.headline)
                    Text("• Séances de force lourde (squat, développé couché, soulevé de terre).\n• Objectif : maximiser la performance sur une charge principale.\n• Parfait pour les pratiquants intermédiaires et avancés qui veulent limiter les surprises sur la série de travail.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Section {
                Label("Modèle Potentiation 80%", systemImage: WarmupModel.potentiation80.icon)
                    .font(.title3.weight(.semibold))
                Text("Échauffement court et intense pour passer rapidement aux séries effectives. Utilise une montée directe vers 80-85% pour activer sans générer trop de fatigue.")
                    .font(.body)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Protocole recommandé")
                        .font(.headline)
                    Label("≈50% × 6-8 répétitions", systemImage: "1.circle")
                    Label("≈80% × 3-5 répétitions", systemImage: "2.circle")
                    Text("Les pratiquants avancés peuvent ajouter un single à 90-92% pour maximiser la potentiation.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Quand l'utiliser ?")
                        .font(.headline)
                    Text("• Séances explosives ou de vitesse.\n• Athlètes confirmés disposant de peu de temps.\n• À privilégier sur les mouvements polyarticulaires. Pour les isolations, limitez-vous à 1-2 séries légères.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Modèles d'échauffement")
    }
}

struct WarmupModelInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WarmupModelInfoView()
        }
    }
}
