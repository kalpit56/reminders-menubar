import Testing

struct ComparableExtensionsTests {
    @Test(arguments: [
        (value: 5, expected: 5),
        (value: -3, expected: 0),
        (value: 42, expected: 10),
        (value: 0, expected: 0),
        (value: 10, expected: 10)
    ])
    func constrainedTo(value: Int, expected: Int) {
        #expect(value.constrainedTo(min: 0, max: 10) == expected)
    }

    @Test
    func constrainedToSingleValueRange() {
        #expect(7.constrainedTo(min: 3, max: 3) == 3)
    }

    @Test
    func constrainedToDoubles() {
        #expect(0.25.constrainedTo(min: 0.5, max: 1.5) == 0.5)
    }
}
