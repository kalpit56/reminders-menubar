import EventKit

@MainActor
enum ToDoListService {
    static func findList() -> EKCalendar? {
        let lists = RemindersService.shared.getCalendars()
        guard let list = ToDoList.match(in: lists, savedIdentifier: ToDoPreferences.shared.listIdentifier) else {
            return nil
        }

        ToDoPreferences.shared.listIdentifier = list.calendarIdentifier
        return list
    }

    static func findOrCreateList() -> EKCalendar? {
        if let list = findList() {
            return list
        }

        guard let newList = RemindersService.shared.createReminderList(titled: ToDoList.title) else {
            return nil
        }

        ToDoPreferences.shared.listIdentifier = newList.calendarIdentifier
        return newList
    }
}
