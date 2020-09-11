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

enum IFUnicodeURLConvertError: Int {
    case IFUnicodeURLConvertErrorNone             = 0
    case IFUnicodeURLConvertErrorSTD3NonLDH       = 300
    case IFUnicodeURLConvertErrorSTD3Hyphen       = 301
    case IFUnicodeURLConvertErrorAlreadyEncoded   = 302
    case IFUnicodeURLConvertErrorInvalidDNSLength = 303
    case IFUnicodeURLConvertErrorCircleCheck      = 30
}
