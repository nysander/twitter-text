//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation


class TwitterTextParseResults {
    /// The adjust tweet length based on char weights.
    ///
    /// @property (nonatomic, readonly) NSInteger weightedLength;
    let weightedLength: Int

    /// Compute true weightedLength by weightedLength/permillage
    ///
    /// @property (nonatomic, readonly) NSInteger permillage;
    let permillage: Int

    /// If the tweet is valid or not.
    ///
    /// @property (nonatomic, readonly) BOOL isValid;
    let isValid: Bool

    /// Text range that is visible
    ///
    /// @property (nonatomic, readonly) NSRange displayTextRange;
    let displayTextRange: Range<>

    /// Text range that is valid under Twitter
    ///
    /// @property (nonatomic, readonly) NSRange validDisplayTextRange;
    let validDisplayTextRange: Range<>

    /// - (instancetype)initWithWeightedLength:(NSInteger)length permillage:(NSInteger)permillage valid:(BOOL)valid displayRange:(NSRange)displayRange validRange:(NSRange)validRange;
    init(weightedLength length: Int,
         permillage: Int,
         valid: Bool,
         displayRange: Range<>,
         validRange: Range<>) {
        self.weightedLength = length
        self.permillage = permillage
        self.isValid = valid
        displayTextRange = displayRange
        validRange = validDisplayTextRange

    }
}
