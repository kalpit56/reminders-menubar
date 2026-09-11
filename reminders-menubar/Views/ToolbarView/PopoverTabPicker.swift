import SwiftUI

struct PopoverTabPicker: View {
    @ObservedObject var toDoPreferences = ToDoPreferences.shared

    var body: some View {
        Picker(String(""), selection: $toDoPreferences.selectedTab) {
            ForEach(PopoverTab.allCases, id: \.self) { tab in
                Text(tab.title).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .padding(.horizontal, 14)
        .padding(.bottom, 6)
    }
}

extension PopoverTab {
    var title: String {
        switch self {
        case .reminders:
            return rmbLocalized(.remindersTabTitle)
        case .toDo:
            return rmbLocalized(.toDoTabTitle)
        }
    }
}

#Preview {
    PopoverTabPicker()
}
