import SwiftUI

private enum ToDoPreferencesKeys {
    static let listIdentifier = "toDoListIdentifier"
    static let selectedTab = "selectedPopoverTab"
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

    @Published var selectedTab: PopoverTab = {
        return PopoverTab(storedValue: defaults.string(forKey: ToDoPreferencesKeys.selectedTab))
    }() {
        didSet {
            ToDoPreferences.defaults.set(selectedTab.rawValue, forKey: ToDoPreferencesKeys.selectedTab)
        }
    }
}
