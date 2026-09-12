---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import hashes, random, sets, strutils, tables\nimport cplib/math/bigint\n\nblock:\n\
    \    doAssert $(-17'i8) == \"-17\"\n    doAssert $(-17'i16) == \"-17\"\n    doAssert\
    \ $(-17'i32) == \"-17\"\n    doAssert $(-17'i64) == \"-17\"\n    doAssert $(17'u8)\
    \ == \"17\"\n    doAssert $(17'u16) == \"17\"\n    doAssert $(17'u32) == \"17\"\
    \n    doAssert $(17'u64) == \"17\"\n    doAssert cmp(-17'i32, 17'i32) == -1\n\
    \    doAssert cmp(17'u32, 17'u32) == 0\n    doAssert hash(-17'i32) == hashes.hash(-17'i32)\n\
    \    doAssert hash(17'u32) == hashes.hash(17'u32)\n    doAssert hash(17) == hashes.hash(17)\n\
    \nblock:\n    var zero: BigInt\n    doAssert $zero == \"0\"\n    doAssert zero.isZero\n\
    \    doAssert zero.sgn == 0\n    for s in [\"0\", \"-0\", \"+0\", \"00000\", \"\
    -00000\", \"+00000\"]:\n        let value = parseBigInt(s)\n        doAssert value\
    \ == zero\n        doAssert $value == \"0\"\n        doAssert value.hash == zero.hash\n\
    \    doAssert $parseBigInt(\"+00012345678901234567890\") == \"12345678901234567890\"\
    \n    doAssert $initBigInt(\"-00012345678901234567890\") == \"-12345678901234567890\"\
    \n    for s in [\"\", \"+\", \"-\", \" 1\", \"1 \", \"1\\n\", \"--1\", \"+-1\"\
    , \"1_000\", \"0x10\", \"1.0\", \"a\", \"\uFF11\uFF12\"]:\n        doAssertRaises(ValueError):\n\
    \            discard parseBigInt(s)\n    for value in [low(int), low(int) + 1,\
    \ -1, 0, 1, high(int) - 1, high(int)]:\n        doAssert $initBigInt(value) ==\
    \ $value\n        doAssert initBigInt(value).toInt == value\n        doAssert\
    \ parseBigInt($value).toInt == value\n    doAssert $initBigInt(low(int8)) == \"\
    -128\"\n    doAssert $initBigInt(high(uint8)) == \"255\"\n    doAssert $initBigInt(low(int16))\
    \ == \"-32768\"\n    doAssert $initBigInt(high(uint16)) == \"65535\"\n    doAssert\
    \ $initBigInt(low(int32)) == \"-2147483648\"\n    doAssert $initBigInt(high(uint32))\
    \ == \"4294967295\"\n    doAssert $initBigInt(low(int64)) == \"-9223372036854775808\"\
    \n    doAssert $initBigInt(high(uint64)) == \"18446744073709551615\"\n    let\
    \ unsignedValue: BigInt = high(uint64)\n    let signedValue: BigInt = low(int64)\n\
    \    doAssert $unsignedValue == \"18446744073709551615\"\n    doAssert $signedValue\
    \ == \"-9223372036854775808\"\n    doAssertRaises(OverflowDefect):\n        discard\
    \ (initBigInt(high(int)) + 1).toInt\n    doAssertRaises(OverflowDefect):\n   \
    \     discard (initBigInt(low(int)) - 1).toInt\n    doAssertRaises(OverflowDefect):\n\
    \        discard parseBigInt(\"999999999999999999999999999999999999\").toInt\n\
    \nstatic:\n    for a in -7..7:\n        for b in -3..3:\n            if b != 0:\n\
    \                let x = initBigInt(a)\n                let y = initBigInt(b)\n\
    \                doAssert x div y == initBigInt(a div b)\n                doAssert\
    \ x mod y == initBigInt(a mod b)\n                var q = a div b\n          \
    \      var r = a mod b\n                if r != 0 and (a < 0) != (b < 0):\n  \
    \                  dec q\n                    r += b\n                doAssert\
    \ x // y == initBigInt(q)\n                doAssert x % y == initBigInt(r)\n \
    \   doAssert divmod(initBigInt(-7), initBigInt(3)) == (initBigInt(-3), initBigInt(2))\n\
    \    doAssert divmod(initBigInt(7), initBigInt(-3)) == (initBigInt(-3), initBigInt(-2))\n\
    \    doAssert divmod(initBigInt(-7), initBigInt(-3)) == (initBigInt(2), initBigInt(-1))\n\
    \    doAssert divmod(initBigInt(-6), initBigInt(3)) == (initBigInt(-2), initBigInt(0))\n\
    \nproc checkSmall(a, b: int) =\n    ## \u7D44\u307F\u8FBC\u307F\u6574\u6570\u3068\
    \u56DB\u5247\u6F14\u7B97\u30FB\u6BD4\u8F03\u30FB\u4EE3\u5165\u6F14\u7B97\u306E\
    \u7D50\u679C\u3092\u7167\u5408\u3059\u308B\u3002\n    let x = initBigInt(a)\n\
    \    let y = initBigInt(b)\n    doAssert +x == x\n    doAssert -x == initBigInt(-a)\n\
    \    doAssert x.abs == initBigInt(abs(a))\n    doAssert x.sgn == (if a < 0: -1\
    \ elif a > 0: 1 else: 0)\n    doAssert x.isZero == (a == 0)\n    doAssert x +\
    \ y == initBigInt(a + b)\n    doAssert x - y == initBigInt(a - b)\n    doAssert\
    \ x * y == initBigInt(a * b)\n    doAssert x + b == initBigInt(a + b)\n    doAssert\
    \ a + y == initBigInt(a + b)\n    doAssert x - b == initBigInt(a - b)\n    doAssert\
    \ a - y == initBigInt(a - b)\n    doAssert x * b == initBigInt(a * b)\n    doAssert\
    \ a * y == initBigInt(a * b)\n    doAssert (x == y) == (a == b)\n    doAssert\
    \ (x != y) == (a != b)\n    doAssert (x < y) == (a < b)\n    doAssert (x <= y)\
    \ == (a <= b)\n    doAssert (x > y) == (a > b)\n    doAssert (x >= y) == (a >=\
    \ b)\n    doAssert cmp(x, y) == cmp(a, b)\n    doAssert (x == b) == (a == b)\n\
    \    doAssert (a == y) == (a == b)\n    doAssert (x < b) == (a < b)\n    doAssert\
    \ (a < y) == (a < b)\n    doAssert (x <= b) == (a <= b)\n    doAssert (a <= y)\
    \ == (a <= b)\n    doAssert (x > b) == (a > b)\n    doAssert (a > y) == (a > b)\n\
    \    doAssert (x >= b) == (a >= b)\n    doAssert (a >= y) == (a >= b)\n    var\
    \ assigned = x\n    assigned += y\n    doAssert assigned == x + y\n    assigned\
    \ = x\n    assigned -= y\n    doAssert assigned == x - y\n    assigned = x\n \
    \   assigned *= y\n    doAssert assigned == x * y\n    if b != 0:\n        let\
    \ (quotient, remainder) = divmod(x, y)\n        var expectedQ = a div b\n    \
    \    var expectedR = a mod b\n        if expectedR != 0 and (a < 0) != (b < 0):\n\
    \            dec expectedQ\n            expectedR += b\n        doAssert quotient\
    \ == initBigInt(expectedQ)\n        doAssert remainder == initBigInt(expectedR)\n\
    \        doAssert x // y == quotient\n        doAssert x % y == remainder\n  \
    \      doAssert x // b == quotient\n        doAssert a // y == quotient\n    \
    \    doAssert x % b == remainder\n        doAssert a % y == remainder\n      \
    \  doAssert x div y == initBigInt(a div b)\n        doAssert x mod y == initBigInt(a\
    \ mod b)\n        doAssert x div b == initBigInt(a div b)\n        doAssert a\
    \ div y == initBigInt(a div b)\n        doAssert x mod b == initBigInt(a mod b)\n\
    \        doAssert a mod y == initBigInt(a mod b)\n        assigned = x\n     \
    \   `div=`(assigned, y)\n        doAssert assigned == initBigInt(a div b)\n  \
    \      assigned = x\n        `mod=`(assigned, y)\n        doAssert assigned ==\
    \ initBigInt(a mod b)\n    doAssert $x == $a\n    doAssert $y == $b\n\nfor a in\
    \ -12..12:\n    for b in -12..12:\n        checkSmall(a, b)\nvar rng = initRand(20260908)\n\
    for _ in 0..<2000:\n    checkSmall(rng.rand(-30000..30000), rng.rand(-30000..30000))\n\
    \nblock:\n    let a = initBigInt(\"123456789012345678901234567890\")\n    let\
    \ b = initBigInt(\"98765432109876543210\")\n    doAssert $(a + b) == \"123456789111111111011111111100\"\
    \n    doAssert $(a - b) == \"123456788913580246791358024680\"\n    doAssert $(a\
    \ * b) == \"12193263113702179522496570642237463801111263526900\"\n    let carry\
    \ = initBigInt(\"999999999999999999999999999\")\n    doAssert $(carry + 1) ==\
    \ \"1000000000000000000000000000\"\n    doAssert $(carry + 1 - carry) == \"1\"\
    \n    doAssert $(-carry - 1) == \"-1000000000000000000000000000\"\n    doAssert\
    \ $(a - a) == \"0\"\n    doAssert $(a * 0) == \"0\"\n    doAssert (a * 0).sgn\
    \ == 0\n    doAssert a < a + 1\n    doAssert -a < -b\n    doAssert a > b\n   \
    \ doAssert initBigInt(low(int)) div -1 == -initBigInt(low(int))\n    doAssert\
    \ initBigInt(low(int)) mod -1 == 0\n\nproc decimalProduct(a, b: string): string\
    \ =\n    ## \u975E\u8CA0\u6574\u6570\u306E\u7A4D\u3092\u72EC\u7ACB\u3057\u305F\
    \ 10 \u9032\u306E\u7B46\u7B97\u3067\u6C42\u3081\u308B\u3002\n    var digits =\
    \ newSeq[int](a.len + b.len)\n    for i in 0..<a.len:\n        for j in 0..<b.len:\n\
    \            digits[i + j] += (ord(a[a.high - i]) - ord('0')) *\n            \
    \    (ord(b[b.high - j]) - ord('0'))\n    for i in 0..<digits.high:\n        digits[i\
    \ + 1] += digits[i] div 10\n        digits[i] = digits[i] mod 10\n    while digits.len\
    \ > 1 and digits[^1] == 0:\n        digits.setLen(digits.len - 1)\n    result\
    \ = newString(digits.len)\n    for i in 0..<digits.len:\n        result[result.high\
    \ - i] = char(ord('0') + digits[i])\n\nproc decimalSum(a, b: string): string =\n\
    \    ## \u975E\u8CA0\u6574\u6570\u306E\u548C\u3092\u72EC\u7ACB\u3057\u305F 10\
    \ \u9032\u306E\u7B46\u7B97\u3067\u6C42\u3081\u308B\u3002\n    result = newString(max(a.len,\
    \ b.len) + 1)\n    var carry = 0\n    for offset in 0..<result.len:\n        if\
    \ offset < a.len:\n            carry += ord(a[a.high - offset]) - ord('0')\n \
    \       if offset < b.len:\n            carry += ord(b[b.high - offset]) - ord('0')\n\
    \        result[result.high - offset] = char(ord('0') + carry mod 10)\n      \
    \  carry = carry div 10\n    if result[0] == '0':\n        result = result[1..^1]\n\
    \nproc decimalPredecessor(a: string): string =\n    ## \u6B63\u6574\u6570\u304B\
    \u3089 1 \u3092\u5F15\u3044\u305F\u5024\u3092\u72EC\u7ACB\u3057\u305F 10 \u9032\
    \u306E\u7B46\u7B97\u3067\u6C42\u3081\u308B\u3002\n    result = a\n    var i =\
    \ result.high\n    while result[i] == '0':\n        result[i] = '9'\n        dec\
    \ i\n    result[i] = char(ord(result[i]) - 1)\n    if result.len > 1 and result[0]\
    \ == '0':\n        result = result[1..^1]\n\nproc randomDecimal(rng: var Rand,\
    \ length: int): string =\n    ## \u5148\u982D\u304C 0 \u3067\u306F\u306A\u3044\
    \u6307\u5B9A\u6841\u6570\u306E\u4E71\u6570\u6587\u5B57\u5217\u3092\u8FD4\u3059\
    \u3002\n    result = newString(length)\n    result[0] = char(ord('0') + rng.rand(1..9))\n\
    \    for i in 1..<length:\n        result[i] = char(ord('0') + rng.rand(0..9))\n\
    \nproc checkLargeProduct(aText, bText, expected: string, allSigns = false) =\n\
    \    ## \u5927\u6574\u6570\u306E\u7A4D\u30FB\u4EA4\u63DB\u6CD5\u5247\u30FB\u4EE3\
    \u5165\u6F14\u7B97\u3068\u5165\u529B\u5024\u306E\u4FDD\u6301\u3092\u78BA\u8A8D\
    \u3059\u308B\u3002\n    for aSign in (if allSigns: @[-1, 1] else: @[1]):\n   \
    \     for bSign in (if allSigns: @[-1, 1] else: @[1]):\n            let signedA\
    \ = (if aSign < 0: \"-\" else: \"\") & aText\n            let signedB = (if bSign\
    \ < 0: \"-\" else: \"\") & bText\n            let a = initBigInt(signedA)\n  \
    \          let b = initBigInt(signedB)\n            let signedExpected =\n   \
    \             (if aSign != bSign and expected != \"0\": \"-\" else: \"\") & expected\n\
    \            doAssert $(a * b) == signedExpected\n            doAssert $(b * a)\
    \ == signedExpected\n            var assigned = a\n            assigned *= b\n\
    \            doAssert $assigned == signedExpected\n            doAssert a == initBigInt(signedA)\n\
    \            doAssert b == initBigInt(signedB)\n\nblock:\n    const nines = repeat('9',\
    \ 2400)\n    const squared = $(initBigInt(nines) * initBigInt(nines))\n    doAssert\
    \ squared == repeat('9', 2399) & \"8\" & repeat('0', 2399) & \"1\"\n\nblock:\n\
    \    doAssert decimalProduct(\"0\", \"123\") == \"0\"\n    doAssert decimalProduct(\"\
    99\", \"99\") == \"9801\"\n    doAssert decimalProduct(\"123456789\", \"987654321\"\
    ) == \"121932631112635269\"\n    var multiplicationRng = initRand(20260909)\n\
    \    for limbs in [63, 64, 65, 255, 256, 257]:\n        for missingDigits in [0,\
    \ 1, 2]:\n            let aText = multiplicationRng.randomDecimal(9 * limbs -\
    \ missingDigits)\n            let bText = multiplicationRng.randomDecimal(9 *\
    \ limbs - 2 + missingDigits)\n            checkLargeProduct(aText, bText, decimalProduct(aText,\
    \ bText),\n                allSigns = missingDigits == 1)\n        let nines =\
    \ repeat('9', 9 * limbs)\n        let expected = repeat('9', nines.len - 1) &\
    \ \"8\" &\n            repeat('0', nines.len - 1) & \"1\"\n        checkLargeProduct(nines,\
    \ nines, expected)\n        let original = initBigInt(nines)\n        var squared\
    \ = original\n        squared *= squared\n        doAssert $squared == expected\n\
    \        doAssert $original == nines\n\n    let longText = multiplicationRng.randomDecimal(5432)\n\
    \    for shortText in [\"0\", \"1\", \"999\", \"1000\", \"999999999\", \"1000000000\"\
    ,\n            multiplicationRng.randomDecimal(9 * 255),\n            multiplicationRng.randomDecimal(9\
    \ * 256),\n            multiplicationRng.randomDecimal(9 * 257)]:\n        checkLargeProduct(longText,\
    \ shortText, decimalProduct(longText, shortText),\n            allSigns = true)\n\
    \    for _ in 0..<24:\n        let aText = multiplicationRng.randomDecimal(multiplicationRng.rand(2305..3600))\n\
    \        let bText = multiplicationRng.randomDecimal(multiplicationRng.rand(2305..3600))\n\
    \        checkLargeProduct(aText, bText, decimalProduct(aText, bText))\n\n   \
    \ for length in [3068, 3069, 3070, 6137, 6138, 6139, 30000, 30001]:\n        let\
    \ nines = repeat('9', length)\n        let expected = repeat('9', length - 1)\
    \ & \"8\" & repeat('0', length - 1) & \"1\"\n        checkLargeProduct(nines,\
    \ nines, expected, allSigns = true)\n        let powerOfTen = \"1\" & repeat('0',\
    \ length)\n        let sparse = \"1\" & repeat('0', length - 1) & \"1\"\n    \
    \    checkLargeProduct(powerOfTen, sparse, sparse & repeat('0', length))\n   \
    \     let original = initBigInt(nines)\n        var squared = original\n     \
    \   squared *= squared\n        doAssert $squared == expected\n        doAssert\
    \ $original == nines\n\n# Python \u306E\u6574\u6570\u6F14\u7B97\u3067\u6C42\u3081\
    \u305F\u5546\u3068\u4F59\u308A\u3092\u3001\u3059\u3079\u3066\u306E\u7B26\u53F7\
    \u306E\u7D44\u5408\u305B\u3067\u78BA\u8A8D\u3059\u308B\u3002\nconst divisionCases\
    \ = [\n    (\"2000000000000000001\", \"1000000000000000001\", \"1\", \"1000000000000000000\"\
    ),\n    (\"1000000000000000000000000001\", \"500000000000000000000000001\", \"\
    1\", \"500000000000000000000000000\"),\n    (\"9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999\"\
    , \"100000000000000000000000000000000000000000000000001\", \"99999999999999999999999999999999999999999999999999\"\
    , \"0\"),\n    (\"10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000\"\
    , \"1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001\"\
    , \"9\", \"999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999991\"\
    ),\n    (\"1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000001\"\
    , \"1000000000000000000000000000001\", \"1000000000000000000000000000000000000000000000000000000000000\"\
    , \"1\"),\n    (\"999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999\"\
    , \"999999999999999999999999999999\", \"1000000000000000000000000000001000000000000000000000000000001\"\
    , \"0\"),\n    (\"999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999\"\
    , \"500000000000000000000000000999999999000000000000000000000000000000000001\"\
    , \"1999999999999999999999999996000000004\", \"3999999992000000002000000000000000000000000003999999995\"\
    ),\n    (\"999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999\"\
    , \"999999999000000000000000000000000000000000000000000000000000000000000001\"\
    , \"1000000001000000001000000001000000001\", \"999999999999999999999999998999999998999999998999999998999999998\"\
    ),\n    (\"123456789012345678901234567890\", \"98765432109876543210\", \"1249999988\"\
    , \"60185185207253086410\"),\n    (\"3796052693489564843253710304040655603295954567943613205390690926345308868081920963\"\
    , \"65221160938\", \"58202777118581759447762351084212091387289230161903212293762910607473076\"\
    , \"32784015675\"),\n    (\"601683709998136956527839735741885860425411888647\"\
    , \"79495099288022836431966841303039098631547246743370831594175098982\", \"0\"\
    , \"601683709998136956527839735741885860425411888647\"),\n    (\"2913724607330040846456734216287175774859309675541302074084378887193146695666474313520521350831219807083802683926809969102496\"\
    , \"1136657516803566048503413535873373530396301528475286832158510543890417887\"\
    , \"2563414717498923229959648078627694839670758663288883\", \"489563967881475992376338984662834979163097076109434830969080709297652275\"\
    ),\n    (\"6425616253610195704805707157032601658589479184557362782218667037111511517641532311655576424827274220028248486674369795463398\"\
    , \"66317544685625043304904237\", \"96891648870151988021814780755673848282446186190168654300365260228848864137085678350534844942733101\"\
    , \"16247344136848681940414461\"),\n    (\"926577822074079225583833867330555517271863708837179740757190366418533930174844131424064490168045088372293954428243192518195264755018126920551509936966838127\"\
    , \"3608707898\", \"256761657707902194300524643718491265172458607465042253956679307386417322651046036928108413547203949498573119045015926783164444626107592740539264875\"\
    , \"3440355377\"),\n    (\"1304210434873779084743550067431254846598502647807810549096427220381417913693718366677991532915226604275583604020901987682098446835615860809572888779138525128185\"\
    , \"408831999948629823273198786739002560839462725514092689819678885360233\", \"\
    3190088924148927961977760174182266970648955966534006982076541817250068305186199564582499833\"\
    , \"170170546547957694000813903976652546844236802053942770404764657787096\"),\n\
    \    (\"50986593485365203686530924358555874778344517159083891922445851614812536465351666912423747\"\
    , \"1620840360163328120\", \"31456887882670573015348383284727863138483601531897975216641221403736474\"\
    , \"1195684987638574867\")]\n\nfor (aText, bText, qText, rText) in divisionCases:\n\
    \    for aSign in [-1, 1]:\n        for bSign in [-1, 1]:\n            let a =\
    \ initBigInt(aText) * aSign\n            let b = initBigInt(bText) * bSign\n \
    \           var expectedQ = initBigInt(qText) * (aSign * bSign)\n            var\
    \ expectedR = initBigInt(rText) * aSign\n            if rText != \"0\" and aSign\
    \ != bSign:\n                expectedQ -= 1\n                expectedR += b\n\
    \            let qr = divmod(a, b)\n            doAssert qr.quotient == expectedQ\n\
    \            doAssert qr.remainder == expectedR\n            doAssert a // b ==\
    \ expectedQ\n            doAssert a % b == expectedR\n            doAssert a div\
    \ b == initBigInt(qText) * (aSign * bSign)\n            doAssert a mod b == initBigInt(rText)\
    \ * aSign\n            doAssert qr.quotient * b + qr.remainder == a\n        \
    \    doAssert qr.remainder.abs < b.abs\n\nproc checkLargeDivision(aText, bText,\
    \ qText, rText: string, allSigns = false) =\n    ## \u65E2\u77E5\u306E\u5546\u3068\
    \u4F59\u308A\u3092\u4F7F\u3044\u3001\u5927\u6574\u6570\u306E\u9664\u7B97\u30FB\
    \u5270\u4F59\u30FB\u4EE3\u5165\u6F14\u7B97\u3068\u5165\u529B\u5024\u306E\u4FDD\
    \u6301\u3092\u78BA\u8A8D\u3059\u308B\u3002\n    for aSign in (if allSigns: @[-1,\
    \ 1] else: @[1]):\n        for bSign in (if allSigns: @[-1, 1] else: @[1]):\n\
    \            let signedA = (if aSign < 0: \"-\" else: \"\") & aText\n        \
    \    let signedB = (if bSign < 0: \"-\" else: \"\") & bText\n            let a\
    \ = initBigInt(signedA)\n            let b = initBigInt(signedB)\n           \
    \ var expectedQValue = initBigInt(qText) * (aSign * bSign)\n            var expectedRValue\
    \ = initBigInt(rText) * aSign\n            if rText != \"0\" and aSign != bSign:\n\
    \                expectedQValue -= 1\n                expectedRValue += b\n  \
    \          let expectedQ = $expectedQValue\n            let expectedR = $expectedRValue\n\
    \            let qr = divmod(a, b)\n            doAssert $qr.quotient == expectedQ\n\
    \            doAssert $qr.remainder == expectedR\n            doAssert $(a //\
    \ b) == expectedQ\n            doAssert $(a % b) == expectedR\n            let\
    \ truncQ = initBigInt(qText) * (aSign * bSign)\n            let truncR = initBigInt(rText)\
    \ * aSign\n            doAssert a div b == truncQ\n            doAssert a mod\
    \ b == truncR\n            doAssert qr.quotient * b + qr.remainder == a\n    \
    \        doAssert qr.remainder.abs < b.abs\n            var assigned = a\n   \
    \         `div=`(assigned, b)\n            doAssert assigned == truncQ\n     \
    \       assigned = a\n            `mod=`(assigned, b)\n            doAssert assigned\
    \ == truncR\n            doAssert $a == signedA\n            doAssert $b == signedB\n\
    \nblock:\n    doAssert decimalSum(\"0\", \"0\") == \"0\"\n    doAssert decimalSum(\"\
    999\", \"1\") == \"1000\"\n    doAssert decimalSum(\"12\", \"345\") == \"357\"\
    \n    doAssert decimalPredecessor(\"1\") == \"0\"\n    doAssert decimalPredecessor(\"\
    1000\") == \"999\"\n    doAssert decimalPredecessor(\"12345\") == \"12344\"\n\
    \    var divisionRng = initRand(20260910)\n    for leadingLimb in [\"1\", \"500000000\"\
    , \"999999999\"]:\n        let bText = leadingLimb & divisionRng.randomDecimal(9\
    \ * 1280)\n        let qText = divisionRng.randomDecimal(9 * 1283 - 5)\n     \
    \   let product = decimalProduct(qText, bText)\n        for rText in [\"0\", \"\
    1\", decimalPredecessor(bText),\n                divisionRng.randomDecimal(bText.len\
    \ - 1)]:\n            checkLargeDivision(decimalSum(product, rText), bText, qText,\
    \ rText,\n                allSigns = leadingLimb == \"1\")\n\nblock:\n    const\
    \ length = 9 * 1281\n    const dividend = initBigInt(\"1\" & repeat('0', 2 * length))\n\
    \    const divisor = initBigInt(repeat('9', length))\n    const qr = divmod(dividend,\
    \ divisor)\n    doAssert $qr.quotient == \"1\" & repeat('0', length - 1) & \"\
    1\"\n    doAssert qr.remainder == 1\n\nblock:\n    for length in [9 * 255, 9 *\
    \ 256, 9 * 257, 9 * 511, 9 * 512, 9 * 513, 9 * 1279, 9 * 1280,\n            9\
    \ * 1281, 30000]:\n        let divisor = repeat('9', length)\n        let powerOfTen\
    \ = \"1\" & repeat('0', length)\n        let powerPlusOne = \"1\" & repeat('0',\
    \ length - 1) & \"1\"\n        let powerMinusTwo = repeat('9', length - 1) & \"\
    8\"\n        checkLargeDivision(repeat('9', 2 * length), divisor, powerPlusOne,\
    \ \"0\")\n        checkLargeDivision(\"1\" & repeat('0', 2 * length), divisor,\n\
    \            powerPlusOne, \"1\", allSigns = length == 30000)\n        checkLargeDivision(repeat('9',\
    \ length - 1) & \"8\" & repeat('0', length),\n            divisor, powerMinusTwo,\
    \ powerMinusTwo, allSigns = length == 30000)\n        checkLargeDivision(divisor\
    \ & repeat('0', length), divisor, powerOfTen, \"0\")\n        checkLargeDivision(repeat('9',\
    \ 2 * length), powerOfTen, divisor, divisor)\n\n    for length in [18, 9 * 257,\
    \ 9 * 341, 9 * 342, 9 * 1281]:\n        let blocks = if length == 18: 4096 else:\
    \ 8\n        let divisor = repeat('9', length)\n        let quotient = \"1\" &\
    \ repeat(repeat('0', length - 1) & \"1\", blocks - 1)\n        checkLargeDivision(repeat('9',\
    \ length * blocks), divisor, quotient, \"0\")\n\n    for limbs in [257, 341, 342,\
    \ 683]:\n        let length = 9 * limbs\n        for leading in [\"1\", \"999999999\"\
    ]:\n            let divisor = leading & repeat('0', length - leading.len - 1)\
    \ & \"1\"\n            let quotient = \"1\" & repeat('0', 3 * length - 1) & \"\
    1\"\n            let product = divisor & repeat('0', 3 * length - divisor.len)\
    \ & divisor\n            for remainder in [\"0\", \"1\", decimalPredecessor(divisor)]:\n\
    \                checkLargeDivision(decimalSum(product, remainder), divisor,\n\
    \                    quotient, remainder, allSigns = limbs == 257)\n\n    let\
    \ originalText = repeat(\"987654321001234567\", 1800)\n    let original = initBigInt(originalText)\n\
    \    checkLargeDivision(decimalPredecessor(originalText), originalText, \"0\"\
    ,\n        decimalPredecessor(originalText), allSigns = true)\n    checkLargeDivision(originalText,\
    \ originalText, \"1\", \"0\", allSigns = true)\n    var copied = original\n  \
    \  `div=`(copied, copied)\n    doAssert copied == 1\n    copied = original\n \
    \   `mod=`(copied, copied)\n    doAssert copied == 0\n    doAssert $original ==\
    \ originalText\n\nblock:\n    let original = initBigInt(\"999999999999999999999999999999999999\"\
    )\n    var copied = original\n    copied += 1\n    doAssert $original == \"999999999999999999999999999999999999\"\
    \n    doAssert $copied == \"1000000000000000000000000000000000000\"\n    copied\
    \ = original\n    copied += copied\n    doAssert copied == original * 2\n    copied\
    \ = original\n    copied -= copied\n    doAssert copied == 0\n    copied = original\n\
    \    copied *= copied\n    doAssert copied == original * original\n    copied\
    \ = original\n    `div=`(copied, copied)\n    doAssert copied == 1\n    copied\
    \ = original\n    `mod=`(copied, copied)\n    doAssert copied == 0\n    var negative\
    \ = -original\n    var absolute = negative.abs\n    absolute += 1\n    negative\
    \ -= 1\n    doAssert absolute == original + 1\n    doAssert negative == -original\
    \ - 1\n    doAssert $original == \"999999999999999999999999999999999999\"\n  \
    \  let values = @[original, -original, original + 1, initBigInt(0)]\n    var copiedValues\
    \ = values\n    copiedValues[0] += 1\n    doAssert values[0] == original\n   \
    \ doAssert copiedValues[0] == original + 1\n\nblock:\n    doAssert initBigInt(0).pow(0)\
    \ == 1\n    doAssert initBigInt(0).pow(15) == 0\n    doAssert initBigInt(-2).pow(5)\
    \ == -32\n    doAssert initBigInt(-2).pow(6) == 64\n    doAssert $initBigInt(2).pow(256)\
    \ == \"115792089237316195423570985008687907853269984665640564039457584007913129639936\"\
    \n    doAssertRaises(ValueError):\n        discard initBigInt(2).pow(-1)\n   \
    \ let factor = initBigInt(\"123456789012345678901234567890\")\n    for aSign in\
    \ [-1, 1]:\n        for bSign in [-1, 1]:\n            let a = factor * (12 *\
    \ aSign)\n            let b = factor * (18 * bSign)\n            doAssert gcd(a,\
    \ b) == factor * 6\n            doAssert lcm(a, b) == factor * 36\n    doAssert\
    \ gcd(initBigInt(0), initBigInt(0)) == 0\n    doAssert gcd(-factor, initBigInt(0))\
    \ == factor\n    doAssert gcd(initBigInt(0), -factor) == factor\n    doAssert\
    \ lcm(factor, initBigInt(0)) == 0\n    doAssert lcm(initBigInt(0), -factor) ==\
    \ 0\n    doAssert lcm(initBigInt(0), initBigInt(0)) == 0\n\nblock:\n    let zero\
    \ = initBigInt(0)\n    for value in [initBigInt(0), initBigInt(1), initBigInt(-1),\
    \ initBigInt(\"123456789012345678901234567890\")]:\n        doAssertRaises(DivByZeroDefect):\n\
    \            discard value div zero\n        doAssertRaises(DivByZeroDefect):\n\
    \            discard value mod zero\n        doAssertRaises(DivByZeroDefect):\n\
    \            discard value // zero\n        doAssertRaises(DivByZeroDefect):\n\
    \            discard value % zero\n        doAssertRaises(DivByZeroDefect):\n\
    \            discard divmod(value, zero)\n        var assigned = value\n     \
    \   doAssertRaises(DivByZeroDefect):\n            `div=`(assigned, zero)\n   \
    \     doAssert assigned == value\n        doAssertRaises(DivByZeroDefect):\n \
    \           `mod=`(assigned, zero)\n        doAssert assigned == value\n\nblock:\n\
    \    var values = initHashSet[BigInt]()\n    for s in [\"0\", \"000\", \"-0\"\
    , \"+0\", \"1\", \"+01\", \"-1\", \"-001\", \"999999999999999999999999999999\"\
    ]:\n        values.incl(initBigInt(s))\n    doAssert values.len == 4\n    doAssert\
    \ initBigInt(0) in values\n    doAssert initBigInt(-1) in values\n    var counts\
    \ = initTable[BigInt, int]()\n    counts[initBigInt(\"00012345678901234567890\"\
    )] = 7\n    doAssert counts[initBigInt(\"+12345678901234567890\")] == 7\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/powmod.nim
  - cplib/modint/modint.nim
  - cplib/math/bigint.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/modint/modint.nim
  - cplib/math/inner_math.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/bigint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  isVerificationFile: true
  path: verify/math/bigint_unit_test.nim
  requiredBy: []
  timestamp: '2026-09-12 14:57:18+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/bigint_unit_test.nim
layout: document
redirect_from:
- /verify/verify/math/bigint_unit_test.nim
- /verify/verify/math/bigint_unit_test.nim.html
title: verify/math/bigint_unit_test.nim
---
