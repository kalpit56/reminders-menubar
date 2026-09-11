import SwiftUI

struct ToolbarView: View {
    @EnvironmentObject var remindersData: RemindersData
    @ObservedObject var toDoPreferences = ToDoPreferences.shared

    var body: some View {
        HStack(spacing: 4) {
            CreateReminderButton()
                .disabled(remindersData.availableCalendars.isEmpty)

            Spacer()

            if !isShowingToDoTab {
                SearchRemindersButton()
                    .disabled(remindersData.availableCalendars.isEmpty)

                RecentRemindersButton()
                    .disabled(remindersData.availableCalendars.isEmpty)

                FilterReminderListButton()
                    .disabled(remindersData.availableCalendars.isEmpty)
            }

            UpdateAvailableButton()

            OpenSettingButton()
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
        .padding(.leading, 14)
        .padding(.bottom, 6)
    }

    private var isShowingToDoTab: Bool {
        // NOTE: Tabs are only shown when reminder lists are available.
        toDoPreferences.selectedTab == .toDo && !remindersData.availableCalendars.isEmpty
    }
}

#Preview {
    ToolbarView()
        .environmentObject(RemindersData())
        .environmentObject(NewReminderTypingCoordinator())
}
