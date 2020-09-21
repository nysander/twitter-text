//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import XCTest
@testable import TwitterText

final class TwitterTextTests: XCTestCase {
    func testRemainingCharacterCountForLongTweet() {
        XCTAssertEqual(TwitterText.remainingCharacterCount( text: "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", transformedURLLength:23), -10)
    }

    func testHastagBoundary() {
        let set = TwitterText.validHashtagBoundaryCharacterSet()

        XCTAssertNotNil(set)
        XCTAssertFalse(set.contains("a"))
        XCTAssertFalse(set.contains("m"))
        XCTAssertFalse(set.contains("z"))
        XCTAssertFalse(set.contains("A"))
        XCTAssertFalse(set.contains("M"))
        XCTAssertFalse(set.contains("Z"))
        XCTAssertFalse(set.contains("0"))
        XCTAssertFalse(set.contains("5"))
        XCTAssertFalse(set.contains("9"))
        XCTAssertFalse(set.contains("_"))
        XCTAssertFalse(set.contains("&"))
        XCTAssertTrue(set.contains(" "))
        XCTAssertTrue(set.contains("#"))
        XCTAssertTrue(set.contains("@"))
        XCTAssertTrue(set.contains(","))
        XCTAssertTrue(set.contains("="))
        XCTAssertTrue(set.contains("\u{00BF}"))
        XCTAssertTrue(set.contains("\u{00BF}"))
        XCTAssertFalse(set.contains("\u{00C0}"))
        XCTAssertFalse(set.contains("\u{00D6}"))
        XCTAssertTrue(set.contains("\u{00D7}"))

        // FIXME: Fix assertions
        /// NSString *validLongCharacterString = @"\U0001FFFF";
        let validLongCharacterString = "\u{0001FFFF}"
        /// XCTAssertTrue([set longCharacterIsMember:CFStringGetLongCharacterForSurrogatePair([validLongCharacterString     characterAtIndex:0], [validLongCharacterString characterAtIndex:1])]);

        /// NSString *invalidLongCharacterString = @"\U00020000";
        let invalidLongCharacterString = "\u{00020000}"
        /// XCTAssertFalse([set longCharacterIsMember:CFStringGetLongCharacterForSurrogatePair([invalidLongCharacterString  characterAtIndex:0], [invalidLongCharacterString characterAtIndex:1])]);
    }

    func testLongDomain() {
        let text = "jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp"
        let entities = TwitterText.entities(inText: text)

        XCTAssertEqual(entities.count, 1)

        if entities.count >= 1 {
            let entity = entities[0]

            XCTAssertEqual(NSStringFromRange(entity.range), NSStringFromRange(NSMakeRange(0, text.count)))
        }
    }

    func testJapaneseTLDFollowedByJapaneseCharacters() {
        let text = "テスト test.みんなです"
        let entities = TwitterText.entities(inText: text)

        XCTAssertEqual(entities.count, 1)

        if entities.count >= 1 {
            let entity = entities[0]

            XCTAssertEqual(NSStringFromRange(entity.range), NSStringFromRange(NSMakeRange(4, 8)))
        }
    }

    func testJapaneseTLDFollowedByASCIICharacters() {
        let text = "テスト test.みんなabc"
        let entities = TwitterText.entities(inText: text)

        XCTAssertEqual(entities.count, 0)
    }

    // TODO: this test method should be split into smaller chunks
    func testExtract() {
        let filename = conformanceRootDirectory.appendingPathComponent("extract.json")
        guard let jsonData = try? String(contentsOf: filename, encoding: .utf8).data(using: .utf8),
              let validation = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail("Invalid test data: \(filename)")
            return
        }

        /// NSArray *mentions = [tests objectForKey:@"mentions"];
        /// NSArray *mentionsWithIndices = [tests objectForKey:@"mentions_with_indices"];
        /// NSArray *mentionsOrListsWithIndices = [tests objectForKey:@"mentions_or_lists_with_indices"];
        /// NSArray *replies = [tests objectForKey:@"replies"];
        /// NSArray *urls = [tests objectForKey:@"urls"];
        /// NSArray *urlsWithIndices = [tests objectForKey:@"urls_with_indices"];
        /// NSArray *hashtags = [tests objectForKey:@"hashtags"];
        /// NSArray *hashtagsFromAstral = [tests objectForKey:@"hashtags_from_astral"];
        /// NSArray *hashtagsWithIndices = [tests objectForKey:@"hashtags_with_indices"];
        /// NSArray *symbols = [tests objectForKey:@"cashtags"];
        /// NSArray *symbolsWithIndices = [tests objectForKey:@"cashtags_with_indices"];
        guard let tests = validation["tests"] as? [String: Any],
              let mentions = tests["mentions"] as? [[String: Any]],
              let mentionsWithIndices = tests["mentions_with_indices"] as? [[String: Any]],
              let mentionsOrListsWithIndices = tests["mentions_or_lists_with_indices"] as? [[String: Any]],
              let replies = tests["replies"] as? [[String: Any]],
              let urls = tests["urls"] as? [[String: Any]],
              let urlsWithIndices = tests["urls_with_indices"] as? [[String: Any]],
              let hashtags = tests["hashtags"] as? [[String: Any]],
              let hashtagsFromAstral = tests["hashtags_from_astral"] as? [[String: Any]],
              let hashtagsWithIndices = tests["hashtags_with_indices"] as? [[String: Any]],
              let symbols = tests["cashtags"] as? [[String: Any]],
              let symbolsWithIndices = tests["cashtags_with_indices"] as? [[String: Any]] else {
            XCTFail()
            return
        }

        // MARK: Mentions
        for testCase in mentions {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }

            let results = TwitterText.mentionsOrLists(inText: text)
            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedText = expected[index]
                    let entity = results[index]

                    var actualRange = entity.range
                    actualRange.location += 1
                    actualRange.length -= 1

                    let actualText = text.substring(with: Range(actualRange, in: text)!)

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                }
            } else {
                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)")
            }
        }

        // MARK: Mentions with indices
        for testCase in mentionsWithIndices {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [[String: Any]] else {
                XCTFail()
                break
            }

            let results = TwitterText.mentionsOrLists(inText: text)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedDict = expected[index]

                    guard let expectedText = expectedDict["screen_name"] as? String,
                          let indices = expectedDict["indices"] as? [Int] else {
                        XCTFail()
                        return
                    }

                    let expectedStart = indices[0]
                    let expectedEnd = indices[1]
                    if expectedEnd < expectedStart {
                        XCTFail("Expected start '\(expectedStart)' is greater than expected end '\(expectedEnd)'")
                    }

                    let expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart)

                    let entity = results[index]
                    let actualRange = entity.range
                    var r = actualRange
                    r.location += 1
                    r.length -= 1
                    let actualText = text.substring(with: Range(r, in: text)!)

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                    XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), "\(NSStringFromRange(expectedRange)) != \(NSStringFromRange(actualRange)), \(testCase)")
                }
            } else {
                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)")
            }
        }

        // MARK: Mentions or lists with indices
        for testCase in mentionsOrListsWithIndices {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [[String: Any]] else {
                XCTFail()
                break
            }

            let results = TwitterText.mentionsOrLists(inText: text)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedDict = expected[index]
                    guard var expectedText = expectedDict["screen_name"] as? String,
                          let expectedListSlug = expectedDict["list_slug"] as? String,
                          let indices = expectedDict["indices"] as? [Int] else {
                        XCTFail()
                        return
                    }

                    if expectedListSlug.utf16.count > 0 {
                        expectedText = expectedText.appending(expectedListSlug)
                    }

                    let expectedStart = indices[0]
                    let expectedEnd = indices[1]
                    if expectedEnd < expectedStart {
                        XCTFail("Expected start '\(expectedStart)' is greater than expected end '\(expectedEnd)'")
                    }

                    let expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart)

                    let entity = results[index]
                    let actualRange = entity.range
                    var r = actualRange
                    r.location += 1
                    r.length -= 1
                    let actualText = text.substring(with: Range(r, in: text)!)

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                    XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), "\(NSStringFromRange(expectedRange)) != \(NSStringFromRange(actualRange))\n\(testCase)")
                }
            } else {
                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)")
            }
        }

        // MARK: Replies
        for testCase in replies {
            guard let text = testCase["text"] as? String
                   else {
                XCTFail()
                break
            }
            let expected = testCase["expected"] as? String
            let result = TwitterText.repliedScreenName(inText: text)

            if result != nil || expected != nil {
                var actual: String? = nil
                if let range = result?.range {
                    actual = text.substring(with: Range(range, in: text)!)
                }

                if expected == nil {
                    XCTAssertNil(actual, "\(actual)\n\(testCase)")
                } else {
                    XCTAssertEqual(expected, actual, "\(testCase)")
                }
            }
        }


        // MARK: URLs
        /// for (NSDictionary *testCase in urls) {
        ///     NSString *text = [testCase objectForKey:@"text"];
        ///     NSArray *expected = [testCase objectForKey:@"expected"];
        for testCase in urls {
            // FIXME: Failing test cases
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }
        ///     NSArray *results = [TwitterText URLsInText:text];
            let results = TwitterText.URLs(inText: text)

        ///     if (results.count == expected.count) {
            if results.count == expected.count {
        ///         NSUInteger count = results.count;
        ///         for (NSUInteger i = 0; i < count; i++) {
                for index in 0..<results.count {
        ///             NSString *expectedText = [expected objectAtIndex:i];
                    let expectedText = expected[index]
///
        ///             TwitterTextEntity *entity = [results objectAtIndex:i];
                    let entity = results[index]
        ///             NSRange r = entity.range;
                    let r = entity.range
        ///             NSString *actualText = [text substringWithRange:r];
                    let actualText = text.substring(with: Range(r, in: text)!)
///
        ///             XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
        ///         }
                }
        ///     } else {
            } else {
        ///         NSMutableArray *resultTexts = [NSMutableArray array];
                var resultTexts: [String] = []
        ///         for (TwitterTextEntity *entity in results) {
                for entity in results {
        ///             [resultTexts addObject:[text substringWithRange:entity.range]];
                    resultTexts.append(text.substring(with: Range(entity.range, in: text)!))
        ///         }
                }
        ///         XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")

        ///     }
            }
        /// }
        }

        // MARK: URLs with indices
        /// for (NSDictionary *testCase in urlsWithIndices) {
        ///     NSString *text = [testCase objectForKey:@"text"];
        ///     NSArray *expected = [testCase objectForKey:@"expected"];
        for testCase in urlsWithIndices {
            // FIXME: Failing test cases
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [[String: Any]] else {
                XCTFail()
                break
            }

        ///     NSArray *results = [TwitterText URLsInText:text];
            let results = TwitterText.URLs(inText: text)

        ///     if (results.count == expected.count) {
            if results.count == expected.count {
        ///         NSUInteger count = results.count;
        ///         for (NSUInteger i = 0; i < count; i++) {
                for index in 0..<results.count {
        ///             NSDictionary *expectedDic = [expected objectAtIndex:i];
        ///             NSString *expectedUrl = [expectedDic objectForKey:@"url"];
        ///             NSArray *expectedIndices = [expectedDic objectForKey:@"indices"];
                    let expectedDict = expected[index]
                    guard var expectedUrl = expectedDict["url"] as? String,
                          let expectedIndices = expectedDict["indices"] as? [Int] else {
                        XCTFail()
                        return
                    }
        ///             NSUInteger expectedStart = [[expectedIndices objectAtIndex:0] unsignedIntegerValue];
                    let expectedStart = expectedIndices[0]
        ///             NSUInteger expectedEnd = [[expectedIndices objectAtIndex:1] unsignedIntegerValue];
                    let expectedEnd = expectedIndices[1]
        ///             if (expectedEnd < expectedStart) {
                    if expectedEnd < expectedStart {
        ///                 XCTFail(@"Expected start is greater than expected end: %lu, %lu", (unsigned long)expectedStart, (unsigned long)expectedEnd);
                        XCTFail("Expected start '\(expectedStart)' is greater than expected end '\(expectedEnd)'")
        ///             }
                    }
        ///             NSRange expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart);
                    let expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart)
///
        ///             TwitterTextEntity *entity = [results objectAtIndex:i];
                    let entity = results[index]
        ///             NSRange actualRange = entity.range;
                    let actualRange = entity.range
        ///             NSString *actualText = [text substringWithRange:actualRange];
                    let actualText = text.substring(with: Range(actualRange, in: text)!)
///
        ///             XCTAssertEqualObjects(expectedUrl, actualText, @"%@", testCase);
                    XCTAssertEqual(expectedUrl, actualText, "\(testCase)")
        ///             XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), @"%@ != %@\n%@", NSStringFromRange(expectedRange), NSStringFromRange(actualRange), testCase);
                    XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), "\(NSStringFromRange(expectedRange)) != \(NSStringFromRange(actualRange))\n\(testCase)")
        ///         }
                }
        ///     } else {
            } else {
        ///         NSMutableArray *resultTexts = [NSMutableArray array];
                var resultTexts: [String] = []
        ///         for (TwitterTextEntity *entity in results) {
                for entity in results {
        ///             [resultTexts addObject:[text substringWithRange:entity.range]];
                    resultTexts.append(text.substring(with: Range(entity.range, in: text)!))
        ///         }
                }
        ///         XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
        ///     }
            }
        /// }
        }

        // MARK: Hashtags
        /// for (NSDictionary *testCase in hashtags) {
        ///     NSString *text = [testCase objectForKey:@"text"];
        ///     NSArray *expected = [testCase objectForKey:@"expected"];
        for testCase in hashtags {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }
        ///     NSArray *results = [TwitterText hashtagsInText:text checkingURLOverlap:YES];
            let results = TwitterText.hashtags(inText: text, checkingURLOverlap: true)
        ///     if (results.count == expected.count) {
            if results.count == expected.count {
        ///         NSUInteger count = results.count;
        ///         for (NSUInteger i = 0; i < count; i++) {
                for index in 0..<results.count {
        ///             NSString *expectedText = [expected objectAtIndex:i];
                    let expectedText = expected[index]
///
        ///             TwitterTextEntity *entity = [results objectAtIndex:i];
                    let entity = results[index]
        ///             NSRange r = entity.range;
                    var r = entity.range
        ///             r.location++;
                    r.location += 1
        ///             r.length--;
                    r.length -= 1
        ///             NSString *actualText = [text substringWithRange:r];
                    let actualText = text.substring(with: Range(r, in:text)!)
///
        ///             XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
        ///         }
                }
        ///     } else {
            } else {
        ///         NSMutableArray *resultTexts = [NSMutableArray array];
                var resultTexts: [String] = []
        ///         for (TwitterTextEntity *entity in results) {
                for entity in results {
        ///             [resultTexts addObject:[text substringWithRange:entity.range]];
                    resultTexts.append(text.substring(with: Range(entity.range, in: text)!))
        ///         }
                }
        ///         XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
                    XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
        ///     }
            }
        /// }
        }

        // MARK: Hashtags from Astral
        /// for (NSDictionary *testCase in hashtagsFromAstral) {
        ///     NSString *text = [testCase objectForKey:@"text"];
        ///     NSArray *expected = [testCase objectForKey:@"expected"];
        for testCase in hashtagsFromAstral {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }
        ///     NSArray *results = [TwitterText hashtagsInText:text checkingURLOverlap:YES];
            let results = TwitterText.hashtags(inText: text, checkingURLOverlap: true)
        ///     if (results.count == expected.count) {
            if results.count == expected.count {
        ///         NSUInteger count = results.count;
        ///         for (NSUInteger i = 0; i < count; i++) {
                for index in 0..<results.count {
        ///             NSString *expectedText = [expected objectAtIndex:i];
                    let expectedText = expected[index]
///
        ///             TwitterTextEntity *entity = [results objectAtIndex:i];
                    let entity = results[index]
        ///             NSRange r = entity.range;
                    var r = entity.range
        ///             r.location++;
                    r.location += 1
        ///             r.length--;
                    r.length -= 1
        ///             NSString *actualText = [text substringWithRange:r];
                    let actualText = text.substring(with: Range(r, in: text)!)
///
        ///             XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
        ///         }
                }
        ///     } else {
            } else {
        ///         NSMutableArray *resultTexts = [NSMutableArray array];
                var resultTexts: [String] = []
        ///         for (TwitterTextEntity *entity in results) {
                for entity in results {
        ///             [resultTexts addObject:[text substringWithRange:entity.range]];
                    resultTexts.append(text.substring(with: Range(entity.range, in: text)!))
        ///         }
                }
        ///         XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
                    XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
        ///     }
            }
        /// }
        }

    /*
        //
        // Hashtags with indices
        //

        for (NSDictionary *testCase in hashtagsWithIndices) {
            NSString *text = [testCase objectForKey:@"text"];
            NSArray *expected = [testCase objectForKey:@"expected"];

            NSArray *results = [TwitterText hashtagsInText:text checkingURLOverlap:YES];
            if (results.count == expected.count) {
                NSUInteger count = results.count;
                for (NSUInteger i = 0; i < count; i++) {
                    NSDictionary *expectedDic = [expected objectAtIndex:i];
                    NSString *expectedHashtag = [expectedDic objectForKey:@"hashtag"];
                    NSArray *expectedIndices = [expectedDic objectForKey:@"indices"];
                    NSUInteger expectedStart = [[expectedIndices objectAtIndex:0] unsignedIntegerValue];
                    NSUInteger expectedEnd = [[expectedIndices objectAtIndex:1] unsignedIntegerValue];
                    if (expectedEnd < expectedStart) {
                        XCTFail(@"Expected start is greater than expected end: %lu, %lu", (unsigned long)expectedStart, (unsigned long)expectedEnd);
                    }
                    NSRange expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart);

                    TwitterTextEntity *entity = [results objectAtIndex:i];
                    NSRange actualRange = entity.range;
                    NSRange r = actualRange;
                    r.location++;
                    r.length--;
                    NSString *actualText = [text substringWithRange:r];

                    XCTAssertEqualObjects(expectedHashtag, actualText, @"%@", testCase);
                    XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), @"%@ != %@\n%@", NSStringFromRange(expectedRange), NSStringFromRange(actualRange), testCase);
                }
            } else {
                NSMutableArray *resultTexts = [NSMutableArray array];
                for (TwitterTextEntity *entity in results) {
                    [resultTexts addObject:[text substringWithRange:entity.range]];
                }
                XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
            }
        }
     */
    /*
        //
        // Symbols
        //
        for (NSDictionary *testCase in symbols) {
            NSString *text = [testCase objectForKey:@"text"];
            NSArray *expected = [testCase objectForKey:@"expected"];

            NSArray *results = [TwitterText symbolsInText:text checkingURLOverlap:YES];
            if (results.count == expected.count) {
                NSUInteger count = results.count;
                for (NSUInteger i = 0; i < count; i++) {
                    NSString *expectedText = [expected objectAtIndex:i];

                    TwitterTextEntity *entity = [results objectAtIndex:i];
                    NSRange r = entity.range;
                    r.location++;
                    r.length--;
                    NSString *actualText = [text substringWithRange:r];

                    XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
                }
            } else {
                NSMutableArray *resultTexts = [NSMutableArray array];
                for (TwitterTextEntity *entity in results) {
                    [resultTexts addObject:[text substringWithRange:entity.range]];
                }
                XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
            }
        }
 */
/*
        //
        // Symbols with indices
        //
        for (NSDictionary *testCase in symbolsWithIndices) {
            NSString *text = [testCase objectForKey:@"text"];
            NSArray *expected = [testCase objectForKey:@"expected"];

            NSArray *results = [TwitterText symbolsInText:text checkingURLOverlap:YES];
            if (results.count == expected.count) {
                NSUInteger count = results.count;
                for (NSUInteger i = 0; i < count; i++) {
                    NSDictionary *expectedDic = [expected objectAtIndex:i];
                    NSString *expectedSymbol = [expectedDic objectForKey:@"cashtag"];
                    NSArray *expectedIndices = [expectedDic objectForKey:@"indices"];
                    NSUInteger expectedStart = [[expectedIndices objectAtIndex:0] unsignedIntegerValue];
                    NSUInteger expectedEnd = [[expectedIndices objectAtIndex:1] unsignedIntegerValue];
                    if (expectedEnd < expectedStart) {
                        XCTFail(@"Expected start is greater than expected end: %lu, %lu", (unsigned long)expectedStart, (unsigned long)expectedEnd);
                    }
                    NSRange expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart);

                    TwitterTextEntity *entity = [results objectAtIndex:i];
                    NSRange actualRange = entity.range;
                    NSRange r = actualRange;
                    r.location++;
                    r.length--;
                    NSString *actualText = [text substringWithRange:r];

                    XCTAssertEqualObjects(expectedSymbol, actualText, @"%@", testCase);
                    XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), @"%@ != %@\n%@", NSStringFromRange(expectedRange), NSStringFromRange(actualRange), testCase);
                }
            } else {
                NSMutableArray *resultTexts = [NSMutableArray array];
                for (TwitterTextEntity *entity in results) {
                    [resultTexts addObject:[text substringWithRange:entity.range]];
                }
                XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
            }
        }
     */
    }

// FIXME: failing test
    func testValidate() {
        let filename = conformanceRootDirectory.appendingPathComponent("validate.json")
        guard let jsonData = try? String(contentsOf: filename, encoding: .utf8).data(using: .utf8),
              let validation = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail("Invalid test data: \(filename)")
            return
        }

        TwitterTextParser.setDefaultParser(with: TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationClassic)!)

        /// NSDictionary *tests = [rootDic objectForKey:@"tests"];
        /// NSArray *lengths = [tests objectForKey:@"lengths"];
// FIXME: lengths has provided wrong dict key, cannot find anywhere "lengths" key in validate.json file
        guard let tests = validation["tests"] as? [String: Any],
              let lengths = tests["UnicodeDirectionalMarkerCounterTest"] as? [[String: Any]] else {
            XCTFail()
            return
        }

        for testCase in lengths {
            guard var text = testCase["text"] as? String else {
                XCTFail()
                break
            }
            text = stringByParsingUnicodeEscapes(string: text)

            let expected = testCase["expected"] as? Int
            let len = TwitterText.tweetLength(text: text)
            let results = TwitterTextParser.defaultParser.parseTweet(text: text)

            XCTAssertEqual(len, results.weightedLength, "TwitterTextParser with classic configuration is not compatible with TwitterText for string: \(text)")
            XCTAssertEqual(len, expected, "Length should be the same")
        }
    }


    /// - (void)_testWeightedTweetsCountingWithTestSuite:(NSString *)testSuite
    func _testWeightedTweetsCountingWithTestSuite(testSuite: String) {
        /// NSString *fileName = [[[self class] conformanceRootDirectory] stringByAppendingPathComponent:@"validate.json"];
        /// NSData *data = [NSData dataWithContentsOfFile:fileName];
        /// if (!data) {
        ///     XCTFail(@"No test data: %@", fileName);
        ///     return;
        /// }
        /// NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        /// if (!rootDic) {
        ///     XCTFail(@"Invalid test data: %@", fileName);
        ///     return;
        /// }
        let filename = conformanceRootDirectory.appendingPathComponent("validate.json")
        guard let jsonData = try? String(contentsOf: filename, encoding: .utf8).data(using: .utf8),
              let validation = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail("Invalid test data: \(filename)")
            return
        }

        /// NSDictionary *tests = [rootDic objectForKey:@"tests"];
        /// NSArray *lengths = [tests objectForKey:testSuite];

        guard let tests = validation["tests"] as? [String: Any],
              let lengths = tests[testSuite] as? [[String: Any]] else {
            XCTFail()
            return
        }

        /// for (NSDictionary *testCase in lengths) {
        for testCase in lengths {
            ///     NSString *text = [testCase objectForKey:@"text"];
            ///     text = [self stringByParsingUnicodeEscapes:text];
            ///     NSDictionary *expected = [testCase objectForKey:@"expected"];
            ///     NSString *testDescription = testCase[@"description"];
            ///     NSInteger weightedLength = [expected[@"weightedLength"] integerValue];
            ///     NSInteger permillage = [expected[@"permillage"] integerValue];
            ///     BOOL isValid = [expected[@"valid"] boolValue];
            ///     NSUInteger displayRangeStart = [expected[@"displayRangeStart"] integerValue];
            ///     NSUInteger displayRangeEnd = [expected[@"displayRangeEnd"] integerValue];
            ///     NSUInteger validRangeStart = [expected[@"validRangeStart"] integerValue];
            ///     NSUInteger validRangeEnd = [expected[@"validRangeEnd"] integerValue];
            guard var text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String: Any],
                  let testDescription = testCase["description"] as? String,
                  let weightedLength = expected["weightedLength"] as? Int,
                  let permillage = expected["permillage"] as? Int,
                  let isValid = expected["valid"] as? Bool,
                  let displayRangeStart = expected["displayRangeStart"] as? Int,
                  let displayRangeEnd = expected["displayRangeEnd"] as? Int,
                  let validRangeStart = expected["validRangeStart"] as? Int,
                  let validRangeEnd = expected["validRangeEnd"] as? Int else {
                XCTFail()
                break
            }
            text = stringByParsingUnicodeEscapes(string: text)
        ///     TwitterTextParseResults *results = [[TwitterTextParser defaultParser] parseTweet:text];
            let results = TwitterTextParser.defaultParser.parseTweet(text: text)
///
        ///     XCTAssertEqual(results.weightedLength, weightedLength, @"Length should be the same in \"%@\"", testDescription);
            XCTAssertEqual(results.weightedLength,
                           weightedLength,
                           "Length should be the same in \(testDescription)")
        ///     XCTAssertEqual(results.permillage, permillage, @"Permillage should be the same in \"%@\"", testDescription);
            XCTAssertEqual(results.permillage,
                           permillage,
                           "Permillage should be the same in \(testDescription)")
        ///     XCTAssertEqual(results.isValid, isValid, @"Valid should be the samein \"%@\"", testDescription);
            XCTAssertEqual(results.isValid,
                           isValid,
                           "Valid should be the same in \(testDescription)")
        ///     XCTAssertEqual(results.displayTextRange.location, displayRangeStart, @"Display text range start should be the same in \"%@\"", testDescription);
            XCTAssertEqual(results.displayTextRange.location,
                           displayRangeStart,
                           "Display text range start should be the same in \(testDescription)")
        ///     XCTAssertEqual(results.displayTextRange.length, displayRangeEnd - displayRangeStart + 1, @"Display text range length should be the same in \"%@\"", testDescription);
            XCTAssertEqual(results.displayTextRange.length,
                           displayRangeEnd - displayRangeStart + 1,
                           "Display text range length should be the same in \(testDescription)")
        ///     XCTAssertEqual(results.validDisplayTextRange.location, validRangeStart, @"Valid text range start should be the same in \"%@\"", testDescription);
            XCTAssertEqual(results.validDisplayTextRange.location,
                           validRangeStart,
                           "Valid text range start should be the same in \(testDescription)")
        ///     XCTAssertEqual(results.validDisplayTextRange.length, validRangeEnd - validRangeStart + 1, @"Valid text range length should be the same in \"%@\"", testDescription);
            XCTAssertEqual(results.validDisplayTextRange.length,
                           validRangeEnd - validRangeStart + 1,
                           "Valid text range length should be the same in \(testDescription)")
        /// }
        }
    }

    /// - (void)testUnicodePointTweetLengthCounting
    func testUnicodePointTweetLengthCounting() {
        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV2]];
        TwitterTextParser.setDefaultParser(with: TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV2)!)
        /// [self _testWeightedTweetsCountingWithTestSuite:@"WeightedTweetsCounterTest"];
        self._testWeightedTweetsCountingWithTestSuite(testSuite: "WeightedTweetsCounterTest")
    }

    /// - (void)testEmojiWeightedTweetLengthCounting
    func testEmojiWeightedTweetLengthCounting() {
        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3]];
        TwitterTextParser.setDefaultParser(with: TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV3)!)
        /// [self _testWeightedTweetsCountingWithTestSuite:@"WeightedTweetsWithDiscountedEmojiCounterTest"];
        self._testWeightedTweetsCountingWithTestSuite(testSuite: "WeightedTweetsWithDiscountedEmojiCounterTest")
    }

    /// - (void)testEmojiWeightedTweetLengthCountingWithDiscountedUnicode9Emoji
    func testEmojiWeightedTweetLengthCountingWithDiscountedUnicode9Emoji() {
        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3]];
        TwitterTextParser.setDefaultParser(with: TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV3)!)
        /// [self _testWeightedTweetsCountingWithTestSuite:@"WeightedTweetsWithDiscountedUnicode9EmojiCounterTest"];
        self._testWeightedTweetsCountingWithTestSuite(testSuite: "WeightedTweetsWithDiscountedUnicode9EmojiCounterTest")
    }

    /// - (void)testEmojiWeightedTweetLengthCountingWithDiscountedUnicode10Emoji
    func testEmojiWeightedTweetLengthCountingWithDiscountedUnicode10Emoji() {
        /// // TODO: drop-iOS-10: when dropping support for iOS 10, remove the #if, #endif and everything in between
        /// #if __IPHONE_11_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
        /// if (@available(iOS 11, *)) {
        /// } else {
        ///     NSLog(@"Info: in iOS %@ -[NSString enumerateSubstringsInRange:options:usingBlock:] does not enumerate ranges correctly for Unicode 10; therefore, this test is being bypassed",
        ///            [NSProcessInfo processInfo].operatingSystemVersionString);
        ///     return;
        /// }
        /// #endif // #if __IPHONE_11_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3]];

        TwitterTextParser.setDefaultParser(with: TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV3)!)
        /// [self _testWeightedTweetsCountingWithTestSuite:@"WeightedTweetsWithDiscountedUnicode10EmojiCounterTest"];
        self._testWeightedTweetsCountingWithTestSuite(testSuite: "WeightedTweetsWithDiscountedUnicode10EmojiCounterTest")
    }

    func testZeroWidthJoinerAndNonJoiner() {
        // This test is in the Objective-C code because the behavior seems to differ between
        // this implementation and other platforms.
        var text = "ZWJ: क्ष -> क्\u{200D}ष; ZWNJ: क्ष -> क्\u{200C}ष"
        text = self.stringByParsingUnicodeEscapes(string: text)

        TwitterTextParser.setDefaultParser(with: TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV3)!)
        let results = TwitterTextParser.defaultParser.parseTweet(text: text)

        XCTAssertEqual(results.weightedLength, 35)
        XCTAssertEqual(results.permillage, 125)
        XCTAssertTrue(results.isValid)
        XCTAssertEqual(results.displayTextRange.location, 0)
        XCTAssertEqual(results.displayTextRange.length, 35)
        XCTAssertEqual(results.validDisplayTextRange.location, 0)
        XCTAssertEqual(results.validDisplayTextRange.length, 35)
    }

    func testUnicodeDirectionalMarkerCounting() {
        let filename = conformanceRootDirectory.appendingPathComponent("validate.json")
        guard let jsonData = try? String(contentsOf: filename, encoding: .utf8).data(using: .utf8),
              let validation = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                XCTFail("Invalid test data: \(filename)")
                return
        }

        guard let tests = validation["tests"] as? [String: Any],
              let lengths = tests["UnicodeDirectionalMarkerCounterTest"] as? [[String: Any]] else {
            XCTFail()
            return
        }

        for testCase in lengths {
            guard var text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String: Any] else {
                XCTFail()
                break
            }
            text = stringByParsingUnicodeEscapes(string: text)

            let results = TwitterTextParser.defaultParser.parseTweet(text: text)

            XCTAssertEqual(results.weightedLength,
                           expected["weightedLength"] as? Int,
                           "Length should be the same")
            XCTAssertEqual(results.permillage,
                           expected["permillage"] as? Int,
                           "Permillage should be the same")
            XCTAssertEqual(results.isValid,
                           expected["valid"] as? Bool,
                           "Valid should be the same")
            XCTAssertEqual(results.displayTextRange.location,
                           expected["displayRangeStart"] as? Int,
                           "Display text range start should be the same")
            XCTAssertEqual(results.validDisplayTextRange.location,
                           expected["validRangeStart"] as? Int,
                           "Valid text range start should be the same")

            guard let expectedDisplayRangeStart = expected["displayRangeStart"] as? Int,
                  let expectedDisplayRangeEnd = expected["displayRangeEnd"] as? Int,
                  let expectedValidRangeStart = expected["validRangeStart"] as? Int,
                  let expectedValidRangeEnd = expected["validRangeEnd"] as? Int else {
                XCTFail()
                break
            }

            XCTAssertEqual(results.displayTextRange.length, expectedDisplayRangeEnd - expectedDisplayRangeStart + 1, "Display text range length should be the same")
            XCTAssertEqual(results.validDisplayTextRange.length, expectedValidRangeEnd - expectedValidRangeStart + 1, "Valid text range length should be the same")
        }
    }

    // TODO: split into two methods, extract test setup part to different method (similar for many other tests also) ?
    /*
- (void)testTlds
{
    NSString *fileName = [[[self class] conformanceRootDirectory] stringByAppendingPathComponent:@"tlds.json"];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    if (!data) {
        XCTFail(@"No test data: %@", fileName);
        return;
    }
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if (!rootDic) {
        XCTFail(@"Invalid test data: %@", fileName);
        return;
    }

    NSDictionary *tests = [rootDic objectForKey:@"tests"];

    NSArray *country = [tests objectForKey:@"country"];
    NSArray *generic = [tests objectForKey:@"generic"];

    //
    // URLs with ccTLD
    //
    for (NSDictionary *testCase in country) {
        NSString *text = [testCase objectForKey:@"text"];
        NSArray *expected = [testCase objectForKey:@"expected"];

        NSArray *results = [TwitterText URLsInText:text];
        if (results.count == expected.count) {
            NSUInteger count = results.count;
            for (NSUInteger i = 0; i < count; i++) {
                NSString *expectedText = [expected objectAtIndex:i];

                TwitterTextEntity *entity = [results objectAtIndex:i];
                NSRange r = entity.range;
                NSString *actualText = [text substringWithRange:r];

                XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
            }
        } else {
            NSMutableArray *resultTexts = [NSMutableArray array];
            for (TwitterTextEntity *entity in results) {
                [resultTexts addObject:[text substringWithRange:entity.range]];
            }
            XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
        }
    }

    //
    // URLs with gTLD
    //
    for (NSDictionary *testCase in generic) {
        NSString *text = [testCase objectForKey:@"text"];
        NSArray *expected = [testCase objectForKey:@"expected"];

        NSArray *results = [TwitterText URLsInText:text];
        if (results.count == expected.count) {
            NSUInteger count = results.count;
            for (NSUInteger i = 0; i < count; i++) {
                NSString *expectedText = [expected objectAtIndex:i];

                TwitterTextEntity *entity = [results objectAtIndex:i];
                NSRange r = entity.range;
                NSString *actualText = [text substringWithRange:r];

                XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
            }
        } else {
            NSMutableArray *resultTexts = [NSMutableArray array];
            for (TwitterTextEntity *entity in results) {
                [resultTexts addObject:[text substringWithRange:entity.range]];
            }
            XCTFail(@"Matching count is different: %lu != %lu\n%@\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase, resultTexts);
        }
    }
}
*/

    func testTwitterTextParserConfiguration() {
        let configurationString = "{\"version\": 1, \"maxWeightedTweetLength\": 280, \"scale\": 2, \"defaultWeight\": 1, \"transformedURLLength\": 23, \"ranges\": [{\"start\": 4352, \"end\": 4353, \"weight\": 2}]}"
        guard let configuration = TwitterTextConfiguration.configuration(from: configurationString) else {
            XCTFail()
            return
        }

        XCTAssertEqual(1, configuration.version)
        XCTAssertEqual(1, configuration.defaultWeight)
        XCTAssertEqual(23, configuration.transformedURLLength)
        XCTAssertEqual(280, configuration.maxWeightedTweetLength)
        XCTAssertEqual(2, configuration.scale)

        let weightedRange = configuration.ranges[0]

        XCTAssertEqual(4352, weightedRange.range.location);
        XCTAssertEqual(1, weightedRange.range.length);
        XCTAssertEqual(2, weightedRange.weight);
    }

    func testTwitterTextParserConfigurationV2ToV3Transition() {
        guard let configurationV2 = TwitterTextConfiguration
                .configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV2),
              let configurationV3 = TwitterTextConfiguration
                .configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV3) else {
            XCTFail()
            return
        }

        XCTAssertEqual(configurationV2.defaultWeight, configurationV3.defaultWeight)
        XCTAssertEqual(configurationV2.transformedURLLength, configurationV2.transformedURLLength)
        XCTAssertEqual(configurationV2.maxWeightedTweetLength, configurationV3.maxWeightedTweetLength)
        XCTAssertEqual(configurationV2.scale, configurationV3.scale)

        for index in 0..<configurationV2.ranges.count {
            let weightedRangeV2 = configurationV2.ranges[index]
            let weightedRangeV3 = configurationV3.ranges[index]
            XCTAssertTrue(NSEqualRanges(weightedRangeV2.range, weightedRangeV3.range))
            XCTAssertEqual(weightedRangeV2.weight, weightedRangeV3.weight)
        }
    }

    func stringByParsingUnicodeEscapes(string: String) -> String {
        var string = string

        var regex: NSRegularExpression? = nil
        if regex == nil {
            regex = try? NSRegularExpression.init(pattern: "\\\\U([0-9a-fA-F]{8}|[0-9a-fA-F]{4})",
                                                  options: [])
        }

        var index = 0
        while index < string.count {
            guard let result = regex?.firstMatch(in: string,
                                                 options: [],
                                                 range: NSMakeRange(index, string.count - index)) else {
                break
            }

            let patternRange = result.range
            let hexRange = result.range(at: 1)
            var resultLength = 1

            if hexRange.location != NSNotFound, let rHexRange = Range(hexRange, in: string) {
                let hexString = String(string[rHexRange])
                let value = strtol(NSString(string: hexString).utf8String, nil, 16)

                if value < 0x10000 {
                    string = string.replacingCharacters(in: Range(patternRange, in: string)!,
                                                        with: String(unichar(value)))
                } else {
                    var surrogates: [unichar] = Array.init(repeating: unichar(), count: 2)

                    if CFStringGetSurrogatePairForLongCharacter(UTF32Char(value), &surrogates) {
                        guard let range = Range(patternRange, in: string) else {
                            break
                        }
                        string = string.replacingCharacters(in: range,
                                                            with: String(NSString(characters: surrogates, length: 2)))
                        resultLength = 2
                    }
                }
            }

            index = patternRange.location + resultLength
        }

        return string
    }

    var conformanceRootDirectory: URL {
        return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("json-conformance")
    }
}
