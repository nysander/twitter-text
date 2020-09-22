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
            let range = NSMakeRange(0, self.utf16.count)
            let regex = try NSRegularExpression(pattern: Regexp.emojiPattern, options: [])
            let matches = regex.matches(in: self, options: [], range: range)

            return matches.count == 1
                && matches[0].range.location != NSNotFound
                && NSMaxRange(matches[0].range) <= self.utf16.count
        } catch {
            return false
        }
    }
}
