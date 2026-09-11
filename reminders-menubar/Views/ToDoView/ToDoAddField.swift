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

private struct SubmittableTextField: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var onSubmit: () -> Void

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = placeholder
        textField.isBordered = false
        textField.drawsBackground = false
        textField.delegate = context.coordinator
        textField.font = .systemFont(ofSize: NSFont.systemFontSize)
        textField.cell?.sendsActionOnEndEditing = false
        DispatchQueue.main.async {
            textField.window?.makeFirstResponder(textField)
        }
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        context.coordinator.parent = self
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: SubmittableTextField

        init(_ parent: SubmittableTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            parent.text = textField.stringValue
        }

        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            guard commandSelector == #selector(NSResponder.insertNewline(_:)) else {
                return false
            }
            parent.onSubmit()
            return true
        }
    }
}

#Preview {
    ToDoAddField()
        .environmentObject(ToDoData())
}
