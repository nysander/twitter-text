//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

public class ParseResults {
    /// The adjust tweet length based on char weights.
    public let weightedLength: Int

    /// Compute true weightedLength by weightedLength/permillage
    public private(set) var permillage: Int

    /// If the tweet is valid or not.
    public let isValid: Bool

    /// Text range that is visible
    public let displayTextRange: NSRange

    /// Text range that is valid under Twitter
    public let validDisplayTextRange: NSRange

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

    func description() -> String {
        return "weightedLength: \(weightedLength), permillage: \(permillage), "
            + "isValid: \(isValid), displayTextRange: \(displayTextRange), "
            + "validDisplayTextRange: \(validDisplayTextRange)"
    }
}
