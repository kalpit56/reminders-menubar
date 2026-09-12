import AppKit

@MainActor
final class ToDoTypingCoordinator: ObservableObject {
    private weak var addField: NSTextField?

    // Typing is only redirected to the add field when the To Do tab is showing
    // and nothing else in the popover is expecting the keystrokes.
    nonisolated static func shouldRedirectTyping(
        isShowingToDoTab: Bool,
        isRenaming: Bool,
        hasAttachedSheet: Bool,
        isTextInput: Bool
    ) -> Bool {
        guard isShowingToDoTab, !isRenaming, !hasAttachedSheet, isTextInput else {
            return false
        }
        return true
    }

    func register(addField: NSTextField?) {
        self.addField = addField
    }

    // Returns false when the add field is missing or already being typed into.
    func focusAddField(replaying event: NSEvent) -> Bool {
        guard let addField, addField.currentEditor() == nil else { return false }

        addField.window?.makeFirstResponder(addField)
        guard let fieldEditor = addField.currentEditor() else { return false }

        fieldEditor.keyDown(with: event)
        return true
    }
}
