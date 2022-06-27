//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation
import CoreFoundation

public class Parser {
    public static var defaultParser = Parser(with: Configuration.configuration(fromJSONResource: ConfigurationType.v3)!)

    public static func setDefaultParser(with configuration: Configuration) {
        defaultParser = Parser(with: configuration)
    }

    let configuration: Configuration

    static var queue: DispatchQueue {
        return DispatchQueue(label: "twitterText")
    }

    public init(with configuration: Configuration) {
        self.configuration = configuration
    }

    public func parseTweet(text: String) -> ParseResults {
        var normalizedText: String = ""
        var normalizedTextLength: Int

        if !text.isEmpty {
            normalizedText = text.precomposedStringWithCanonicalMapping
            normalizedTextLength = normalizedText.utf16.count
        } else {
            normalizedTextLength = 0
        }

        if normalizedTextLength == 0 {
            let rangeZero: NSRange = NSMakeRange(0, 0)
            return ParseResults(weightedLength: 0, permillage: 0, valid: true, displayRange: rangeZero, validRange: rangeZero)
        }

        let rangeNotFound = NSMakeRange(NSNotFound, NSNotFound)

        // Build an map of ranges, assuming the original character count does not change after normalization
        let textLength = text.utf16.count
        var textRanges: [NSRange] = Array(repeating: rangeNotFound, count: textLength)

        _ = self.length(of: text, range: NSMakeRange(0, text.utf16.count)) { index, blockText, entity, substring -> Int in
            for i in 0..<entity.range.length {
                if index + i < textLength {
                    textRanges[index + i] = entity.range
                } else {
                    assert(false, "index+i (\(index + i)) greater than text.count (\(textLength)) for text \"\(text)\"")
                }
            }

            return index + entity.range.length
        }

        var normalizedRanges: [NSRange] = Array.init(repeating: rangeNotFound, count: normalizedTextLength)
        var offset = 0

        _ = self.length(of: normalizedText, range: NSMakeRange(0, normalizedTextLength)) { composedCharIndex, blockText, entity, subscring -> Int in
            // map index of each composed char back to its pre-normalized index.
            if composedCharIndex + offset < textLength {
                let originalRange = textRanges[composedCharIndex + offset]

                for i in 0..<entity.range.length {
                    normalizedRanges[composedCharIndex + i] = originalRange
                }

                if originalRange.length > entity.range.length {
                    offset += originalRange.length - entity.range.length
                }
            } else {
                assert(false, "composedCharIndex+offset (\(composedCharIndex + offset)) greater than text.count (\(text.count)) for text \"\(text)\"")
            }

            return composedCharIndex + entity.range.length
        }

        let urlEntities = TwitterText.urls(in: normalizedText)

        var isValid = true
        var weightedLength = 0
        var validStartIndex = NSNotFound
        var validEndIndex = NSNotFound
        var displayStartIndex = NSNotFound
        var displayEndIndex = NSNotFound

        let textUnitCountingBlock: (_ previousLength: Int, _ blockText: String, _ entity: Entity, _ substring: String) -> Int = { previousLength, blockText, entity, substring in
            let range = entity.range
            var updatedLength = previousLength

            switch entity.type {
                case .url:
                    updatedLength = previousLength + self.configuration.transformedURLLength * self.configuration.scale
                case .tweetEmojiChar:
                    updatedLength = previousLength + self.configuration.defaultWeight
                case .tweetChar:
                    updatedLength = previousLength + self.length(ofWeightedChar: substring)
                // Do nothing for these entity types.
                case .screenName:
                    fallthrough
                case .hashtag:
                    fallthrough
                case .listname:
                    fallthrough
                case .symbol:
                    fallthrough
                default:
                    break
            }

            if validStartIndex == NSNotFound {
                validStartIndex = range.location
            }

            if displayStartIndex == NSNotFound {
                displayStartIndex = range.location
            }

            if range.length > 0 {
                displayEndIndex = NSMaxRange(range) - 1
            }

            if range.location + range.length <= blockText.utf16.count {
                let invalidResult = TwitterText.invalidCharacterRegexp?.firstMatch(in: blockText, options: [], range: range)

                if invalidResult != nil {
                    isValid = false
                } else if isValid && (updatedLength + weightedLength <= self.maxWeightedTweetLength() * self.configuration.scale) {
                    validEndIndex = (range.length > 0) ? NSMaxRange(range) - 1 : range.location
                } else {
                    isValid = false
                }
            } else {
                isValid = false
                assert(false, "range (\(NSStringFromRange(range))) outside of bounds of blockText.count (\(blockText.count) for blockText \"\(blockText)\"")
            }

            return updatedLength
        }

        var textIndex = 0

        for urlEntity in urlEntities {
            if textIndex < urlEntity.range.location {
                weightedLength += self.length(of: normalizedText, range: NSMakeRange(textIndex, urlEntity.range.location - textIndex), countingBlock: textUnitCountingBlock)
            }
            guard let entityRange = Range(urlEntity.range, in: normalizedText) else {
                break
            }
            weightedLength += textUnitCountingBlock(0, normalizedText, urlEntity, String(normalizedText[entityRange]))

            textIndex = urlEntity.range.location + urlEntity.range.length
        }


        // handle trailing text
        weightedLength += self.length(of: normalizedText, range: NSMakeRange(textIndex, normalizedTextLength - textIndex), countingBlock: textUnitCountingBlock)

        assert(!NSEqualRanges(normalizedRanges[displayStartIndex], rangeNotFound),
               "displayStartIndex should map to existing index in original string")
        assert(!NSEqualRanges(normalizedRanges[displayEndIndex], rangeNotFound),
               "displayEndIndex should map to existing index in original string")
        assert(!NSEqualRanges(normalizedRanges[validStartIndex], rangeNotFound),
               "validStartIndex should map to existing index in original string")
        assert(!NSEqualRanges(normalizedRanges[validEndIndex], rangeNotFound),
               "validEndIndex should map to existing index in original string")

        if displayStartIndex == NSNotFound {
            displayStartIndex = 0
        }
        if displayEndIndex == NSNotFound {
            displayEndIndex = 0
        }
        if validStartIndex == NSNotFound {
            validStartIndex = 0
        }
        if validEndIndex == NSNotFound {
            validEndIndex = 0
        }

        let displayRange = NSMakeRange(normalizedRanges[displayStartIndex].location,
                                       NSMaxRange(normalizedRanges[displayEndIndex]) - normalizedRanges[displayStartIndex].location)
        let validRange = NSMakeRange(normalizedRanges[validStartIndex].location,
                                     NSMaxRange(normalizedRanges[validEndIndex]) - normalizedRanges[validStartIndex].location)
        let scaledWeightedLength = weightedLength / configuration.scale
        let permillage = TwitterText.permillageScaleFactor * scaledWeightedLength / self.maxWeightedTweetLength()

        return ParseResults(weightedLength: scaledWeightedLength, permillage: permillage, valid: isValid, displayRange: displayRange, validRange: validRange)
    }

    public func maxWeightedTweetLength() -> Int {
        return configuration.maxWeightedTweetLength
    }

    // MARK: - Private methods

    private func length(of text: String, range: NSRange, countingBlock: @escaping (Int, String, Entity, String) -> Int) -> Int {
        var length = 0
        var emojiRanges: [NSRange] = []

            // TODO: How to handle this?
        if self.configuration.emojiParsingEnabled {
            if let emojiRegexp = try? NSRegularExpression(pattern: Regexp.emojiPattern, options: []) {
                let emojiMatches = emojiRegexp.matches(in: text, options: [], range: range)

                for match in emojiMatches {
                    emojiRanges.append(match.range)
                }
            }
        }

        if range.location + range.length <= text.utf16.count {
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
            let textString = text as NSString
            textString.enumerateSubstrings(in: range, options: .byComposedCharacterSequences) { (substring, substringRange, enclosingRange, stop) in
                let type = (self.configuration.emojiParsingEnabled && emojiRanges.contains(substringRange)) ? EntityType.tweetEmojiChar : EntityType.tweetChar
                length = countingBlock(length, textString as String, Entity.init(withType: type, range: substringRange), substring!)
            }
        } else {
            assert(false, "range (\(NSStringFromRange(range))) outside bounds of text.count (\(text.count)) for text \"\(text)\"")
            length = text.count
        }

        return length
    }

    private func length(ofWeightedChar text: String) -> Int {
        let length = text.utf16.count

        if length == 0 {
            return 0
        }

        var buffer = Array(repeating: UniChar(), count: length)
        NSString(string: text).getCharacters(&buffer, range: NSMakeRange(0, length))

        var weightedLength = 0
        var codepointCount = 0

        for index in 0..<length {
            var charWeight = configuration.defaultWeight
            let isSurrogatePair = index + 1 < length && CFStringIsSurrogateHighCharacter(buffer[index]) && CFStringIsSurrogateLowCharacter(buffer[index + 1])

            for weightedRange in configuration.ranges {
                let begin = weightedRange.range.location
                let end = weightedRange.range.location + weightedRange.range.length

                if isSurrogatePair {
                    let char32 = CFStringGetLongCharacterForSurrogatePair(buffer[index], buffer[index+1])

                    if char32 >= begin && char32 <= end {
                        charWeight = weightedRange.weight
                        break
                    }
                } else if buffer[index] >= begin && buffer[index] <= end {
                    charWeight = weightedRange.weight
                    break
                }
            }

            // skip the next char of the surrogate pair.
            if isSurrogatePair {
                continue
            }

            codepointCount += 1
            weightedLength += charWeight
        }

        return weightedLength
    }
}
