//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation

public class TwitterTextWeightedRange {
    /// Contiguous unicode region
    ///
    /// @property (nonatomic, readonly) NSRange range;
    public let range: NSRange

    /// Weight for each unicode point in the region
    /// 
    /// @property (nonatomic, readonly) NSInteger weight;
    public let weight: Int

    /// - (instancetype)initWithRange:(NSRange)range weight:(NSInteger)weight
    init(range: NSRange, weight: Int) {
        ///self = [super init];
        ///if (self) {
        ///    _range = range;
        ///    _weight = weight;
        ///}
        /// return self;
        self.range = range
        self.weight = weight
    }
}
