//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

public class TwitterTextEntity {
    var type: TwitterTextEntityType
    var range: NSRange

    public init(withType type: TwitterTextEntityType, range: NSRange) {
        self.type = type
        self.range = range
    }
}
