import XCTest
@testable import Launcher

final class LauncherTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Launcher().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
