import SwiftUI
import Combine
import EventKit

@MainActor
class ToDoData: ObservableObject {
    private var cancellationTokens: [AnyCancellable] = []

    @Published private(set) var toDoItems: [ReminderItem] = []

    init() {
        addObservers()
        Task {
            await update()
        }
    }

    private func addObservers() {
        Publishers.MergeMany(
            NotificationCenter.default.publisher(for: .EKEventStoreChanged),
            NotificationCenter.default.publisher(for: .remindersDataShouldUpdate)
        )
        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
        .sink { [weak self] _ in
            Task {
                await self?.update()
            }
        }
        .store(in: &cancellationTokens)
    }

    func update() async {
        guard let list = ToDoListService.findList() else {
            toDoItems = []
            return
        }

        let reminderLists = await RemindersService.shared.getReminders(of: [list.calendarIdentifier])
        let reminderItems = reminderLists.first?.reminders ?? []
        toDoItems = ToDoList.sortedNewestFirst(reminderItems, creationDate: { $0.reminder.creationDate })
    }

    // Returns false when nothing was added, so the typed text can be kept.
    @discardableResult
    func addToDo(titled input: String) -> Bool {
        guard let title = ToDoList.normalizedTitle(input),
              let list = ToDoListService.findOrCreateList() else {
            return false
        }

        RemindersService.shared.createNew(titled: title, in: list)
        return true
    }
}
