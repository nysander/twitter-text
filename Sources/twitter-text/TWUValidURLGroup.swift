//
//  File.swift
//  
//
//  Created by Pawel Madej on 08/09/2020.
//

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
