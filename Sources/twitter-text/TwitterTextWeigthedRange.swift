//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation

class TwitterTextWeightedRange {
    /// Contiguous unicode region
    ///
    /// @property (nonatomic, readonly) NSRange range;
    public let range: Range<Int>

    /// Weight for each unicode point in the region
    /// 
    /// @property (nonatomic, readonly) NSInteger weight;
    public let weight: Int
}
