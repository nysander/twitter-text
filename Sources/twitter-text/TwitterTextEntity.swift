//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation

class TwitterTextEntity {
    /// @property (nonatomic) TwitterTextEntityType type;
    var type: TwitterTextEntityType

    /// @property (nonatomic) NSRange range;
    var range: Range<>

    /// + (instancetype)entityWithType:(TwitterTextEntityType)type range:(NSRange)range;
    init(withType type: TwitterTextEntityType, range: Range<>) {
        self.type = type
        self.range = range
    }
}
