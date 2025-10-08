import SwiftUI
import AudioToolbox

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var timeRemaining = 60
    @State private var isActive = false
    @State private var selectedTime = 60
    @State private var timer: Timer?

    private let timeOptions = [30, 45, 60, 90, 120, 180]

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Rest Timer")
                    .font(.largeTitle.weight(.bold))

                ZStack {
                    Circle()
                        .stroke(lineWidth: 18)
                        .opacity(0.2)
                        .foregroundColor(.blue)

                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(Double(selectedTime - timeRemaining) / Double(selectedTime), 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.linear, value: timeRemaining)

                    Text(timeString(time: timeRemaining))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                }
                .frame(width: 240, height: 240)

                if !isActive {
                    VStack(spacing: 12) {
                        Text("Sélectionnez le repos")
                            .font(.headline)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(timeOptions, id: \.self) { option in
                                Button {
                                    selectedTime = option
                                    timeRemaining = option
                                } label: {
                                    Text(timeString(time: option))
                                        .font(.headline)
                                        .foregroundColor(selectedTime == option ? .white : .blue)
                                        .frame(width: 80, height: 38)
                                        .background(selectedTime == option ? Color.blue : Color.blue.opacity(0.1))
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }

                HStack(spacing: 24) {
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
                            .frame(width: 90, height: 90)
                            .background(isActive ? Color.orange : Color.green)
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Rest Timer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
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
                    AudioServicesPlaySystemSound(1005)
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

    private func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
