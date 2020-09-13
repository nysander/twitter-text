//
//  File.swift
//  
//
//  Created by Pawel Madej on 13/09/2020.
//

import Foundation

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
        var buffer = Array(repeating: Int8(), count: length)
        /// [self getCharacters:buffer range:NSMakeRange(0, length)];
        _ = self.getCString(&buffer, maxLength: length, encoding: .utf8)

        ///
        /// BOOL pendingSurrogateHigh = NO;
        var pendingSurrogateHigh = false
        /// for (NSInteger index = 0; index < (NSInteger)length; index++) {
        for index in 0..<length {
            ///     unichar c = buffer[index];
            let c = buffer[index]
            ///     if (CFStringIsSurrogateHighCharacter(c)) {
            if CFStringIsSurrogateHighCharacter(UniChar(c)) {
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
            } else if CFStringIsSurrogateLowCharacter(UniChar(c)) {
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
