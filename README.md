<h1 align="center">twitter-text</h1>

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
    <img src="https://img.shields.io/github/workflow/status/nysander/twitter-text/ci" alt="Github Actions">
</p>
<p align="center">
<a href="https://swiftpackageindex.com/nysander/twitter-text">
<img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnysander%2Ftwitter-text%2Fbadge%3Ftype%3Dswift-versions">
</a>
<a href="https://swiftpackageindex.com/nysander/twitter-text">
<img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnysander%2Ftwitter-text%2Fbadge%3Ftype%3Dplatforms">
</a>
</p>
<br>

This is the Swift implementation of the twitter-text parsing
library. The library has methods to parse Tweets and calculate length,
validity, parse @mentions, #hashtags, URLs, and more.

## Setup


Add twitter-text directly to your Package.swift file:

```
dependencies: [
    // ...
    .package(url: "https://github.com/nysander/twitter-text.git", from:"0.0.1"),
],
targets: [
.target(name: "Your App", dependencies: [
    /// ...
    .product(name: "twitter-text", package: "twitter-text"),
]),
```
or via Xcode:

search for `https://github.com/nysander/twitter-text.git` repository 

![Xcode setup](https://github.com/nysander/twitter-text/tree/main/docs/Xcode-setup.png)

## Conformance tests

To run the Conformance test suite from the command line:

```
% swift test --enable-test-discovery
```

You can also run the tests from within Xcode itself. Open the project
file and run the tests are you normally would (Cmd-U).

## API

twitter-text 2.0 introduces configuration files that define how Tweets
are parsed for length. This allows for backwards compatibility and
flexibility going forward. Old-style traditional 140-character parsing
is defined by the v1.json configuration file, whereas v2.json is
updated for "weighted" Tweets where ranges of Unicode code points can
have independent weights aside from the default weight. The sum of all
code points, each weighted appropriately, should not exceed the max
weighted length.

Some old methods from twitter-text 1.0 have been marked deprecated,
such as the various `+tweetLength:` methods. The new API is based on the
following method, `-parseTweet:`

```
- TwitterTextParser parseTweet(text:)
```

This method takes a string as input and returns a results object that
contains information about the string. `TwitterTextParseResults`
includes:

* `weightedLength: Int`: the overall length of the tweet with code points
weighted per the ranges defined in the configuration file.

* `permillage: Int`: indicates the proportion (per thousand) of the weighted
length in comparison to the max weighted length. A value > 1000
indicates input text that is longer than the allowable maximum.

* `isValid: Bool`: indicates if input text length corresponds to a valid
result.

* `displayTextRange: NSRange`: An array of two unicode code point
indices identifying the inclusive start and exclusive end of the
displayable content of the Tweet. For more information, see
the description of `display_text_range` here:
[Tweet updates](https://developer.twitter.com/en/docs/tweets/tweet-updates)

* `validDisplayTextRange: NSRange`: An array of two unicode code point
indices identifying the inclusive start and exclusive end of the valid
content of the Tweet. For more information on the extended Tweet
payload see [Tweet updates](https://developer.twitter.com/en/docs/tweets/tweet-updates)

## Issues

Have a bug? Please create an issue here on GitHub!

<https://github.com/nysander/twitter-text/issues>

## Authors

* Paweł Madej - [Twitter @PawelMadejCK](https://twitter.com/PawelMadejCK) - [GitHub](https://github.com/nysander)
* Rizwan Mohamed Ibrahim - [Twitter @rizzu26](https://twitter.com/rizzu26) - [GitHub](https://github.com/rizwankce)

## Source

This library was directly based upon its Objective-C implementation which can be found in [twitter/twitter-text](https://github.com/twitter/twitter-text) repository and which was written by [Satoshi Nakagawa](https://github.com/psychs), [David LaMacchia](https://github.com/dlamacchia) and [Keh-Li Sheng](https://github.com/kehli)

Version 3.1.0 was used as reference. All test case JSON files used in this library are directly copied from said repository to keep consistency and being sure that results are the same. 

## License

Copyright 2020 Paweł Madej, and other contributors

Licensed under the [MIT License](https://github.com/nysander/twitter-text/blob/main/LICENSE)
