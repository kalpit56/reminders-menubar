enum PopoverTab: String, CaseIterable {
    case reminders
    case toDo

    init(storedValue: String?) {
        self = storedValue.flatMap(PopoverTab.init(rawValue:)) ?? .reminders
    }
}
