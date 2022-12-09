//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import XCTest
import CoreFoundation
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
        XCTAssertTrue(set.contains(" ".unicodeScalars.first!))
        XCTAssertTrue(set.contains("\u{00BF}".unicodeScalars.first!))
        XCTAssertTrue(set.contains("\u{00BF}".unicodeScalars.first!))
        XCTAssertFalse(set.contains("\u{00C0}".unicodeScalars.first!))
        XCTAssertFalse(set.contains("\u{00D6}".unicodeScalars.first!))
        XCTAssertTrue(set.contains("\u{00D7}".unicodeScalars.first!))
        XCTAssertFalse(set.contains("\u{00E0}".unicodeScalars.first!))

        let characterSet = set as NSCharacterSet
        let validLongCharacterString = "\u{0001FFFF}" as NSString
        XCTAssertTrue(characterSet.longCharacterIsMember(CFStringGetLongCharacterForSurrogatePair(validLongCharacterString.character(at: 0),validLongCharacterString.character(at: 1))))

        let invalidLongCharacterString = "\u{00020000}" as NSString
        XCTAssertFalse(characterSet.longCharacterIsMember(CFStringGetLongCharacterForSurrogatePair(invalidLongCharacterString.character(at: 0), invalidLongCharacterString.character(at: 1))))
    }

    func testLongDomain() {
        let text = "jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp"
        let entities = TwitterText.entities(in: text)

        XCTAssertEqual(entities.count, 1)

        if entities.count >= 1 {
            let entity = entities[0]

            XCTAssertEqual(NSStringFromRange(entity.range), NSStringFromRange(NSMakeRange(0, text.count)))
        }
    }

    func testJapaneseTLDFollowedByJapaneseCharacters() {
        let text = "テスト test.みんなです"
        let entities = TwitterText.entities(in: text)

        XCTAssertEqual(entities.count, 1)

        if entities.count >= 1 {
            let entity = entities[0]

            XCTAssertEqual(NSStringFromRange(entity.range), NSStringFromRange(NSMakeRange(4, 8)))
        }
    }

    func testJapaneseTLDFollowedByASCIICharacters() {
        let text = "テスト test.みんなabc"
        let entities = TwitterText.entities(in: text)

        XCTAssertEqual(entities.count, 0)
    }

    func testURLWithZeroWidthJoinerFailsParsingButDoesntCrash() {
        // The "2" character in the URL has a zero-width-joiner which causes parsing to fail, but the library shouldn't crash
        let text = "Heroes 🚀 https://t.co/11111112‍"
        let entities = TwitterText.entities(in: text)

        XCTAssertEqual(entities.count, 0)
    }

    func testURLWithoutZeroWidthJoinerParsesOneEntity() {
        let text = "Heroes 🚀 https://t.co/11111112"
        let entities = TwitterText.entities(in: text)

        XCTAssertEqual(entities.count, 1)
    }

    func testExtract() {
        let filename = conformanceRootDirectory.appendingPathComponent("extract.json")
        guard let jsonData = try? String(contentsOf: filename, encoding: .utf8).data(using: .utf8),
              let validation = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail("Invalid test data: \(filename)")
            return
        }

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

            let results = TwitterText.mentionsOrLists(in: text)
            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedText = expected[index]
                    let entity = results[index]

                    var actualRange = entity.range
                    actualRange.location += 1
                    actualRange.length -= 1

                    guard let range = Range(actualRange, in: text) else {
                        XCTFail()
                        break
                    }

                    let actualText = String(text[range])

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

            let results = TwitterText.mentionsOrLists(in: text)

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

                    guard let range = Range(r, in: text) else {
                        XCTFail()
                        break
                    }

                    let actualText = String(text[range])

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

            let results = TwitterText.mentionsOrLists(in: text)

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

                    guard let range = Range(r, in: text) else {
                        XCTFail()
                        break
                    }

                    let actualText = String(text[range])

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
            let result = TwitterText.repliedScreenName(in: text)

            if result != nil || expected != nil {
                var actual: String? = nil
                if let resultRange = result?.range, let range = Range(resultRange, in: text) {
                    actual = String(text[range])
                }

                if expected == nil {
                    XCTAssertNil(actual, "\(String(describing: actual))\n\(testCase)")
                } else {
                    XCTAssertEqual(expected, actual, "\(testCase)")
                }
            }
        }


        // MARK: URLs
        for testCase in urls {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }

            let results = TwitterText.urls(in: text)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedText = expected[index]
                    let entity = results[index]

                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }
                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }

        // MARK: URLs with indices
        for testCase in urlsWithIndices {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [[String: Any]] else {
                XCTFail()
                break
            }

            let results = TwitterText.urls(in: text)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedDict = expected[index]

                    guard let expectedUrl = expectedDict["url"] as? String,
                          let expectedIndices = expectedDict["indices"] as? [Int] else {
                        XCTFail()
                        return
                    }

                    let expectedStart = expectedIndices[0]
                    let expectedEnd = expectedIndices[1]
                    if expectedEnd < expectedStart {
                        XCTFail("Expected start '\(expectedStart)' is greater than expected end '\(expectedEnd)'")
                    }

                    let expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart)

                    let entity = results[index]
                    let actualRange = entity.range
                    guard let range = Range(actualRange, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedUrl, actualText, "\(testCase)")
                    XCTAssertTrue(NSEqualRanges(expectedRange, actualRange),
                                  "\(NSStringFromRange(expectedRange)) != \(NSStringFromRange(actualRange))\n\(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }

                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }

        // MARK: Hashtags
        for testCase in hashtags {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }

            let results = TwitterText.hashtags(in: text, checkingURLOverlap: true)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedText = expected[index]
                    let entity = results[index]

                    var r = entity.range
                    r.location += 1
                    r.length -= 1
                    guard let range = Range(r, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }

                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }

        // MARK: Hashtags from Astral
        for testCase in hashtagsFromAstral {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }
            let results = TwitterText.hashtags(in: text, checkingURLOverlap: true)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedText = expected[index]
                    let entity = results[index]

                    var r = entity.range
                    r.location += 1
                    r.length -= 1
                    guard let range = Range(r, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }

                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }

        // MARK: Hashtags with indices
        for testCase in hashtagsWithIndices {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [[String: Any]] else {
                XCTFail()
                break
            }

            let results = TwitterText.hashtags(in: text, checkingURLOverlap: true)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedDict = expected[index]

                    guard let expectedHashtag = expectedDict["hashtag"] as? String,
                          let expectedIndices = expectedDict["indices"] as? [Int] else {
                        XCTFail()
                        break
                    }

                    let expectedStart = expectedIndices[0]
                    let expectedEnd = expectedIndices[1]

                    if expectedEnd < expectedStart {
                        XCTFail("Expected start (\(expectedStart)) is greater than expected end (\(expectedEnd))")
                    }

                    let expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart)
                    let entity = results[index]
                    let actualRange = entity.range

                    var r = actualRange
                    r.location += 1
                    r.length -= 1
                    guard let range = Range(r, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedHashtag, actualText, "\(testCase)")
                    XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), "\(NSStringFromRange(expectedRange)) != \(NSStringFromRange(actualRange)), \(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }

                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }

        // MARK: Symbols
        for testCase in symbols {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }

            let results = TwitterText.symbols(in: text, checkingURLOverlap: true)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedText = expected[index]
                    let entity = results[index]

                    var r = entity.range
                    r.location += 1
                    r.length -= 1
                    guard let range = Range(r, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }

                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }

        // MARK: Symbols with indices
        for testCase in symbolsWithIndices {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [[String: Any]] else {
                XCTFail()
                break
            }

            let results = TwitterText.symbols(in: text, checkingURLOverlap: true)

            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedDict = expected[index]

                    guard let expectedHashtag = expectedDict["cashtag"] as? String,
                          let expectedIndices = expectedDict["indices"] as? [Int] else {
                        XCTFail()
                        break
                    }

                    let expectedStart = expectedIndices[0]
                    let expectedEnd = expectedIndices[1]

                    if expectedEnd < expectedStart {
                        XCTFail("Expected start (\(expectedStart)) is greater than expected end (\(expectedEnd))")
                    }

                    let expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart)
                    let entity = results[index]
                    let actualRange = entity.range

                    var r = actualRange
                    r.location += 1
                    r.length -= 1
                    guard let range = Range(r, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedHashtag, actualText, "\(testCase)")
                    XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), "\(NSStringFromRange(expectedRange)) != \(NSStringFromRange(actualRange)), \(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }

                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }
    }

    func testValidate() {
        let filename = conformanceRootDirectory.appendingPathComponent("validate.json")
        guard let jsonData = try? String(contentsOf: filename, encoding: .utf8).data(using: .utf8),
              let validation = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail("Invalid test data: \(filename)")
            return
        }

        Parser.setDefaultParser(with: Configuration.configuration(fromJSONResource: ConfigurationType.classic)!)

        guard let tests = validation["tests"] as? [String: Any] else {
            XCTFail()
            return
        }

        let lengths = tests["lengths"] as? [[String: Any]] ?? []

        for testCase in lengths {
            guard var text = testCase["text"] as? String else {
                XCTFail()
                break
            }
            text = stringByParsingUnicodeEscapes(string: text)

            let expected = testCase["expected"] as? Int
            let len = TwitterText.tweetLength(text: text)
            let results = Parser.defaultParser.parseTweet(text: text)

            XCTAssertEqual(len, results.weightedLength, "TwitterTextParser with classic configuration is not compatible with TwitterText for string: \(text)")
            XCTAssertEqual(len, expected, "Length should be the same")
        }
    }

    func _testWeightedTweetsCountingWithTestSuite(testSuite: String) {
        let filename = conformanceRootDirectory.appendingPathComponent("validate.json")
        guard let jsonData = try? String(contentsOf: filename, encoding: .utf8).data(using: .utf8),
              let validation = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail("Invalid test data: \(filename)")
            return
        }

        guard let tests = validation["tests"] as? [String: Any],
              let lengths = tests[testSuite] as? [[String: Any]] else {
            XCTFail()
            return
        }

        for testCase in lengths {
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
            let results = Parser.defaultParser.parseTweet(text: text)

            XCTAssertEqual(results.weightedLength,
                           weightedLength,
                           "Length should be the same in \(testDescription)")
            XCTAssertEqual(results.permillage,
                           permillage,
                           "Permillage should be the same in \(testDescription)")

            XCTAssertEqual(results.isValid,
                           isValid,
                           "Valid should be the same in \(testDescription)")
            XCTAssertEqual(results.displayTextRange.location,
                           displayRangeStart,
                           "Display text range start should be the same in \(testDescription)")
            XCTAssertEqual(results.displayTextRange.length,
                           displayRangeEnd - displayRangeStart + 1,
                           "Display text range length should be the same in \(testDescription)")
            XCTAssertEqual(results.validDisplayTextRange.location,
                           validRangeStart,
                           "Valid text range start should be the same in \(testDescription)")
            XCTAssertEqual(results.validDisplayTextRange.length,
                           validRangeEnd - validRangeStart + 1,
                           "Valid text range length should be the same in \(testDescription)")
        }
    }

    func testUnicodePointTweetLengthCounting() {
        Parser.setDefaultParser(with: Configuration.configuration(fromJSONResource: ConfigurationType.v2)!)
        self._testWeightedTweetsCountingWithTestSuite(testSuite: "WeightedTweetsCounterTest")
    }

    func testEmojiWeightedTweetLengthCounting() {
        Parser.setDefaultParser(with: Configuration.configuration(fromJSONResource: ConfigurationType.v3)!)
        self._testWeightedTweetsCountingWithTestSuite(testSuite: "WeightedTweetsWithDiscountedEmojiCounterTest")
    }

    func testEmojiWeightedTweetLengthCountingWithDiscountedUnicode9Emoji() {
        Parser.setDefaultParser(with: Configuration.configuration(fromJSONResource: ConfigurationType.v3)!)
        self._testWeightedTweetsCountingWithTestSuite(testSuite: "WeightedTweetsWithDiscountedUnicode9EmojiCounterTest")
    }

    func testEmojiWeightedTweetLengthCountingWithDiscountedUnicode10Emoji() {
        /// // TODO: drop-iOS-10: when dropping support for iOS 10, remove the #if, #endif and everything in between
        if #available(iOS 11, *) {

        }
        else {
            print("Info: in iOS \(ProcessInfo.processInfo.operatingSystemVersion) String().enumerateSubstrings(in:, options:) does not enumerate ranges correctly for Unicode 10; therefore, this test is being bypassed")
            return
        }

        Parser.setDefaultParser(with: Configuration.configuration(fromJSONResource: ConfigurationType.v3)!)
        self._testWeightedTweetsCountingWithTestSuite(testSuite: "WeightedTweetsWithDiscountedUnicode10EmojiCounterTest")
    }

    func testZeroWidthJoinerAndNonJoiner() {
        // This test is in the Objective-C code because the behavior seems to differ between
        // this implementation and other platforms.
        var text = "ZWJ: क्ष -> क्\u{200D}ष; ZWNJ: क्ष -> क्\u{200C}ष"
        text = self.stringByParsingUnicodeEscapes(string: text)

        Parser.setDefaultParser(with: Configuration.configuration(fromJSONResource: ConfigurationType.v3)!)
        let results = Parser.defaultParser.parseTweet(text: text)

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

            let results = Parser.defaultParser.parseTweet(text: text)

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

    func testTlds() {
        let filename = conformanceRootDirectory.appendingPathComponent("tlds.json")
        guard let jsonData = try? String(contentsOf: filename, encoding: .utf8).data(using: .utf8),
              let validation = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            XCTFail("Invalid test data: \(filename)")
            return
        }

        guard let tests = validation["tests"] as? [String: Any] else {
            XCTFail()
            return
        }

        guard let country = tests["country"] as? [[String: Any]],
              let generic = tests["generic"] as? [[String: Any]] else {
            XCTFail()
            return
        }

        // MARK: URLs with ccTLD
        for testCase in country {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }

            let results = TwitterText.urls(in: text)
            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedText = expected[index]
                    let entity = results[index]
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }
                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }

        // MARK: URLs with gTLD
        for testCase in generic {
            guard let text = testCase["text"] as? String,
                  let expected = testCase["expected"] as? [String] else {
                XCTFail()
                break
            }

            let results = TwitterText.urls(in: text)
            if results.count == expected.count {
                for index in 0..<results.count {
                    let expectedText = expected[index]
                    let entity = results[index]
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    let actualText = String(text[range])

                    XCTAssertEqual(expectedText, actualText, "\(testCase)")
                }
            } else {
                var resultTexts: [String] = []
                for entity in results {
                    guard let range = Range(entity.range, in: text) else {
                        XCTFail()
                        break
                    }
                    resultTexts.append(String(text[range]))
                }
                XCTFail("Matching count is different: \(expected.count) != \(results.count)\n\(testCase)\n\(resultTexts)")
            }
        }
    }

    func testTwitterTextParserConfiguration() {
        let configurationString = "{\"version\": 1, \"maxWeightedTweetLength\": 280, \"scale\": 2, \"defaultWeight\": 1, \"transformedURLLength\": 23, \"ranges\": [{\"start\": 4352, \"end\": 4353, \"weight\": 2}]}"
        guard let configuration = Configuration.configuration(from: configurationString) else {
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
        guard let configurationV2 = Configuration
                .configuration(fromJSONResource: ConfigurationType.v2),
              let configurationV3 = Configuration
                .configuration(fromJSONResource: ConfigurationType.v3) else {
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
                let value = strtol(NSString(string: hexString).utf8String!, nil, 16)

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
                                                            with: NSString(characters: surrogates, length: 2) as String)
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
