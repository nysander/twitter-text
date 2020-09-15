//
//  File.swift
//  
//
//  Created by Pawel Madej on 15/09/2020.
//

import Foundation

extension String {
    var isEmoji: Bool {
        do {
            let range = NSMakeRange(0, self.count)
            let regex = try NSRegularExpression(pattern: TwitterTextRegexp.emojiPattern, options: NSRegularExpression.Options(rawValue: 0))
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: range)

            return matches.count == 1
                && matches[0].range.location != NSNotFound
                && NSMaxRange(matches[0].range) <= self.count
        } catch {
            return false
        }
    }
}
