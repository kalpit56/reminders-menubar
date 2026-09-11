import SwiftUI

private enum ToDoPreferencesKeys {
    static let listIdentifier = "toDoListIdentifier"
}

class ToDoPreferences: ObservableObject {
    static let shared = ToDoPreferences()

    private init() {
        // This prevents others from using the default '()' initializer for this class.
    }

    private static let defaults = UserDefaults.standard

    var listIdentifier: String? {
        get {
            return ToDoPreferences.defaults.string(forKey: ToDoPreferencesKeys.listIdentifier)
        }
        set {
            ToDoPreferences.defaults.set(newValue, forKey: ToDoPreferencesKeys.listIdentifier)
        }
    }
}
