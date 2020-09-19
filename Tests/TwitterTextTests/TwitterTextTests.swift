//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import XCTest
@testable import TwitterText

final class TwitterTextTests: XCTestCase {
    /// - (void)testRemainingCharacterCountForLongTweet
    func testRemainingCharacterCountForLongTweet() {
        XCTAssertEqual(TwitterText.remainingCharacterCount( text: "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", transformedURLLength:23), -10)
    }

    /// - (void)testHashtagBoundary
    func testHastagBoundary() {
        /// NSCharacterSet *set = [TwitterText validHashtagBoundaryCharacterSet];
        let set = TwitterText.validHashtagBoundaryCharacterSet()
        /// XCTAssertTrue(set != nil);
        XCTAssertNotNil(set)
        /// XCTAssertFalse([set characterIsMember:'a']);
        XCTAssertFalse(set.contains("a"))
        /// XCTAssertFalse([set characterIsMember:'m']);
        XCTAssertFalse(set.contains("m"))
        /// XCTAssertFalse([set characterIsMember:'z']);
        XCTAssertFalse(set.contains("z"))
        /// XCTAssertFalse([set characterIsMember:'A']);
        XCTAssertFalse(set.contains("A"))
        /// XCTAssertFalse([set characterIsMember:'M']);
        XCTAssertFalse(set.contains("M"))
        /// XCTAssertFalse([set characterIsMember:'Z']);
        XCTAssertFalse(set.contains("Z"))
        /// XCTAssertFalse([set characterIsMember:'0']);
        XCTAssertFalse(set.contains("0"))
        /// XCTAssertFalse([set characterIsMember:'5']);
        XCTAssertFalse(set.contains("5"))
        /// XCTAssertFalse([set characterIsMember:'9']);
        XCTAssertFalse(set.contains("9"))
        /// XCTAssertFalse([set characterIsMember:'_']);
        XCTAssertFalse(set.contains("_"))
        /// XCTAssertFalse([set characterIsMember:'&']);
        XCTAssertFalse(set.contains("&"))
        /// XCTAssertTrue([set characterIsMember:' ']);
        XCTAssertTrue(set.contains(" "))
        /// XCTAssertTrue([set characterIsMember:'#']);
        XCTAssertTrue(set.contains("#"))
        /// XCTAssertTrue([set characterIsMember:'@']);
        XCTAssertTrue(set.contains("@"))
        /// XCTAssertTrue([set characterIsMember:',']);
        XCTAssertTrue(set.contains(","))
        /// XCTAssertTrue([set characterIsMember:'=']);
        XCTAssertTrue(set.contains("="))
        /// XCTAssertTrue([set characterIsMember:[@"　" characterAtIndex:0]]);
        XCTAssertTrue(set.contains("\u{00BF}"))
        /// XCTAssertTrue([set characterIsMember:[@"\u00BF" characterAtIndex:0]]);
        XCTAssertTrue(set.contains("\u{00BF}"))
        /// XCTAssertFalse([set characterIsMember:[@"\u00C0" characterAtIndex:0]]);
        XCTAssertFalse(set.contains("\u{00C0}"))
        /// XCTAssertFalse([set characterIsMember:[@"\u00D6" characterAtIndex:0]]);
        XCTAssertFalse(set.contains("\u{00D6}"))
        /// XCTAssertTrue([set characterIsMember:[@"\u00D7" characterAtIndex:0]]);
        XCTAssertTrue(set.contains("\u{00D7}"))
        /// XCTAssertFalse([set characterIsMember:[@"\u00E0" characterAtIndex:0]]);

// TODO
        /// NSString *validLongCharacterString = @"\U0001FFFF";
        let validLongCharacterString = "\u{0001FFFF}"
        /// XCTAssertTrue([set longCharacterIsMember:CFStringGetLongCharacterForSurrogatePair([validLongCharacterString     characterAtIndex:0], [validLongCharacterString characterAtIndex:1])]);

        /// NSString *invalidLongCharacterString = @"\U00020000";
        let invalidLongCharacterString = "\u{00020000}"
        /// XCTAssertFalse([set longCharacterIsMember:CFStringGetLongCharacterForSurrogatePair([invalidLongCharacterString  characterAtIndex:0], [invalidLongCharacterString characterAtIndex:1])]);
    }

    /// - (void)testLongDomain
    func testLongDomain() {
        /// NSString *text = @"jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp";
        let text = "jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp.jp"
        /// NSArray *entities = [TwitterText entitiesInText:text];
        let entities = TwitterText.entities(inText: text)
        /// XCTAssertEqual(entities.count, (NSUInteger)1);
        XCTAssertEqual(entities.count, 1)
        /// if (entities.count >= 1) {
        if entities.count >= 1 {
        ///     TwitterTextEntity *entity = [entities objectAtIndex:0];
            let entity = entities[0]
        ///     XCTAssertEqualObjects(NSStringFromRange(entity.range), NSStringFromRange(NSMakeRange(0, text.length)));
            XCTAssertEqual(NSStringFromRange(entity.range), NSStringFromRange(NSMakeRange(0, text.count)))
        /// }
        }
    }

    /// - (void)testJapaneseTLDFollowedByJapaneseCharacters
    func testJapaneseTLDFollowedByJapaneseCharacters() {
        /// NSString *text = @"テスト test.みんなです";
        let text = "テスト test.みんなです"
        /// NSArray *entities = [TwitterText entitiesInText:text];
        let entities = TwitterText.entities(inText: text)
        /// XCTAssertEqual(entities.count, (NSUInteger)1);
        XCTAssertEqual(entities.count, 1)
        /// if (entities.count >= 1) {
        if entities.count >= 1 {
        ///     TwitterTextEntity *entity = [entities objectAtIndex:0];
            let entity = entities[0]
        ///     XCTAssertEqualObjects(NSStringFromRange(entity.range), NSStringFromRange(NSMakeRange(4, 8)));
            XCTAssertEqual(NSStringFromRange(entity.range), NSStringFromRange(NSMakeRange(4, 8)))
        /// }
        }
    }

    /// - (void)testJapaneseTLDFollowedByASCIICharacters
    func testJapaneseTLDFollowedByASCIICharacters() {
        /// NSString *text = @"テスト test.みんなabc";
        let text = "テスト test.みんなabc"
        /// NSArray *entities = [TwitterText entitiesInText:text];
        let entities = TwitterText.entities(inText: text)
        /// XCTAssertEqual(entities.count, (NSUInteger)0);
        XCTAssertEqual(entities.count, 0)
    }
// TODO: this test method should be split into smaller chunks
/*
- (void)testExtract
{
    NSString *fileName = [[[self class] conformanceRootDirectory] stringByAppendingPathComponent:@"extract.json"];
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

    NSArray *mentions = [tests objectForKey:@"mentions"];
    NSArray *mentionsWithIndices = [tests objectForKey:@"mentions_with_indices"];
    NSArray *mentionsOrListsWithIndices = [tests objectForKey:@"mentions_or_lists_with_indices"];
    NSArray *replies = [tests objectForKey:@"replies"];
    NSArray *urls = [tests objectForKey:@"urls"];
    NSArray *urlsWithIndices = [tests objectForKey:@"urls_with_indices"];
    NSArray *hashtags = [tests objectForKey:@"hashtags"];
    NSArray *hashtagsFromAstral = [tests objectForKey:@"hashtags_from_astral"];
    NSArray *hashtagsWithIndices = [tests objectForKey:@"hashtags_with_indices"];
    NSArray *symbols = [tests objectForKey:@"cashtags"];
    NSArray *symbolsWithIndices = [tests objectForKey:@"cashtags_with_indices"];

    //
    // Mentions
    //

    for (NSDictionary *testCase in mentions) {
        NSString *text = [testCase objectForKey:@"text"];
        NSArray *expected = [testCase objectForKey:@"expected"];

        NSArray *results = [TwitterText mentionsOrListsInText:text];
        if (results.count == expected.count) {
            NSUInteger count = results.count;
            for (NSUInteger i = 0; i < count; i++) {
                NSString *expectedText = [expected objectAtIndex:i];

                TwitterTextEntity *entity = [results objectAtIndex:i];
                NSRange actualRange = entity.range;
                actualRange.location++;
                actualRange.length--;
                NSString *actualText = [text substringWithRange:actualRange];

                XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
            }
        } else {
            XCTFail(@"Matching count is different: %lu != %lu\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase);
        }
    }

    //
    // Mentions with indices
    //

    for (NSDictionary *testCase in mentionsWithIndices) {
        NSString *text = [testCase objectForKey:@"text"];
        NSArray *expected = [testCase objectForKey:@"expected"];

        NSArray *results = [TwitterText mentionsOrListsInText:text];
        if (results.count == expected.count) {
            NSUInteger count = results.count;
            for (NSUInteger i = 0; i < count; i++) {
                NSDictionary *expectedDic = [expected objectAtIndex:i];
                NSString *expectedText = [expectedDic objectForKey:@"screen_name"];
                NSArray *indices = [expectedDic objectForKey:@"indices"];
                NSUInteger expectedStart = [[indices objectAtIndex:0] unsignedIntegerValue];
                NSUInteger expectedEnd = [[indices objectAtIndex:1] unsignedIntegerValue];
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

                XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
                XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), @"%@ != %@\n%@", NSStringFromRange(expectedRange), NSStringFromRange(actualRange), testCase);
            }
        } else {
            XCTFail(@"Matching count is different: %lu != %lu\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase);
        }
    }

    //
    // Mentions or lists with indices
    //

    for (NSDictionary *testCase in mentionsOrListsWithIndices) {
        NSString *text = [testCase objectForKey:@"text"];
        NSArray *expected = [testCase objectForKey:@"expected"];

        NSArray *results = [TwitterText mentionsOrListsInText:text];
        if (results.count == expected.count) {
            NSUInteger count = results.count;
            for (NSUInteger i = 0; i < count; i++) {
                NSDictionary *expectedDic = [expected objectAtIndex:i];
                NSString *expectedText = [expectedDic objectForKey:@"screen_name"];
                NSString *expectedListSlug = [expectedDic objectForKey:@"list_slug"];
                if (expectedListSlug.length > 0) {
                    expectedText = [expectedText stringByAppendingString:expectedListSlug];
                }
                NSArray *indices = [expectedDic objectForKey:@"indices"];
                NSUInteger expectedStart = [[indices objectAtIndex:0] unsignedIntegerValue];
                NSUInteger expectedEnd = [[indices objectAtIndex:1] unsignedIntegerValue];
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

                XCTAssertEqualObjects(expectedText, actualText, @"%@", testCase);
                XCTAssertTrue(NSEqualRanges(expectedRange, actualRange), @"%@ != %@\n%@", NSStringFromRange(expectedRange), NSStringFromRange(actualRange), testCase);
            }
        } else {
            XCTFail(@"Matching count is different: %lu != %lu\n%@", (unsigned long)expected.count, (unsigned long)results.count, testCase);
        }
    }

    //
    // Replies
    //

    for (NSDictionary *testCase in replies) {
        NSString *text = [testCase objectForKey:@"text"];
        NSString *expected = [testCase objectForKey:@"expected"];
        if (expected == (id)[NSNull null]) {
            expected = nil;
        }

        TwitterTextEntity *result = [TwitterText repliedScreenNameInText:text];
        if (result || expected) {
            NSRange range = result.range;
            NSString *actual = [text substringWithRange:range];
            if (expected == nil) {
                XCTAssertNil(actual, @"%@\n%@", actual, testCase);
            } else {
                XCTAssertEqualObjects(expected, actual, @"%@", testCase);
            }
        }
    }

    //
    // URLs
    //

    for (NSDictionary *testCase in urls) {
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
    // URLs with indices
    //

    for (NSDictionary *testCase in urlsWithIndices) {
        NSString *text = [testCase objectForKey:@"text"];
        NSArray *expected = [testCase objectForKey:@"expected"];

        NSArray *results = [TwitterText URLsInText:text];
        if (results.count == expected.count) {
            NSUInteger count = results.count;
            for (NSUInteger i = 0; i < count; i++) {
                NSDictionary *expectedDic = [expected objectAtIndex:i];
                NSString *expectedUrl = [expectedDic objectForKey:@"url"];
                NSArray *expectedIndices = [expectedDic objectForKey:@"indices"];
                NSUInteger expectedStart = [[expectedIndices objectAtIndex:0] unsignedIntegerValue];
                NSUInteger expectedEnd = [[expectedIndices objectAtIndex:1] unsignedIntegerValue];
                if (expectedEnd < expectedStart) {
                    XCTFail(@"Expected start is greater than expected end: %lu, %lu", (unsigned long)expectedStart, (unsigned long)expectedEnd);
                }
                NSRange expectedRange = NSMakeRange(expectedStart, expectedEnd - expectedStart);

                TwitterTextEntity *entity = [results objectAtIndex:i];
                NSRange actualRange = entity.range;
                NSString *actualText = [text substringWithRange:actualRange];

                XCTAssertEqualObjects(expectedUrl, actualText, @"%@", testCase);
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

    //
    // Hashtags
    //

    for (NSDictionary *testCase in hashtags) {
        NSString *text = [testCase objectForKey:@"text"];
        NSArray *expected = [testCase objectForKey:@"expected"];

        NSArray *results = [TwitterText hashtagsInText:text checkingURLOverlap:YES];
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

    //
    // Hashtags from Astral
    //

    for (NSDictionary *testCase in hashtagsFromAstral) {
        NSString *text = [testCase objectForKey:@"text"];
        NSArray *expected = [testCase objectForKey:@"expected"];

        NSArray *results = [TwitterText hashtagsInText:text checkingURLOverlap:YES];
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
}
*/
    /// - (void)testValidate
    func testValidate() {
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

        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationClassic]];

        /// NSDictionary *tests = [rootDic objectForKey:@"tests"];
        /// NSArray *lengths = [tests objectForKey:@"lengths"];

        /// for (NSDictionary *testCase in lengths) {
        ///     NSString *text = [testCase objectForKey:@"text"];
        ///     text = [self stringByParsingUnicodeEscapes:text];
        ///     NSUInteger expected = [[testCase objectForKey:@"expected"] unsignedIntegerValue];
        ///     NSUInteger len = [TwitterText tweetLength:text];
        ///     TwitterTextParseResults *results = [[TwitterTextParser defaultParser] parseTweet:text];
        ///     XCTAssertEqual(len, results.weightedLength, "TwitterTextParser with classic configuration is not compatible with TwitterText for string %@", text);
        ///     XCTAssertEqual(len, expected, @"Length should be the same");
        /// }
    }
/*
- (void)_testWeightedTweetsCountingWithTestSuite:(NSString *)testSuite
{
    NSString *fileName = [[[self class] conformanceRootDirectory] stringByAppendingPathComponent:@"validate.json"];
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
    NSArray *lengths = [tests objectForKey:testSuite];

    for (NSDictionary *testCase in lengths) {
        NSString *text = [testCase objectForKey:@"text"];
        text = [self stringByParsingUnicodeEscapes:text];
        NSDictionary *expected = [testCase objectForKey:@"expected"];
        TwitterTextParseResults *results = [[TwitterTextParser defaultParser] parseTweet:text];

        NSString *testDescription = testCase[@"description"];
        NSInteger weightedLength = [expected[@"weightedLength"] integerValue];
        NSInteger permillage = [expected[@"permillage"] integerValue];
        BOOL isValid = [expected[@"valid"] boolValue];
        NSUInteger displayRangeStart = [expected[@"displayRangeStart"] integerValue];
        NSUInteger displayRangeEnd = [expected[@"displayRangeEnd"] integerValue];
        NSUInteger validRangeStart = [expected[@"validRangeStart"] integerValue];
        NSUInteger validRangeEnd = [expected[@"validRangeEnd"] integerValue];

        XCTAssertEqual(results.weightedLength, weightedLength, @"Length should be the same in \"%@\"", testDescription);
        XCTAssertEqual(results.permillage, permillage, @"Permillage should be the same in \"%@\"", testDescription);
        XCTAssertEqual(results.isValid, isValid, @"Valid should be the samein \"%@\"", testDescription);
        XCTAssertEqual(results.displayTextRange.location, displayRangeStart, @"Display text range start should be the same in \"%@\"", testDescription);
        XCTAssertEqual(results.displayTextRange.length, displayRangeEnd - displayRangeStart + 1, @"Display text range length should be the same in \"%@\"", testDescription);
        XCTAssertEqual(results.validDisplayTextRange.location, validRangeStart, @"Valid text range start should be the same in \"%@\"", testDescription);
        XCTAssertEqual(results.validDisplayTextRange.length, validRangeEnd - validRangeStart + 1, @"Valid text range length should be the same in \"%@\"", testDescription);
    }
}
*/
    /// - (void)testUnicodePointTweetLengthCounting
    func testUnicodePointTweetLengthCounting() {
        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV2]];
        let parser = TwitterTextParser.setDefaultParser(with: TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV2)!)
        /// [self _testWeightedTweetsCountingWithTestSuite:@"WeightedTweetsCounterTest"];

    }

    /// - (void)testEmojiWeightedTweetLengthCounting
    func testEmojiWeightedTweetLengthCounting() {
        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3]];
        /// [self _testWeightedTweetsCountingWithTestSuite:@"WeightedTweetsWithDiscountedEmojiCounterTest"];
    }

    /// - (void)testEmojiWeightedTweetLengthCountingWithDiscountedUnicode9Emoji
    func testEmojiWeightedTweetLengthCountingWithDiscountedUnicode9Emoji() {
        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3]];
        /// [self _testWeightedTweetsCountingWithTestSuite:@"WeightedTweetsWithDiscountedUnicode9EmojiCounterTest"];
    }
/*
- (void)testEmojiWeightedTweetLengthCountingWithDiscountedUnicode10Emoji
{
    // TODO: drop-iOS-10: when dropping support for iOS 10, remove the #if, #endif and everything in between
    #if __IPHONE_11_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
    if (@available(iOS 11, *)) {
    } else {
        NSLog(@"Info: in iOS %@ -[NSString enumerateSubstringsInRange:options:usingBlock:] does not enumerate ranges correctly for Unicode 10; therefore, this test is being bypassed",
               [NSProcessInfo processInfo].operatingSystemVersionString);
        return;
    }
    #endif // #if __IPHONE_11_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
    [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3]];
    [self _testWeightedTweetsCountingWithTestSuite:@"WeightedTweetsWithDiscountedUnicode10EmojiCounterTest"];
}
*/
    /// - (void)testZeroWidthJoinerAndNonJoiner
    func testZeroWidthJoinerAndNonJoiner() {
        // This test is in the Objective-C code because the behavior seems to differ between
        // this implementation and other platforms.
        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3]];
        /// NSString *text = @"ZWJ: क्ष -> क्\u200Dष; ZWNJ: क्ष -> क्\u200Cष";
        let text = "ZWJ: क्ष -> क्\u{200d}ष; ZWNJ: क्ष -> क्\u{200c}ष"
        /// text = [self stringByParsingUnicodeEscapes:text];
        TwitterTextParser.setDefaultParser(with: TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV3)!)
        /// TwitterTextParseResults *results = [[TwitterTextParser defaultParser] parseTweet:text];
        let results = TwitterTextParser.defaultParser.parseTweet(text: text)
        /// XCTAssertEqual(results.weightedLength, 35);
        XCTAssertEqual(results.weightedLength, 35)
        /// XCTAssertEqual(results.permillage, 125);
        XCTAssertEqual(results.permillage, 125)
        /// XCTAssertEqual(results.isValid, YES);
        XCTAssertTrue(results.isValid)
        /// XCTAssertEqual(results.displayTextRange.location, 0);
        XCTAssertEqual(results.displayTextRange.location, 0)
        /// XCTAssertEqual(results.displayTextRange.length, 35);
        XCTAssertEqual(results.displayTextRange.length, 35)
        /// XCTAssertEqual(results.validDisplayTextRange.location, 0);
        XCTAssertEqual(results.validDisplayTextRange.location, 0)
        /// XCTAssertEqual(results.validDisplayTextRange.length, 35);
        XCTAssertEqual(results.validDisplayTextRange.length, 35)
    }

    /// - (void)testUnicodeDirectionalMarkerCounting
//    func testUnicodeDirectionalMarkerCounting() {
//        /// NSString *fileName = [[[self class] conformanceRootDirectory] stringByAppendingPathComponent:@"validate.json"];
//        let filename = conformanceRootDirectory.appendingPathComponent("validate.json")
//        /// NSData *data = [NSData dataWithContentsOfFile:fileName];
//        /// if (!data) {
//        ///    XCTFail(@"No test data: %@", fileName);
//        ///    return;
//        /// }
//        guard let data = try? Data(contentsOf: filename) else {
//            XCTFail("No test data: \(filename)")
//            return
//        }
//
//        /// NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//        /// if (!rootDic) {
//        ///    XCTFail(@"Invalid test data: %@", fileName);
//        ///    return;
//        /// }
//        struct Validate: Decodable{
//            struct Test: Decodable {
//                let description: String
//                let text: String
//                let expected: Any
//            }
//            var tests: [String: [Test]]
//        }
//        guard let validation = try? JSONDecoder().decode(Validate.self, from: data) else {
//            XCTFail("Invalid test data: \(filename)")
//            return
//        }
//
//        /// [TwitterTextParser setDefaultParserWithConfiguration:[TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV2]];
//        /// NSDictionary *tests = [rootDic objectForKey:@"tests"];
//        let tests = validation.tests
//        /// NSArray *lengths = [tests objectForKey:@"UnicodeDirectionalMarkerCounterTest"];
//        guard let lengths = tests["UnicodeDirectionalMarkerCounterTest"] else {
//            XCTFail()
//            return
//        }
//
//        /// for (NSDictionary *testCase in lengths) {
//        for testCase in lengths {
//        ///     NSString *text = [testCase objectForKey:@"text"];
//            var text = testCase.text
//        ///     text = [self stringByParsingUnicodeEscapes:text];
//
//        ///     NSDictionary *expected = [testCase objectForKey:@"expected"];
//            guard let expected = testCase.expected as? [String: Any] else {
//                XCTFail()
//                continue
//            }
//        ///     TwitterTextParseResults *results = [[TwitterTextParser defaultParser] parseTweet:text];
//            let results = TwitterTextParser.defaultParser.parseTweet(text)
//        ///     XCTAssertEqual(results.weightedLength, [expected[@"weightedLength"] integerValue], @"Length should be the same");
//            XCTAssertEqual(results.weightedLength, Int(expected["weightedLength"]), "Length should be the same")
//        ///     XCTAssertEqual(results.permillage, [expected[@"permillage"] integerValue], @"Permillage should be the same");
//            XCTAssertEqual(results.permillage, Int(expected["permillage"]), "Permillage should be the same")
//        ///     XCTAssertEqual(results.isValid, [expected[@"valid"] boolValue], @"Valid should be the same");
//            XCTAssertEqual(results.isValid, Bool(expected["valid"]), "Valid should be the same")
//        ///     XCTAssertEqual(results.displayTextRange.location, [expected[@"displayRangeStart"] integerValue], @"Display text range start should be the same");
//            XCTAssertEqual(results.displayTextRange.location, expected["displayRangeStart"], "Display text range start should be the same")
//        ///     XCTAssertEqual(results.displayTextRange.length, [expected[@"displayRangeEnd"] integerValue] - [expected[@"displayRangeStart"] integerValue] + 1, @"Display text range length should be the same");
//            XCTAssertEqual(results.displayTextRange.length, Int(expected["displayRangeEnd"]) - Int(expected["displayRangeStart"]) + 1, "Display text range length should be the same")
//        ///     XCTAssertEqual(results.validDisplayTextRange.location, [expected[@"validRangeStart"] integerValue], @"Valid text range start should be the same");
//            XCTAssertEqual(results.validDisplayTextRange.location, Int(expected["validRangeStart"]), "Valid text range start should be the same")
//        ///     XCTAssertEqual(results.validDisplayTextRange.length, [expected[@"validRangeEnd"] integerValue] - [expected[@"validRangeStart"] integerValue] + 1, @"Valid text range length should be the same");
//            XCTAssertEqual(results.validDisplayTextRange.length, Int(expected["validRangeEnd"]) - expected["validRangeStart"] + 1, "Valid text range length should be the same")
//        /// }
//        }
//    }

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
    /// - (void)testTwitterTextParserConfiguration
//    func testTwitterTextParserConfiguration() {
//        // NSString *configurationString = @"{\"version\": 1, \"maxWeightedTweetLength\": 280, \"scale\": 2, \"defaultWeight\": 1, \"transformedURLLength\": 23, \"ranges\": [{\"start\": 4352, \"end\": 4353, \"weight\": 2}]}";
//        let configurationString = "{\"version\": 1, \"maxWeightedTweetLength\": 280, \"scale\": 2, \"defaultWeight\": 1, \"transformedURLLength\": 23, \"ranges\": [{\"start\": 4352, \"end\": 4353, \"weight\": 2}]}"
//        /// TwitterTextConfiguration *configuration = [TwitterTextConfiguration configurationFromJSONString:configurationString];
//        guard let configuration = TwitterTextConfiguration.configuration(fromJSONString: configurationString) else {
//            XCTFail()
//            return
//        }
//
//        XCTAssertEqual(1, configuration.version)
//        XCTAssertEqual(1, configuration.defaultWeight)
//        XCTAssertEqual(23, configuration.transformedURLLength)
//        XCTAssertEqual(280, configuration.maxWeightedTweetLength)
//        XCTAssertEqual(2, configuration.scale)
//        /// TwitterTextWeightedRange *weightedRange = configuration.ranges[0];
//        let weightedRange = configuration.ranges[0]
//        XCTAssertEqual(4352, weightedRange.range.location);
//        XCTAssertEqual(1, weightedRange.range.length);
//        XCTAssertEqual(2, weightedRange.weight);
//    }

    /// - (void)testTwitterTextParserConfigurationV2ToV3Transition
    func testTwitterTextParserConfigurationV2ToV3Transition() {
        /// TwitterTextConfiguration *configurationV2 = [TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV2];
        /// TwitterTextConfiguration *configurationV3 = [TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3];
        guard let configurationV2 = TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV2),
              let configurationV3 = TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV3) else {
            XCTFail()
            return
        }

        /// XCTAssertEqual(configurationV2.defaultWeight, configurationV3.defaultWeight);
        XCTAssertEqual(configurationV2.defaultWeight, configurationV3.defaultWeight)
        /// XCTAssertEqual(configurationV2.transformedURLLength, configurationV3.transformedURLLength);
        XCTAssertEqual(configurationV2.transformedURLLength, configurationV2.transformedURLLength)
        /// XCTAssertEqual(configurationV2.maxWeightedTweetLength, configurationV3.maxWeightedTweetLength);
        XCTAssertEqual(configurationV2.maxWeightedTweetLength, configurationV3.maxWeightedTweetLength)
        /// XCTAssertEqual(configurationV2.scale, configurationV3.scale);
        XCTAssertEqual(configurationV2.scale, configurationV3.scale)

        /// for (NSUInteger i = 0; i < configurationV2.ranges.count; i++) {
        for index in 0..<configurationV2.ranges.count {
        ///     TwitterTextWeightedRange *weightedRangeV2 = configurationV2.ranges[i];
            let weightedRangeV2 = configurationV2.ranges[index]
        ///     TwitterTextWeightedRange *weightedRangeV3 = configurationV3.ranges[i];
            let weightedRangeV3 = configurationV3.ranges[index]
        ///     XCTAssertTrue(NSEqualRanges(weightedRangeV2.range, weightedRangeV3.range));
            XCTAssertTrue(NSEqualRanges(weightedRangeV2.range, weightedRangeV3.range))
        ///     XCTAssertEqual(weightedRangeV2.weight, weightedRangeV3.weight);
            XCTAssertEqual(weightedRangeV2.weight, weightedRangeV3.weight)
        /// }
        }
    }

    /// - (NSString *)stringByParsingUnicodeEscapes:(NSString *)string
    func stringByParsingUnicodeEscapes(string: String) -> String {
        var string = string

        /// static NSRegularExpression *regex = nil;
        var regex: NSRegularExpression? = nil
        /// if (!regex) {
        ///     regex = [[NSRegularExpression alloc] initWithPattern:@"\\\\U([0-9a-fA-F]{8}|[0-9a-fA-F]{4})" options:0 error:NULL];
        /// }
        if regex == nil {
            regex = try? NSRegularExpression.init(pattern: "\\\\U([0-9a-fA-F]{8}|[0-9a-fA-F]{4})", options: NSRegularExpression.Options(rawValue: 0))
        }

        /// NSUInteger index = 0;
        var index = 0
        /// while (index < string.length) {
        while index < string.count {
        ///     NSTextCheckingResult *result = [regex firstMatchInString:string options:0 range:NSMakeRange(index, string.length - index)];
        ///     if (!result) {
        ///         break;
        ///     }
            guard let result = regex?.firstMatch(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(index, string.count - index)) else {
                break
            }

        ///     NSRange patternRange = result.range;
            let patternRange = result.range
        ///     NSRange hexRange = [result rangeAtIndex:1];
            let hexRange = result.range(at: 1)
        ///     NSUInteger resultLength = 1;
            var resultLength = 1
        ///     if (hexRange.location != NSNotFound) {
            if hexRange.location != NSNotFound, let rHexRange = Range(hexRange, in: string) {
        ///         NSString *hexString = [string substringWithRange:hexRange];
                let hexString = String(string[rHexRange])
        ///         long value = strtol([hexString UTF8String], NULL, 16);
                let value = strtol(NSString(string: hexString).utf8String, nil, 16)
        ///         if (value < 0x10000) {
                if value < 0x10000 {
        ///             string = [string stringByReplacingCharactersInRange:patternRange withString:[NSString stringWithFormat:@"%C", (UniChar)value]];
                    string = string.replacingCharacters(in: Range(patternRange, in: string)!, with: String(unichar(value)))
        ///         } else {
                } else {
        ///             UniChar surrogates[2];
                    var surrogates: [unichar] = Array.init(repeating: unichar(), count: 2)
        ///             if (CFStringGetSurrogatePairForLongCharacter((UTF32Char)value, surrogates)) {
                    if CFStringGetSurrogatePairForLongCharacter(UTF32Char(value), &surrogates) {
        ///                 string = [string stringByReplacingCharactersInRange:patternRange withString:[NSString stringWithCharacters:surrogates length:2]];
                        guard let range = Range(patternRange, in: string) else {
                            break
                        }
                        string = string.replacingCharacters(in: range, with: String(NSString(characters: surrogates, length: 2)))
        ///                 resultLength = 2;
                        resultLength = 2
        ///             }
                    }
        ///         }
                }
        ///     }
            }
        ///     index = patternRange.location + resultLength;
            index = patternRange.location + resultLength
        /// }
        }

        /// return string;
        return string
    }

    /// + (NSString *)conformanceRootDirectory
    var conformanceRootDirectory: URL {
        /// NSString *sourceFilePath = [[NSString alloc] initWithCString:__FILE__ encoding:NSUTF8StringEncoding];
        /// return [[[sourceFilePath stringByDeletingLastPathComponent] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"tests/json-conformance"];
        return URL(fileURLWithPath: "__FILE__").deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("Tests/json-conformance")
    }
}
