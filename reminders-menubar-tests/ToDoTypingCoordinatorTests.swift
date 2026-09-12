import Testing

struct ToDoTypingCoordinatorTests {
    private func shouldRedirect(
        isShowingToDoTab: Bool = true,
        isRenaming: Bool = false,
        hasAttachedSheet: Bool = false,
        isTextInput: Bool = true
    ) -> Bool {
        ToDoTypingCoordinator.shouldRedirectTyping(
            isShowingToDoTab: isShowingToDoTab,
            isRenaming: isRenaming,
            hasAttachedSheet: hasAttachedSheet,
            isTextInput: isTextInput
        )
    }

    @Test
    func redirectsWhileTheToDoTabIsShowing() {
        #expect(shouldRedirect())
    }

    @Test
    func doesNotRedirectOnTheRemindersTab() {
        #expect(!shouldRedirect(isShowingToDoTab: false))
    }

    @Test
    func doesNotRedirectWhileRenaming() {
        #expect(!shouldRedirect(isRenaming: true))
    }

    @Test
    func doesNotRedirectWhileASheetIsOpen() {
        #expect(!shouldRedirect(hasAttachedSheet: true))
    }

    @Test
    func doesNotRedirectNonTypingKeys() {
        #expect(!shouldRedirect(isTextInput: false))
    }

    @Test
    func everyBlockingConditionAtOnceStillDoesNotRedirect() {
        #expect(!shouldRedirect(
            isShowingToDoTab: false,
            isRenaming: true,
            hasAttachedSheet: true,
            isTextInput: false
        ))
    }
}
