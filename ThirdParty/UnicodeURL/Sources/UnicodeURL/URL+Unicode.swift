//  UnicodeURL
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: Apache Licence 2.0 (see LICENCE files for details)

import Foundation

extension URL {
    /// + (NSURL *)URLWithUnicodeString:(NSString *)str
    static func urlWithUnicodeString(str: String) -> Self {
        /// return [self URLWithUnicodeString:str error:nil];
        return self.urlWithUnicodeString(str: str)
    }

    /// + (NSURL *)URLWithUnicodeString:(NSString *)str error:(NSError **)error
    static func urlWithUnicodeString(str: String) -> Self? {
        /// return ([str length]) ? [[self alloc] initWithUnicodeString:str error:error] : nil;
        str.count > 0 ? self.init(unicodeString: str) : nil
    }

    /// - (instancetype)initWithUnicodeString:(NSString *)str
    init?(unicodeString string: String) {
        /// return [self initWithUnicodeString:str error:nil];
        self.init(str: string)
    }

    init?(str: String) {
        if let asciiStr = UnicodeURL.ConvertUnicodeURLString(str: str, toAscii: true) {
            self.init(string: asciiStr)
        } else {
            return nil
        }
    }

    var unicodeAbsoluteString: String? {
        return UnicodeURL.ConvertUnicodeURLString(str: self.absoluteString, toAscii: false)
    }

    var unicodeHost: String? {
        if let host = self.host {
            return UnicodeURL.ConvertUnicodeURLString(str: host, toAscii: false)
        }
        return nil
    }

    static func decode(unicodeDomain domain: String) -> String? {
        return UnicodeURL.ConvertUnicodeURLString(str: domain, toAscii: false)
    }
}
