//  UnicodeURL
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: Apache Licence 2.0 (see LICENCE files for details)

import XCTest
@testable import UnicodeURL

final class UnicodeURLTests: XCTestCase {
    func testURLWithStringWithNormalDomain() {
        let url = URL(str: "https://www.google.com")

        XCTAssertEqual(url?.unicodeAbsoluteString, "https://www.google.com")
        XCTAssertEqual(url?.absoluteString, "https://www.google.com")
        XCTAssertEqual(url?.unicodeHost, "www.google.com")
    }

    func testURLWithUnicodeStringWithNormalDomain() {
        let url = URL(unicodeString: "https://www.google.com")

        XCTAssertEqual(url?.unicodeAbsoluteString, "https://www.google.com")
        XCTAssertEqual(url?.absoluteString, "https://www.google.com")
        XCTAssertEqual(url?.unicodeHost, "www.google.com")
    }

    func testURLWithStringWithJapaneseDomain() {
        let url = URL(str: "https://xn--eckwd4c7cu47r2wf.jp")

        XCTAssertEqual(url?.unicodeAbsoluteString, "https://ドメイン名例.jp")
        XCTAssertEqual(url?.absoluteString, "https://xn--eckwd4c7cu47r2wf.jp")
        XCTAssertEqual(url?.unicodeHost, "ドメイン名例.jp")
    }

    func testURLWithUnicodeStringWithJapaneseDomain() {
        let url = URL(unicodeString: "http://ドメイン名例.jp")
        XCTAssertEqual(url?.unicodeAbsoluteString, "http://ドメイン名例.jp")
        XCTAssertEqual(url?.absoluteString, "http://xn--eckwd4c7cu47r2wf.jp")
        XCTAssertEqual(url?.unicodeHost, "ドメイン名例.jp")
    }

    func testURLWithUnicodeStringWithEmojiDomain() {
        let url = URL(unicodeString: "https://😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com/😭😭")

        XCTAssertEqual(url?.unicodeAbsoluteString, "https://😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com/%F0%9F%98%AD%F0%9F%98%AD")
        XCTAssertEqual(url?.absoluteString, "https://xn--rs8haaaa34raa89aaadaa.com/%F0%9F%98%AD%F0%9F%98%AD")
        XCTAssertEqual(url?.unicodeHost, "😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com")
    }

    func testURLWithUnicodeStringWithInvalidLongUnicodeDomain() {
        let url = URL(unicodeString: "http://あいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいう.com")

        XCTAssertNil(url)
    }

    func testDecodeUnicodeDomainStringWithNormalDomain() {
        let decodedDomain = URL.decode(unicodeDomain: "www.google.com")

        XCTAssertEqual(decodedDomain, "www.google.com")
    }

    func testDecodeUnicodeDomainStringWithTCO() {
        let decodedDomain = URL.decode(unicodeDomain: "t.co")

        XCTAssertEqual(decodedDomain, "t.co")
    }

    func testDecodeUnicodeDomainStringWithJapaneseDomain() {
        let decodedDomain = URL.decode(unicodeDomain: "xn--eckwd4c7cu47r2wf.jp")

        XCTAssertEqual(decodedDomain, "ドメイン名例.jp")
    }

    func testDecodeUnicodeDomainStringWithEmojiDomain() {
        let decodedDomain = URL.decode(unicodeDomain: "xn--rs8haaaa34raa89aaadaa.com")

        XCTAssertEqual(decodedDomain, "😭😭😭😂😂😂😭😭😭💯💯💯💯💯.com")
    }

    func testDecodeUnicodeDomainStringWithInvalidPunycodeInternational() {
        let decodedDomain = URL.decode(unicodeDomain: "xn--みんな.com")

        XCTAssertEqual(decodedDomain, "xn--みんな.com")
    }

    func testDecodeUnicodeDomainStringWithInvalidPunycode() {
        // This looks strange. But this is the current library spec.
        let decodedDomain = URL.decode(unicodeDomain: "xn--0.com")

        XCTAssertEqual(decodedDomain, ".com")
    }

    func testDecodeUnicodeDomainStringWithInvalidInternationalDomain() {
        // This looks strange. But this is the current library spec.
        let decodedDomain = URL.decode(unicodeDomain: "www.xn--l8j3933d.com")

        XCTAssertEqual(decodedDomain, "www..com")
    }
}
