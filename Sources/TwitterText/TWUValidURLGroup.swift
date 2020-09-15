//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

/// typedef NS_ENUM(NSInteger, TWUValidURLGroup) {
///     TWUValidURLGroupAll = 1,
///     TWUValidURLGroupPreceding,
///     TWUValidURLGroupURL,
///     TWUValidURLGroupProtocol,
///     TWUValidURLGroupDomain,
///     TWUValidURLGroupPort,
///     TWUValidURLGroupPath,
///     TWUValidURLGroupQueryString
/// };
enum TWUValidURLGroup: Int {
    case TWUValidURLGroupAll = 1
    case TWUValidURLGroupPreceding
    case TWUValidURLGroupURL
    case TWUValidURLGroupProtocol
    case TWUValidURLGroupDomain
    case TWUValidURLGroupPort
    case TWUValidURLGroupPath
    case TWUValidURLGroupQueryString
}
