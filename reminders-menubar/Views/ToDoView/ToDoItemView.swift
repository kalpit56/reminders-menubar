import SwiftUI
import EventKit

struct ToDoItemView: View {
    var reminderItem: ReminderItem

    @State private var isPendingCompletion = false

    var body: some View {
        if reminderItem.reminder.calendar == nil {
            // On macOS 12 the calendar may be nil during delete operation.
            // Returning Empty to avoid issues since calendar is a force unwrap.
            EmptyView()
        } else {
            HStack(alignment: .top) {
                ReminderCompleteButton(reminderItem: reminderItem, isPendingCompletion: $isPendingCompletion)

                VStack(spacing: 4) {
                    Text(reminderItem.reminder.title.toDetectedLinkAttributedString())
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Divider()
                        .padding(.top, 2)
                        .opacity(0.8)
                }
                .opacity(isPendingCompletion ? 0.6 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isPendingCompletion)
                .allowsHitTesting(!isPendingCompletion)
            }
            .padding(.bottom, 2)
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
        .environmentObject(RemindersData())
}
