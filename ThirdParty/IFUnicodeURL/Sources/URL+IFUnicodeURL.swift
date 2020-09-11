//
//  File.swift
//  
//
//  Created by Pawel Madej on 11/09/2020.
//

import Foundation

extension URL {
    static let
    init(withUnicodeString str: String) {

    }

    init(
}

extension String {
    var IFUnicodeURL_isValidCharacterSequence: Bool {
        /// NSUInteger length = self.length;
        let length = self.length
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
                if 
        ///     }
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
}
