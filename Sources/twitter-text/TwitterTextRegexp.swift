//
//  File.swift
//  
//
//  Created by Pawel Madej on 09/09/2020.
//

import Foundation

enum TwitterTextRegexp {
    /// #define TWUControlCharacters        @"\\u0009-\\u000D"
    static let TWUControlCharacters         = "\\u0009-\\u000D"
    /// #define TWUSpace                    @"\\u0020"
    static let TWUSpace                     = "\\u0020"
    /// #define TWUControl85                @"\\u0085"
    static let TWUControl85                 = "\\u0085"
    /// #define TWUNoBreakSpace             @"\\u00A0"
    static let TWUNoBreakSpace              = "\\u00A0"
    /// #define TWUOghamBreakSpace          @"\\u1680"
    static let TWUOghamBreakSpace           = "\\u1680"
    /// #define TWUMongolianVowelSeparator  @"\\u180E"
    static let TWUMongolianVowelSeparator   = "\\u180E"
    /// #define TWUWhiteSpaces              @"\\u2000-\\u200A"
    static let TWUWhiteSpaces               = "\\u2000-\\u200A"
    /// #define TWULineSeparator            @"\\u2028"
    static let TWULineSeparator             = "\\u2028"
    /// #define TWUParagraphSeparator       @"\\u2029"
    static let TWUParagraphSeparator        = "\\u2029"
    /// #define TWUNarrowNoBreakSpace       @"\\u202F"
    static let TWUNarrowNoBreakSpace        = "\\u202F"
    /// #define TWUMediumMathematicalSpace  @"\\u205F"
    static let TWUMediumMathematicalSpace   = "\\u205F"
    /// #define TWUIdeographicSpace         @"\\u3000"
    static let TWUIdeographicSpace          = "\\u3000"

    /// #define TWUUnicodeSpaces \
    ///     TWUControlCharacters \
    ///     TWUSpace \
    ///     TWUControl85 \
    ///     TWUNoBreakSpace \
    ///     TWUOghamBreakSpace \
    ///     TWUMongolianVowelSeparator \
    ///     TWUWhiteSpaces \
    ///     TWULineSeparator \
    ///     TWUParagraphSeparator \
    ///     TWUNarrowNoBreakSpace \
    ///     TWUMediumMathematicalSpace \
    ///     TWUIdeographicSpace
    static let TWUUnicodeSpaces = "\(TWUControlCharacters)\(TWUSpace)\(TWUControl85)"
        + "\(TWUNoBreakSpace)\(TWUOghamBreakSpace)\(TWUMongolianVowelSeparator)"
        + "\(TWUWhiteSpaces)\(TWULineSeparator)\(TWUParagraphSeparator)"
        + "\(TWUNarrowNoBreakSpace)\(TWUMediumMathematicalSpace)\(TWUIdeographicSpace)"

    /// #define TWUUnicodeALM               @"\\u061C"
    static let TWUUnicodeALM                = "\\u061C"
    /// #define TWUUnicodeLRM               @"\\u200E"
    static let TWUUnicodeLRM                = "\\u200E"
    /// #define TWUUnicodeRLM               @"\\u200F"
    static let TWUUnicodeRLM                = "\\u200F"
    /// #define TWUUnicodeLRE               @"\\u202A"
    static let TWUUnicodeLRE                = "\\u202A"
    /// #define TWUUnicodeRLE               @"\\u202B"
    static let TWUUnicodeRLE                = "\\u202B"
    /// #define TWUUnicodePDF               @"\\u202C"
    static let TWUUnicodePDF                = "\\u202C"
    /// #define TWUUnicodeLRO               @"\\u202D"
    static let TWUUnicodeLRO                = "\\u202D"
    /// #define TWUUnicodeRLO               @"\\u202E"
    static let TWUUnicodeRLO                = "\\u202E"
    /// #define TWUUnicodeLRI               @"\\u2066"
    static let TWUUnicodeLRI                = "\\u2066"
    /// #define TWUUnicodeRLI               @"\\u2067"
    static let TWUUnicodeRLI                = "\\u2067"
    /// #define TWUUnicodeFSI               @"\\u2068"
    static let TWUUnicodeFSI                = "\\u2068"
    /// #define TWUUnicodePDI               @"\\u2069"

    /// #define TWUUnicodeDirectionalCharacters \
    ///     TWUUnicodeALM \
    ///     TWUUnicodeLRM \
    ///     TWUUnicodeRLM \
    ///     TWUUnicodeLRE \
    ///     TWUUnicodeRLE \
    ///     TWUUnicodePDF \
    ///     TWUUnicodeLRO \
    ///     TWUUnicodeRLO \
    ///     TWUUnicodeLRI \
    ///     TWUUnicodeRLI \
    ///     TWUUnicodeFSI \
    ///     TWUUnicodePDI
    static let TWUUnicodeDirectionalCharacters = "\(TWUUnicodeALM)\(TWUUnicodeLRM)"
        + "\(TWUUnicodeLRE)\(TWUUnicodeRLE)\(TWUUnicodePDF)\(TWUUnicodeLRO)"
        + "\(TWUUnicodeRLO)\(TWUUnicodeLRI)\(TWUUnicodeRLI)\(TWUUnicodeFSI)"

    /// #define TWUInvalidCharacters        @"\\uFFFE\\uFEFF\\uFFFF"
    static let TWUInvalidCharacters         = "\\uFFFE\\uFEFF\\uFFFF"
    /// #define TWUInvalidCharactersPattern @"[" TWUInvalidCharacters @"]"
    static let TWUInvalidCharactersPattern = "[\(TWUInvalidCharacters)]"

    /// #define TWULatinAccents \
    ///     @"\\u00C0-\\u00D6\\u00D8-\\u00F6\\u00F8-\\u00FF\\u0100-\\u024F\\u0253-\\u0254\\u0256-\\u0257\\u0259\\u025b\\u0263\\u0268\\u026F\\u0272\\u0289\\u02BB\\u1E00-\\u1EFF"
    static let TWULatinAccents = "\\u00C0-\\u00D6\\u00D8-\\u00F6\\u00F8-\\u00FF\\u0100-\\u024F\\u0253-\\u0254\\u0256-\\u0257\\u0259\\u025b\\u0263\\u0268\\u026F\\u0272\\u0289\\u02BB\\u1E00-\\u1EFF"

    // MARK: - Hashtag

    /// #define TWUPunctuationChars                             @"-_!\"#$%&'\\(\\)*+,./:;<=>?@\\[\\]^`\\{|}~"
    static let TWUPunctuationChars                             = "-_!\"#$%&'\\(\\)*+,./:;<=>?@\\[\\]^`\\{|}~"
    /// #define TWUPunctuationCharsWithoutHyphen                @"_!\"#$%&'\\(\\)*+,./:;<=>?@\\[\\]^`\\{|}~"
    static let TWUPunctuationCharsWithoutHyphen                = "_!\"#$%&'\\(\\)*+,./:;<=>?@\\[\\]^`\\{|}~"
    /// #define TWUPunctuationCharsWithoutHyphenAndUnderscore   @"!\"#$%&'\\(\\)*+,./:;<=>?@\\[\\]^`\\{|}~"
    static let TWUPunctuationCharsWithoutHyphenAndUnderscore   = "!\"#$%&'\\(\\)*+,./:;<=>?@\\[\\]^`\\{|}~"

    /// #define TWHashtagAlpha                          @"[\\p{L}\\p{M}]"
    static let TWHashtagAlpha                           = "[\\p{L}\\p{M}]"
    /// #define TWHashtagSpecialChars                   @"_\\u200c\\u200d\\ua67e\\u05be\\u05f3\\u05f4\\uff5e\\u301c\\u309b\\u309c\\u30a0\\u30fb\\u3003\\u0f0b\\u0f0c\\u00b7"
    static let TWHashtagSpecialChars                    = "_\\u200c\\u200d\\ua67e\\u05be\\u05f3\\u05f4\\uff5e\\u301c\\u309b\\u309c\\u30a0\\u30fb\\u3003\\u0f0b\\u0f0c\\u00b7"
    /// #define TWUHashtagAlphanumeric                  @"[\\p{L}\\p{M}\\p{Nd}" TWHashtagSpecialChars @"]"
    static let TWUHashtagAlphanumeric                   = "[\\p{L}\\p{M}\\p{Nd}\(TWHashtagSpecialChars)]"
    /// #define TWUHashtagBoundaryInvalidChars          @"&\\p{L}\\p{M}\\p{Nd}" TWHashtagSpecialChars
    static let TWUHashtagBoundaryInvalidChars           = "&\\p{L}\\p{M}\\p{Nd}\(TWHashtagSpecialChars)"

    /// #define TWUHashtagBoundary \
    ///     @"^|\\ufe0e|\\ufe0f|$|[^" \
    ///     TWUHashtagBoundaryInvalidChars \
    ///     @"]"
    static let TWUHashtagBoundary = "^|\\ufe0e|\\ufe0f|$|[^\(TWUHashtagBoundaryInvalidChars)]"

    /// #define TWUValidHashtag \
    /// @"(?:" TWUHashtagBoundary @")([#＃](?!\ufe0f|\u20e3)" TWUHashtagAlphanumeric @"*" TWHashtagAlpha TWUHashtagAlphanumeric @"*)"
    static let TWUValidHashtag = "(?:\(TWUHashtagBoundary))([#＃](?!\\ufe0f|\\u20e3)\(TWUHashtagAlphanumeric)*\(TWHashtagAlpha)\(TWUHashtagAlphanumeric)*)"

    /// #define TWUEndHashTagMatch      @"\\A(?:[#＃]|://)"
    static let TWUEndHashTagMatch = "\\A(?:[#＃]|://)"

    // MARK: - Symbol (Cashtag)

    /// #define TWUSymbol               @"[a-z]{1,6}(?:[._][a-z]{1,2})?"
    static let TWUSymbol = "[a-z]{1,6}(?:[._][a-z]{1,2})?"
    /// #define TWUValidSymbol \
    ///     @"(?:^|[" TWUUnicodeSpaces TWUUnicodeDirectionalCharacters @"])" \
    ///     @"(\\$" TWUSymbol @")" \
    ///     @"(?=$|\\s|[" TWUPunctuationChars @"])"
    static let TWUValidSymbol = "(?:^|[\(TWUUnicodeSpaces)\(TWUUnicodeDirectionalCharacters)])"
        + "(\\$\(TWUSymbol))(?=$|\\s|[\(TWUPunctuationChars)])"

    // MARK: - Mention and list name

    /// #define TWUValidMentionPrecedingChars   @"(?:[^a-z0-9_!#$%&*@＠]|^|(?:^|[^a-z0-9_+~.-])RT:?)"
    static let TWUValidMentionPrecedingChars = "(?:[^a-z0-9_!#$%&*@＠]|^|(?:^|[^a-z0-9_+~.-])RT:?)"
    /// #define TWUAtSigns                      @"[@＠]"
    static let TWUAtSigns = "[@＠]"
    /// #define TWUValidUsername                @"\\A" TWUAtSigns @"[a-z0-9_]{1,20}\\z"
    static let TWUValidUsername                = "\\A\(TWUAtSigns)[a-z0-9_]{1,20}\\z"
    /// #define TWUValidList                    @"\\A" TWUAtSigns @"[a-z0-9_]{1,20}/[a-z][a-z0-9_\\-]{0,24}\\z"
    static let TWUValidList                    = "\\A\(TWUAtSigns)[a-z0-9_]{1,20}/[a-z][a-z0-9_\\-]{0,24}\\z"

    /// #define TWUValidMentionOrList \
    ///     @"(" TWUValidMentionPrecedingChars @")" \
    ///     @"(" TWUAtSigns @")" \
    ///     @"([a-z0-9_]{1,20})" \
    ///     @"(/[a-z][a-z0-9_\\-]{0,24})?"
    static let TWUValidMentionOrList = "(\(TWUValidMentionPrecedingChars))"
        + "(\(TWUAtSigns))([a-z0-9_]{1,20})(/[a-z][a-z0-9_\\-]{0,24})?"

    /// #define TWUValidReply                   @"\\A(?:[" TWUUnicodeSpaces TWUUnicodeDirectionalCharacters @"])*"  TWUAtSigns @"([a-z0-9_]{1,20})"
    static let TWUValidReply = "\\A(?:[\(TWUUnicodeSpaces)"
        + "\(TWUUnicodeDirectionalCharacters)])*\(TWUAtSigns)([a-z0-9_]{1,20})"
    /// #define TWUEndMentionMatch              @"\\A(?:" TWUAtSigns @"|[" TWULatinAccents @"]|://)"
    static let TWUEndMentionMatch = "\\A(?:\(TWUAtSigns)|[\(TWULatinAccents)]|://)"

    // MARK: - URL

    /// #define TWUValidURLPrecedingChars       @"(?:[^a-z0-9@＠$#＃" TWUInvalidCharacters @"]|[" TWUUnicodeDirectionalCharacters "]|^)"
    static let TWUValidURLPrecedingChars = "(?:[^a-z0-9@＠$#＃\(TWUInvalidCharacters)]|[\(TWUUnicodeDirectionalCharacters)]|^)"

    /// These patterns extract domains that are ascii+latin only. We separately check
    /// for unencoded domains with unicode characters elsewhere.
    /// 
    /// #define TWUValidURLCharacters           @"[a-z0-9" TWULatinAccents @"]"
    static let TWUValidURLCharacters = "[a-z0-9\(TWULatinAccents)]"
    /// #define TWUValidURLSubdomain            @"(?>(?:" TWUValidURLCharacters @"[" TWUValidURLCharacters @"\\-_]{0,255})?" TWUValidURLCharacters @"\\.)"
    static let TWUValidURLSubdomain = "(?>(?:\(TWUValidURLCharacters)"
        + "[\(TWUValidURLCharacters)\\-_]{0,255})?\(TWUValidURLCharacters)\\.)"
    /// #define TWUValidURLDomain               @"(?:(?:" TWUValidURLCharacters @"[" TWUValidURLCharacters @"\\-]{0,255})?" TWUValidURLCharacters @"\\.)"
    static let TWUValidURLDomain = "(?:(?:\(TWUValidURLCharacters)"
        + "[\(TWUValidURLCharacters)\\-]{0,255})?\(TWUValidURLCharacters)\\.)"

    /// Used to extract domains that contain unencoded unicode.
    ///
    /// #define TWUValidURLUnicodeCharacters \
    /// @"[^" \
    /// TWUPunctuationChars \
    /// @"\\s\\p{Z}\\p{InGeneralPunctuation}" \
    /// @"]"
    static let TWUValidURLUnicodeCharacters = "[^\(TWUPunctuationChars)\\s\\p{Z}\\p{InGeneralPunctuation}]"

    /// #define TWUValidURLUnicodeDomain        @"(?:(?:" TWUValidURLUnicodeCharacters @"[" TWUValidURLUnicodeCharacters @"\\-]{0,255})?" TWUValidURLUnicodeCharacters @"\\.)"
    static let TWUValidURLUnicodeDomain = "(?:(?:\(TWUValidURLUnicodeCharacters)"
        + "[\(TWUValidURLUnicodeCharacters)\\-]{0,255})?\(TWUValidURLUnicodeCharacters)\\.)"

    /// #define TWUValidPunycode                @"(?:xn--[-0-9a-z]+)"
    static let TWUValidPunycode = "(?:xn--[-0-9a-z]+)"

    /// #define TWUValidDomain \
    /// @"(?:" \
    /// TWUValidURLSubdomain @"*" TWUValidURLDomain \
    /// @"(?:" TWUValidGTLD @"|" TWUValidCCTLD @"|" TWUValidPunycode @")" \
    /// @")" \
    /// @"|(?:(?<=https?://)" \
    /// @"(?:" \
    /// @"(?:" TWUValidURLDomain TWUValidCCTLD @")" \
    /// @"|(?:" \
    /// TWUValidURLUnicodeDomain @"{0,255}" TWUValidURLUnicodeDomain \
    /// @"(?:" TWUValidGTLD @"|" TWUValidCCTLD @")" \
    /// @")" \
    /// @")" \
    /// @")" \
    /// @"|(?:" \
    /// TWUValidURLDomain TWUValidCCTLD @"(?=/)" \
    /// @")"
    static let TWUValidDomain = "(?:\(TWUValidURLSubdomain)*\(TWUValidURLDomain)"
        + "(?:\(TWUValidGTLD)|\(TWUValidCCTLD)|\(TWUValidPunycode))"
        + ")|(?:(?<=https?://)(?:(?:\(TWUValidURLDomain)\(TWUValidCCTLD))"
        + "|(?:\(TWUValidURLUnicodeDomain){0,255}\(TWUValidURLUnicodeDomain)"
        + "(?:\(TWUValidGTLD)|\(TWUValidCCTLD)))))|(?:"
        + "\(TWUValidURLDomain)\(TWUValidCCTLD)(?=/))"


    /// #define TWUValidPortNumber              @"[0-9]++"
    static let TWUValidPortNumber = "[0-9]++"
    /// #define TWUValidGeneralURLPathChars     @"[a-z\\p{Cyrillic}0-9!\\*';:=+,.$/%#\\[\\]\\-\\u2013_~&|@" TWULatinAccents @"]"
    static let TWUValidGeneralURLPathChars = "[a-z\\p{Cyrillic}0-9!\\*';:=+,.$/%#\\[\\]\\-\\u2013_~&|@\(TWULatinAccents)]"

    /// #define TWUValidURLBalancedParens               \
    /// @"\\(" \
    /// @"(?:" \
    /// TWUValidGeneralURLPathChars @"+" \
    /// @"|" \
    /// @"(?:" \
    /// TWUValidGeneralURLPathChars @"*" \
    /// @"\\(" \
    /// TWUValidGeneralURLPathChars @"+" \
    /// @"\\)" \
    /// TWUValidGeneralURLPathChars @"*" \
    /// @")" \
    /// @")" \
    /// @"\\)"
    static let TWUValidURLBalancedParens = "\\((?:\(TWUValidGeneralURLPathChars)+"
        + "|(?:\(TWUValidGeneralURLPathChars)*\\(\(TWUValidGeneralURLPathChars)+"
        + "\\)\(TWUValidGeneralURLPathChars)*))\\)"

    /// #define TWUValidURLPathEndingChars      @"[a-z\\p{Cyrillic}0-9=_#/+\\-" TWULatinAccents @"]|(?:" TWUValidURLBalancedParens @")"
    static let TWUValidURLPathEndingChars = "[a-z\\p{Cyrillic}0-9=_#/+\\-\(TWULatinAccents)]|(?:\(TWUValidURLBalancedParens))"

    /// #define TWUValidPath @"(?:" \
    /// @"(?:" \
    /// TWUValidGeneralURLPathChars @"*" \
    /// @"(?:" TWUValidURLBalancedParens TWUValidGeneralURLPathChars @"*)*" \
    /// TWUValidURLPathEndingChars \
    /// @")|(?:@" TWUValidGeneralURLPathChars @"+/)" \
    /// @")"
    static let TWUValidPath = "(?:(?:\(TWUValidGeneralURLPathChars)*"
        + "(?:\(TWUValidURLBalancedParens)\(TWUValidGeneralURLPathChars)*)*"
        + "\(TWUValidURLPathEndingChars))|(?:@\(TWUValidGeneralURLPathChars)+/))"

    /// #define TWUValidURLQueryChars           @"[a-z0-9!?*'\\(\\);:&=+$/%#\\[\\]\\-_\\.,~|@]"
    static let TWUValidURLQueryChars = "[a-z0-9!?*'\\(\\);:&=+$/%#\\[\\]\\-_\\.,~|@]"
    /// #define TWUValidURLQueryEndingChars     @"[a-z0-9\\-_&=#/]"
    static let TWUValidURLQueryEndingChars = "[a-z0-9\\-_&=#/]"

    /// #define TWUValidURLPatternString \
    /// @"(" \
    /// @"(" TWUValidURLPrecedingChars @")" \
    /// @"(" \
    /// @"(https?://)?" \
    /// @"(" TWUValidDomain @")" \
    /// @"(?::(" TWUValidPortNumber @"))?" \
    /// @"(/" \
    /// TWUValidPath @"*+" \
    /// @")?" \
    /// @"(\\?" TWUValidURLQueryChars @"*" \
    /// TWUValidURLQueryEndingChars @")?" \
    /// @")" \
    /// @")"
    static let TWUValidURLPatternString = "((\(TWUValidURLPrecedingChars))"
        + "((https?://)?(\(TWUValidDomain))(?::(\(TWUValidPortNumber)))?"
        + "(/\(TWUValidPath)*+)?(\\?\(TWUValidURLQueryChars)*"
        + "\(TWUValidURLQueryEndingChars))?))"

    static let TWUValidGTLD = "(?:(?:"
    + "삼성|닷컴|닷넷|香格里拉|餐厅|食品|飞利浦|電訊盈科|集团|通販|购物|谷歌|诺基亚|联通|网络|网站|网店|网址|组织机构|移动|珠宝|点看|游戏|淡马锡|机构|書籍|时尚|新闻|政府|政务|"
    + "招聘|手表|手机|我爱你|慈善|微博|广东|工行|家電|娱乐|天主教|大拿|大众汽车|在线|嘉里大酒店|嘉里|商标|商店|商城|公益|公司|八卦|健康|信息|佛山|企业|中文网|中信|世界|ポイント|"
    + "ファッション|セール|ストア|コム|グーグル|クラウド|みんな|คอม|संगठन|नेट|कॉम|همراه|موقع|موبايلي|كوم|كاثوليك|عرب|شبكة|بيتك|بازار|"
+ "العليان|ارامكو|اتصالات|ابوظبي|קום|сайт|рус|орг|онлайн|москва|ком|католик|дети|zuerich|zone|zippo|zip|"
    + "zero|zara|zappos|yun|youtube|you|yokohama|yoga|yodobashi|yandex|yamaxun|yahoo|yachts|xyz|xxx|xperia|"
    + "xin|xihuan|xfinity|xerox|xbox|wtf|wtc|wow|world|works|work|woodside|wolterskluwer|wme|winners|wine|"
    + "windows|win|williamhill|wiki|wien|whoswho|weir|weibo|wedding|wed|website|weber|webcam|weatherchannel|"
    + "weather|watches|watch|warman|wanggou|wang|walter|walmart|wales|vuelos|voyage|voto|voting|vote|volvo|"
    + "volkswagen|vodka|vlaanderen|vivo|viva|vistaprint|vista|vision|visa|virgin|vip|vin|villas|viking|vig|"
    + "video|viajes|vet|versicherung|vermögensberatung|vermögensberater|verisign|ventures|vegas|vanguard|"
    + "vana|vacations|ups|uol|uno|university|unicom|uconnect|ubs|ubank|tvs|tushu|tunes|tui|tube|trv|trust|"
    + "travelersinsurance|travelers|travelchannel|travel|training|trading|trade|toys|toyota|town|tours|"
    + "total|toshiba|toray|top|tools|tokyo|today|tmall|tkmaxx|tjx|tjmaxx|tirol|tires|tips|tiffany|tienda|"
    + "tickets|tiaa|theatre|theater|thd|teva|tennis|temasek|telefonica|telecity|tel|technology|tech|team|"
    + "tdk|tci|taxi|tax|tattoo|tatar|tatamotors|target|taobao|talk|taipei|tab|systems|symantec|sydney|swiss|"
    + "swiftcover|swatch|suzuki|surgery|surf|support|supply|supplies|sucks|style|study|studio|stream|store|"
    + "storage|stockholm|stcgroup|stc|statoil|statefarm|statebank|starhub|star|staples|stada|srt|srl|"
    + "spreadbetting|spot|sport|spiegel|space|soy|sony|song|solutions|solar|sohu|software|softbank|social|"
    + "soccer|sncf|smile|smart|sling|skype|sky|skin|ski|site|singles|sina|silk|shriram|showtime|show|shouji|"
    + "shopping|shop|shoes|shiksha|shia|shell|shaw|sharp|shangrila|sfr|sexy|sex|sew|seven|ses|services|"
    + "sener|select|seek|security|secure|seat|search|scot|scor|scjohnson|science|schwarz|schule|school|"
    + "scholarships|schmidt|schaeffler|scb|sca|sbs|sbi|saxo|save|sas|sarl|sapo|sap|sanofi|sandvikcoromant|"
    + "sandvik|samsung|samsclub|salon|sale|sakura|safety|safe|saarland|ryukyu|rwe|run|ruhr|rugby|rsvp|room|"
    + "rogers|rodeo|rocks|rocher|rmit|rip|rio|ril|rightathome|ricoh|richardli|rich|rexroth|reviews|review|"
    + "restaurant|rest|republican|report|repair|rentals|rent|ren|reliance|reit|reisen|reise|rehab|"
    + "redumbrella|redstone|red|recipes|realty|realtor|realestate|read|raid|radio|racing|qvc|quest|quebec|"
    + "qpon|pwc|pub|prudential|pru|protection|property|properties|promo|progressive|prof|productions|prod|"
    + "pro|prime|press|praxi|pramerica|post|porn|politie|poker|pohl|pnc|plus|plumbing|playstation|play|"
    + "place|pizza|pioneer|pink|ping|pin|pid|pictures|pictet|pics|piaget|physio|photos|photography|photo|"
    + "phone|philips|phd|pharmacy|pfizer|pet|pccw|pay|passagens|party|parts|partners|pars|paris|panerai|"
    + "panasonic|pamperedchef|page|ovh|ott|otsuka|osaka|origins|orientexpress|organic|org|orange|oracle|"
    + "open|ooo|onyourside|online|onl|ong|one|omega|ollo|oldnavy|olayangroup|olayan|okinawa|office|off|"
    + "observer|obi|nyc|ntt|nrw|nra|nowtv|nowruz|now|norton|northwesternmutual|nokia|nissay|nissan|ninja|"
    + "nikon|nike|nico|nhk|ngo|nfl|nexus|nextdirect|next|news|newholland|new|neustar|network|netflix|"
    + "netbank|net|nec|nba|navy|natura|nationwide|name|nagoya|nadex|nab|mutuelle|mutual|museum|mtr|mtpc|mtn|"
    + "msd|movistar|movie|mov|motorcycles|moto|moscow|mortgage|mormon|mopar|montblanc|monster|money|monash|"
    + "mom|moi|moe|moda|mobily|mobile|mobi|mma|mls|mlb|mitsubishi|mit|mint|mini|mil|microsoft|miami|metlife|"
    + "merckmsd|meo|menu|men|memorial|meme|melbourne|meet|media|med|mckinsey|mcdonalds|mcd|mba|mattel|"
    + "maserati|marshalls|marriott|markets|marketing|market|map|mango|management|man|makeup|maison|maif|"
    + "madrid|macys|luxury|luxe|lupin|lundbeck|ltda|ltd|lplfinancial|lpl|love|lotto|lotte|london|lol|loft|"
    + "locus|locker|loans|loan|llp|llc|lixil|living|live|lipsy|link|linde|lincoln|limo|limited|lilly|like|"
    + "lighting|lifestyle|lifeinsurance|life|lidl|liaison|lgbt|lexus|lego|legal|lefrak|leclerc|lease|lds|"
    + "lawyer|law|latrobe|latino|lat|lasalle|lanxess|landrover|land|lancome|lancia|lancaster|lamer|"
    + "lamborghini|ladbrokes|lacaixa|kyoto|kuokgroup|kred|krd|kpn|kpmg|kosher|komatsu|koeln|kiwi|kitchen|"
    + "kindle|kinder|kim|kia|kfh|kerryproperties|kerrylogistics|kerryhotels|kddi|kaufen|juniper|juegos|jprs|"
    + "jpmorgan|joy|jot|joburg|jobs|jnj|jmp|jll|jlc|jio|jewelry|jetzt|jeep|jcp|jcb|java|jaguar|iwc|iveco|"
    + "itv|itau|istanbul|ist|ismaili|iselect|irish|ipiranga|investments|intuit|international|intel|int|"
    + "insure|insurance|institute|ink|ing|info|infiniti|industries|inc|immobilien|immo|imdb|imamat|ikano|"
    + "iinet|ifm|ieee|icu|ice|icbc|ibm|hyundai|hyatt|hughes|htc|hsbc|how|house|hotmail|hotels|hoteles|hot|"
    + "hosting|host|hospital|horse|honeywell|honda|homesense|homes|homegoods|homedepot|holiday|holdings|"
    + "hockey|hkt|hiv|hitachi|hisamitsu|hiphop|hgtv|hermes|here|helsinki|help|healthcare|health|hdfcbank|"
    + "hdfc|hbo|haus|hangout|hamburg|hair|guru|guitars|guide|guge|gucci|guardian|group|grocery|gripe|green|"
    + "gratis|graphics|grainger|gov|got|gop|google|goog|goodyear|goodhands|goo|golf|goldpoint|gold|godaddy|"
    + "gmx|gmo|gmbh|gmail|globo|global|gle|glass|glade|giving|gives|gifts|gift|ggee|george|genting|gent|gea|"
    + "gdn|gbiz|gay|garden|gap|games|game|gallup|gallo|gallery|gal|fyi|futbol|furniture|fund|fun|fujixerox|"
    + "fujitsu|ftr|frontier|frontdoor|frogans|frl|fresenius|free|fox|foundation|forum|forsale|forex|ford|"
    + "football|foodnetwork|food|foo|fly|flsmidth|flowers|florist|flir|flights|flickr|fitness|fit|fishing|"
    + "fish|firmdale|firestone|fire|financial|finance|final|film|fido|fidelity|fiat|ferrero|ferrari|"
    + "feedback|fedex|fast|fashion|farmers|farm|fans|fan|family|faith|fairwinds|fail|fage|extraspace|"
    + "express|exposed|expert|exchange|everbank|events|eus|eurovision|etisalat|esurance|estate|esq|erni|"
    + "ericsson|equipment|epson|epost|enterprises|engineering|engineer|energy|emerck|email|education|edu|"
    + "edeka|eco|eat|earth|dvr|dvag|durban|dupont|duns|dunlop|duck|dubai|dtv|drive|download|dot|doosan|"
    + "domains|doha|dog|dodge|doctor|docs|dnp|diy|dish|discover|discount|directory|direct|digital|diet|"
    + "diamonds|dhl|dev|design|desi|dentist|dental|democrat|delta|deloitte|dell|delivery|degree|deals|"
    + "dealer|deal|dds|dclk|day|datsun|dating|date|data|dance|dad|dabur|cyou|cymru|cuisinella|csc|cruises|"
    + "cruise|crs|crown|cricket|creditunion|creditcard|credit|cpa|courses|coupons|coupon|country|corsica|"
    + "coop|cool|cookingchannel|cooking|contractors|contact|consulting|construction|condos|comsec|computer|"
    + "compare|company|community|commbank|comcast|com|cologne|college|coffee|codes|coach|clubmed|club|cloud|"
    + "clothing|clinique|clinic|click|cleaning|claims|cityeats|city|citic|citi|citadel|cisco|circle|"
    + "cipriani|church|chrysler|chrome|christmas|chloe|chintai|cheap|chat|chase|charity|channel|chanel|cfd|"
    + "cfa|cern|ceo|center|ceb|cbs|cbre|cbn|cba|catholic|catering|cat|casino|cash|caseih|case|casa|cartier|"
    + "cars|careers|career|care|cards|caravan|car|capitalone|capital|capetown|canon|cancerresearch|camp|"
    + "camera|cam|calvinklein|call|cal|cafe|cab|bzh|buzz|buy|business|builders|build|bugatti|budapest|"
    + "brussels|brother|broker|broadway|bridgestone|bradesco|box|boutique|bot|boston|bostik|bosch|boots|"
    + "booking|book|boo|bond|bom|bofa|boehringer|boats|bnpparibas|bnl|bmw|bms|blue|bloomberg|blog|"
    + "blockbuster|blanco|blackfriday|black|biz|bio|bingo|bing|bike|bid|bible|bharti|bet|bestbuy|best|"
    + "berlin|bentley|beer|beauty|beats|bcn|bcg|bbva|bbt|bbc|bayern|bauhaus|basketball|baseball|bargains|"
    + "barefoot|barclays|barclaycard|barcelona|bar|bank|band|bananarepublic|banamex|baidu|baby|azure|axa|"
    + "aws|avianca|autos|auto|author|auspost|audio|audible|audi|auction|attorney|athleta|associates|asia|"
    + "asda|arte|art|arpa|army|archi|aramco|arab|aquarelle|apple|app|apartments|aol|anz|anquan|android|"
    + "analytics|amsterdam|amica|amfam|amex|americanfamily|americanexpress|alstom|alsace|ally|allstate|"
    + "allfinanz|alipay|alibaba|alfaromeo|akdn|airtel|airforce|airbus|aigo|aig|agency|agakhan|africa|afl|"
    + "afamilycompany|aetna|aero|aeg|adult|ads|adac|actor|active|aco|accountants|accountant|accenture|"
    + "academy|abudhabi|abogado|able|abc|abbvie|abbott|abb|abarth|aarp|aaa|onion"
    + ")(?=[^a-z0-9@+-]|$))"

    static let TWUValidCCTLD = "(?:(?:"
    + "한국|香港|澳門|新加坡|台灣|台湾|中國|中国|გე|ລາວ|ไทย|ලංකා|ഭാരതം|ಭಾರತ|భారత్|சிங்கப்பூர்|இலங்கை|இந்தியா|ଭାରତ|ભારત|ਭਾਰਤ|"
    + "ভাৰত|ভারত|বাংলা|भारोत|भारतम्|भारत|ڀارت|پاکستان|موريتانيا|مليسيا|مصر|قطر|فلسطين|عمان|عراق|سورية|سودان|"
   + "تونس|بھارت|بارت|ایران|امارات|المغرب|السعودية|الجزائر|البحرين|الاردن|հայ|қаз|укр|срб|рф|мон|мкд|ею|"
    + "бел|бг|ευ|ελ|zw|zm|za|yt|ye|ws|wf|vu|vn|vi|vg|ve|vc|va|uz|uy|us|um|uk|ug|ua|tz|tw|tv|tt|tr|tp|to|tn|"
    + "tm|tl|tk|tj|th|tg|tf|td|tc|sz|sy|sx|sv|su|st|ss|sr|so|sn|sm|sl|sk|sj|si|sh|sg|se|sd|sc|sb|sa|rw|ru|"
    + "rs|ro|re|qa|py|pw|pt|ps|pr|pn|pm|pl|pk|ph|pg|pf|pe|pa|om|nz|nu|nr|np|no|nl|ni|ng|nf|ne|nc|na|mz|my|"
    + "mx|mw|mv|mu|mt|ms|mr|mq|mp|mo|mn|mm|ml|mk|mh|mg|mf|me|md|mc|ma|ly|lv|lu|lt|ls|lr|lk|li|lc|lb|la|kz|"
    + "ky|kw|kr|kp|kn|km|ki|kh|kg|ke|jp|jo|jm|je|it|is|ir|iq|io|in|im|il|ie|id|hu|ht|hr|hn|hm|hk|gy|gw|gu|"
    + "gt|gs|gr|gq|gp|gn|gm|gl|gi|gh|gg|gf|ge|gd|gb|ga|fr|fo|fm|fk|fj|fi|eu|et|es|er|eh|eg|ee|ec|dz|do|dm|"
    + "dk|dj|de|cz|cy|cx|cw|cv|cu|cr|co|cn|cm|cl|ck|ci|ch|cg|cf|cd|cc|ca|bz|by|bw|bv|bt|bs|br|bq|bo|bn|bm|"
    + "bl|bj|bi|bh|bg|bf|be|bd|bb|ba|az|ax|aw|au|at|as|ar|aq|ao|an|am|al|ai|ag|af|ae|ad|ac"
    + ")(?=[^a-z0-9@+-]|$))"

    /// #define TWUValidTCOURL                  @"^https?://t\\.co/([a-z0-9]+)"
    static let TWUValidTCOURL = "^https?://t\\.co/([a-z0-9]+)"

    /// #define TWUValidURLPath \
    /// @"(?:" \
    /// @"(?:" \
    /// TWUValidGeneralURLPathChars @"*" \
    /// @"(?:" TWUValidURLBalancedParens TWUValidGeneralURLPathChars @"*)*" TWUValidURLPathEndingChars \
    /// @")" \
    /// @"|" \
    /// @"(?:" TWUValidGeneralURLPathChars @"+/)" \
    /// @")"
    static let TWUValidURLPath = "(?:(?:\(TWUValidGeneralURLPathChars)*"
        + "(?:\(TWUValidURLBalancedParens)\(TWUValidGeneralURLPathChars)*)*\(TWUValidURLPathEndingChars)"
        + ")|(?:\(TWUValidGeneralURLPathChars)+/))"
}
