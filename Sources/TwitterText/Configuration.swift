//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

public class Configuration {
    let version: Int
    let maxWeightedTweetLength: Int
    let scale: Int
    let defaultWeight: Int
    let transformedURLLength: Int
    let emojiParsingEnabled: Bool
    let ranges: [WeightedRange]

    struct ConfigurationJSON: Decodable {
        let version: Int
        let maxWeightedTweetLength: Int
        let scale: Int
        let defaultWeight: Int
        let transformedURLLength: Int
        let emojiParsingEnabled: Bool?
        let ranges: [[String: Int]]
    }

    init?(jsonData: Data) {
        do {
            let config = try JSONDecoder().decode(ConfigurationJSON.self, from: jsonData)

            self.version = config.version
            self.maxWeightedTweetLength = config.maxWeightedTweetLength
            self.scale = config.scale
            self.defaultWeight = config.defaultWeight
            self.transformedURLLength = config.transformedURLLength
            self.emojiParsingEnabled = config.emojiParsingEnabled ?? false

            var ranges: [WeightedRange] = []

            for rangeDict in config.ranges {
                guard let start = rangeDict["start"],
                      let end = rangeDict["end"],
                      let charWeight = rangeDict["weight"] else {
                    return nil
                }
                var range = NSMakeRange(NSNotFound, NSNotFound)
                range.location = start
                range.length = end - range.location
                let charWeightObject = WeightedRange(range: range, weight: charWeight)
                ranges.append(charWeightObject)
            }
            self.ranges = ranges
        } catch let error {
            print(error)
            return nil
        }
    }

    public static func configuration(fromJSONResource jsonResource: String) -> Configuration? {
        guard let url = Bundle.module.url(forResource: jsonResource, withExtension: "json"), let jsonData = try? Data(contentsOf: url) else {
            return nil
        }

        return Configuration(jsonData: jsonData)
    }

    public static func configuration(from jsonString: String) -> Configuration? {
        let jsonData = Data(jsonString.utf8)

        return Configuration(jsonData: jsonData)
    }
}
