import SwiftUI

struct MainCalculatorView: View {
    @EnvironmentObject private var exerciseLibrary: ExerciseLibrary
    @StateObject private var viewModel = MainCalculatorViewModel()

    @AppStorage(StorageKeys.preferredUnit) private var storedUnit = WeightUnit.kg.rawValue
    @AppStorage(StorageKeys.userLevel) private var storedLevel = UserLevel.intermediate.rawValue

    @State private var showExerciseSheet = false
    @State private var showModelInfo = false
    @State private var showEstimateSheet = false
    @State private var showTimer = false
    @State private var previousUnit: WeightUnit = .kg

    private var weightUnit: WeightUnit {
        WeightUnit(rawValue: storedUnit) ?? .kg
    }

    private var userLevel: UserLevel {
        UserLevel(rawValue: storedLevel) ?? .intermediate
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    exerciseCard
                    warmupModelCard
                    calculateButton
                    resultsCard
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Warmup Calculator")
            .sheet(isPresented: $showExerciseSheet) {
                NavigationStack {
                    ExerciseSelectionView(selectedExercise: $viewModel.selectedExercise)
                        .environmentObject(exerciseLibrary)
                }
            }
            .sheet(isPresented: $showModelInfo) {
                NavigationStack { WarmupModelInfoView() }
            }
            .sheet(isPresented: $showEstimateSheet) {
                EstimateOneRMView(unit: weightUnit) { estimated in
                    viewModel.updateWorkingWeight(with: estimated)
                }
            }
            .sheet(isPresented: $showTimer) {
                TimerView()
            }
            .onAppear {
                previousUnit = weightUnit
            }
            .onChange(of: storedUnit) { _ in
                let newUnit = weightUnit
                convertWorkingWeight(from: previousUnit, to: newUnit)
                previousUnit = newUnit
                recalculateIfNeeded()
            }
            .onChange(of: storedLevel) { _ in
                recalculateIfNeeded()
            }
            .onChange(of: viewModel.warmupModel) { _ in
                recalculateIfNeeded()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Science-based warmups")
                .font(.title)
                .fontWeight(.bold)
            Text("Optimisez vos séries d'échauffement selon l'exercice, le protocole et votre niveau.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }

    private var exerciseCard: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                Text("Exercice & charge")
                    .font(.headline)

                Button {
                    showExerciseSheet = true
                } label: {
                    HStack {
                        if let exercise = viewModel.selectedExercise {
                            Label(exercise.name, systemImage: exercise.iconName)
                                .font(.body.weight(.medium))
                            Spacer()
                            Text(exercise.type.displayName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            Label("Choisir un exercice", systemImage: "list.bullet")
                                .font(.body.weight(.medium))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Poids de travail")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    HStack(spacing: 12) {
                        TextField("Poids", text: $viewModel.workingWeightInput)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)

                        Picker("Unité", selection: $storedUnit) {
                            ForEach(WeightUnit.allCases) { unit in
                                Text(unit.displayName).tag(unit.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 130)
                    }

                    Button {
                        showEstimateSheet = true
                    } label: {
                        Label("Estimer mon 1RM", systemImage: "function")
                    }
                    .buttonStyle(.borderless)

                    Label("Niveau : \(userLevel.displayName)", systemImage: "person.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var warmupModelCard: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Modèle d'échauffement", systemImage: viewModel.warmupModel.icon)
                        .font(.headline)
                    Spacer()
                    Button {
                        showModelInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .buttonStyle(.plain)
                }

                Picker("Modèle", selection: $viewModel.warmupModel) {
                    ForEach(WarmupModel.allCases) { model in
                        Text(model.title).tag(model)
                    }
                }
                .pickerStyle(.segmented)

                Text(viewModel.warmupModel.summary)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var calculateButton: some View {
        Button {
            viewModel.calculate(unit: weightUnit, userLevel: userLevel)
        } label: {
            Text("Calculer l'échauffement")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(14)
        }
        .padding(.horizontal, 4)
        .disabled(viewModel.selectedExercise == nil || viewModel.workingWeightInput.isEmpty)
    }

    private var resultsCard: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Protocoles générés", systemImage: "flame.fill")
                        .font(.headline)
                    Spacer()
                    if !viewModel.warmupSets.isEmpty {
                        Button {
                            showTimer = true
                        } label: {
                            Label("Timer", systemImage: "timer")
                        }
                        .buttonStyle(.borderless)
                    }
                }

                if viewModel.warmupSets.isEmpty {
                    Text("Renseignez votre exercice et votre charge puis lancez le calcul pour voir les séries recommandées.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                } else {
                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.warmupSets.enumerated()), id: \.offset) { index, set in
                            WarmupSetRow(set: WarmupSet(setNumber: index + 1, weight: set.weight, reps: set.reps, percentage: set.percentage, note: set.note), unit: weightUnit)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Recommandations")
                            .font(.subheadline.weight(.semibold))
                        Text("• Repos 45-60 sec entre les séries d'échauffement.\n• Repos 2-3 min avant la série de travail.\n• Concentrez-vous sur la technique et la respiration.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    private func convertWorkingWeight(from oldUnit: WeightUnit, to newUnit: WeightUnit) {
        guard oldUnit != newUnit else { return }
        let normalized = viewModel.workingWeightInput.replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized), value > 0 else { return }

        let valueInKg = oldUnit == .kg ? value : value / WeightUnit.lbs.conversionFactor
        let converted = newUnit == .kg ? valueInKg : valueInKg * WeightUnit.lbs.conversionFactor
        viewModel.updateWorkingWeight(with: converted)
    }

    private func recalculateIfNeeded() {
        guard !viewModel.warmupSets.isEmpty else { return }
        viewModel.calculate(unit: weightUnit, userLevel: userLevel)
    }
}

struct MainCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCalculatorView()
            .environmentObject(ExerciseLibrary())
    }
}
