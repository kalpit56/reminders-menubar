import EventKit

protocol ReminderListCandidate {
    var calendarIdentifier: String { get }
    var title: String { get }
    var allowsContentModifications: Bool { get }
}

extension EKCalendar: ReminderListCandidate {}

enum ToDoList {
    static let title = "To-Dos"

    static func match<List: ReminderListCandidate>(in lists: [List], savedIdentifier: String?) -> List? {
        let writableLists = lists.filter(\.allowsContentModifications)

        // NOTE: The saved list wins even if it was renamed in Apple Reminders.
        if let savedIdentifier,
           let savedList = writableLists.first(where: { $0.calendarIdentifier == savedIdentifier }) {
            return savedList
        }

        return writableLists.first(where: { isToDoListTitle($0.title) })
    }

    static func normalizedTitle(_ input: String) -> String? {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedInput.isEmpty ? nil : trimmedInput
    }

    static func sortedNewestFirst<Item>(_ items: [Item], creationDate: (Item) -> Date?) -> [Item] {
        // NOTE: Items without a creation date go last, and ties keep their original order.
        return items.enumerated()
            .sorted { first, second in
                let firstDate = creationDate(first.element) ?? .distantPast
                let secondDate = creationDate(second.element) ?? .distantPast
                if firstDate != secondDate {
                    return firstDate > secondDate
                }
                return first.offset < second.offset
            }
            .map(\.element)
    }

    static func isToDoListTitle(_ listTitle: String) -> Bool {
        let trimmedTitle = listTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedTitle.caseInsensitiveCompare(title) == .orderedSame
    }

    static func removingList<List: ReminderListCandidate>(
        withIdentifier identifier: String?,
        from lists: [List]
    ) -> [List] {
        guard let identifier else { return lists }
        return lists.filter { $0.calendarIdentifier != identifier }
    }

    static func removingIdentifier(_ identifier: String?, from identifiers: [String]) -> [String] {
        guard let identifier else { return identifiers }
        return identifiers.filter { $0 != identifier }
    }
}
