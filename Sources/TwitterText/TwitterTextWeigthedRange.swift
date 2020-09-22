//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

public class TwitterTextWeightedRange {
    /// Contiguous unicode region
    public let range: NSRange

    /// Weight for each unicode point in the region
    public let weight: Int

    init(range: NSRange, weight: Int) {
        self.range = range
        self.weight = weight
    }
}
