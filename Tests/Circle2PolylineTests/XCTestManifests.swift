import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Circle2PolylineTests.allTests),
    ]
}
#endif