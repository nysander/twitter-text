//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation

class TwitterTextParser {
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

    /// + (instancetype)defaultParser NS_SWIFT_NAME(defaultParser());
    static var defaultParser: TwitterTextParser {
        /// dispatch_sync([self _queue], ^{
        ///     @autoreleasepool {
        ///         if (!sDefaultParser) {
        ///             TwitterTextConfiguration *configuration = [TwitterTextConfiguration configurationFromJSONResource:kTwitterTextParserConfigurationV3];
        ///             sDefaultParser = [[TwitterTextParser alloc] initWithConfiguration:configuration];
        ///         }
        ///     }
        /// });
        /// return sDefaultParser;
        let sDefaultParser: TwitterTextParser
        queue.sync {
            if !sDefaultParser {
                let configuration = TwitterTextConfiguration.configuration(fromJSONResource: kTwitterTextParserConfigurationV3)
                sDefaultParser = self.init(withConfiguration: configuration)
            }
        }
        return sDefaultParser
    }

    /// + (void)setDefaultParserWithConfiguration:(TwitterTextConfiguration *)configuration;
    static func setDefaultParser(withConfiguration configuration: TwitterTextConfiguration) {
        /// dispatch_async([self _queue], ^{
        ///     @autoreleasepool {
        ///         sDefaultParser = [[TwitterTextParser alloc] initWithConfiguration:configuration];
        ///     }
        /// });
        queue.async {
            sDefaultParser = TwitterTextParser(withConfiguration: configuration)
        }
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
            let rangeZero: Range<String.Index> = 0...0
            return TwitterTextParseResults(weightedLength: 0, permillage: 0, valid: true, displayRange: rangeZero, validRange: rangeZero)
        }

        /// const NSRange rangeNotFound = NSMakeRange(NSNotFound, NSNotFound);
        let rangeNotFound = NSMakeRange(NSNotFound, NSNotFound)

        /// // Build an map of ranges, assuming the original character count does not change after normalization
        /// const NSUInteger textLength = text.length;
        let textLength = text.count
        /// NSRange textRanges[textLength], *ptr = textRanges;
        var textRanges: [Int]
        /// for (NSUInteger i = 0; i < textLength; i++) {
        ///     textRanges[i] = rangeNotFound;
        /// }
        for i in 0..<textLength {
            textRanges[i] = rangeNotFound
        }
        /// [self _tt_lengthOfText:text range:NSMakeRange(0, text.length) countingBlock:^NSInteger(NSInteger index, NSString *blockText, TwitterTextEntity *entity, NSString *substring) {
        self.tt_length(ofText: text, range: NSMakeRange(0, text.count)) { index, blockText, entity, subscring -> Int in
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
        self.tt_length(ofText: normalizedText, range: NSMakeRange(0, normalizedTextLength)) { composedCharIndex, blockText, entity, subscring -> Int in
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
        /// __block NSInteger weightedLength = 0;
        /// __block NSInteger validStartIndex = NSNotFound, validEndIndex = NSNotFound;
        /// __block NSInteger displayStartIndex = NSNotFound, displayEndIndex = NSNotFound;
        /// TextUnitCounterBlock textUnitCountingBlock = ^NSInteger(NSInteger previousLength, NSString *blockText, TwitterTextEntity *entity, NSString *substring) {
        ///     NSRange range = entity.range;
        ///     NSInteger updatedLength = previousLength;
        ///     switch (entity.type) {
        ///         case TwitterTextEntityURL:
        ///             updatedLength = previousLength + (self->_configuration.transformedURLLength * self->_configuration.scale);
        ///             break;
        ///         case TwitterTextEntityTweetEmojiChar:
        ///             updatedLength = previousLength + self.configuration.defaultWeight;
        ///             break;
        ///         case TwitterTextEntityTweetChar:
        ///             updatedLength = previousLength + [self _tt_lengthOfWeightedChar:substring];
        ///             break;
        ///         case TwitterTextEntityScreenName:
        ///         case TwitterTextEntityHashtag:
        ///         case TwitterTextEntityListName:
        ///         case TwitterTextEntitySymbol:
        ///             // Do nothing for these entity types.
        ///             break;
        ///     }
        ///     if (validStartIndex == NSNotFound) {
        ///         validStartIndex = range.location;
        ///     }
        ///     if (displayStartIndex == NSNotFound) {
        ///         displayStartIndex = range.location;
        ///     }
        ///     if (range.length > 0) {
        ///         displayEndIndex = NSMaxRange(range) - 1;
        ///     }
        ///     if (range.location + range.length <= blockText.length) {
        ///         NSTextCheckingResult *invalidResult = [[TwitterText invalidCharacterRegexp] firstMatchInString:blockText options:0 range:range];
        ///         if (invalidResult) {
        ///             isValid = NO;
        ///         } else if (isValid && (updatedLength + weightedLength <= self.maxWeightedTweetLength * self->_configuration.scale)) {
        ///             validEndIndex = (range.length > 0) ? NSMaxRange(range) - 1 : range.location;
        ///         } else {
        ///             isValid = NO;
        ///         }
        ///     } else {
        ///         NSAssert(NO, @"range (%@) outside bounds of blockText.length (%lu) for blockText \"%@\"", NSStringFromRange(range), (unsigned long)blockText.length, blockText);
        ///         isValid = NO;
        ///     }
        ///     return updatedLength;
        /// };
///
        /// NSInteger textIndex = 0;
        var textIndex = 0
        /// for (TwitterTextEntity *urlEntity in urlEntities) {
        for urlEntity in urlEntities {
        ///     if (textIndex < urlEntity.range.location) {
        ///         weightedLength += [self _tt_lengthOfText:normalizedText range:NSMakeRange(textIndex, urlEntity.range.location - textIndex) countingBlock:textUnitCountingBlock];
        ///     }
            if textIndex < urlEntity.range.location {
                weightedLength += self.tt_length(ofText: normalizedText, range: NSMakeRange(textIndex, urlEntity.range.location - textIndex), countingBlock: )
            }
        ///     weightedLength += textUnitCountingBlock(0, normalizedText, urlEntity, [normalizedText substringWithRange:urlEntity.range]);
            weightedLength += textUnitCountingBlock(0, normalizedText, urlEntity, normalizedText.substring(with: urlEntity.range))
///
        ///     textIndex = urlEntity.range.location + urlEntity.range.length;
            textIndex = urlEntity.range.location + urlEntity.range.length
        /// }
        }
///
        /// // handle trailing text
        /// weightedLength += [self _tt_lengthOfText:normalizedText range:NSMakeRange(textIndex, normalizedTextLength - textIndex) countingBlock:textUnitCountingBlock];
        weightedLength += self.tt_length(ofText: normalizedText, range: NSMakeRange(textIndex, normalizedTextLength - textLength), countingBlock: textUnitCountingBlock)
///
        /// NSAssert(!NSEqualRanges(normalizedRanges[displayStartIndex], rangeNotFound), @"displayStartIndex should map to existing index in original string");
        /// NSAssert(!NSEqualRanges(normalizedRanges[displayEndIndex], rangeNotFound), @"displayEndIndex should map to existing index in original string");
        /// NSAssert(!NSEqualRanges(normalizedRanges[validStartIndex], rangeNotFound), @"validStartIndex should map to existing index in original string");
        /// NSAssert(!NSEqualRanges(normalizedRanges[validEndIndex], rangeNotFound), @"validEndIndex should map to existing index in original string");
///
        /// if (displayStartIndex == NSNotFound) {
        ///     displayStartIndex = 0;
        /// }
        /// if (displayEndIndex == NSNotFound) {
        ///     displayEndIndex = 0;
        /// }
        /// if (validStartIndex == NSNotFound) {
        ///     validStartIndex = 0;
        /// }
        /// if (validEndIndex == NSNotFound) {
        ///     validEndIndex = 0;
        /// }
///
        /// NSRange displayRange = NSMakeRange(normalizedRanges[displayStartIndex].location, NSMaxRange(normalizedRanges[displayEndIndex]) - normalizedRanges[displayStartIndex].location);
        /// NSRange validRange = NSMakeRange(normalizedRanges[validStartIndex].location, NSMaxRange(normalizedRanges[validEndIndex]) - normalizedRanges[validStartIndex].location);
///
        /// NSInteger scaledWeightedLength = weightedLength / _configuration.scale;
        /// NSInteger permillage = (NSInteger)(kPermillageScaleFactor * (scaledWeightedLength / (float)[self maxWeightedTweetLength]));
        /// return [[TwitterTextParseResults alloc] initWithWeightedLength:scaledWeightedLength permillage:permillage valid:isValid displayRange:displayRange validRange:validRange];
        return TwitterTextParseResults()
    }

    /// - (NSInteger)maxWeightedTweetLength;
    func maxWeightedTweetLength() -> Int {
        /// return _configuration.maxWeightedTweetLength;
        return configuration.maxWeightedTweetLength
    }
}
