//
//  File.swift
//
//
//  Created by Pawel Madej on 11/09/2020.
//

import Foundation
import IDNSDK

struct UnicodeURL {
    ///static NSString *ConvertUnicodeDomainString(NSString *hostname, BOOL toAscii, NSError **error)
    static func ConvertUnicodeDomainString(hostname: String, toAscii: Bool) -> String? {
        /// const UTF16CHAR *inputString = (const UTF16CHAR *)[hostname cStringUsingEncoding:NSUTF16StringEncoding];
        var inputString = (hostname.cString(using: .utf16) ?? []).map { UInt16($0) }
        let inputStringPointer = Data(bytes: inputString, count: inputString.count)
            .withUnsafeBytes { $0.load(as: UnsafePointer<UInt16>.self) }

        /// NSUInteger inputLength = [hostname lengthOfBytesUsingEncoding:NSUTF16StringEncoding] / sizeof(UTF16CHAR);
        let inputLength = hostname.lengthOfBytes(using: .utf16)

        var hostname: String? = hostname
        /// int ret = XCODE_SUCCESS;
        var ret = XCODE_SUCCESS
        /// if (toAscii) {
        if toAscii {
        ///     int outputLength = MAX_DOMAIN_SIZE_8;
            var outputLength = MAX_DOMAIN_SIZE_8
        ///     UCHAR8 outputString[outputLength];
            var outputString = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(outputLength))

        ///     ret = Xcode_DomainToASCII(inputString, (int) inputLength, outputString, &outputLength);
            ret = Xcode_DomainToASCII(inputStringPointer, Int32(inputLength), outputString, &outputLength)

        ///     if (XCODE_SUCCESS == ret) {
            if ret == XCODE_SUCCESS {
        ///         hostname = [[NSString alloc] initWithBytes:outputString length:outputLength encoding:NSASCIIStringEncoding];
                let data = Data(bytes: outputString, count: Int(outputLength))
                let bytes = data.withUnsafeBytes { $0.load(as: UnsafePointer<CChar>.self) }
                hostname = String(cString: bytes, encoding: .ascii)
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
            var outputLength = MAX_DOMAIN_SIZE_16
        ///     UTF16CHAR outputString[outputLength];
            var outputString = UnsafeMutablePointer<UInt16>.allocate(capacity: Int(outputLength))

        ///     ret = Xcode_DomainToUnicode16(inputString, (int) inputLength, outputString, &outputLength);
            ret = Xcode_DomainToUnicode16(inputString, Int32(inputLength), outputString, &outputLength)
        ///     if (XCODE_SUCCESS == ret) {
            if ret == XCODE_SUCCESS {
        ///         hostname = [[NSString alloc] initWithCharacters:outputString length:outputLength];
                let data = Data(bytes: outputString, count: Int(outputLength))
                let bytes = data.withUnsafeBytes { $0.load(as: UnsafePointer<CChar>.self) }
                hostname = String(cString: bytes, encoding: .utf8)
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
        var hostname: String? = nil
        /// NSArray *parts = nil;
        var parts: [String] = []

        /// parts = [str _IFUnicodeURL_splitAfterString:@":"];
        parts = str.split(after: ":")
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitAfterString:@"//"];
        parts = hostname?.split(after: "//") ?? []
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitBeforeCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/?#"]];
        parts = hostname?.split(before: CharacterSet(charactersIn: "/?#")) ?? []
        /// hostname = [parts objectAtIndex:0];
        hostname = parts[0]
        /// [urlParts addObject:[parts objectAtIndex:1]];
        urlParts.append(parts[1])

        /// parts = [hostname _IFUnicodeURL_splitAfterString:@"@"];
        parts = hostname?.split(after: "@") ?? []
        /// hostname = [parts objectAtIndex:1];
        hostname = parts[1]
        /// [urlParts addObject:[parts objectAtIndex:0]];
        urlParts.append(parts[0])

        /// parts = [hostname _IFUnicodeURL_splitBeforeCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        parts = hostname?.split(before: CharacterSet(charactersIn: ":")) ?? []
        /// hostname = [parts objectAtIndex:0];
        hostname = parts[0]
        /// [urlParts addObject:[parts objectAtIndex:1]];
        urlParts.append(parts[1])

        /// // Now that we have isolated just the hostname, do the magic decoding...
        /// hostname = ConvertUnicodeDomainString(hostname, toAscii, error);
        if let hostnameDecoded = hostname {
            hostname = UnicodeURL.ConvertUnicodeDomainString(hostname: hostnameDecoded, toAscii: toAscii)
        }
        /// if (!hostname) {
        ///     return nil;
        /// }
        if hostname == nil {
            return nil
        }
        /// // This will try to clean up the stuff after the hostname in the URL by making sure it's all encoded properly.
        /// // NSURL doesn't normally do anything like this, but I found it useful for my purposes to put it in here.
        /// NSString *afterHostname = [[urlParts objectAtIndex:4] stringByAppendingString:[urlParts objectAtIndex:2]];
        let afterHostname = ""
        /// NSString *processedAfterHostname = [afterHostname stringByRemovingPercentEncoding] ?: afterHostname;
        let processedAfterHostname = afterHostname.removingPercentEncoding ?? afterHostname
        /// static NSCharacterSet *sURLFragmentPlusHashtagPlusBracketsCharacterSet;
        /// static dispatch_once_t sConstructURLFragmentPlusHashtagPlusBracketsOnceToken;
        /// dispatch_once(&sConstructURLFragmentPlusHashtagPlusBracketsOnceToken, ^{
        /// NSMutableCharacterSet *URLFragmentPlusHashtagPlusBracketsMutableCharacterSet = [[NSCharacterSet URLFragmentAllowedCharacterSet] mutableCopy];
        var URLFragmentPlusHashtagPlusBracketsCharacterSet: CharacterSet = .urlFragmentAllowed
        /// [URLFragmentPlusHashtagPlusBracketsMutableCharacterSet addCharactersInString:@"#[]"];
        URLFragmentPlusHashtagPlusBracketsCharacterSet.formUnion(CharacterSet(charactersIn: "#[]"))
        /// sURLFragmentPlusHashtagPlusBracketsCharacterSet = [URLFragmentPlusHashtagPlusBracketsMutableCharacterSet copy];
        /// });
        /// NSString* finalAfterHostname = [processedAfterHostname stringByAddingPercentEncodingWithAllowedCharacters:sURLFragmentPlusHashtagPlusBracketsCharacterSet];
        let finalAfterHostname = processedAfterHostname.addingPercentEncoding(withAllowedCharacters: URLFragmentPlusHashtagPlusBracketsCharacterSet)
///
        /// // Now recreate the URL safely with the new hostname (if it was successful) instead...
        /// NSArray *reconstructedArray = [NSArray arrayWithObjects:[urlParts objectAtIndex:0], [urlParts objectAtIndex:1], [urlParts objectAtIndex:3], hostname, finalAfterHostname, nil];
        let reconstructedArray = [urlParts[0], urlParts[1], urlParts[3], hostname ?? "", finalAfterHostname ?? ""]
        /// NSString *reconstructedURLString = [reconstructedArray componentsJoinedByString:@""];
        let reconstructedURLString = reconstructedArray.joined(separator: "")

        /// if (reconstructedURLString.length == 0) {
        ///     return nil;
        /// }
        if reconstructedURLString.count == 0 {
            return nil
        }
        /// if (![reconstructedURLString _IFUnicodeURL_isValidCharacterSequence]) {
        ///     // If reconstructedURLString contains invalid UTF-16 sequence,
        ///     // we treat it as an error.
        ///     return nil;
        /// }
        if !reconstructedURLString.IFUnicodeURL_isValidCharacterSequence {
            return nil
        }
        /// return reconstructedURLString;
        return reconstructedURLString
    }
}
