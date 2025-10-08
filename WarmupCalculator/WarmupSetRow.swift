import SwiftUI

struct WarmupSetRow: View {
    let set: WarmupSet
    let unit: WeightUnit

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.9))
                    .frame(width: 34, height: 34)
                Text("\(set.setNumber)")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(set.weight, specifier: "%.1f") \(unit.displayName)")
                        .font(.headline)
                    if let note = set.note {
                        Text(LocalizedStringKey(note))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Text(Localization.localizedString("%d répétitions • %d%%", arguments: set.reps, set.percentage))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ProgressView(value: Double(set.percentage), total: 100)
                .tint(.blue)
                .frame(width: 70)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct WarmupSetRow_Previews: PreviewProvider {
    static var previews: some View {
        WarmupSetRow(
            set: WarmupSet(setNumber: 1, weight: 60, reps: 8, percentage: 50),
            unit: .kg
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
