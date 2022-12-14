//
//  File.swift
//  
//
//  Created by Pawel Madej on 17/09/2020.
//

import Foundation
@testable import TwitterText

extension NSRegularExpression {
    func matches(in string: String) -> [String] {
        let length = string.count
        let range = NSMakeRange(0, length)
        let matches = self.matches(in: string, options: [], range: range)

        var results: [String] = []
        for match in matches {
            if let rRange = Range(match.range, in: string), NSMaxRange(match.range) <= length {
                results.append(String(string[rRange]))
            }
        }

        return results
    }
}

import XCTest

final class TwitterTextEmojiTests: XCTestCase {
    func testEmojiUnicode10() {
        guard let regex = TwitterTextEmojiRegex else {
            XCTFail()
            return
        }

        let matches = regex.matches(in: "Unicode 10.0; grinning face with one large and one small eye: 🤪; woman with headscarf: 🧕; (fitzpatrick) woman with headscarf + medium-dark skin tone: 🧕🏾; flag (England): 🏴󠁧󠁢󠁥󠁮󠁧󠁿")
        let expected = ["🤪", "🧕", "🧕🏾", "🏴󠁧󠁢󠁥󠁮󠁧󠁿", nil]

        matches.enumerated().forEach { (index, match) in
            XCTAssertEqual(match, expected[index])
        }
    }

    func testEmojiUnicode9() {
        guard let regex = TwitterTextEmojiRegex else {
            XCTFail()
            return
        }

        let matches = regex.matches(in: "Unicode 9.0; face with cowboy hat: 🤠; woman dancing: 💃, woman dancing + medium-dark skin tone: 💃🏾")
        let expected = ["🤠", "💃", "💃🏾", nil]

        matches.enumerated().forEach { (index, match) in
            XCTAssertEqual(match, expected[index])
        }
    }

    func testIsEmoji() {
        XCTAssertTrue("🤦".isEmoji)
        XCTAssertTrue("🏴󠁧󠁢󠁥󠁮󠁧󠁿".isEmoji)
        XCTAssertTrue("👨‍👨‍👧‍👧".isEmoji)
        XCTAssertTrue("0️⃣".isEmoji)
        XCTAssertFalse("A".isEmoji)
        XCTAssertFalse("Á".isEmoji)
    }
    
}
