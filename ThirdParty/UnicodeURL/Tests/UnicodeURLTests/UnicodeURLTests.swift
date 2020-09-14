//
//  UnicodeURLTests.swift
//  
//
//  Created by Pawel Madej on 13/09/2020.
//

import XCTest
@testable import UnicodeURL

final class UnicodeURLTests: XCTestCase {
//    PASS
    /// - (void)testURLWithStringWithNormalDomain
    func testURLWithStringWithNormalDomain() {
        /// NSURL *url = [NSURL URLWithString:@"https://www.google.com"];
        let url = URL(str: "https://www.google.com")

        /// XCTAssertEqualObjects([url unicodeAbsoluteString], @"https://www.google.com");
        XCTAssertEqual(url?.unicodeAbsoluteString, "https://www.google.com")
        /// XCTAssertEqualObjects([url absoluteString], @"https://www.google.com");
        XCTAssertEqual(url?.absoluteString, "https://www.google.com")
        /// XCTAssertEqualObjects([url unicodeHost], @"www.google.com");
        XCTAssertEqual(url?.unicodeHost, "www.google.com")
    }

//    CRASH
    /// - (void)testURLWithUnicodeStringWithNormalDomain
    func testURLWithUnicodeStringWithNormalDomain() {
        /// NSURL *url = [NSURL URLWithUnicodeString:@"https://www.google.com"];
        let url = URL(unicodeString: "https://www.google.com")

        ///XCTAssertEqualObjects([url unicodeAbsoluteString], @"https://www.google.com");
        XCTAssertEqual(url?.unicodeAbsoluteString, "https://www.google.com")
        ///XCTAssertEqualObjects([url absoluteString], @"https://www.google.com");
        XCTAssertEqual(url?.absoluteString, "https://www.google.com")
        ///XCTAssertEqualObjects([url unicodeHost], @"www.google.com");
        XCTAssertEqual(url?.unicodeHost, "www.google.com")
    }

//    FAIL
    /// - (void)testURLWithStringWithJapaneseDomain
    func testURLWithStringWithJapaneseDomain() {
        /// NSURL *url = [NSURL URLWithString:@"https://xn--eckwd4c7cu47r2wf.jp"];
        let url = URL(str: "https://xn--eckwd4c7cu47r2wf.jp")

        /// XCTAssertEqualObjects([url unicodeAbsoluteString], @"https://ドメイン名例.jp");
        XCTAssertEqual(url?.unicodeAbsoluteString, "https://ドメイン名例.jp")
        /// XCTAssertEqualObjects([url absoluteString], @"https://xn--eckwd4c7cu47r2wf.jp");
        XCTAssertEqual(url?.absoluteString, "https://xn--eckwd4c7cu47r2wf.jp")
        /// XCTAssertEqualObjects([url unicodeHost], @"ドメイン名例.jp");
        XCTAssertEqual(url?.unicodeHost, "ドメイン名例.jp")
    }

//    CRASH
    /// - (void)testURLWithUnicodeStringWithJapaneseDomain
    func testURLWithUnicodeStringWithJapaneseDomain() {
        /// NSURL *url = [NSURL URLWithUnicodeString:@"http://ドメイン名例.jp"];
        let url = URL(unicodeString: "http://ドメイン名例.jp")

        /// XCTAssertEqualObjects([url unicodeAbsoluteString], @"http://ドメイン名例.jp");
        XCTAssertEqual(url?.unicodeAbsoluteString, "http://ドメイン名例.jp")
        /// XCTAssertEqualObjects([url absoluteString], @"http://xn--eckwd4c7cu47r2wf.jp");
        XCTAssertEqual(url?.absoluteString, "http://xn--eckwd4c7cu47r2wf.jp")
        /// XCTAssertEqualObjects([url unicodeHost], @"ドメイン名例.jp");
        XCTAssertEqual(url?.unicodeHost, "ドメイン名例.jp")
    }

//    CRASH
    /// - (void)testURLWithUnicodeStringWithEmojiDomain
    func testURLWithUnicodeStringWithEmojiDomain() {
        /// NSURL *url = [NSURL URLWithUnicodeString:@"https://😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com/😭😭"];
        let url = URL(unicodeString: "https://😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com/😭😭")

        /// XCTAssertEqualObjects([url unicodeAbsoluteString], @"https://😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com/%F0%9F%98%AD%F0%9F%98%AD");
        XCTAssertEqual(url?.unicodeAbsoluteString, "https://😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com/%F0%9F%98%AD%F0%9F%98%AD")
        /// XCTAssertEqualObjects([url absoluteString], @"https://xn--rs8haaaa34raa89aaadaa.com/%F0%9F%98%AD%F0%9F%98%AD");
        XCTAssertEqual(url?.absoluteString, "https://xn--rs8haaaa34raa89aaadaa.com/%F0%9F%98%AD%F0%9F%98%AD")
        /// XCTAssertEqualObjects([url unicodeHost], @"😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com");
        XCTAssertEqual(url?.unicodeHost, "😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com")
    }

//    CRASH
    /// - (void)testURLWithUnicodeStringWithInvalidLongUnicodeDomain
    func testURLWithUnicodeStringWithInvalidLongUnicodeDomain() {
        /// NSURL *url = [NSURL URLWithUnicodeString:@"http://あいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいう.com"];
        let url = URL(unicodeString: "http://あいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいう.com")

        /// XCTAssertNil(url);
        XCTAssertNil(url)
    }

//    PASS
    /// - (void)testDecodeUnicodeDomainStringWithNormalDomain
    func testDecodeUnicodeDomainStringWithNormalDomain() {
        /// NSString *decodedDomain = [NSURL decodeUnicodeDomainString:@"www.google.com"];
        let decodedDomain = URL.decode(unicodeDomain: "www.google.com")
        /// XCTAssertEqualObjects(decodedDomain, @"www.google.com");
        XCTAssertEqual(decodedDomain, "www.google.com")
    }

//    CRASH
    /// - (void)testDecodeUnicodeDomainStringWithTCO
    func testDecodeUnicodeDomainStringWithTCO() {
        /// NSString *decodedDomain = [NSURL decodeUnicodeDomainString:@"t.co"];
        let decodedDomain = URL.decode(unicodeDomain: "t.co")
        /// XCTAssertEqualObjects(decodedDomain, @"t.co");
        XCTAssertEqual(decodedDomain, "t.co")
    }

//    FAIL
    /// - (void)testDecodeUnicodeDomainStringWithJapaneseDomain
    func testDecodeUnicodeDomainStringWithJapaneseDomain() {
        /// NSString *decodedDomain = [NSURL decodeUnicodeDomainString:@"xn--eckwd4c7cu47r2wf.jp"];
        let decodedDomain = URL.decode(unicodeDomain: "xn--eckwd4c7cu47r2wf.jp")

        /// XCTAssertEqualObjects(decodedDomain, @"ドメイン名例.jp");
        XCTAssertEqual(decodedDomain, "ドメイン名例.jp")
    }

//    FAIL
    /// - (void)testDecodeUnicodeDomainStringWithEmojiDomain
    func testDecodeUnicodeDomainStringWithEmojiDomain() {
        /// NSString *decodedDomain = [NSURL decodeUnicodeDomainString:@"xn--rs8haaaa34raa89aaadaa.com"];
        let decodedDomain = URL.decode(unicodeDomain: "xn--rs8haaaa34raa89aaadaa.com")
        /// XCTAssertEqualObjects(decodedDomain, @"😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com");
        XCTAssertEqual(decodedDomain, "😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com")
    }

//    PASS
    /// - (void)testDecodeUnicodeDomainStringWithInvalidPunycodeInternational
    func testDecodeUnicodeDomainStringWithInvalidPunycodeInternational() {
        /// NSString *decodedDomain = [NSURL decodeUnicodeDomainString:@"xn--みんな.com"];
        let decodedDomain = URL.decode(unicodeDomain: "xn--みんな.com")
        /// XCTAssertEqualObjects(decodedDomain, @"xn--みんな.com");
        XCTAssertEqual(decodedDomain, "xn--みんな.com")
    }

//    FAIL
    /// - (void)testDecodeUnicodeDomainStringWithInvalidPunycode
    func testDecodeUnicodeDomainStringWithInvalidPunycode() {
        // This looks strange. But this is the current library spec.
        /// NSString *decodedDomain = [NSURL decodeUnicodeDomainString:@"xn--0.com"];
        let decodedDomain = URL.decode(unicodeDomain: "xn--0.com")
        /// XCTAssertEqualObjects(decodedDomain, @".com");
        XCTAssertEqual(decodedDomain, ".com")
    }

//    FAIL
    /// - (void)testDecodeUnicodeDomainStringWithInvalidInternationalDomain
    func testDecodeUnicodeDomainStringWithInvalidInternationalDomain() {
        // This looks strange. But this is the current library spec.
        /// NSString *decodedDomain = [NSURL decodeUnicodeDomainString:@"www.xn--l8j3933d.com"];
        let decodedDomain = URL.decode(unicodeDomain: "www.xn--l8j3933d.com")
        /// XCTAssertEqualObjects(decodedDomain, @"www..com");
        XCTAssertEqual(decodedDomain, "www..com")
    }
}
