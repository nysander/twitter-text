//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import Foundation

enum ValidURLGroup: Int {
    case all = 1
    case preceding
    case url
    case urlProtocol
    case domain
    case port
    case path
    case queryString
}
