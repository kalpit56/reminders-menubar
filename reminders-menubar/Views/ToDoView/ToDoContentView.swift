import SwiftUI

struct ToDoContentView: View {
    @EnvironmentObject var toDoData: ToDoData

    var body: some View {
        VStack(spacing: 0) {
            ToDoAddField()

            List {
                Section {
                    if toDoData.toDoItems.isEmpty {
                        NoReminderItemsView(emptyList: .allItemsCompleted)
                    }
                    ForEach(toDoData.toDoItems) { toDoItem in
                        ToDoItemView(reminderItem: toDoItem)
                    }
                }
                .modifier(ListSectionModifier())
            }
            .modifier(ReminderListModifier(animationValue: toDoData.toDoItems))
        }
    }
}

#Preview {
    ToDoContentView()
        .environmentObject(ToDoData())
        .environmentObject(RemindersData())
}
