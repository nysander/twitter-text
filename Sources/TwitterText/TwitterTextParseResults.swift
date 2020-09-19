//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

public class TwitterTextParseResults {
    /// The adjust tweet length based on char weights.
    ///
    /// @property (nonatomic, readonly) NSInteger weightedLength;
    public let weightedLength: Int

    /// Compute true weightedLength by weightedLength/permillage
    ///
    /// @property (nonatomic, readonly) NSInteger permillage;
    public private(set) var permillage: Int

    /// If the tweet is valid or not.
    ///
    /// @property (nonatomic, readonly) BOOL isValid;
    public let isValid: Bool

    /// Text range that is visible
    ///
    /// @property (nonatomic, readonly) NSRange displayTextRange;
    public let displayTextRange: NSRange

    /// Text range that is valid under Twitter
    ///
    /// @property (nonatomic, readonly) NSRange validDisplayTextRange;
    public let validDisplayTextRange: NSRange

    /// - (instancetype)initWithWeightedLength:(NSInteger)length permillage:(NSInteger)permillage valid:(BOOL)valid displayRange:(NSRange)displayRange validRange:(NSRange)validRange;
    public init(weightedLength length: Int,
                permillage: Int,
                valid: Bool,
                displayRange: NSRange,
                validRange: NSRange) {
        self.weightedLength = length
        self.permillage = permillage
        self.isValid = valid
        self.displayTextRange = displayRange
        self.validDisplayTextRange = validRange
    }

    /// - (NSString *)description
    func description() -> String {
        /// return [NSString stringWithFormat:@"weightedLength: %ld, permillage: %ld, isValid: %d, displayTextRange: %@, validDisplayTextRange: %@", (long)_weightedLength, (long)_permillage, _isValid, NSStringFromRange(_displayTextRange), NSStringFromRange(_validDisplayTextRange)]; // TODO: when no longer supporting 32-bit devices, remove (long) casts
        return "weightedLength: \(weightedLength), permillage: \(permillage), isValid: \(isValid), displayTextRange: \(displayTextRange), validDisplayTextRange: \(validDisplayTextRange)"
    }
}
