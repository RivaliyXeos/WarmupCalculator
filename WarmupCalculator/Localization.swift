import Foundation

enum Localization {
    static func localizedString(_ key: String) -> String {
        let language = currentLanguage()
        let bundle = bundle(for: language)
        return bundle.localizedString(forKey: key, value: key, table: nil)
    }

    static func localizedString(_ key: String, arguments: CVarArg...) -> String {
        let format = localizedString(key)
        return String(format: format, arguments: arguments)
    }

    private static func bundle(for language: AppLanguage) -> Bundle {
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }
        return .main
    }

    private static func currentLanguage() -> AppLanguage {
        if let stored = UserDefaults.standard.string(forKey: StorageKeys.selectedLanguage),
           let language = AppLanguage(rawValue: stored) {
            return language
        }
        return .french
    }
}
