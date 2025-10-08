import SwiftUI
import Foundation
import AudioToolbox

// MARK: - Models
struct WarmupSet {
    let setNumber: Int
    let weight: Double
    let reps: Int
    let percentage: Int
}

enum ExerciseType: String, CaseIterable {
    case compound = "Compound"
    case secondaryCompound = "Secondary Compound"
    case isolation = "Isolation"
    case machine = "Machine"
}

enum EquipmentType: String, CaseIterable {
    case barbell = "Barbell"
    case dumbbell = "Dumbbell"
    case machine = "Machine"
}

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}

// MARK: - Content View
struct ContentView: View {
    @State private var workingWeight: String = ""
    @State private var exerciseType: ExerciseType = .compound
    @State private var equipmentType: EquipmentType = .barbell
    @State private var weightUnit: WeightUnit = .kg
    @State private var warmupSets: [WarmupSet] = []
    @State private var showTimer = false
    
    // iOS panel background color
    private var panelBackground: Color {
        Color(UIColor.systemGroupedBackground)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack {
                    Text("Warmup Calculator")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Science-based warmup protocols")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Input Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Exercise Details")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            // Working Weight Input
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Working Weight")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                HStack {
                                    TextField("Enter weight", text: $workingWeight)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.decimalPad)
                                    
                                    Picker("Unit", selection: $weightUnit) {
                                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                                            Text(unit.rawValue).tag(unit)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .frame(width: 120)
                                }
                            }
                            
                            // Exercise Type
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Exercise Type")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Picker("Exercise Type", selection: $exerciseType) {
                                    ForEach(ExerciseType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Equipment Type
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Equipment")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Picker("Equipment", selection: $equipmentType) {
                                    ForEach(EquipmentType.allCases, id: \.self) { equipment in
                                        Text(equipment.rawValue).tag(equipment)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        .padding()
                        .background(
                            panelBackground.opacity(0.8)
                        )
                        .cornerRadius(12)
                        
                        // Calculate Button
                        Button(action: calculateWarmup) {
                            Text("Calculate Warmup")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        
                        // Results Section
                        if !warmupSets.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Warmup Protocol")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                    
                                    Button(action: { showTimer = true }) {
                                        Image(systemName: "timer")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                ForEach(warmupSets, id: \.setNumber) { set in
                                    WarmupSetRow(set: set, unit: weightUnit)
                                }
                                
                                // Instructions
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Instructions:")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("• Rest 45-60 seconds between warmup sets")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("• Rest 2-3 minutes after final warmup")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("• Focus on form and gradual activation")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 8)
                            }
                            .padding()
                            .background(
                                panelBackground.opacity(0.8)
                            )
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Warmup Calculator")
            .sheet(isPresented: $showTimer) {
                TimerView()
            }
        }
    }
    
    private func calculateWarmup() {
        guard let weight = Double(workingWeight), weight > 0 else { return }
        
        let calculator = WarmupCalculator()
        warmupSets = calculator.calculateWarmup(
            workingWeight: weight,
            exerciseType: exerciseType,
            equipmentType: equipmentType,
            unit: weightUnit
        )
    }
}

// MARK: - Warmup Set Row
struct WarmupSetRow: View {
    let set: WarmupSet
    let unit: WeightUnit
    
    var body: some View {
        HStack {
            // Set Number
            Circle()
                .fill(Color.blue)
                .frame(width: 30, height: 30)
                .overlay(
                    Text("\(set.setNumber)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            // Weight and Reps
            VStack(alignment: .leading, spacing: 2) {
                Text("\(set.weight, specifier: "%.1f") \(unit.rawValue)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(set.reps) reps (\(set.percentage)%)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Visual indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 60, height: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue)
                        .frame(width: CGFloat(set.percentage) / 100 * 60, height: 8),
                    alignment: .leading
                )
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.9))
        .cornerRadius(8)
    }
}

// MARK: - Timer View
struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var timeRemaining = 60
    @State private var isActive = false
    @State private var selectedTime = 60
    @State private var timer: Timer?
    
    let timeOptions = [30, 45, 60, 90, 120, 180]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Rest Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Time Display
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.blue)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(Double(selectedTime - timeRemaining) / Double(selectedTime), 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: timeRemaining)
                    
                    Text(timeString(time: timeRemaining))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                }
                .frame(width: 250, height: 250)
                
                // Time Selection
                if !isActive {
                    VStack(spacing: 15) {
                        Text("Select Rest Time")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(timeOptions, id: \.self) { time in
                                Button(action: {
                                    selectedTime = time
                                    timeRemaining = time
                                }) {
                                    Text(timeString(time: time))
                                        .font(.headline)
                                        .foregroundColor(selectedTime == time ? .white : .blue)
                                        .frame(width: 80, height: 40)
                                        .background(selectedTime == time ? Color.blue : Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                
                // Control Buttons
                HStack(spacing: 20) {
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Button(action: toggleTimer) {
                        Image(systemName: isActive ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(isActive ? Color.orange : Color.green)
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Rest Timer")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    private func toggleTimer() {
        isActive.toggle()
        
        if isActive {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Play sound when timer ends
                    playTimerSound()
                    resetTimer()
                }
            }
        } else {
            timer?.invalidate()
        }
    }
    
    private func resetTimer() {
        isActive = false
        timer?.invalidate()
        timeRemaining = selectedTime
    }
    
    private func playTimerSound() {
        AudioServicesPlaySystemSound(1005) // Bell sound
    }
    
    private func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Warmup Calculator
class WarmupCalculator {
    func calculateWarmup(workingWeight: Double, exerciseType: ExerciseType, equipmentType: EquipmentType, unit: WeightUnit) -> [WarmupSet] {
        var sets: [WarmupSet] = []
        let barWeight = unit == .lbs ? 45.0 : 20.0
        
        switch exerciseType {
        case .compound:
            // 4-5 set protocol for compound movements
            if equipmentType == .barbell {
                sets.append(WarmupSet(setNumber: 1, weight: barWeight, reps: 10, percentage: Int((barWeight / workingWeight) * 100)))
            }
            
            let startIndex = equipmentType == .barbell ? 2 : 1
            let percentages = [50, 70, 80]
            let reps = [5, 3, 2]
            
            for (index, percentage) in percentages.enumerated() {
                let weight = roundWeight(workingWeight * Double(percentage) / 100.0, unit: unit, equipment: equipmentType)
                sets.append(WarmupSet(
                    setNumber: startIndex + index,
                    weight: weight,
                    reps: reps[index],
                    percentage: percentage
                ))
            }
            
            // Optional heavy single if working weight > 315 lbs / 143 kg
            let heavyThreshold = unit == .lbs ? 315.0 : 143.0
            if workingWeight > heavyThreshold {
                let weight = roundWeight(workingWeight * 0.92, unit: unit, equipment: equipmentType)
                sets.append(WarmupSet(
                    setNumber: sets.count + 1,
                    weight: weight,
                    reps: 1,
                    percentage: 92
                ))
            }
            
        case .secondaryCompound:
            // 2-3 set protocol
            let percentages = [50, 75]
            let reps = [5, 3]
            
            for (index, percentage) in percentages.enumerated() {
                let weight = roundWeight(workingWeight * Double(percentage) / 100.0, unit: unit, equipment: equipmentType)
                sets.append(WarmupSet(
                    setNumber: index + 1,
                    weight: weight,
                    reps: reps[index],
                    percentage: percentage
                ))
            }
            
        case .isolation, .machine:
            // 1-2 set protocol
            let weight = roundWeight(workingWeight * 0.5, unit: unit, equipment: equipmentType)
            sets.append(WarmupSet(
                setNumber: 1,
                weight: weight,
                reps: 8,
                percentage: 50
            ))
        }
        
        return sets
    }
    
    private func roundWeight(_ weight: Double, unit: WeightUnit, equipment: EquipmentType) -> Double {
        switch equipment {
        case .barbell:
            let increment = unit == .lbs ? 5.0 : 2.5
            return round(weight / increment) * increment
        case .dumbbell:
            let increment = unit == .lbs ? 5.0 : 2.5
            return round(weight / increment) * increment
        case .machine:
            let increment = unit == .lbs ? 5.0 : 2.5
            return round(weight / increment) * increment
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
