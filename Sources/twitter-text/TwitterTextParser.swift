//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation

class TwitterTextParser {
    static let kTwitterTextParserConfigurationClassic = "v1"
    static let kTwitterTextParserConfigurationV2 = "v2"
    static let kTwitterTextParserConfigurationV3 = "v3"

    /// + (instancetype)defaultParser NS_SWIFT_NAME(defaultParser());
    /// dispatch_sync([self _queue], ^{
    ///     @autoreleasepool {
    ///         if (!sDefaultParser) {
    ///             TwitterTextConfiguration *configuration = [TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3];
    ///             sDefaultParser = [[TwitterTextParser alloc] initWithConfiguration:configuration];
    ///         }
    ///     }
    /// });
    /// return sDefaultParser;
    /// }

    /// + (void)setDefaultParserWithConfiguration:(TwitterTextConfiguration *)configuration {
    /// dispatch_async([self _queue], ^{
    ///     @autoreleasepool {
    ///         sDefaultParser = [[TwitterTextParser alloc] initWithConfiguration:configuration];
    ///     }
    /// });
    static var sDefaultParser: TwitterTextParser {
        let configuration = TwitterTextConfiguration.configuration(fromJSONResource: TwitterTextParser.kTwitterTextParserConfigurationV3)!
        return TwitterTextParser(withConfiguration: configuration)
    }

    /// @property (nonatomic, readonly) TwitterTextConfiguration *configuration;
    let configuration: TwitterTextConfiguration

    /// + (dispatch_queue_t)_queue
    static var queue: DispatchQueue {
        /// static dispatch_queue_t sQueue;
        /// static dispatch_once_t onceToken;
        /// dispatch_once(&onceToken, ^{
        ///     sQueue = dispatch_queue_create("twitterText", DISPATCH_QUEUE_SERIAL);
        /// });
        /// return sQueue;
        return DispatchQueue(label: "twitterText")
    }

    /// - (instancetype)initWithConfiguration:(TwitterTextConfiguration *)configuration;
    init(withConfiguration configuration: TwitterTextConfiguration) {
        /// if (self = [super init]) {
        ///     _configuration = configuration;
        /// }
        /// return self;
        self.configuration = configuration
    }

    /// - (TwitterTextParseResults *)parseTweet:(NSString *)text;
    func parseTweet(text: String) -> TwitterTextParseResults {
        /// // Use Unicode Normalization Form Canonical Composition
        /// NSString *normalizedText;
        var normalizedText: String
        /// NSUInteger normalizedTextLength;
        var normalizedTextLength: Int
        /// if (text.length != 0) {
        ///     normalizedText = [text precomposedStringWithCanonicalMapping];
        ///     normalizedTextLength = normalizedText.length;
        /// } else {
        ///     normalizedTextLength = 0;
        /// }
        if !text.isEmpty {
            normalizedText = text.precomposedStringWithCanonicalMapping
            normalizedTextLength = normalizedText.count
        } else {
            normalizedTextLength = 0
        }

        /// if (normalizedTextLength == 0) {
        ///     NSRange rangeZero = NSMakeRange(0, 0);
        ///     return [[TwitterTextParseResults alloc] initWithWeightedLength:0 permillage:0 valid:YES displayRange:rangeZero validRange:rangeZero];
        /// }
        if normalizedTextLength == 0 {
            let rangeZero: NSRange = NSMakeRange(0, 0)
            return TwitterTextParseResults(weightedLength: 0, permillage: 0, valid: true, displayRange: rangeZero, validRange: rangeZero)
        }

        /// const NSRange rangeNotFound = NSMakeRange(NSNotFound, NSNotFound);
        let rangeNotFound = NSMakeRange(NSNotFound, NSNotFound)

        /// // Build an map of ranges, assuming the original character count does not change after normalization
        /// const NSUInteger textLength = text.length;
        let textLength = text.count
// FIXME !!!
        /// NSRange textRanges[textLength], *ptr = textRanges;
        var textRanges: [NSRange]
        /// for (NSUInteger i = 0; i < textLength; i++) {
        ///     textRanges[i] = rangeNotFound;
        /// }
        for i in 0..<textLength {
            textRanges[i] = rangeNotFound
        }
        /// [self _tt_lengthOfText:text range:NSMakeRange(0, text.length) countingBlock:^NSInteger(NSInteger index, NSString *blockText, TwitterTextEntity *entity, NSString *substring) {
        let block = self.tt_length(ofText: text, range: NSMakeRange(0, text.count)) { index, blockText, entity, subscring -> Int in
        /// // entity.range.length can be > 1 for emoji, decomposed characters, etc.
        ///     for (NSInteger i = 0; i < entity.range.length; i++) {
                for i in 0..<entity.range.count {
        ///         if (index+i < textLength) {
        ///             ptr[index+i] = entity.range;
        ///         } else {
        ///             NSAssert(NO, @"index+i (%ld+%ld) greater than text.length (%lu) for text \"%@\"", (long)index, (long)i, (unsigned long)textLength, text);  // casts will be unnecessary when TwitterText is no longer built for 32-bit targets
        ///         }
                    if index + i < textLength {
                        ptr[index + i] = entity.range
                    } else {
                        assert(false, "index+i (\(index + i)) greater than text.count (\(txtLength)) for text \"\(text)\"")
                    }
        ///     }
                }
        ///     return index + entity.range.length;
            return index + entity.range.length
        /// }];
        }

        /// NSRange normalizedRanges[normalizedTextLength], *normalizedRangesPtr = normalizedRanges;
        let normalizedRanges[normalizedTextLength], normalizedRangesPtr = normalizedRanges
        /// for (NSUInteger i = 0; i < normalizedTextLength; i++) {
        ///     normalizedRangesPtr[i] = rangeNotFound;
        /// }
        for i in 0..<normalizedTextLength {
            normalizedRangesPtr[i] = rangeNotFound
        }

        /// __block NSInteger offset = 0;
        var offset = 0
        /// [self _tt_lengthOfText:normalizedText range:NSMakeRange(0, normalizedTextLength) countingBlock:^NSInteger(NSInteger composedCharIndex, NSString *blockText, TwitterTextEntity *entity, NSString *substring) {
        let countingBlock = self.tt_length(ofText: normalizedText, range: NSMakeRange(0, normalizedTextLength)) { composedCharIndex, blockText, entity, subscring -> Int in
        /// // map index of each composed char back to its pre-normalized index.
        ///     if (composedCharIndex+offset < textLength) {
            if composedCharIndex + offset < textLength {
        ///         NSRange originalRange = ptr[composedCharIndex+offset];
                let originalRange = ptr[composedCharIndex + offset]
        ///         for (NSInteger i = 0; i < entity.range.length; i++) {
        ///             normalizedRangesPtr[composedCharIndex+i] = originalRange;
        ///         }
                for i in 0..<entity.range.count {
                    normalizedRangesPtr[composedCharIndex + i] = originalRange
                }
        ///         if (originalRange.length > entity.range.length) {
        ///             offset += (originalRange.length - entity.range.length);
        ///         }
                if originalRange.count > entity.range.count {
                    offset += originalRange.count - entity.range.count
                }
        ///     } else {
        ///         NSAssert(NO, @"composedCharIndex+offset (%ld+%ld) greater than text.length (%lu) for text \"%@\"", (long)composedCharIndex, (long)offset, (unsigned long)textLength, text); // casts will be unnecessary when TwitterText is no longer /// built for 32-bit targets
        ///     }
            } else {
                assert(false, "composedCharIndex+offset (\(composedCharIndex + offset)) greater than text.count (\(text.count)) for text \"\(text)\"")
            }
        /// return composedCharIndex + entity.range.length;
            return composedCharIndex + entity.range.length
        /// }];
        }

        /// NSArray<TwitterTextEntity *> *urlEntities = [TwitterText URLsInText:normalizedText];
        let urlEntities = TwitterText.URLs(inText: normalizedText)

        /// __block BOOL isValid = YES;
        var isValid = true
        /// __block NSInteger weightedLength = 0;
        var weightedLength = 0
        /// __block NSInteger validStartIndex = NSNotFound, validEndIndex = NSNotFound;
        var validStartIndex = NSNotFound
        var validEndIndex = NSNotFound
        /// __block NSInteger displayStartIndex = NSNotFound, displayEndIndex = NSNotFound;
        var displayStartIndex = NSNotFound
        var displayEndIndex = NSNotFound

        /// TextUnitCounterBlock textUnitCountingBlock = ^NSInteger(NSInteger previousLength, NSString *blockText, TwitterTextEntity *entity, NSString *substring) {
        let textUnitCountingBlock: (_ previousLength: Int, _ blockText: String, _ entity: TwitterTextEntity, _ substring: String) -> Int = { previousLength, blockText, entity, substring in
        ///     NSRange range = entity.range;
            let range = entity.range
        ///     NSInteger updatedLength = previousLength;
            var updatedLength = previousLength
        ///     switch (entity.type) {
            switch entity.type {
        ///         case TwitterTextEntityURL:
        ///             updatedLength = previousLength + (self->_configuration.transformedURLLength * self->_configuration.scale);
        ///             break;
                case .TwitterTextEntityURL:
                    updatedLength = previousLength + self.configuration.transformedURLLength * self.configuration.scale
        ///         case TwitterTextEntityTweetEmojiChar:
        ///             updatedLength = previousLength + self.configuration.defaultWeight;
        ///             break;
                case .TwitterTextEntityTweetEmojiChar:
                    updatedLength = previousLength + self.configuration.defaultWeight
        ///         case TwitterTextEntityTweetChar:
        ///             updatedLength = previousLength + [self _tt_lengthOfWeightedChar:substring];
        ///             break;
                case .TwitterTextEntityTweetChar:
                    updatedLength = previousLength + self.tt_length(ofWeightedChar: substring)
        ///         case TwitterTextEntityScreenName:
        ///         case TwitterTextEntityHashtag:
        ///         case TwitterTextEntityListName:
        ///         case TwitterTextEntitySymbol:
        ///             // Do nothing for these entity types.
        ///             break;
        ///     }
            }
        ///     if (validStartIndex == NSNotFound) {
        ///         validStartIndex = range.location;
        ///     }
            if validStartIndex == NSNotFound {
                validStartIndex = range.location
            }
        ///     if (displayStartIndex == NSNotFound) {
        ///         displayStartIndex = range.location;
        ///     }
            if displayStartIndex == NSNotFound {
                displayStartIndex = range.location
            }
        ///     if (range.length > 0) {
        ///         displayEndIndex = NSMaxRange(range) - 1;
        ///     }
            if range.length > 0 {
                displayEndIndex = NSMaxRange(range) - 1
            }
        ///     if (range.location + range.length <= blockText.length) {
            if range.location + range.length <= blockText.count {
        ///         NSTextCheckingResult *invalidResult = [[TwitterText invalidCharacterRegexp] firstMatchInString:blockText options:0 range:range];
                let invalidResult = TwitterText.invalidCharacterRegexp.firstMatch(in: blockText, options: .init(rawValue: 0), range: range)
        ///         if (invalidResult) {
        ///             isValid = NO;
        ///         } else if (isValid && (updatedLength + weightedLength <= self.maxWeightedTweetLength * self->_configuration.scale)) {
        ///             validEndIndex = (range.length > 0) ? NSMaxRange(range) - 1 : range.location;
        ///         } else {
        ///             isValid = NO;
        ///         }
                if invalidResult != nil {
                    isValid = false
                } else if isValid && (updatedLength + weightedLength <= self.maxWeightedTweetLength() * self.configuration.scale) {
                    validEndIndex = (range.length > 0) ? NSMaxRange(range) - 1 : range.location
                } else {
                    isValid = false
                }
        ///     } else {
        ///         NSAssert(NO, @"range (%@) outside bounds of blockText.length (%lu) for blockText \"%@\"", NSStringFromRange(range), (unsigned long)blockText.length, blockText);
        ///         isValid = NO;
        ///     }
            } else {
                isValid = false
                assert(false, "range (\(NSStringFromRange(range))) outside of bounds of blockText.count (\(blockText.count) for blockText \"\(blockText)\"")
            }
        ///     return updatedLength;
            return updatedLength
        /// };
        }

        /// NSInteger textIndex = 0;
        var textIndex = 0
        /// for (TwitterTextEntity *urlEntity in urlEntities) {
        for urlEntity in urlEntities {
        ///     if (textIndex < urlEntity.range.location) {
        ///         weightedLength += [self _tt_lengthOfText:normalizedText range:NSMakeRange(textIndex, urlEntity.range.location - textIndex) countingBlock:textUnitCountingBlock];
        ///     }
            if textIndex < urlEntity.range.location {
                weightedLength += self.tt_length(ofText: normalizedText, range: NSMakeRange(textIndex, urlEntity.range.location - textIndex), countingBlock: textUnitCountingBlock)
            }
        ///     weightedLength += textUnitCountingBlock(0, normalizedText, urlEntity, [normalizedText substringWithRange:urlEntity.range]);
            weightedLength += textUnitCountingBlock(0, normalizedText, urlEntity, normalizedText.substring(with: (urlEntity.range))

        ///     textIndex = urlEntity.range.location + urlEntity.range.length;
            textIndex = urlEntity.range.location + urlEntity.range.length
        /// }
        }

        /// // handle trailing text
        /// weightedLength += [self _tt_lengthOfText:normalizedText range:NSMakeRange(textIndex, normalizedTextLength - textIndex) countingBlock:textUnitCountingBlock];
        weightedLength += self.tt_length(ofText: normalizedText, range: NSMakeRange(textIndex, normalizedTextLength - textLength), countingBlock: textUnitCountingBlock)

        /// NSAssert(!NSEqualRanges(normalizedRanges[displayStartIndex], rangeNotFound), @"displayStartIndex should map to existing index in original string");
        assert(!NSEqualRanges(normalizedRanges[displayStartIndex], rangeNotFound), "displayStartIndex should map to existing index in original string")
        /// NSAssert(!NSEqualRanges(normalizedRanges[displayEndIndex], rangeNotFound), @"displayEndIndex should map to existing index in original string");
        assert(!NSEqualRanges(normalizedRanges[displayEndIndex], rangeNotFound), "displayEndIndex should map to existing index in original string")
        /// NSAssert(!NSEqualRanges(normalizedRanges[validStartIndex], rangeNotFound), @"validStartIndex should map to existing index in original string");
        assert(!NSEqualRanges(normalizedRanges[validStartIndex], rangeNotFound), "validStartIndex should map to existing index in original string")
        /// NSAssert(!NSEqualRanges(normalizedRanges[validEndIndex], rangeNotFound), @"validEndIndex should map to existing index in original string");
        assert(!NSEqualRanges(normalizedRanges[validEndIndex], rangeNotFound), "validEndIndex should map to existing index in original string")

        /// if (displayStartIndex == NSNotFound) {
        ///     displayStartIndex = 0;
        /// }
        if displayStartIndex == NSNotFound {
            displayStartIndex = 0
        }
        /// if (displayEndIndex == NSNotFound) {
        ///     displayEndIndex = 0;
        /// }
        if displayEndIndex == NSNotFound {
            displayEndIndex = 0
        }
        /// if (validStartIndex == NSNotFound) {
        ///     validStartIndex = 0;
        /// }
        if validStartIndex == NSNotFound {
            validStartIndex = 0
        }
        /// if (validEndIndex == NSNotFound) {
        ///     validEndIndex = 0;
        /// }
        if validEndIndex == NSNotFound {
            validEndIndex = 0
        }

        /// NSRange displayRange = NSMakeRange(normalizedRanges[displayStartIndex].location, NSMaxRange(normalizedRanges[displayEndIndex]) - normalizedRanges[displayStartIndex].location);
        let displayRange = NSMakeRange(normalizedRanges[displayStartIndex].location, NSMaxRange(normalizedRanges[displayEndIndex]) - normalizedRanges[displayStartIndex].location)
        /// NSRange validRange = NSMakeRange(normalizedRanges[validStartIndex].location, NSMaxRange(normalizedRanges[validEndIndex]) - normalizedRanges[validStartIndex].location);
        let validRange = NSMakeRange(normalizedRanges[validStartIndex].location, NSMaxRange(normalizedRanges[validEndIndex]) - normalizedRanges[validStartIndex].location)

        /// NSInteger scaledWeightedLength = weightedLength / _configuration.scale;
        let scaledWeightedLength = weightedLength / configuration.scale
        /// NSInteger permillage = (NSInteger)(kPermillageScaleFactor * (scaledWeightedLength / (float)[self maxWeightedTweetLength]));
        let permillage = TwitterText.kPermillageScaleFactor * (scaledWeightedLength / self.maxWeightedTweetLength())
        /// return [[TwitterTextParseResults alloc] initWithWeightedLength:scaledWeightedLength permillage:permillage valid:isValid displayRange:displayRange validRange:validRange];
        return TwitterTextParseResults(weightedLength: weightedLength, permillage: permillage, valid: isValid, displayRange: displayRange, validRange: validRange)
    }

    /// - (NSInteger)maxWeightedTweetLength;
    func maxWeightedTweetLength() -> Int {
        /// return _configuration.maxWeightedTweetLength;
        return configuration.maxWeightedTweetLength
    }

    // MARK: - Private methods

    /// - (NSInteger)_tt_lengthOfText:(NSString *)text range:(NSRange)range countingBlock:(nonnull TextUnitCounterBlock)countingBlock
    private func tt_length(ofText text: String, range: NSRange, countingBlock: (Int) -> Int) -> Int {
    ///     __block NSInteger length = 0;
        var length = 0
///
    ///     NSMutableArray *emojiRanges = [[NSMutableArray alloc] init];
    ///     if (self.configuration.isEmojiParsingEnabled) {
    ///         // With emoji parsing enabled, we first find all emoji in the input text (so that we only
    ///         // have to match vs. the complex emoji regex once).
    ///         NSArray<NSTextCheckingResult *> *emojiMatches = [TwitterTextEmojiRegex() matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    ///         for (NSTextCheckingResult *match in emojiMatches) {
    ///             [emojiRanges addObject:[NSValue valueWithRange:match.range]];
    ///         }
    ///     }
///
    ///     if (range.location + range.length <= text.length) {
    ///         // TODO: drop-iOS-10: when dropping support for iOS 10, remove the #if, #endif and everything in between
    ///         #if __IPHONE_11_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
    ///         #if 0
    ///         // Unicode 10.0 isn't fully supported on iOS 10.
///
    ///         // e.g. on iOS 10, closure block arg of [NSString enumerateSubstringsInRange:options:usingBlock:]
    ///         // is called an "incorrect" number of times for some Unicode10 composed character sequences
///
    ///         // i.e. calling enumerateSubstringsInRange:options:usingBlock: on the string
///
    ///         @"🤪; 🧕; 🧕🏾; 🏴󠁧󠁢󠁥󠁮󠁧󠁿"
///
    ///         // results in the following values of `substringRange` and `substring` within the block
    ///         // and of the __block var `length` once the block is complete:
///
    ///         //  iOS 11 and above
///
    ///         substringRange = @"{1, 2}" , substring = @"🤪"
    ///         substringRange = @"{3, 1}" , substring = @";"
    ///         substringRange = @"{4, 1}" , substring = @" "
    ///         substringRange = @"{5, 2}" , substring = @"🧕"
    ///         substringRange = @"{7, 1}" , substring = @";"
    ///         substringRange = @"{8, 1}" , substring = @" "
    ///         substringRange = @"{9, 4}" , substring = @"🧕🏾"
    ///         substringRange = @"{13, 1}" , substring = @";"
    ///         substringRange = @"{14, 1}" , substring = @" "
    ///         substringRange = @"{15, 14}" , substring = @"🏴󠁧󠁢󠁥󠁮󠁧󠁿"
///
    ///         length = 15
///
    ///         //  iOS 10
///
    ///         substringRange = @"{1, 2}" , substring = @"🤪"
    ///         substringRange = @"{3, 1}" , substring = @";"
    ///         substringRange = @"{4, 1}" , substring = @" "
    ///         substringRange = @"{5, 2}" , substring = @"🧕"
    ///         substringRange = @"{7, 1}" , substring = @";"
    ///         substringRange = @"{8, 1}" , substring = @" "
    ///         substringRange = @"{9, 2}" , substring = @"🧕"
    ///         substringRange = @"{11, 2}" , substring = @"🏾"
    ///         substringRange = @"{13, 1}" , substring = @";"
    ///         substringRange = @"{14, 1}" , substring = @" "
    ///         substringRange = @"{15, 2}" , substring = @"🏴"
    ///         substringRange = @"{17, 2}" , substring = @"󠁧"
    ///         substringRange = @"{19, 2}" , substring = @"󠁢"
    ///         substringRange = @"{21, 2}" , substring = @"󠁥"
    ///         substringRange = @"{23, 2}" , substring = @"󠁮"
    ///         substringRange = @"{25, 2}" , substring = @"󠁧"
    ///         substringRange = @"{27, 2}" , substring = @"󠁿"
///
    ///         length = 29
///
    ///         #endif // #if 0
    ///         #endif // #if __IPHONE_11_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
    ///         [text enumerateSubstringsInRange:range options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
    ///          if (countingBlock != NULL) {
    ///          TwitterTextEntityType type = (self.configuration.isEmojiParsingEnabled && [emojiRanges containsObject:[NSValue valueWithRange:substringRange]]) ? TwitterTextEntityTweetEmojiChar : TwitterTextEntityTweetChar;
    ///          length = countingBlock(length, text, [TwitterTextEntity entityWithType:type range:substringRange], substring);
    ///          }
    ///          }];
    ///     } else {
    ///         NSAssert(NO, @"range (%@) outside bounds of text.length (%lu) for text \"%@\"", NSStringFromRange(range), (unsigned long)text.length, text);
    ///         length = text.length;
    ///     }
///
    ///     return length;
    /// }
    }

    /// - (NSInteger)_tt_lengthOfWeightedChar:(NSString *)text
    private func tt_length(ofWeightedChar text: String) -> Int {
    ///     NSInteger length = text.length;
    ///     if (length == 0) {
    ///         return 0;
    ///     }
///
    ///     UniChar buffer[length];
    ///     [text getCharacters:buffer range:NSMakeRange(0, length)];
///
    ///     NSInteger weightedLength = 0;
    ///     NSInteger codepointCount = 0;
    ///     UniChar *ptr = buffer;
    ///     for (NSUInteger i = 0; i < length; i++) {
    ///         __block NSInteger charWeight = _configuration.defaultWeight;
    ///         BOOL isSurrogatePair = (i + 1 < length && CFStringIsSurrogateHighCharacter(ptr[i]) && CFStringIsSurrogateLowCharacter(ptr[i+1]));
    ///         for (TwitterTextWeightedRange *weightedRange in _configuration.ranges) {
    ///             NSInteger begin = weightedRange.range.location;
    ///             NSInteger end = weightedRange.range.location + weightedRange.range.length;
///
    ///             if (isSurrogatePair) {
    ///                 UTF32Char char32 = CFStringGetLongCharacterForSurrogatePair(ptr[i], ptr[i+1]);
    ///                 if (char32 >= begin && char32 <= end) {
    ///                     charWeight = weightedRange.weight;
    ///                     break;
    ///                 }
    ///             } else if (ptr[i] >= begin && ptr[i] <= end) {
    ///                 charWeight = weightedRange.weight;
    ///                 break;
    ///             }
    ///         }
///
    ///         // skip the next char of the surrogate pair.
    ///         if (isSurrogatePair) {
    ///             i++;
    ///         }
///
    ///         codepointCount++;
///
    ///         weightedLength += charWeight;
    ///     }
///
    ///     return weightedLength;
    /// }
    }
}
