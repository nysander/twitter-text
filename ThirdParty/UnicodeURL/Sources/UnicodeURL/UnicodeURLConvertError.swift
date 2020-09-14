//  UnicodeURL
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: Apache Licence 2.0 (see LICENCE files for details)

import Foundation

enum UnicodeURLConvertError: Int {
    case UnicodeURLConvertErrorNone             = 0
    case UnicodeURLConvertErrorSTD3NonLDH       = 300
    case UnicodeURLConvertErrorSTD3Hyphen       = 301
    case UnicodeURLConvertErrorAlreadyEncoded   = 302
    case UnicodeURLConvertErrorInvalidDNSLength = 303
    case UnicodeURLConvertErrorCircleCheck      = 30
}
