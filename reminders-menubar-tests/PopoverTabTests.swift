import Testing

struct PopoverTabTests {
    @Test
    func tabsAreInDisplayOrder() {
        #expect(PopoverTab.allCases == [.reminders, .toDo])
    }

    @Test
    func missingValueDefaultsToReminders() {
        #expect(PopoverTab(storedValue: nil) == .reminders)
    }

    @Test(arguments: ["", " ", "ToDo", "todo", "Reminders", "calendar"])
    func unknownValueDefaultsToReminders(storedValue: String) {
        #expect(PopoverTab(storedValue: storedValue) == .reminders)
    }

    @Test(arguments: PopoverTab.allCases)
    func storedValueRoundTrips(tab: PopoverTab) {
        #expect(PopoverTab(storedValue: tab.rawValue) == tab)
    }
}
