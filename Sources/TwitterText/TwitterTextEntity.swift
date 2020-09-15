//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

public class TwitterTextEntity {
    /// @property (nonatomic) TwitterTextEntityType type;
    var type: TwitterTextEntityType

    /// @property (nonatomic) NSRange range;
    var range: NSRange

    /// + (instancetype)entityWithType:(TwitterTextEntityType)type range:(NSRange)range;
    public init(withType type: TwitterTextEntityType, range: NSRange) {
        self.type = type
        self.range = range
    }
}
