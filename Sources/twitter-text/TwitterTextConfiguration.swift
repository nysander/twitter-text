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

    /// + (instancetype)configurationFromJSONString:(NSString *)jsonString;
    init(jsonString: String) {
        /// self = [super init];
        /// if (self) {
        ///     NSError *jsonError = nil;
        var jsonError: Error = nil
        ///     NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        var jsonData = try JSONEncoder().encode(jsonString)
        ///     NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
        let jsonDictionary = JSONSerialization().dic

        ///     _version = [jsonDictionary[@"version"] integerValue];
        version = jsonDictionary["version"] as Int
        ///     _maxWeightedTweetLength = [jsonDictionary[@"maxWeightedTweetLength"] integerValue];
        maxWeightedTweetLength = jsonDictionary["maxWeightedTweetLength"] as Int
        ///     _scale = [jsonDictionary[@"scale"] integerValue];
        scale = jsonDictionary["scale"] as Int
        ///     _defaultWeight = [jsonDictionary[@"defaultWeight"] integerValue];
        defaultWeight = jsonDictionary["defaultWeight"] as Int
        ///     _transformedURLLength = [jsonDictionary[@"transformedURLLength"] integerValue];
        transformedURLLength = jsonDictionary["transformedURLLength"] as Int
        ///     _emojiParsingEnabled = [jsonDictionary[@"emojiParsingEnabled"] boolValue];
        emojiParsingEnabled = jsonDictionary["emojiParsingEnabled"] as Bool
        ///     NSArray *jsonRanges = jsonDictionary[@"ranges"];
        let jsonRanges = jsonDictionary["ranges"]
        ///     NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:jsonRanges.count];
        var ranges: [TwitterTextWeightedRange]
        ///     for (NSDictionary *rangeDict in jsonRanges) {
        for rangeDict in jsonRanges {
        ///         NSRange range;
        ///         range.location = [rangeDict[@"start"] integerValue];
        ///         range.length = [rangeDict[@"end"] integerValue] - range.location;
        ///         NSInteger charWeight = [rangeDict[@"weight"] integerValue];
        ///         TwitterTextWeightedRange *charWeightObject = [[TwitterTextWeightedRange alloc] initWithRange:range weight:charWeight];
        ///         [ranges addObject:charWeightObject];
            var range: NSRange
            range.lowerBound = rangeDict["start"] as Int
            let charWeight = rangeDict["weight"] as Int
            let charWeightObject = TwitterTextWeightedRange(range: range, weight: charWeight)
            ranges.append(charWeightObject)
        ///     }
        }
        ///     _ranges = [ranges copy];
        self.ranges = ranges
        /// }
        /// return self;
    }

    /// + (instancetype)configurationFromJSONResource:(NSString *)jsonResource;
    public static func configuration(fromJSONResource jsonResource: String) {
        /// NSError *error = nil;

        /// NSString *sourceFile = [[NSBundle bundleForClass:self] pathForResource:jsonResource ofType:@"json"];
        /// NSString *jsonString = [NSString stringWithContentsOfFile:sourceFile encoding:NSUTF8StringEncoding error:&error];
        guard let sourceFile = Bundle().path(forResource: jsonResource, ofType: "json"),
              let url = URL(string: sourceFile),
              let jsonString = try? String(contentsOf: url, encoding: .utf8) else {
            return
        }
        /// return !error ? [self configurationFromJSONString:jsonString] : nil;
        self.configuration(fromJSONString: jsonString)
    }

    /// + (instancetype)configurationFromJSONString:(NSString *)jsonString
    public static func configuration(fromJSONString jsonString: String) {
        /// return [[TwitterTextConfiguration alloc] initWithJSONString:jsonString];
        _ = TwitterTextConfiguration(jsonString: jsonString)
    }
}
