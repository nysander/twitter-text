//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation
import UnicodeURL

/// @interface TwitterText : NSObject
public class TwitterText {
    static let kMaxURLLength = 4096;
    static let kMaxTCOSlugLength = 40;
    static let kMaxTweetLengthLegacy = 140;
    static let kTransformedURLLength = 23;
    static let kPermillageScaleFactor = 1000;

    /// The backend adds http:// for normal links and https to *.twitter.com URLs
    /// (it also rewrites http to https for URLs matching *.twitter.com).
    /// We always add https://. By making the assumption that kURLProtocolLength
    /// is https, the trade off is we'll disallow a http URL that is 4096 characters.
    static let kURLProtocolLength = 8

    /// + (NSArray<TwitterTextEntity *> *)entitiesInText:(NSString *)text;
    public static func entities(inText text: String) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity] = []

        /// NSArray<TwitterTextEntity *> *urls = [self URLsInText:text];
        let urls = self.URLs(inText: text)

        /// [results addObjectsFromArray:urls];
        results.append(contentsOf: urls)

        /// NSArray<TwitterTextEntity *> *hashtags = [self hashtagsInText:text withURLEntities:urls];
        let hashtags = self.hashtags(inText: text, withURLEntities: urls)
        /// [results addObjectsFromArray:hashtags];
        results.append(contentsOf: hashtags)

        /// NSArray<TwitterTextEntity *> *symbols = [self symbolsInText:text withURLEntities:urls];
        let symbols = self.symbols(inText: text, withURLEntities: urls)
        /// [results addObjectsFromArray:symbols];
        results.append(contentsOf: symbols)

        /// NSArray<TwitterTextEntity *> *mentionsAndLists = [self mentionsOrListsInText:text];
        let mentionsAndLists = mentionsOrLists(inText: text)

        /// NSMutableArray<TwitterTextEntity *> *addingItems = [NSMutableArray<TwitterTextEntity *> array];
        var addingItems: [TwitterTextEntity] = []

        /// for (TwitterTextEntity *entity in mentionsAndLists) {
        ///     NSRange entityRange = entity.range;
        ///     BOOL found = NO;
        ///     for (TwitterTextEntity *existingEntity in results) {
        ///         if (NSIntersectionRange(existingEntity.range, entityRange).length > 0) {
        ///             found = YES;
        ///             break;
        ///         }
        ///     }
        ///     if (!found) {
        ///         [addingItems addObject:entity];
        ///     }
        /// }
        for entity in mentionsAndLists {
            let entityRange = entity.range
            var found = false
            for existingEntity in results {
                if NSIntersectionRange(existingEntity.range, entityRange).length > 0 {
                    found = true
                    break
                }
            }
            if !found {
                addingItems.append(entity)
            }
        }

        /// [results addObjectsFromArray:addingItems];
        results.append(contentsOf: addingItems)
        /// [results sortUsingSelector:@selector(compare:)];

        /// return results;
        return results
    }

    /// + (NSArray<TwitterTextEntity *> *)URLsInText:(NSString *)text;
    public static func URLs(inText text: String) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity] = []
        /// NSUInteger len = text.length;
        let len = text.count

        /// NSUInteger position = 0;
        var position = 0
        /// NSRange allRange = NSMakeRange(0, 0);
        var allRange = NSMakeRange(0, 0)

        /// while (1) {
        while true {
        ///     position = NSMaxRange(allRange);
            position = NSMaxRange(allRange)
        ///     if (len <= position) {
        ///         break;
        ///     }
            if len <= position {
                break
            }

        ///     NSTextCheckingResult *urlResult = [[self validURLRegexp] firstMatchInString:text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(position, len - position)];
        ///     if (!urlResult) {
        ///         break;
        ///     }
            guard let urlResult = self.validURLRegexp.firstMatch(in: text, options: .withoutAnchoringBounds, range: NSMakeRange(position, len - position)) else {
                break
            }

        ///     allRange = urlResult.range;
            allRange = urlResult.range
        ///     if (urlResult.numberOfRanges < 9) {
        ///         // Continue processing after the end of this invalid result.
        ///         continue;
        ///     }
            if urlResult.numberOfRanges < 9 {
                continue
            }

        ///     NSRange urlRange = [urlResult rangeAtIndex:TWUValidURLGroupURL];
            let urlRange = urlResult.range(at: TWUValidURLGroup.TWUValidURLGroupURL.rawValue)
        ///     NSRange precedingRange = [urlResult rangeAtIndex:TWUValidURLGroupPreceding];
            let precedingRange = urlResult.range(at: TWUValidURLGroup.TWUValidURLGroupPreceding.rawValue)
        ///     NSRange protocolRange = [urlResult rangeAtIndex:TWUValidURLGroupProtocol];
            let protocolRange = urlResult.range(at: TWUValidURLGroup.TWUValidURLGroupProtocol.rawValue)
        ///     NSRange domainRange = [urlResult rangeAtIndex:TWUValidURLGroupDomain];
            let domainRange = urlResult.range(at: TWUValidURLGroup.TWUValidURLGroupDomain.rawValue)

        ///     NSString *protocol = (protocolRange.location != NSNotFound) ? [text substringWithRange:protocolRange] : nil;
            let protocolStr = protocolRange.location != NSNotFound ? NSString(string: text).substring(with: protocolRange) : nil
        ///     if (protocol.length == 0) {
            if let protocolStr = protocolStr, protocolStr.count == 0 {
        ///         NSString *preceding = (precedingRange.location != NSNotFound) ? [text substringWithRange:precedingRange] : nil;
                let preceding = precedingRange.location != NSNotFound ? NSString(string: text).substring(with: precedingRange) : nil
        ///         NSRange suffixRange = [preceding rangeOfCharacterFromSet:[self invalidURLWithoutProtocolPrecedingCharSet] options:NSBackwardsSearch | NSAnchoredSearch];

                let suffixRange = NSRange((preceding?.rangeOfCharacter(from: self.invalidURLWithoutProtocolPrecedingCharSet))!, in: preceding!)
        ///         if (suffixRange.location != NSNotFound) {
        ///             continue;
        ///         }
                if suffixRange.location != NSNotFound {
                    continue
                }
        ///     }
            }
            let r = Range(urlResult.range, in: text)
        ///     NSString *url = (urlRange.location != NSNotFound) ? [text substringWithRange:urlRange] : nil;
            var url = urlRange.location != NSNotFound ? text.substring(with: r!) : nil
        ///     NSString *host = (domainRange.location != NSNotFound) ? [text substringWithRange:domainRange] : nil;
            let host = domainRange.location != NSNotFound ? text.substring(with: Range(domainRange, in: text)!) : nil

        ///     NSInteger start = urlRange.location;
            let start = urlRange.location
        ///     NSInteger end = NSMaxRange(urlRange);
            var end = NSMaxRange(urlRange)

        ///     NSTextCheckingResult *tcoResult = url ? [[self validTCOURLRegexp] firstMatchInString:url options:0 range:NSMakeRange(0, url.length)] : nil;
            let tcoResult: NSTextCheckingResult?
            if let url = url {
                tcoResult = self.validTCOURLRegexp.firstMatch(in: url, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, url.count))
            } else {
                tcoResult = nil
            }
        ///     if (tcoResult && tcoResult.numberOfRanges >= 2) {
            if let tcoResult = tcoResult, tcoResult.numberOfRanges >= 2 {
        ///         NSRange tcoRange = [tcoResult rangeAtIndex:0];
                let tcoRange = tcoResult.range(at: 0)
        ///         NSRange tcoUrlSlugRange = [tcoResult rangeAtIndex:1];
                let tcoUrlSlugRange = tcoResult.range(at: 0)
        ///         if (tcoRange.location == NSNotFound || tcoUrlSlugRange.location == NSNotFound) {
        ///             continue;
        ///         }
                if tcoRange.location == NSNotFound || tcoUrlSlugRange.location == NSNotFound {
                    continue
                }
        ///         NSString *tcoUrlSlug = [text substringWithRange:tcoUrlSlugRange];
                let tcoUrlSlug = text.substring(with: Range(tcoUrlSlugRange, in: text)!)
        ///         // In the case of t.co URLs, don't allow additional path characters and ensure that the slug is under 40 chars.
        ///         if ([tcoUrlSlug length] > kMaxTCOSlugLength) {
        ///             continue;
        ///         } else {
        ///             url = [url substringWithRange:tcoRange];
        ///             end = start + url.length;
        ///         }
                if tcoUrlSlug.count > TwitterText.kMaxTCOSlugLength {
                    continue
                } else {
                    url = url?.substring(with: Range(tcoRange, in: url!)!)
                    end = start + url!.count
                }
        ///     }
            }
        ///     if ([self isValidHostAndLength:url.length protocol:protocol host:host]) {
            if isValidHostAndLength(urlLength: url!.count, urlProtocol: protocolStr, host: host) {
        ///         TwitterTextEntity *entity = [TwitterTextEntity entityWithType:TwitterTextEntityURL range:NSMakeRange(start, end - start)];
                let entity = TwitterTextEntity(withType: .TwitterTextEntityURL, range: NSMakeRange(start, end - start))
                ///         [results addObject:entity];
                results.append(entity)
        ///         allRange = entity.range;
                allRange = entity.range
        ///     }
            }
        /// }
        }

        /// return results;
        return results
    }

    /// + (NSArray<TwitterTextEntity *> *)hashtagsInText:(NSString *)text checkingURLOverlap:(BOOL)checkingURLOverlap;
    public static func hashtags(inText text: String, checkingURLOverlap: Bool) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSArray<TwitterTextEntity *> *urls = nil;
        var urls: [TwitterTextEntity] = []
        /// if (checkingURLOverlap) {
        ///     urls = [self URLsInText:text];
        /// }
        if checkingURLOverlap {
            urls = self.URLs(inText: text)
        }

        /// return [self hashtagsInText:text withURLEntities:urls];
        return self.hashtags(inText: text, withURLEntities: urls)
    }

    /// + (NSArray<TwitterTextEntity *> *)hashtagsInText:(NSString *)text withURLEntities:(NSArray<TwitterTextEntity *> *)urlEntities
    static func hashtags(inText text: String, withURLEntities urlEntities: [TwitterTextEntity]) -> [TwitterTextEntity] {
        /// if (!text.length) {
        /// return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity] = []
        /// NSUInteger len = text.length;
        let len = text.count
        /// NSUInteger position = 0;
        var position = 0

        /// while (1) {
        while true {
            /// NSTextCheckingResult *matchResult = [[self validHashtagRegexp] firstMatchInString:text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(position, len - position)];
            let matchResult = self.validHashtagRegexp.firstMatch(in: text, options: .withoutAnchoringBounds, range: NSMakeRange(position, len - position))
            /// if (!matchResult || matchResult.numberOfRanges < 2) {
            ///     break;
            /// }
            guard let result = matchResult, result.numberOfRanges < 2 else {
                break
            }

            /// NSRange hashtagRange = [matchResult rangeAtIndex:1];
            let hashtagRange = result.range(at: 1)
            /// BOOL matchOk = YES;
            var matchOk = true

            /// // Check URL overlap
            /// for (TwitterTextEntity *urlEntity in urlEntities) {
            ///     if (NSIntersectionRange(urlEntity.range, hashtagRange).length > 0) {
            ///         matchOk = NO;
            ///     break;
            ///     }
            /// }
            for urlEntity in urlEntities {
                if NSIntersectionRange(urlEntity.range, hashtagRange).length > 0 {
                    matchOk = false
                    break
                }
            }

            /// if (matchOk) {
            /// NSUInteger afterStart = NSMaxRange(hashtagRange);
            /// if (afterStart < len) {
            /// NSRange endMatchRange = [[self endHashtagRegexp] rangeOfFirstMatchInString:text options:0 range:NSMakeRange(afterStart, len - afterStart)];
            /// if (endMatchRange.location != NSNotFound) {
            /// matchOk = NO;
            /// }
            /// }
            if matchOk {
                let afterStart = NSMaxRange(hashtagRange)
                if afterStart < len {
                    let endMatchRange = self.endHashtagRegexp.rangeOfFirstMatch(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(afterStart, len - afterStart))
                    if endMatchRange.location != NSNotFound {
                        matchOk = false
                    }
                }

                /// if (matchOk) {
                /// TwitterTextEntity *entity = [TwitterTextEntity entityWithType:TwitterTextEntityHashtag range:hashtagRange];
                /// [results addObject:entity];
                /// }
                /// }
                if matchOk {
                    let entity = TwitterTextEntity(withType: .TwitterTextEntityHashtag, range: hashtagRange)
                    results.append(entity)
                }
            }
            /// position = NSMaxRange(matchResult.range);
            position = NSMaxRange(result.range)
            /// }
        }

        /// return results;
        return results
    }

    /// + (NSArray<TwitterTextEntity *> *)symbolsInText:(NSString *)text checkingURLOverlap:(BOOL)checkingURLOverlap;
    public static func symbols(inText text: String, checkingURLOverlap: Bool) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSArray<TwitterTextEntity *> *urls = nil;
        /// if (checkingURLOverlap) {
        ///     urls = [self URLsInText:text];
        /// }
        var urls: [TwitterTextEntity] = []
        if checkingURLOverlap {
            urls = self.URLs(inText: text)
        }

        /// return [self symbolsInText:text withURLEntities:urls];
        return symbols(inText: text, withURLEntities: urls)
    }

    /// + (NSArray<TwitterTextEntity *> *)symbolsInText:(NSString *)text withURLEntities:(NSArray<TwitterTextEntity *> *)urlEntities
    static func symbols(inText text: String, withURLEntities urlEntities: [TwitterTextEntity]) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity] = []
        /// NSUInteger len = text.length;
        let len = text.count
        /// NSUInteger position = 0;
        var position = 0

        /// while (1) {
        while true {
            ///     NSTextCheckingResult *matchResult = [[self validSymbolRegexp] firstMatchInString:text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(position, len - position)];
            let matchResult = self.validSymbolRegexp.firstMatch(in: text, options: .withoutAnchoringBounds, range: NSMakeRange(position, len - position))
            ///     if (!matchResult || matchResult.numberOfRanges < 2) {
            ///         break;
            ///     }
            guard let result = matchResult, result.numberOfRanges < 2 else {
                break
            }

            ///     NSRange symbolRange = [matchResult rangeAtIndex:1];
            let symbolRange = result.range(at: 1)
            ///     BOOL matchOk = YES;
            var matchOk = true

            ///     // Check URL overlap
            ///     for (TwitterTextEntity *urlEntity in urlEntities) {
            ///         if (NSIntersectionRange(urlEntity.range, symbolRange).length > 0) {
            ///             matchOk = NO;
            ///             break;
            ///         }
            ///     }
            for urlEntity in urlEntities {
                if NSIntersectionRange(urlEntity.range, symbolRange).length > 0 {
                    matchOk = false
                    break
                }
            }

            ///     if (matchOk) {
            ///         TwitterTextEntity *entity = [TwitterTextEntity entityWithType:TwitterTextEntitySymbol range:symbolRange];
            ///         [results addObject:entity];
            ///     }
            if matchOk {
                let entity = TwitterTextEntity(withType: .TwitterTextEntitySymbol, range: symbolRange)
                results.append(entity)
            }

            ///     position = NSMaxRange(matchResult.range);
            position = NSMaxRange(result.range)
            /// }
        }

        /// return results;
        return results
    }

    /// + (NSArray<TwitterTextEntity *> *)mentionedScreenNamesInText:(NSString *)text;
    public static func mentionedScreenNames(inText text: String) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSArray<TwitterTextEntity *> *mentionsOrLists = [self mentionsOrListsInText:text];
        let mentionsOrLists = self.mentionsOrLists(inText: text)
        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity] = []

        /// for (TwitterTextEntity *entity in mentionsOrLists) {
        ///     if (entity.type == TwitterTextEntityScreenName) {
        ///         [results addObject:entity];
        ///     }
        /// }
        for entity in mentionsOrLists {
            if entity.type == .TwitterTextEntityScreenName {
                results.append(entity)
            }
        }

        /// return results;
        return results
    }

    /// + (NSArray<TwitterTextEntity *> *)mentionsOrListsInText:(NSString *)text;
    public static func mentionsOrLists(inText text: String) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity] = []
        /// NSUInteger len = text.length;
        let len = text.count
        /// NSUInteger position = 0;
        var position = 0

        /// while (1) {
        while true {
            ///     NSTextCheckingResult *matchResult = [[self validMentionOrListRegexp] firstMatchInString:text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(position, len - position)];
            let matchResult = self.validMentionOrListRegexp.firstMatch(in: text, options: .withoutAnchoringBounds, range: NSMakeRange(position, len - position))
            ///     if (!matchResult || matchResult.numberOfRanges < 5) {
            ///         break;
            ///     }
            guard let result = matchResult, result.numberOfRanges < 5 else {
                break
            }

            ///     NSRange allRange = matchResult.range;
            let allRange = result.range
            ///     NSUInteger end = NSMaxRange(allRange);
            var end = NSMaxRange(allRange)

            ///     NSRange endMentionRange = [[self endMentionRegexp] rangeOfFirstMatchInString:text options:0 range:NSMakeRange(end, len - end)];
            let endMentionRange = self.endMentionRegexp.rangeOfFirstMatch(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(end, len - end))
            ///     if (endMentionRange.location == NSNotFound) {
            if endMentionRange.location == NSNotFound {
                ///         NSRange atSignRange = [matchResult rangeAtIndex:2];
                ///         NSRange screenNameRange = [matchResult rangeAtIndex:3];
                ///         NSRange listNameRange = [matchResult rangeAtIndex:4];
                let atSignRange = result.range(at: 2)
                let screenNameRange = result.range(at: 3)
                let listNameRange = result.range(at: 4)
                ///         if (listNameRange.location == NSNotFound) {
                ///             TwitterTextEntity *entity = [TwitterTextEntity entityWithType:TwitterTextEntityScreenName range:NSMakeRange(atSignRange.location, NSMaxRange(screenNameRange) - atSignRange.location)];
                ///             [results addObject:entity];
                ///         } else {
                ///             TwitterTextEntity *entity = [TwitterTextEntity entityWithType:TwitterTextEntityListName range:NSMakeRange(atSignRange.location, NSMaxRange(listNameRange) - atSignRange.location)];
                ///             [results addObject:entity];
                ///         }
                if listNameRange.location == NSNotFound {
                    let entity = TwitterTextEntity(withType: .TwitterTextEntityScreenName, range: NSMakeRange(atSignRange.location, NSMaxRange(screenNameRange) - atSignRange.location))
                    results.append(entity)
                } else {
                    let entity = TwitterTextEntity(withType: .TwitterTextEntityListName, range: NSMakeRange(atSignRange.location, NSMaxRange(listNameRange) - atSignRange.location))
                    results.append(entity)
                }
                ///     } else {
                ///         // Avoid matching the second username in @username@username
                ///         end++;
                ///     }
            } else {
                end += 1
            }

            ///     position = end;
            position = end
            /// }
        }

        /// return results;
        return results
    }

    /// + (nullable TwitterTextEntity *)repliedScreenNameInText:(NSString *)text;
    public static func repliedScreenName(inText text: String) -> TwitterTextEntity? {
        /// if (!text.length) {
        ///     return nil;
        /// }
        if text.isEmpty {
            return nil
        }
        /// NSUInteger len = text.length;
        let len = text.count

        /// NSTextCheckingResult *matchResult = [[self validReplyRegexp] firstMatchInString:text options:(NSMatchingWithoutAnchoringBounds | NSMatchingAnchored) range:NSMakeRange(0, len)];
        let matchResult = self.validReplyRegexp.firstMatch(in: text, options: .withoutAnchoringBounds, range: NSMakeRange(0, len))
        /// if (!matchResult || matchResult.numberOfRanges < 2) {
        ///     return nil;
        /// }
        guard let result =  matchResult, result.numberOfRanges < 2 else {
            return nil
        }

        /// NSRange replyRange = [matchResult rangeAtIndex:1];
        let replyRange = result.range(at: 1)
        /// NSUInteger replyEnd = NSMaxRange(replyRange);
        let replyEnd = NSMaxRange(replyRange)

        /// NSRange endMentionRange = [[self endMentionRegexp] rangeOfFirstMatchInString:text options:0 range:NSMakeRange(replyEnd, len - replyEnd)];
        let endMentionRange = self.endMentionRegexp.rangeOfFirstMatch(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(replyEnd, len - replyEnd))
        /// if (endMentionRange.location != NSNotFound) {
        ///     return nil;
        /// }
        if endMentionRange.location != NSNotFound {
            return nil
        }
        ///
        /// return [TwitterTextEntity entityWithType:TwitterTextEntityScreenName range:replyRange];
        return TwitterTextEntity(withType: .TwitterTextEntityScreenName, range: replyRange)
    }


    /// + (NSCharacterSet *)validHashtagBoundaryCharacterSet;
    public static func validHashtagBoundaryCharacterSet() -> CharacterSet {
        /// static NSCharacterSet *charset;
//        var charset: CharacterSet
        /// static dispatch_once_t onceToken;
        /// dispatch_once(&onceToken, ^{
        /// // Generate equivalent character set matched by TWUHashtagBoundaryInvalidChars regex and invert
        /// NSMutableCharacterSet *set = [NSMutableCharacterSet letterCharacterSet];
        var set: CharacterSet = .letters
        /// [set formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
        set.formUnion(.decimalDigits)
        /// [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString: TWHashtagSpecialChars @"&"]];
        set.formUnion(CharacterSet(charactersIn: TwitterTextRegexp.TWHashtagSpecialChars + "&"))
        /// charset = [set invertedSet];
        let charset = set.inverted
        /// });
        /// return charset;
        return charset
    }


    /// + (NSInteger)tweetLength:(NSString *)text;
    public static func tweetLength(text: String) -> Int {
        /// return [self tweetLength:text transformedURLLength:kTransformedURLLength];
        return self.tweetLength(text: text, transformedURLLength: kTransformedURLLength)
    }

    /// + (NSInteger)tweetLength:(NSString *)text transformedURLLength:(NSInteger)transformedURLLength;
    public static func tweetLength(text: String, transformedURLLength: Int) -> Int {
        /// // Use Unicode Normalization Form Canonical Composition to calculate tweet text length
        /// text = [text precomposedStringWithCanonicalMapping];
        let text = text.precomposedStringWithCanonicalMapping
        /// if (!text.length) {
        ///     return 0;
        /// }
        if text.isEmpty {
            return 0
        }

        /// // Remove URLs from text and add t.co length
        /// NSMutableString *string = [text mutableCopy];
        var string = text

        /// NSUInteger urlLengthOffset = 0;
        var urlLengthOffset = 0
        /// NSArray<TwitterTextEntity *> *urlEntities = [self URLsInText:text];
        let urlEntities = URLs(inText: text)
        /// for (NSInteger i = (NSInteger)urlEntities.count - 1; i >= 0; i--) {
        ///     TwitterTextEntity *entity = [urlEntities objectAtIndex:(NSUInteger)i];
        ///     NSRange urlRange = entity.range;
        ///     urlLengthOffset += transformedURLLength;
        ///     [string deleteCharactersInRange:urlRange];
        /// }
        for urlEntity in urlEntities.reversed() {
            let entity = urlEntity
            let urlRange = entity.range
            urlLengthOffset += transformedURLLength

            let mutableString = NSMutableString(string: string)
            mutableString.deleteCharacters(in: urlRange)
            string = String(mutableString)
        }

        /// NSUInteger len = string.length;
        let len = string.count
        /// NSUInteger charCount = len + urlLengthOffset;
        var charCount = len + urlLengthOffset

        /// // Adjust count for surrogate pair characters
        /// if (len > 0) {
        if len > 0 {
            ///     UniChar buffer[len];
            var buffer: [UniChar] = Array.init(repeating: UniChar(), count: len)

            ///     [string getCharacters:buffer range:NSMakeRange(0, len)];
            let mutableString = NSMutableString(string: string)
            mutableString.getCharacters(&buffer, range: NSMakeRange(0, len))

            ///     for (NSUInteger i = 0; i < len; i++) {
            for index in 0..<len {
                /// UniChar c = buffer[i];
                let c = buffer[index]
                /// if (CFStringIsSurrogateHighCharacter(c)) {
                if CFStringIsSurrogateHighCharacter(c) {
                    ///             if (i + 1 < len) {
                    if index + 1 < len {
                        ///                 UniChar d = buffer[i + 1];
                        let d = buffer[index + 1]
                        ///                 if (CFStringIsSurrogateLowCharacter(d)) {
                        if CFStringIsSurrogateHighCharacter(d) {
                            ///                     charCount--;
                            charCount -= 1
                            ///                     i++;
                            ///                 }
                        }
                        ///             }
                    }
                    ///         }
                }
                ///     }
            }
            /// }
        }

        /// return (NSInteger)charCount;
        return charCount
    }

    /// + (NSInteger)tweetLength:(NSString *)text httpURLLength:(NSInteger)httpURLLength httpsURLLength:(NSInteger)httpsURLLength __attribute__((deprecated("Use tweetLength:transformedURLLength: instead")));
    @available(*, deprecated, message: "Use `tweetLength(transformedURLLength:)` instead")
    public static func tweetLength(text: String, httpURLLength: Int, httpsURLLength: Int) -> Int {
        /// Deprecated, here for backwards compatibility. Just uses the httpsURLLength,
        /// which has been the same as httpURLLength for some time.
        ///
        /// return [self tweetLength:text transformedURLLength:httpsURLLength];
        return self.tweetLength(text: text, transformedURLLength: httpsURLLength)
    }


    /// + (NSInteger)remainingCharacterCount:(NSString *)text;
    public static func remainingCharacterCount(text: String) -> Int {
        /// return [self remainingCharacterCount:text transformedURLLength:kTransformedURLLength];
        return self.remainingCharacterCount(text: text, transformedURLLength: kTransformedURLLength)
    }

    /// + (NSInteger)remainingCharacterCount:(NSString *)text transformedURLLength:(NSInteger)transformedURLLength;
    public static func remainingCharacterCount(text: String, transformedURLLength: Int) -> Int {
        /// return kMaxTweetLengthLegacy - [self tweetLength:text transformedURLLength:transformedURLLength];
        return kMaxTweetLengthLegacy - self.tweetLength(text: text, transformedURLLength: transformedURLLength)
    }

    /// + (NSInteger)remainingCharacterCount:(NSString *)text httpURLLength:(NSInteger)httpURLLength httpsURLLength:(NSInteger)httpsURLLength __attribute__((deprecated("Use tweetLength:transformedURLLength: instead")));
    @available(*, deprecated, message: "Use `tweetLength(transformedURLLength:)` instead")
    public static func remaningCharacterCount(text: String, httpURLLength: Int, httpsUrlLength: Int) -> Int {
        /// return kMaxTweetLengthLegacy - [self tweetLength:text httpURLLength:httpURLLength httpsURLLength:httpsURLLength];
        return kMaxTweetLengthLegacy - self.tweetLength(text: text, httpURLLength: httpURLLength, httpsURLLength: httpsUrlLength)
    }


    /// + (void)eagerlyLoadRegexps;
    public static func eagerlyLoadRegexps() {
        /// static dispatch_once_t onceToken;
        /// dispatch_once(&onceToken, ^{
        /// dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validHashtagRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validURLRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validGTLDRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validDomainRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self invalidCharacterRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validTCOURLRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self endHashtagRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validSymbolRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validMentionOrListRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validReplyRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self endMentionRegexp];
        /// }
        /// });

        /// dispatch_async(queue, ^{
        /// @autoreleasepool {
        /// __unused NSRegularExpression *exp = [self validDomainSucceedingCharRegexp];
        /// }
        /// });
        /// });
    }

    // MARK: - Private Methods

    /// + (NSRegularExpression *)validGTLDRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUValidGTLD options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validGTLDRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUValidGTLD, options: .caseInsensitive)

    /// + (NSRegularExpression *)validURLRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUValidURLPatternString options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validURLRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUValidURLPatternString, options: .caseInsensitive)

    /// + (NSRegularExpression *)validDomainRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUValidDomain options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validDomainRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUValidDomain, options: .caseInsensitive)

    /// + (NSRegularExpression *)invalidCharacterRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUInvalidCharactersPattern options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    internal static let invalidCharacterRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUInvalidCharactersPattern, options: .caseInsensitive)

    /// + (NSRegularExpression *)validTCOURLRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUValidTCOURL options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validTCOURLRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUValidTCOURL, options: .caseInsensitive)
    ///
    /// + (NSRegularExpression *)validHashtagRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUValidHashtag options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validHashtagRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUValidHashtag, options: .caseInsensitive)

    /// + (NSRegularExpression *)endHashtagRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUEndHashTagMatch options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let endHashtagRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUEndHashTagMatch, options: .caseInsensitive)

    /// + (NSRegularExpression *)validSymbolRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUValidSymbol options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validSymbolRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUValidSymbol, options: .caseInsensitive)

    /// + (NSRegularExpression *)validMentionOrListRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUValidMentionOrList options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validMentionOrListRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUValidMentionOrList, options: .caseInsensitive)

    /// + (NSRegularExpression *)validReplyRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUValidReply options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validReplyRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUValidReply, options: .caseInsensitive)

    /// + (NSRegularExpression *)endMentionRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUEndMentionMatch options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let endMentionRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUEndMentionMatch, options: .caseInsensitive)

    /// + (NSCharacterSet *)invalidURLWithoutProtocolPrecedingCharSet
    /// {
    /// static NSCharacterSet *charset;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// charset = [NSCharacterSet characterSetWithCharactersInString:@"-_./"];
    /// });
    /// return charset;
    /// }
    private static let invalidURLWithoutProtocolPrecedingCharSet: CharacterSet = {
        CharacterSet.init(charactersIn: "-_./")
    }()

    /// + (NSRegularExpression *)validDomainSucceedingCharRegexp
    /// {
    /// static NSRegularExpression *regexp;
    /// static dispatch_once_t onceToken;
    /// dispatch_once(&onceToken, ^{
    /// regexp = [[NSRegularExpression alloc] initWithPattern:TWUEndMentionMatch options:NSRegularExpressionCaseInsensitive error:NULL];
    /// });
    /// return regexp;
    /// }
    private static let validDomainSucceedingCharRegexp = try! NSRegularExpression(pattern: TwitterTextRegexp.TWUEndMentionMatch, options: .caseInsensitive)

    /// + (BOOL)isValidHostAndLength:(NSUInteger)urlLength protocol:(NSString *)protocol host:(NSString *)host
    private static func isValidHostAndLength(urlLength: Int, urlProtocol: String?, host: String?) -> Bool {
    /// {
    /// if (!host) {
    /// return NO;
    /// }
        if host == nil {
            return false
        }
        var urlLength = urlLength
        /// NSError *error;
        do {
            /// NSInteger originalHostLength = [host length];
            ///
            /// NSURL *url = [NSURL URLWithUnicodeString:host error:&error];
            guard var host = host, let url = URL(string: host) else {
                return false
            }
            let originalHostLength = host.count

// TODO
            /// if (error) {
            ///     if (error.code == IFUnicodeURLConvertErrorInvalidDNSLength) {
            ///         // If the error is specifically IFUnicodeURLConvertErrorInvalidDNSLength,
            ///         // just return a false result. NSURL will happily create a URL for a host
            ///         // with labels > 63 characters (radar 35802213).
            ///         return NO;
            ///     } else {
            ///         // Attempt to create a NSURL object. We may have received an error from
            ///         // URLWithUnicodeString above because the input is not valid for punycode
            ///         // conversion (example: non-LDH characters are invalid and will trigger
            ///         // an error with code == IFUnicodeURLConvertErrorSTD3NonLDH but may be
            ///         // allowed normally per RFC 1035.
            ///         url = [NSURL URLWithString:host];
            ///     }
            /// }
            ///
            /// if (!url) {
            ///     return NO;
            /// }
            if url == nil {
                return false
            }
            ///
            ///
            /// // Should be encoded if necessary.
            /// host = url.absoluteString;
            host = url.absoluteString
            ///
            /// NSInteger updatedHostLength = [host length];
            let updatedHostLength = host.count
            /// if (updatedHostLength == 0) {
            ///     return NO;
            /// } else if (updatedHostLength > originalHostLength) {
            ///     urlLength += (updatedHostLength - originalHostLength);
            /// }
            if updatedHostLength == 0 {
                return false
            } else {
                urlLength += updatedHostLength - originalHostLength
            }
            ///
            /// // Because the backend always adds https:// if we're missing a protocol, add this length
            /// // back in when checking vs. our maximum allowed length of a URL, if necessary.
            /// NSInteger urlLengthWithProtocol = urlLength;
            /// if (!protocol) {
            ///     urlLengthWithProtocol += kURLProtocolLength;
            /// }
            var urlLengthWithProtocol = urlLength
            if urlProtocol == nil {
                urlLengthWithProtocol += TwitterText.kURLProtocolLength
            }
            /// return urlLengthWithProtocol <= kMaxURLLength;
            return urlLengthWithProtocol <= kMaxURLLength
        } catch let error {
            print(error)
        }
    }
}
