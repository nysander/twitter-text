//
//  File.swift
//  
//
//  Created by Pawel Madej on 11/09/2020.
//

import Foundation
import IFUnicodeURL

extension URL {
    /// + (NSURL *)URLWithUnicodeString:(NSString *)str
    static func urlWithUnicodeString(str: String) {
        /// return [self URLWithUnicodeString:str error:nil];
        return self.urlWithUnicodeString(str)
    }

    /// + (NSURL *)URLWithUnicodeString:(NSString *)str error:(NSError **)error
    static func urlWithUnicodeString(str: String) -> URL? {
        /// return ([str length]) ? [[self alloc] initWithUnicodeString:str error:error] : nil;
        str.count > 0 ? self.initWithUnicodeString(str) : nil
    }

    /// - (instancetype)initWithUnicodeString:(NSString *)str
    init(urlWithUnicodeString str: String) {
    /// return [self initWithUnicodeString:str error:nil];
        return
    }

    /// - (instancetype)initWithUnicodeString:(NSString *)str error:(NSError **)error
    init(str: String) {
    /// str = ConvertUnicodeURLString(str, YES, error);
        str = ConvertUnicodeURLString(str, true)
    /// self = (str) ? [self initWithString:str] : nil;
        self = str ? self.initWithString : nil
    /// return self;
        return self
    }

    /// - (NSString *)unicodeAbsoluteString
    var unicodeAbsoluteString: String {
    /// return ConvertUnicodeURLString([self absoluteString], NO, nil);
        return ConvertUnicodeURLString(self.absoluteString, false)
    }

    /// - (NSString *)unicodeHost
    var unicodeHost: String {
    /// return ConvertUnicodeDomainString([self host], NO, nil);
        return ConvertUnicodeURLString(self.host, false)
    }

    /// + (NSString *)decodeUnicodeDomainString:(NSString*)domain
    func decodeUnicodeDomain(from domain: String) -> String{
    /// return ConvertUnicodeDomainString(domain, NO, nil);
        return ConvertUnicodeURLString(domain, false)
    }

}

extension String {
    /// - (BOOL)_IFUnicodeURL_isValidCharacterSequence
    var IFUnicodeURL_isValidCharacterSequence: Bool {
        /// NSUInteger length = self.length;
        let length = self.count
        /// if (length == 0) {
        ///     return YES;
        /// }
        if length == 0 {
            return true
        }
///
        /// unichar buffer[length];
        /// [self getCharacters:buffer range:NSMakeRange(0, length)];
        
///
        /// BOOL pendingSurrogateHigh = NO;
        var pendingSurrogateHigh = false
        /// for (NSInteger index = 0; index < (NSInteger)length; index++) {
        for i in 0..<length {
        ///     unichar c = buffer[index];
            let c = buffer[index]
        ///     if (CFStringIsSurrogateHighCharacter(c)) {
            if CFStringIsSurrogateHighCharacter(c) {
        ///         if (pendingSurrogateHigh) {
        ///             // Surrogate high after surrogate high
        ///             return NO;
        ///         } else {
        ///             pendingSurrogateHigh = YES;
        ///         }
                    if pendingSurrogateHigh {
                        // Surrogate high after surrogate high
                        return false
                    } else {
                        pendingSurrogateHigh = true
                    }
        ///     } else if (CFStringIsSurrogateLowCharacter(c)) {
            } else if CFStringIsSurrogateLowCharacter(c) {
        ///         if (pendingSurrogateHigh) {
        ///             pendingSurrogateHigh = NO;
        ///         } else {
        ///             // Isolated surrogate low
        ///             return NO;
        ///         }
                if pendingSurrogateHigh {
                    pendingSurrogateHigh = false
                } else {
                    return false
                }
        ///     } else {
            } else {
        ///         if (pendingSurrogateHigh) {
        ///             // Isolated surrogate high
        ///             return NO;
        ///         }
                if pendingSurrogateHigh {
                    return false
                }
        ///     }
            }
        /// }
        }

        /// if (pendingSurrogateHigh) {
        ///     // Isolated surrogate high
        ///     return NO;
        /// }
        if pendingSurrogateHigh {
            return false
        }

        /// return YES;
        return true
    }

    /// - (NSArray *)_IFUnicodeURL_splitAfterString:(NSString *)string
    func split(after string: String) -> [String] {
        /// NSString *firstPart;
        let firstPart: String
        /// NSString *secondPart;
        let secondPart: String
        /// NSRange range = [self rangeOfString:string];
        let range: NSRange = NSString(string: self).range(of: string)
        ///
        /// if (range.location != NSNotFound) {
        if range.location != NSNotFound {
            /// NSUInteger index = range.location+range.length;
            let index = range.location + range.length
            /// firstPart = [self substringToIndex:index];
            firstPart = NSString(string: self).substring(to: index)
            /// secondPart = [self substringFromIndex:index];
            secondPart = NSString(string: self).substring(from: index)
        /// } else {
        } else {
        /// firstPart = @"";
            firstPart = ""
        /// secondPart = self;
            secondPart = self
        /// }
        }
        ///
        /// return [NSArray arrayWithObjects:firstPart, secondPart, nil];
        return [firstPart, secondPart]
    }

    /// - (NSArray *)_IFUnicodeURL_splitBeforeCharactersInSet:(NSCharacterSet *)chars
    func split(before chars: CharacterSet) -> [String] {
        /// NSUInteger index=0;
        /// for (; index<[self length]; index++) {
        ///     if ([chars characterIsMember:[self characterAtIndex:index]]) {
        ///         break;
        ///     }
        /// }
        var index = self.startIndex
        while index != self.endIndex {
            let set = CharacterSet(charactersIn: "\(self[index])")
            if set.isSuperset(of: chars) {
                break
            }
            index = self.index(index, offsetBy: 1)
        }

        /// return [NSArray arrayWithObjects:[self substringToIndex:index], [self substringFromIndex:index], nil];
        return [String(self.prefix(upTo: index)), String(self.suffix(from: index))]
    }
}

struct IFUnicodeURLSwift {
    ///static NSString *ConvertUnicodeDomainString(NSString *hostname, BOOL toAscii, NSError **error)
    static func ConvertUnicodeDomainString(hostname: String, toAscii: Bool) -> String? {
        var hostname: String? = hostname
        /// const UTF16CHAR *inputString = (const UTF16CHAR *)[hostname cStringUsingEncoding:NSUTF16StringEncoding];
        let inputString = hostname?.cString(using: .utf8)
        /// NSUInteger inputLength = [hostname lengthOfBytesUsingEncoding:NSUTF16StringEncoding] / sizeof(UTF16CHAR);
        let inputLength = hostname?.lengthOfBytes(using: .utf8)

        /// int ret = XCODE_SUCCESS;
        var ret = XCODE_SUCCESS
        /// if (toAscii) {
        if toAscii {
        ///     int outputLength = MAX_DOMAIN_SIZE_8;
            let outputLength = MAX_DOMAIN_SIZE_8
        ///     UCHAR8 outputString[outputLength];
            var outputString: Buffer

        ///     ret = Xcode_DomainToASCII(inputString, (int) inputLength, outputString, &outputLength);
            ret = Xcode_DomainToASCII(inputString, inputLength, outputString, outputLength)

        ///     if (XCODE_SUCCESS == ret) {
            if ret == XCODE_SUCCESS {
        ///         hostname = [[NSString alloc] initWithBytes:outputString length:outputLength encoding:NSASCIIStringEncoding];
                hostname = String(bytes: outputString, encoding: .ascii)
            } else {
        ///     } else {
        ///         // NSURL specifies that if a URL is malformed then URLWithString: returns nil, so
        ///         // on error we return nil here.
        ///         hostname = nil;
                hostname = nil
        ///     }
            }
        /// } else {
        } else {
        ///     int outputLength = MAX_DOMAIN_SIZE_16;
            let outputLength = MAX_DOMAIN_SIZE_16
        ///     UTF16CHAR outputString[outputLength];
        ///     ret = Xcode_DomainToUnicode16(inputString, (int) inputLength, outputString, &outputLength);
            ret = Xcode_DomainToUnicode16(inputString, inputLength, outputString, &outputLength)
        ///     if (XCODE_SUCCESS == ret) {
            if ret == XCODE_SUCCESS {
        ///         hostname = [[NSString alloc] initWithCharacters:outputString length:outputLength];
                hostname = String(bytes: outputString)
        ///     } else {
            } else {
        ///         // NSURL specifies that if a URL is malformed then URLWithString: returns nil, so
        ///         // on error we return nil here.
        ///         hostname = nil;
                hostname = nil
        ///     }
            }
        /// }
        }

        /// if (error && ret != XCODE_SUCCESS) {
        ///     *error = [NSError errorWithDomain:kIFUnicodeURLErrorDomain code:ret userInfo:nil];
        /// }
        if ret != XCODE_SUCCESS {
            let error = Error(kIFUnicode)
        }

        /// return hostname;
        return hostname
    }


    /// static NSString *ConvertUnicodeURLString(NSString *str, BOOL toAscii, NSError **error)
    static func ConvertUnicodeURLString(str: String, toAscii: Bool) -> String? {
        /// if (!str) {
        ///     return nil;
        /// }
        guard !str.isEmpty else {
            return nil
        }

        /// NSMutableArray *urlParts = [NSMutableArray array];
        var urlParts: [String] = []
        /// NSString *hostname = nil;
        var hostname: String = ""
        /// NSArray *parts = nil;
        var parts: [String] = []

        /// parts = [str _IFUnicodeURL_splitAfterString:@":"];
        parts = str.split(after: ":")
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitAfterString:@"//"];
        parts = hostname.split(after: "//")
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitBeforeCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/?#"]];
        parts = hostname.split(before: CharacterSet(charactersIn: "/?#"))
        /// hostname = [parts objectAtIndex:0];
        hostname = parts[0]
        /// [urlParts addObject:[parts objectAtIndex:1]];
        urlParts.append(parts[1])

        /// parts = [hostname _IFUnicodeURL_splitAfterString:@"@"];
        parts = hostname.split(after: "@")
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitBeforeCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        parts = hostname.split(before: CharacterSet(charactersIn: ":"))
        /// hostname = [parts objectAtIndex:0];
        hostname = parts[0]
        /// [urlParts addObject:[parts objectAtIndex:1]];
        urlParts.append(parts[1])

        /// // Now that we have isolated just the hostname, do the magic decoding...
        /// hostname = ConvertUnicodeDomainString(hostname, toAscii, error);
        hostname = ConvertUnicodeDomainString(hostname, toAscii)
        /// if (!hostname) {
        ///     return nil;
        /// }
        if hostname == nil {
            return nil
        }
        /// // This will try to clean up the stuff after the hostname in the URL by making sure it's all encoded properly.
        /// // NSURL doesn't normally do anything like this, but I found it useful for my purposes to put it in here.
        /// NSString *afterHostname = [[urlParts objectAtIndex:4] stringByAppendingString:[urlParts objectAtIndex:2]];
        /// NSString *processedAfterHostname = [afterHostname stringByRemovingPercentEncoding] ?: afterHostname;
        /// static NSCharacterSet *sURLFragmentPlusHashtagPlusBracketsCharacterSet;
        /// static dispatch_once_t sConstructURLFragmentPlusHashtagPlusBracketsOnceToken;
        /// dispatch_once(&sConstructURLFragmentPlusHashtagPlusBracketsOnceToken, ^{
        /// NSMutableCharacterSet *URLFragmentPlusHashtagPlusBracketsMutableCharacterSet = [[NSCharacterSet URLFragmentAllowedCharacterSet] mutableCopy];
        /// [URLFragmentPlusHashtagPlusBracketsMutableCharacterSet addCharactersInString:@"#[]"];
        /// sURLFragmentPlusHashtagPlusBracketsCharacterSet = [URLFragmentPlusHashtagPlusBracketsMutableCharacterSet copy];
        /// });
        /// NSString* finalAfterHostname = [processedAfterHostname stringByAddingPercentEncodingWithAllowedCharacters:sURLFragmentPlusHashtagPlusBracketsCharacterSet];
///
        /// // Now recreate the URL safely with the new hostname (if it was successful) instead...
        /// NSArray *reconstructedArray = [NSArray arrayWithObjects:[urlParts objectAtIndex:0], [urlParts objectAtIndex:1], [urlParts objectAtIndex:3], hostname, finalAfterHostname, nil];
        /// NSString *reconstructedURLString = [reconstructedArray componentsJoinedByString:@""];
///
        /// if (reconstructedURLString.length == 0) {
        ///     return nil;
        /// }
        /// if (![reconstructedURLString _IFUnicodeURL_isValidCharacterSequence]) {
        ///     // If reconstructedURLString contains invalid UTF-16 sequence,
        ///     // we treat it as an error.
        ///     return nil;
        /// }
        /// return reconstructedURLString;
    }
}
