import SwiftUI
import EventKit

struct ToDoItemView: View {
    @EnvironmentObject private var toDoData: ToDoData

    var reminderItem: ReminderItem

    @State private var isPendingCompletion = false
    @State private var showingRemoveAlert = false
    @State private var renamedTitle = ""

    private var isRenaming: Bool {
        toDoData.renamingItemId == reminderItem.id
    }

    var body: some View {
        if reminderItem.reminder.calendar == nil {
            // On macOS 12 the calendar may be nil during delete operation.
            // Returning Empty to avoid issues since calendar is a force unwrap.
            EmptyView()
        } else {
            HStack(alignment: .top) {
                ReminderCompleteButton(reminderItem: reminderItem, isPendingCompletion: $isPendingCompletion)

                VStack(spacing: 4) {
                    toDoTitle()

                    Divider()
                        .padding(.top, 2)
                        .opacity(0.8)
                }
                .opacity(isPendingCompletion ? 0.6 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isPendingCompletion)
                .allowsHitTesting(!isPendingCompletion)
            }
            .padding(.bottom, 2)
            .alert(isPresented: $showingRemoveAlert) {
                removeReminderAlert(for: reminderItem.reminder)
            }
        }
    }

    @ViewBuilder
    private func toDoTitle() -> some View {
        if isRenaming {
            SubmittableTextField(
                text: $renamedTitle,
                placeholder: reminderItem.reminder.title,
                onSubmit: { toDoData.rename(reminderItem, to: renamedTitle) }
            )
            .font(.body)
        } else {
            Text(reminderItem.reminder.title.toDetectedLinkAttributedString())
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contextMenu {
                    renameButton()
                    removeButton()
                }
        }
    }

    private func renameButton() -> some View {
        Button(action: {
            renamedTitle = reminderItem.reminder.title
            toDoData.renamingItemId = reminderItem.id
        }) {
            HStack {
                Image(rmbSymbol: .pencil)
                Text(rmbLocalized(.toDoRenameMenuOption))
            }
        }
    }

    private func removeButton() -> some View {
        Button(action: {
            showingRemoveAlert = true
        }) {
            HStack {
                Image(rmbSymbol: .trash)
                Text(rmbLocalized(.toDoDeleteMenuOption))
            }
        }
    }
}

#Preview {
    var reminder: EKReminder {
        let calendar = EKCalendar(for: .reminder, eventStore: .init())
        calendar.color = .systemTeal

        let reminder = EKReminder(eventStore: .init())
        reminder.title = "Find gift for friend"
        reminder.calendar = calendar

        return reminder
    }

    ToDoItemView(reminderItem: ReminderItem(for: reminder))
        .environmentObject(ToDoData())
        .environmentObject(RemindersData())
}
