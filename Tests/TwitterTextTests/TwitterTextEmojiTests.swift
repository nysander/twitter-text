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
        let matches = self.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: range)

        var results: [String] = []
        for match in matches {
            if let rRange = Range(range, in: string), NSMaxRange(match.range) <= length {
                results.append(string.substring(with: rRange))
            }
        }

        return results
    }
}

import XCTest

final class TwitterTextEmojiTests: XCTestCase {
    /// - (void)testEmojiUnicode10
    func testEmojiUnicode10() {
    /// NSArray<NSString *> *matches = [TwitterTextEmojiRegex() matchesInString:@"Unicode 10.0; grinning face with one large and one small eye: 🤪; woman with headscarf: 🧕; (fitzpatrick) woman with headscarf + medium-dark skin tone: 🧕🏾; flag (England): 🏴󠁧󠁢󠁥󠁮󠁧󠁿"];
        let matches = TwitterTextEmojiRegex().matches(in: "Unicode 10.0; grinning face with one large and one small eye: 🤪; woman with headscarf: 🧕; (fitzpatrick) woman with headscarf + medium-dark skin tone: 🧕🏾; flag (England): 🏴󠁧󠁢󠁥󠁮󠁧󠁿")

    /// NSArray<NSString *> *expected = [NSArray arrayWithObjects:@"🤪", @"🧕", @"🧕🏾", @"🏴󠁧󠁢󠁥󠁮󠁧󠁿", nil];
        let expected = ["🤪", "🧕", "🧕🏾", "🏴󠁧󠁢󠁥󠁮󠁧󠁿", nil]
    /// for (NSUInteger i = 0; i < matches.count; i++) {
    ///XCTAssertTrue([matches[i] isEqualToString:expected[i]]);
        for index in 0..<matches.count {
            XCTAssertEqual(matches[index], expected[index])
        }
    }

/*
    - (void)testEmojiUnicode9
    {
    NSArray<NSString *> *matches = [TwitterTextEmojiRegex() matchesInString:@"Unicode 9.0; face with cowboy hat: 🤠; woman dancing: 💃, woman dancing + medium-dark skin tone: 💃🏾"];
    NSArray<NSString *> *expected = [NSArray arrayWithObjects:@"🤠", @"💃", @"💃🏾", nil];

    for (NSUInteger i = 0; i < matches.count; i++) {
    XCTAssertTrue([matches[i] isEqualToString:expected[i]]);
    }
    }


    - (void)testIsEmoji
    {
    XCTAssertTrue([@"🤦" tt_isEmoji]);
    XCTAssertTrue([@"🏴󠁧󠁢󠁥󠁮󠁧󠁿" tt_isEmoji]);
    XCTAssertTrue([@"👨‍👨‍👧‍👧" tt_isEmoji]);
    XCTAssertTrue([@"0️⃣" tt_isEmoji]);

    XCTAssertFalse([@"A" tt_isEmoji]);
    XCTAssertFalse([@"Á" tt_isEmoji]);
    }
*/
}
