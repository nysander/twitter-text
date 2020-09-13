//
//  File.swift
//  
//
//  Created by Pawel Madej on 13/09/2020.
//

import Foundation
import XCTest
@testable import UnicodeURL


final class UnicodeURLTests: XCTestCase {
    func test() {
        XCTAssertTrue(true)
    }

    /// - (void)testURLWithStringWithNormalDomain
    func testURLWithStringWithNormalDomain() {
    /// NSURL *url = [NSURL URLWithString:@"https://www.google.com"];
        let url = URL(string: "https://www.google.com")!

        // CRASH
    /// XCTAssertEqualObjects([url unicodeAbsoluteString], @"https://www.google.com");
//        XCTAssertEqual(url.unicodeAbsoluteString, "https://www.google.com")
    /// XCTAssertEqualObjects([url absoluteString], @"https://www.google.com");
        XCTAssertEqual(url.absoluteString, "https://www.google.com")

        // CRASH
        /// XCTAssertEqualObjects([url unicodeHost], @"www.google.com");
//        XCTAssertEqual(url.unicodeHost, "https://www.google.com")
    }
}
