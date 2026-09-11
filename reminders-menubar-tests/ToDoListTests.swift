import Testing

private struct FakeList: ReminderListCandidate, Equatable {
    let calendarIdentifier: String
    let title: String
    var allowsContentModifications = true
}

struct ToDoListTests {
    @Test(arguments: ["To-Dos", "to-dos", "TO-DOS", "  To-Dos  ", "To-Dos\n"])
    func matchingTitles(title: String) {
        #expect(ToDoList.isToDoListTitle(title))
    }

    @Test(arguments: ["", " ", "To Dos", "ToDos", "To-Do", "To-Dos list", "Reminders"])
    func nonMatchingTitles(title: String) {
        #expect(!ToDoList.isToDoListTitle(title))
    }

    @Test
    func noListsReturnsNil() {
        let lists: [FakeList] = []
        #expect(ToDoList.match(in: lists, savedIdentifier: nil) == nil)
        #expect(ToDoList.match(in: lists, savedIdentifier: "saved") == nil)
    }

    @Test
    func noToDoListReturnsNil() {
        let lists = [
            FakeList(calendarIdentifier: "a", title: "Reminders"),
            FakeList(calendarIdentifier: "b", title: "Tasks")
        ]
        #expect(ToDoList.match(in: lists, savedIdentifier: nil) == nil)
    }

    @Test
    func findsListByTitleWhenNothingSaved() {
        let toDoList = FakeList(calendarIdentifier: "b", title: "To-Dos")
        let lists = [FakeList(calendarIdentifier: "a", title: "Tasks"), toDoList]
        #expect(ToDoList.match(in: lists, savedIdentifier: nil) == toDoList)
    }

    @Test
    func emptySavedIdentifierFallsBackToTitle() {
        let toDoList = FakeList(calendarIdentifier: "b", title: "To-Dos")
        #expect(ToDoList.match(in: [toDoList], savedIdentifier: "") == toDoList)
    }

    @Test
    func savedListWinsEvenWhenRenamed() {
        let renamedList = FakeList(calendarIdentifier: "saved", title: "Someday")
        let lists = [FakeList(calendarIdentifier: "other", title: "To-Dos"), renamedList]
        #expect(ToDoList.match(in: lists, savedIdentifier: "saved") == renamedList)
    }

    @Test
    func deletedSavedListFallsBackToTitle() {
        let toDoList = FakeList(calendarIdentifier: "b", title: "To-Dos")
        #expect(ToDoList.match(in: [toDoList], savedIdentifier: "deleted") == toDoList)
    }

    @Test
    func deletedSavedListWithNoTitleMatchReturnsNil() {
        let lists = [FakeList(calendarIdentifier: "a", title: "Reminders")]
        #expect(ToDoList.match(in: lists, savedIdentifier: "deleted") == nil)
    }

    @Test
    func readOnlySavedListIsSkipped() {
        let readOnlyList = FakeList(calendarIdentifier: "saved", title: "To-Dos", allowsContentModifications: false)
        let writableList = FakeList(calendarIdentifier: "b", title: "To-Dos")
        #expect(ToDoList.match(in: [readOnlyList, writableList], savedIdentifier: "saved") == writableList)
    }

    @Test
    func readOnlyTitleMatchIsSkipped() {
        let lists = [FakeList(calendarIdentifier: "a", title: "To-Dos", allowsContentModifications: false)]
        #expect(ToDoList.match(in: lists, savedIdentifier: nil) == nil)
    }

    @Test
    func firstTitleMatchWins() {
        let firstList = FakeList(calendarIdentifier: "a", title: "To-Dos")
        let secondList = FakeList(calendarIdentifier: "b", title: "to-dos")
        #expect(ToDoList.match(in: [firstList, secondList], savedIdentifier: nil) == firstList)
    }
}

struct ToDoListHidingTests {
    private let lists = [
        FakeList(calendarIdentifier: "a", title: "Reminders"),
        FakeList(calendarIdentifier: "todo", title: "To-Dos"),
        FakeList(calendarIdentifier: "b", title: "Tasks")
    ]

    @Test
    func removesToDoListAndKeepsOrder() {
        let visibleLists = ToDoList.removingList(withIdentifier: "todo", from: lists)
        #expect(visibleLists.map(\.calendarIdentifier) == ["a", "b"])
    }

    @Test
    func nilIdentifierKeepsAllLists() {
        #expect(ToDoList.removingList(withIdentifier: nil, from: lists) == lists)
    }

    @Test
    func unknownIdentifierKeepsAllLists() {
        #expect(ToDoList.removingList(withIdentifier: "missing", from: lists) == lists)
    }

    @Test
    func emptyListsStayEmpty() {
        let noLists: [FakeList] = []
        #expect(ToDoList.removingList(withIdentifier: "todo", from: noLists).isEmpty)
    }

    @Test
    func removesIdentifierFromFilterAndKeepsOrder() {
        let filter = ToDoList.removingIdentifier("todo", from: ["a", "todo", "b"])
        #expect(filter == ["a", "b"])
    }

    @Test
    func removesDuplicateIdentifiers() {
        #expect(ToDoList.removingIdentifier("todo", from: ["todo", "a", "todo"]) == ["a"])
    }

    @Test(arguments: [nil, "missing"] as [String?])
    func identifierNotInFilterKeepsFilter(identifier: String?) {
        #expect(ToDoList.removingIdentifier(identifier, from: ["a", "b"]) == ["a", "b"])
    }

    @Test
    func filterWithOnlyToDoListBecomesEmpty() {
        #expect(ToDoList.removingIdentifier("todo", from: ["todo"]).isEmpty)
    }

    @Test
    func emptyFilterStaysEmpty() {
        #expect(ToDoList.removingIdentifier("todo", from: []).isEmpty)
    }
}
