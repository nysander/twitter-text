//
//  File.swift
//
//
//  Created by Pawel Madej on 11/09/2020.
//

import Foundation
import IDNSDK

struct UnicodeURL {
    static func ConvertUnicodeDomainString(hostname: String, toAscii: Bool) -> String? {
        var inputString = hostname.utf16.compactMap { UInt16(exactly: $0) }
        let inputLength = hostname.lengthOfBytes(using: .utf16) / MemoryLayout<UInt16>.size

        var hostname: String? = hostname

        var ret = XCODE_SUCCESS
        if toAscii {
            var outputLength = MAX_DOMAIN_SIZE_8
            var outputString: [UInt8] = Array(repeating: UInt8(), count: Int(outputLength))

            ret = Xcode_DomainToASCII(&inputString, Int32(inputLength), &outputString, &outputLength)

            if ret == XCODE_SUCCESS {
                hostname = String(cString: outputString)
            } else {
                /// URL specifies that if a URL is malformed then URLWithString:
                ///  returns nil, so on error we return nil here.
                hostname = nil
            }
        } else {
            var outputLength = MAX_DOMAIN_SIZE_16
            var outputString: [UInt16] = Array(repeating: UInt16(), count: Int(outputLength))

            ret = Xcode_DomainToUnicode16(&inputString, Int32(inputLength), &outputString, &outputLength)

            if ret == XCODE_SUCCESS {
                hostname = String(utf16CodeUnits: outputString, count: Int(outputLength))
            } else {
                /// URL specifies that if a URL is malformed then URLWithString:
                /// returns nil, so on error we return nil here.
                hostname = nil
            }
        }

        /// if (error && ret != XCODE_SUCCESS) {
        ///     *error = [NSError errorWithDomain:kIFUnicodeURLErrorDomain code:ret userInfo:nil];
        /// }

        return hostname
    }

    /// static NSString *ConvertUnicodeURLString(NSString *str, BOOL toAscii, NSError **error)
    static func ConvertUnicodeURLString(str: String, toAscii: Bool) -> String? {
        guard !str.isEmpty else {
            return nil
        }

        var urlParts: [String] = []
        var hostname: String? = nil
        var parts: [String] = []

        parts = str.split(after: ":")
        hostname = parts[1]
        urlParts.append(parts[0])

        parts = hostname?.split(after: "//") ?? []
        hostname = parts[1]
        urlParts.append(parts[0])

        parts = hostname?.split(before: CharacterSet(charactersIn: "/?#")) ?? []
        hostname = parts[0]
        urlParts.append(parts[1])

        parts = hostname?.split(after: "@") ?? []
        hostname = parts[1]
        urlParts.append(parts[0])

        parts = hostname?.split(before: CharacterSet(charactersIn: ":")) ?? []
        hostname = parts[0]
        urlParts.append(parts[1])

        /// // Now that we have isolated just the hostname, do the magic decoding...
        if let hostnameDecoded = hostname {
            hostname = UnicodeURL.ConvertUnicodeDomainString(hostname: hostnameDecoded, toAscii: toAscii)
        }
        if hostname == nil {
            return nil
        }
        /// // This will try to clean up the stuff after the hostname in the URL by making sure it's all encoded properly.
        /// // URL doesn't normally do anything like this, but I found it useful for my purposes to put it in here.
        let afterHostname = urlParts[4].appending(urlParts[2])
        let processedAfterHostname = afterHostname.removingPercentEncoding ?? afterHostname

        var URLFragmentPlusHashtagPlusBracketsCharacterSet: CharacterSet = .urlFragmentAllowed
        URLFragmentPlusHashtagPlusBracketsCharacterSet.formUnion(CharacterSet(charactersIn: "#[]"))

        let finalAfterHostname = processedAfterHostname.addingPercentEncoding(withAllowedCharacters: URLFragmentPlusHashtagPlusBracketsCharacterSet)

        /// // Now recreate the URL safely with the new hostname (if it was successful) instead...
        let reconstructedArray = [urlParts[0], urlParts[1], urlParts[3], hostname ?? "", finalAfterHostname ?? ""]
        let reconstructedURLString = reconstructedArray.joined(separator: "")

        if reconstructedURLString.count == 0 {
            return nil
        }
        if !reconstructedURLString.isValidCharacterSequence {
            return nil
        }

        return reconstructedURLString
    }
}
