//
//  File.swift
//  
//
//  Created by Pawel Madej on 11/09/2020.
//

import Foundation

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
}

struct IFUnicodeURLSwift {
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
        var hostname: String?
        /// NSArray *parts = nil;
        var parts: [String] = []

        /// parts = [str _IFUnicodeURL_splitAfterString:@":"];
        parts = str.split(after: ":")
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitAfterString:@"//"];
        parts = hostname?.split(after: "//")
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitBeforeCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/?#"]];
        parts = hostname.splitbef
        /// hostname = [parts objectAtIndex:0];
        hostname = parts[0]
        /// [urlParts addObject:[parts objectAtIndex:1]];
        urlParts.append(parts[1])

        /// parts = [hostname _IFUnicodeURL_splitAfterString:@"@"];
        parts = hostname?.split(after: "@")
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitBeforeCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        parts = hostname.splitbefore
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
