//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation

class TwitterTextConfiguration {
    /// @property (nonatomic, readonly) NSInteger version;
    let version: Int

    /// @property (nonatomic, readonly) NSInteger /// maxWeightedTweetLength;
    let maxWeightedTweetLength: Int

    /// @property (nonatomic, readonly) NSInteger scale;
    let scale: Int

    /// @property (nonatomic, readonly) NSInteger defaultWeight;
    let defaultWeight: Int

    /// @property (nonatomic, readonly) NSInteger transformedURLLength;
    let transformedURLLength: Int

    /// @property (nonatomic, readonly, getter=isEmojiParsingEnabled) /// BOOL emojiParsingEnabled;
    let emojiParsingEnabled: Bool

    /// @property (nonatomic, readonly) NSArray<TwitterTextWeightedRange *> *ranges;
    let ranges: [TwitterTextWeightedRange]

    /// + (instancetype)configurationFromJSONResource:(NSString *)jsonResource;
    public init(jsonResource: String) {

    }

    /// + (instancetype)configurationFromJSONString:(NSString *)jsonString;
    public init(jsonString: String) {

    }
}
