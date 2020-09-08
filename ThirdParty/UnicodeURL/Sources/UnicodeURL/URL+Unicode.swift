//
//  File.swift
//  
//
//  Created by Pawel Madej on 13/09/2020.
//

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
        str.count > 0 ? self.init(urlWithUnicodeString: str) : nil
    }

    /// - (instancetype)initWithUnicodeString:(NSString *)str
    init?(urlWithUnicodeString str: String) {
        /// return [self initWithUnicodeString:str error:nil];
        self.init(str: str)
    }

    /// - (instancetype)initWithUnicodeString:(NSString *)str error:(NSError **)error
    init?(str: String) {
        //        var str = str
        /// str = ConvertUnicodeURLString(str, YES, error);
        if let asciiStr = UnicodeURL.ConvertUnicodeURLString(str: str, toAscii: true) {
            self.init(string: asciiStr)
        }
        return nil
        /// self = (str) ? [self initWithString:str] : nil;
        //        self = str ? self.initWithString : nil
        /// return self;
        //        return asciiStr != nil ? self.init(string: asciiStr) : nil
    }

    /// - (NSString *)unicodeAbsoluteString
    var unicodeAbsoluteString: String? {
        /// return ConvertUnicodeURLString([self absoluteString], NO, nil);
        return UnicodeURL.ConvertUnicodeURLString(str: self.absoluteString, toAscii: false)
    }

    /// - (NSString *)unicodeHost
    var unicodeHost: String? {
        /// return ConvertUnicodeDomainString([self host], NO, nil);
        if let host = self.host {
            return UnicodeURL.ConvertUnicodeURLString(str: host, toAscii: false)
        }
        return nil
    }

    /// + (NSString *)decodeUnicodeDomainString:(NSString*)domain
    func decodeUnicodeDomain(from domain: String) -> String? {
        /// return ConvertUnicodeDomainString(domain, NO, nil);
        return UnicodeURL.ConvertUnicodeURLString(str: domain, toAscii: false)
    }
}
