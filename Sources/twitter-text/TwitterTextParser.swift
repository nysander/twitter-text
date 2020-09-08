//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation

class TwitterTextParser {
    /// @property (nonatomic, readonly) TwitterTextConfiguration *configuration;
    let configuration: TwitterTextConfiguration

    /// + (instancetype)defaultParser NS_SWIFT_NAME(defaultParser());

    /// + (void)setDefaultParserWithConfiguration:(TwitterTextConfiguration *)configuration;
    static func setDefaultParser(withConfiguration configuration: TwitterTextConfiguration) {

    }

    /// - (instancetype)initWithConfiguration:(TwitterTextConfiguration *)configuration;
    init(withConfiguration configuration: TwitterTextConfiguration) {

    }

    /// - (TwitterTextParseResults *)parseTweet:(NSString *)text;
    func parseTweet(text: String) -> TwitterTextParseResults {
        return TwitterTextParseResults()
    }

    /// - (NSInteger)maxWeightedTweetLength;
    func maxWeightedTweetLength() -> Int {
        return 0
    }
}
