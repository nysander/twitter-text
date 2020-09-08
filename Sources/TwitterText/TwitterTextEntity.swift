//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

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
