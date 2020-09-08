//
//  File.swift
//  
//
//  Created by Pawel Madej on 11/09/2020.
//

import Foundation

/// typedef NS_ENUM(NSUInteger, IFUnicodeURLConvertError) {
///     IFUnicodeURLConvertErrorNone             = 0,
///     IFUnicodeURLConvertErrorSTD3NonLDH       = 300,
///     IFUnicodeURLConvertErrorSTD3Hyphen       = 301,
///     IFUnicodeURLConvertErrorAlreadyEncoded   = 302,
///     IFUnicodeURLConvertErrorInvalidDNSLength = 303,
///     IFUnicodeURLConvertErrorCircleCheck      = 304
/// };

enum UnicodeURLConvertError: Int {
    case UnicodeURLConvertErrorNone             = 0
    case UnicodeURLConvertErrorSTD3NonLDH       = 300
    case UnicodeURLConvertErrorSTD3Hyphen       = 301
    case UnicodeURLConvertErrorAlreadyEncoded   = 302
    case UnicodeURLConvertErrorInvalidDNSLength = 303
    case UnicodeURLConvertErrorCircleCheck      = 30
}
