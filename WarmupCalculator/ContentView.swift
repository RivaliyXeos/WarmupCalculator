import SwiftUI

struct ContentView: View {
    @StateObject private var exerciseLibrary = ExerciseLibrary()
    @AppStorage(StorageKeys.selectedLanguage) private var storedLanguage = AppLanguage.french.rawValue

    private var appLanguage: AppLanguage {
        AppLanguage(rawValue: storedLanguage) ?? .french
    }

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
        .environment(\.locale, Locale(identifier: appLanguage.localeIdentifier))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
