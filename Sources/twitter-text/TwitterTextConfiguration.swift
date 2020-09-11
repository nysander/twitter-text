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

    init?(jsonString: String) {
        /// self = [super init];
        /// if (self) {
        ///     NSError *jsonError = nil;
        do {
        ///     NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            let jsonData = try JSONEncoder().encode(jsonString)
        ///     NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
            guard let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? Dictionary<String, Any>,
                  let version = jsonDictionary["version"] as? Int,
                  let maxWeightedTweetLength = jsonDictionary["maxWeightedTweetLength"] as? Int,
                  let scale = jsonDictionary["scale"] as? Int,
                  let defaultWeight = jsonDictionary["defaultWeight"] as? Int,
                  let transformedURLLength = jsonDictionary["transformedURLLength"] as? Int,
                  let emojiParsingEnabled = jsonDictionary["emojiParsingEnabled"] as? Bool,
                  let jsonRanges = jsonDictionary["ranges"] as? [[String:Int]] else {
                return
            }

        ///     _version = [jsonDictionary[@"version"] integerValue];
            self.version = version
        ///     _maxWeightedTweetLength = [jsonDictionary[@"maxWeightedTweetLength"] integerValue];
            self.maxWeightedTweetLength = maxWeightedTweetLength
        ///     _scale = [jsonDictionary[@"scale"] integerValue];
            self.scale = scale
        ///     _defaultWeight = [jsonDictionary[@"defaultWeight"] integerValue];
            self.defaultWeight = defaultWeight
        ///     _transformedURLLength = [jsonDictionary[@"transformedURLLength"] integerValue];
            self.transformedURLLength = transformedURLLength
        ///     _emojiParsingEnabled = [jsonDictionary[@"emojiParsingEnabled"] boolValue];
            self.emojiParsingEnabled = emojiParsingEnabled
        ///     NSArray *jsonRanges = jsonDictionary[@"ranges"];
//        let jsonRanges = jsonDictionary["ranges"]
        ///     NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:jsonRanges.count];
        var ranges: [TwitterTextWeightedRange] = []
        ///     for (NSDictionary *rangeDict in jsonRanges) {
        for rangeDict in jsonRanges {
        ///         NSRange range;
        ///         range.location = [rangeDict[@"start"] integerValue];
        ///         range.length = [rangeDict[@"end"] integerValue] - range.location;
        ///         NSInteger charWeight = [rangeDict[@"weight"] integerValue];
        ///         TwitterTextWeightedRange *charWeightObject = [[TwitterTextWeightedRange alloc] initWithRange:range weight:charWeight];
        ///         [ranges addObject:charWeightObject];
            guard let start = rangeDict["start"],
                  let end = rangeDict["end"],
                  let charWeight = rangeDict["weight"] else {
                return
            }
            var range = NSMakeRange(NSNotFound, NSNotFound)
            range.location = start
            range.length = end - range.location
//            let charWeight = rangeDict["weight"] as Int
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

    /// + (instancetype)configurationFromJSONResource:(NSString *)jsonResource;
    public static func configuration(fromJSONResource jsonResource: String) -> TwitterTextConfiguration? {
        /// NSError *error = nil;

        /// NSString *sourceFile = [[NSBundle bundleForClass:self] pathForResource:jsonResource ofType:@"json"];
        /// NSString *jsonString = [NSString stringWithContentsOfFile:sourceFile encoding:NSUTF8StringEncoding error:&error];
        guard let sourceFile = Bundle().path(forResource: jsonResource, ofType: "json"),
              let url = URL(string: sourceFile),
              let jsonString = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        /// return !error ? [self configurationFromJSONString:jsonString] : nil;
        return self.configuration(fromJSONString: jsonString)
    }

    /// + (instancetype)configurationFromJSONString:(NSString *)jsonString
    public static func configuration(fromJSONString jsonString: String) -> TwitterTextConfiguration? {
        /// return [[TwitterTextConfiguration alloc] initWithJSONString:jsonString];
        return TwitterTextConfiguration(jsonString: jsonString)
    }
}
