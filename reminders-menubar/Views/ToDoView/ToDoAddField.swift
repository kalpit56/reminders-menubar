import SwiftUI

struct ToDoAddField: View {
    @EnvironmentObject var toDoData: ToDoData
    @ObservedObject var userPreferences = UserPreferences.shared

    @State private var text = ""

    var body: some View {
        HStack(spacing: 6) {
            Image(rmbSymbol: .plus)
                .foregroundColor(.secondary)
                .font(.callout)

            SubmittableTextField(
                text: $text,
                placeholder: rmbLocalized(.toDoAddFieldPlaceholder),
                onSubmit: submit
            )
            .font(.body)
        }
        .padding(8)
        .padding(.horizontal, 4)
        .background(
            Color.rmbColor(.textFieldBackground(isTransparent: userPreferences.isTransparencyEnabled))
        )
        .cornerRadius(8)
        .padding(.horizontal, 14)
        .padding(.bottom, 6)
    }

    private func submit() {
        if toDoData.addToDo(titled: text) {
            text = ""
        }
    }
}

#Preview {
    ToDoAddField()
        .environmentObject(ToDoData())
}
