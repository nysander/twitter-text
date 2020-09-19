//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

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

    struct Configuration: Decodable {
        let version: Int
        let maxWeightedTweetLength: Int
        let scale: Int
        let defaultWeight: Int
        let transformedURLLength: Int
        let emojiParsingEnabled: Bool?
        let ranges: [[String: Int]]
    }

    init?(jsonData: Data) {
        /// self = [super init];
        /// if (self) {
        ///     NSError *jsonError = nil;
        do {
        ///     NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

        ///     NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];

            let config = try JSONDecoder().decode(Configuration.self, from: jsonData)
        ///     _version = [jsonDictionary[@"version"] integerValue];
            self.version = config.version
        ///     _maxWeightedTweetLength = [jsonDictionary[@"maxWeightedTweetLength"] integerValue];
            self.maxWeightedTweetLength = config.maxWeightedTweetLength
        ///     _scale = [jsonDictionary[@"scale"] integerValue];
            self.scale = config.scale
        ///     _defaultWeight = [jsonDictionary[@"defaultWeight"] integerValue];
            self.defaultWeight = config.defaultWeight
        ///     _transformedURLLength = [jsonDictionary[@"transformedURLLength"] integerValue];
            self.transformedURLLength = config.transformedURLLength
        ///     _emojiParsingEnabled = [jsonDictionary[@"emojiParsingEnabled"] boolValue];
            self.emojiParsingEnabled = config.emojiParsingEnabled ?? false
        ///     NSArray *jsonRanges = jsonDictionary[@"ranges"];
//        let jsonRanges = jsonDictionary["ranges"]
        ///     NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:jsonRanges.count];
        var ranges: [TwitterTextWeightedRange] = []
        ///     for (NSDictionary *rangeDict in jsonRanges) {
            for rangeDict in config.ranges {
        ///         NSRange range;
        ///         range.location = [rangeDict[@"start"] integerValue];
        ///         range.length = [rangeDict[@"end"] integerValue] - range.location;
        ///         NSInteger charWeight = [rangeDict[@"weight"] integerValue];
        ///         TwitterTextWeightedRange *charWeightObject = [[TwitterTextWeightedRange alloc] initWithRange:range weight:charWeight];
        ///         [ranges addObject:charWeightObject];
            guard let start = rangeDict["start"],
                  let end = rangeDict["end"],
                  let charWeight = rangeDict["weight"] else {
                return nil
            }
            var range = NSMakeRange(NSNotFound, NSNotFound)
            range.location = start
            range.length = end - range.location
            let charWeightObject = TwitterTextWeightedRange(range: range, weight: charWeight)
            ranges.append(charWeightObject)
        ///     }
        }
        ///     _ranges = [ranges copy];
        self.ranges = ranges
        /// }
        /// return self;
        } catch let error {
            print(error)
            return nil
        }
    }

    public static func configuration(fromJSONResource jsonResource: String) -> TwitterTextConfiguration? {
        let url = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("config/\(jsonResource).json")
        guard let jsonData = try? Data(contentsOf: url) else {
            return nil
        }

        return self.configuration(from: jsonData)
    }

    public static func configuration(from jsonString: String) -> TwitterTextConfiguration? {
        let jsonData = Data(jsonString.utf8)

        return TwitterTextConfiguration(jsonData: jsonData)
    }

    public static func configuration(from jsonData: Data) -> TwitterTextConfiguration? {
        return TwitterTextConfiguration(jsonData: jsonData)
    }
}
