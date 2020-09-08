//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

import Foundation

/// typedef NS_ENUM(NSUInteger, TwitterTextEntityType) {
///     TwitterTextEntityURL,
///     TwitterTextEntityScreenName,
///     TwitterTextEntityHashtag,
///     TwitterTextEntityListName,
///     TwitterTextEntitySymbol,
///     TwitterTextEntityTweetChar,
///     TwitterTextEntityTweetEmojiChar
/// };
enum TwitterTextEntityType: Int {
    case TwitterTextEntityURL
    case TwitterTextEntityScreenName
    case TwitterTextEntityHashtag
    case TwitterTextEntityListName
    case TwitterTextEntitySymbol
    case TwitterTextEntityTweetChar
    case TwitterTextEntityTweetEmojiCha
}
