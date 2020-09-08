import Foundation

/// @interface TwitterText : NSObject
class TwitterText {
    /// + (NSArray<TwitterTextEntity *> *)entitiesInText:(NSString *)text;
    static func entities(inText text: String) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity]

        /// NSArray<TwitterTextEntity *> *urls = [self URLsInText:text];
        let urls: [TwitterTextEntity]

        /// [results addObjectsFromArray:urls];
        results.append(contentsOf: urls)

        /// NSArray<TwitterTextEntity *> *hashtags = [self hashtagsInText:text withURLEntities:urls];
        let hashtags: [TwitterTextEntity] = self.hashtags(inText: text, withURLEntities: urls)
        /// [results addObjectsFromArray:hashtags];
        results.append(contentsOf: hashtags)

        /// NSArray<TwitterTextEntity *> *symbols = [self symbolsInText:text withURLEntities:urls];
        let symbols: [TwitterTextEntity]
        /// [results addObjectsFromArray:symbols];
        results.append(contentsOf: symbols)

        /// NSArray<TwitterTextEntity *> *mentionsAndLists = [self mentionsOrListsInText:text];
        let mentionsAndLists: [TwitterTextEntity]

        /// NSMutableArray<TwitterTextEntity *> *addingItems = [NSMutableArray<TwitterTextEntity *> array];
        var addingItems: [TwitterTextEntity]

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
                if existingEntity.range, !entityRange.isEmpty {
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
    static func urls(inText text: String) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity]
        /// NSUInteger len = text.length;
        let len = text.count

        /// NSUInteger position = 0;
        var position = 0
        /// NSRange allRange = NSMakeRange(0, 0);
        var allRange = Range<0, 0>

        /// while (1) {
        ///     position = NSMaxRange(allRange);
        ///     if (len <= position) {
        ///         break;
        ///     }

        ///     NSTextCheckingResult *urlResult = [[self validURLRegexp] firstMatchInString:text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(position, len - position)];
        ///     if (!urlResult) {
        ///         break;
        ///     }

        ///     allRange = urlResult.range;
        ///     if (urlResult.numberOfRanges < 9) {
        ///         // Continue processing after the end of this invalid result.
        ///         continue;
        ///     }

        ///     NSRange urlRange = [urlResult rangeAtIndex:TWUValidURLGroupURL];
        ///     NSRange precedingRange = [urlResult rangeAtIndex:TWUValidURLGroupPreceding];
        ///     NSRange protocolRange = [urlResult rangeAtIndex:TWUValidURLGroupProtocol];
        ///     NSRange domainRange = [urlResult rangeAtIndex:TWUValidURLGroupDomain];

        ///     NSString *protocol = (protocolRange.location != NSNotFound) ? [text substringWithRange:protocolRange] : nil;
        ///     if (protocol.length == 0) {
        ///         NSString *preceding = (precedingRange.location != NSNotFound) ? [text substringWithRange:precedingRange] : nil;
        ///         NSRange suffixRange = [preceding rangeOfCharacterFromSet:[self invalidURLWithoutProtocolPrecedingCharSet] options:NSBackwardsSearch | NSAnchoredSearch];
        ///         if (suffixRange.location != NSNotFound) {
        ///             continue;
        ///         }
        ///     }

        ///     NSString *url = (urlRange.location != NSNotFound) ? [text substringWithRange:urlRange] : nil;
        ///     NSString *host = (domainRange.location != NSNotFound) ? [text substringWithRange:domainRange] : nil;

        ///     NSInteger start = urlRange.location;
        ///     NSInteger end = NSMaxRange(urlRange);

        ///     NSTextCheckingResult *tcoResult = url ? [[self validTCOURLRegexp] firstMatchInString:url options:0 range:NSMakeRange(0, url.length)] : nil;
        ///     if (tcoResult && tcoResult.numberOfRanges >= 2) {
        ///         NSRange tcoRange = [tcoResult rangeAtIndex:0];
        ///         NSRange tcoUrlSlugRange = [tcoResult rangeAtIndex:1];
        ///         if (tcoRange.location == NSNotFound || tcoUrlSlugRange.location == NSNotFound) {
        ///             continue;
        ///         }
        ///         NSString *tcoUrlSlug = [text substringWithRange:tcoUrlSlugRange];
        ///         // In the case of t.co URLs, don't allow additional path characters and ensure that the slug is under 40 chars.
        ///         if ([tcoUrlSlug length] > kMaxTCOSlugLength) {
        ///             continue;
        ///         } else {
        ///             url = [url substringWithRange:tcoRange];
        ///             end = start + url.length;
        ///         }
        ///     }
        ///     if ([self isValidHostAndLength:url.length protocol:protocol host:host]) {
        ///         TwitterTextEntity *entity = [TwitterTextEntity entityWithType:TwitterTextEntityURL range:NSMakeRange(start, end - start)];
        ///         [results addObject:entity];
        ///         allRange = entity.range;
        ///     }
        /// }

        /// return results;
        return results
    }

    /// + (NSArray<TwitterTextEntity *> *)hashtagsInText:(NSString *)text checkingURLOverlap:(BOOL)checkingURLOverlap;
    static func hashtags(inText text: String, checkingURLOverlap: Bool) -> [TwitterTextEntity] {
        return []
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
        var results: [TwitterTextEntity]
        /// NSUInteger len = text.length;
        let len = text.count
        /// NSUInteger position = 0;
        var position = 0

        /// while (1) {
        while true {
            /// NSTextCheckingResult *matchResult = [[self validHashtagRegexp] firstMatchInString:text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(position, len - position)];
            let matchResult = self.validHashtagRegexp(firstMatchInString: text, options: , range: position...len-position)
            /// if (!matchResult || matchResult.numberOfRanges < 2) {
            ///     break;
            /// }
            if !matchResult || matchResult.numberOfRanges < 2 {
                break
            }

            /// NSRange hashtagRange = [matchResult rangeAtIndex:1];
            let hashtagRange = matchResult.range(atIndex: 1)
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
                if urlEntity.range, hashtagRange.count > 0 {
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
                let afterStart = hashtagRange.max
                if afterStart < len {
                    let endMatchRange = self.endHashtagRegexp(rangeOfFirstMatchInString: text, options: 0, range: afterStart...len - afterStart)
                    if endMatchRange.location.notfound {
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
            position = matchResult.range.max
            /// }
        }

        /// return results;
        return results
    }

    /// + (NSArray<TwitterTextEntity *> *)symbolsInText:(NSString *)text checkingURLOverlap:(BOOL)checkingURLOverlap;
    static func symbols(inText text: String, checkingURLOverlap: Bool) -> [TwitterTextEntity] {
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
        var urls: [TwitterTextEntity]
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
        var results: [TwitterTextEntity]
        /// NSUInteger len = text.length;
        let len = text.count
        /// NSUInteger position = 0;
        var position = 0

        /// while (1) {
        while true {
        ///     NSTextCheckingResult *matchResult = [[self validSymbolRegexp] firstMatchInString:text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(position, len - position)];
            let matchResult = self.validSymbolRegexp(firstMatchInString: text, options: , range: position...len - position)
        ///     if (!matchResult || matchResult.numberOfRanges < 2) {
        ///         break;
        ///     }
            if !matchResult || matchResult.numberOfRanges < 2 {
                break
            }

        ///     NSRange symbolRange = [matchResult rangeAtIndex:1];
            let symbolRange = matchResult.range(atIndex: 1)
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
                if urlEntity.range, symbolRange.count > 0 {
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
            position = matchResult.range
        /// }
        }

        /// return results;
        return results
    }

    /// + (NSArray<TwitterTextEntity *> *)mentionedScreenNamesInText:(NSString *)text;
    static func mentionedScreenNames(inText text: String) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSArray<TwitterTextEntity *> *mentionsOrLists = [self mentionsOrListsInText:text];
        let mentionsOrLists = self.mentionsOrLists(inText: text)
        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity]

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
    static func mentionsOrLists(inText text: String) -> [TwitterTextEntity] {
        /// if (!text.length) {
        ///     return @[];
        /// }
        if text.isEmpty {
            return []
        }

        /// NSMutableArray<TwitterTextEntity *> *results = [NSMutableArray<TwitterTextEntity *> array];
        var results: [TwitterTextEntity]
        /// NSUInteger len = text.length;
        let len = text.count
        /// NSUInteger position = 0;
        var position = 0

        /// while (1) {
        while true {
        ///     NSTextCheckingResult *matchResult = [[self validMentionOrListRegexp] firstMatchInString:text options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(position, len - position)];
            let matchResult = self.validMentionOrListRegexp(firstMatchInString: text, options: , range: position...len - position)
        ///     if (!matchResult || matchResult.numberOfRanges < 5) {
        ///         break;
        ///     }
            if !matchResult || matchResult.numberOfRanges < 5 {
                break
            }

        ///     NSRange allRange = matchResult.range;
            let allRange = matchResult.range
        ///     NSUInteger end = NSMaxRange(allRange);
            let end = allRange.max

        ///     NSRange endMentionRange = [[self endMentionRegexp] rangeOfFirstMatchInString:text options:0 range:NSMakeRange(end, len - end)];
            let endMentionRange = self.endMentionRegexp(rangeOfFirstMatchInString: text, options: 0, range: end...(len - end))
        ///     if (endMentionRange.location == NSNotFound) {
            if endMentionRange.location.notfound {
        ///         NSRange atSignRange = [matchResult rangeAtIndex:2];
        ///         NSRange screenNameRange = [matchResult rangeAtIndex:3];
        ///         NSRange listNameRange = [matchResult rangeAtIndex:4];
                let atSignRange = matchResult.range(atIndex: 2)
                let screenNameRange = matchResult.range(atIndex: 3)
                let listNameRange = matchResult.range(atIndex: 4)
        ///         if (listNameRange.location == NSNotFound) {
        ///             TwitterTextEntity *entity = [TwitterTextEntity entityWithType:TwitterTextEntityScreenName range:NSMakeRange(atSignRange.location, NSMaxRange(screenNameRange) - atSignRange.location)];
        ///             [results addObject:entity];
        ///         } else {
        ///             TwitterTextEntity *entity = [TwitterTextEntity entityWithType:TwitterTextEntityListName range:NSMakeRange(atSignRange.location, NSMaxRange(listNameRange) - atSignRange.location)];
        ///             [results addObject:entity];
        ///         }
                if listNameRange.location == NSNotFound {
                    let entity = TwitterTextEntity(withType: .TwitterTextEntityScreenName, range: atSignRange.location...screenNameRange.max - atSignRange.location)
                    results.append(entity)
                } else {
                    let entity = TwitterTextEntity(withType: .TwitterTextEntityListName, range: atSignRange.location...listNameRange.max - atSignRange.location)
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
    static func repliedScreenName(inText text: String) -> TwitterTextEntity? {
        /// if (!text.length) {
        ///     return nil;
        /// }
        if text.isEmpty {
            return nil
        }
        /// NSUInteger len = text.length;
        let len = text.count

        /// NSTextCheckingResult *matchResult = [[self validReplyRegexp] firstMatchInString:text options:(NSMatchingWithoutAnchoringBounds | NSMatchingAnchored) range:NSMakeRange(0, len)];
        let matchResult = self.validReplyRegexp(firstMatchInString: text, options: , range: 0...len)
        /// if (!matchResult || matchResult.numberOfRanges < 2) {
        ///     return nil;
        /// }
        if !matchResult || matchResult.numberOfRanges < 2 {
            return nil
        }

        /// NSRange replyRange = [matchResult rangeAtIndex:1];
        let replyRange = matchResult.range(atIndex: 1)
        /// NSUInteger replyEnd = NSMaxRange(replyRange);
        let replyEnd = replyRange.max

        /// NSRange endMentionRange = [[self endMentionRegexp] rangeOfFirstMatchInString:text options:0 range:NSMakeRange(replyEnd, len - replyEnd)];
        let endMentionRange = self.endMentionRegexp(rangeOfFirstMatchInString: text, options: 0, range: replyEnd...(len - replyEnd))
        /// if (endMentionRange.location != NSNotFound) {
        ///     return nil;
        /// }
        if endMentionRange.location not found {
            return nil
        }
///
        /// return [TwitterTextEntity entityWithType:TwitterTextEntityScreenName range:replyRange];
        return TwitterTextEntity(withType: .TwitterTextEntityScreenName, range: replyRange)
    }


    /// + (NSCharacterSet *)validHashtagBoundaryCharacterSet;
    static func validHashtagBoundaryCharacterSet() -> CharacterSet {
        /// static NSCharacterSet *charset;
        var charset: CharacterSet
        /// static dispatch_once_t onceToken;
        /// dispatch_once(&onceToken, ^{
        /// // Generate equivalent character set matched by TWUHashtagBoundaryInvalidChars regex and invert
        /// NSMutableCharacterSet *set = [NSMutableCharacterSet letterCharacterSet];
        /// [set formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
        /// [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString: TWHashtagSpecialChars @"&"]];
        /// charset = [set invertedSet];
        /// });
        /// return charset;
        return CharacterSet(charactersIn: "")
    }


    /// + (NSInteger)tweetLength:(NSString *)text;
    static func tweetLength(text: String) -> Int {
        /// return [self tweetLength:text transformedURLLength:kTransformedURLLength];
        return self.tweetLength(text: text, transformedURLLength: kTransformedURLLength)
    }

    /// + (NSInteger)tweetLength:(NSString *)text transformedURLLength:(NSInteger)transformedURLLength;
    static func tweetLength(text: String, transformedURLLength: Int) -> Int {
        /// // Use Unicode Normalization Form Canonical Composition to calculate tweet text length
        /// text = [text precomposedStringWithCanonicalMapping];
///
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
        for index in urlEntities.enumerated().reversed() {
            let entity = urlEntities(atIndex: index)
            let urlRange = entity.range
            urlLengthOffset += transformedURLLength
            string.removeSubrange(urlRange)
        }

        /// NSUInteger len = string.length;
        let len = string.count
        /// NSUInteger charCount = len + urlLengthOffset;
        var charCount = len + urlLengthOffset

        /// // Adjust count for surrogate pair characters
        /// if (len > 0) {
        if len > 0 {
        ///     UniChar buffer[len];
            var buffer: Int

        ///     [string getCharacters:buffer range:NSMakeRange(0, len)];
            string.get(characters: buffer, range: 0...len)

        ///     for (NSUInteger i = 0; i < len; i++) {
            for index in 0..<len {
        ///         UniChar c = buffer[i];
                let c = buffer(atIndex: index)
        ///         if (CFStringIsSurrogateHighCharacter(c)) {
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
    static func tweetLength(text: String, httpURLLength: Int, httpsURLLength: Int) -> Int {
        /// Deprecated, here for backwards compatibility. Just uses the httpsURLLength,
        /// which has been the same as httpURLLength for some time.
        ///
        /// return [self tweetLength:text transformedURLLength:httpsURLLength];
        return self.tweetLength(text: text, transformedURLLength: httpsURLLength)
    }


    /// + (NSInteger)remainingCharacterCount:(NSString *)text;
    static func remainingCharacterCount(text: String) -> Int {
        return 0
    }

    /// + (NSInteger)remainingCharacterCount:(NSString *)text transformedURLLength:(NSInteger)transformedURLLength;
    static func remainingCharacterCount(text: String, transformedURLLength: Int) -> Int {
        return 0
    }

    /// + (NSInteger)remainingCharacterCount:(NSString *)text httpURLLength:(NSInteger)httpURLLength httpsURLLength:(NSInteger)httpsURLLength __attribute__((deprecated("Use tweetLength:transformedURLLength: instead")));
    @available(*, deprecated, message: "Use `tweetLength(transformedURLLength:)` instead")
    static func remaningCharacterCount(text: String, httpURLLength: Int, httpsUrlLength: Int) -> Int {
        return 0
    }


    /// + (void)eagerlyLoadRegexps;
    static func eagerlyLoadRegexps() {

    }
}
