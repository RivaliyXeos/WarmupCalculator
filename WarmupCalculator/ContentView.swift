import SwiftUI

struct ContentView: View {
    @StateObject private var exerciseLibrary = ExerciseLibrary()

    var body: some View {
        TabView {
            MainCalculatorView()
                .tabItem {
                    Label("Calcul", systemImage: "flame.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.crop.circle")
                }
        }
        .environmentObject(exerciseLibrary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
