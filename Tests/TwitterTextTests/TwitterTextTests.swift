import XCTest
@testable import TwitterText

final class TwitterTextTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(twitter_text().text, "Hello, World!")
    }

    /// - (void)testRemainingCharacterCountForLongTweet
    func testRemainingCharacterCountForLongTweet() {
//    {
//    ;
//    }
        XCTAssertEqual(TwitterText.remainingCharacterCount( "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", transformedURLLength:23), -10)
    }
    static var allTests = [
        ("testExample", testExample),
    ]
}
