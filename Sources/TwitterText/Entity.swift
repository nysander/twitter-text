//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

public class Entity {
    var type: EntityType
    var range: NSRange

    public init(withType type: EntityType, range: NSRange) {
        self.type = type
        self.range = range
    }
}
