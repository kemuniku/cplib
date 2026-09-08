# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import hashes, random, sets, strutils, tables
import cplib/math/bigint

block:
    doAssert $(-17'i8) == "-17"
    doAssert $(-17'i16) == "-17"
    doAssert $(-17'i32) == "-17"
    doAssert $(-17'i64) == "-17"
    doAssert $(17'u8) == "17"
    doAssert $(17'u16) == "17"
    doAssert $(17'u32) == "17"
    doAssert $(17'u64) == "17"
    doAssert cmp(-17'i32, 17'i32) == -1
    doAssert cmp(17'u32, 17'u32) == 0
    doAssert hash(-17'i32) == hashes.hash(-17'i32)
    doAssert hash(17'u32) == hashes.hash(17'u32)
    doAssert hash(17) == hashes.hash(17)

block:
    var zero: BigInt
    doAssert $zero == "0"
    doAssert zero.isZero
    doAssert zero.sgn == 0
    for s in ["0", "-0", "+0", "00000", "-00000", "+00000"]:
        let value = parseBigInt(s)
        doAssert value == zero
        doAssert $value == "0"
        doAssert value.hash == zero.hash
    doAssert $parseBigInt("+00012345678901234567890") == "12345678901234567890"
    doAssert $initBigInt("-00012345678901234567890") == "-12345678901234567890"
    for s in ["", "+", "-", " 1", "1 ", "1\n", "--1", "+-1", "1_000", "0x10", "1.0", "a", "１２"]:
        doAssertRaises(ValueError):
            discard parseBigInt(s)
    for value in [low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]:
        doAssert $initBigInt(value) == $value
        doAssert initBigInt(value).toInt == value
        doAssert parseBigInt($value).toInt == value
    doAssert $initBigInt(low(int8)) == "-128"
    doAssert $initBigInt(high(uint8)) == "255"
    doAssert $initBigInt(low(int16)) == "-32768"
    doAssert $initBigInt(high(uint16)) == "65535"
    doAssert $initBigInt(low(int32)) == "-2147483648"
    doAssert $initBigInt(high(uint32)) == "4294967295"
    doAssert $initBigInt(low(int64)) == "-9223372036854775808"
    doAssert $initBigInt(high(uint64)) == "18446744073709551615"
    let unsignedValue: BigInt = high(uint64)
    let signedValue: BigInt = low(int64)
    doAssert $unsignedValue == "18446744073709551615"
    doAssert $signedValue == "-9223372036854775808"
    doAssertRaises(OverflowDefect):
        discard (initBigInt(high(int)) + 1).toInt
    doAssertRaises(OverflowDefect):
        discard (initBigInt(low(int)) - 1).toInt
    doAssertRaises(OverflowDefect):
        discard parseBigInt("999999999999999999999999999999999999").toInt

proc checkSmall(a, b: int) =
    ## 組み込み整数と四則演算・比較・代入演算の結果を照合する。
    let x = initBigInt(a)
    let y = initBigInt(b)
    doAssert +x == x
    doAssert -x == initBigInt(-a)
    doAssert x.abs == initBigInt(abs(a))
    doAssert x.sgn == (if a < 0: -1 elif a > 0: 1 else: 0)
    doAssert x.isZero == (a == 0)
    doAssert x + y == initBigInt(a + b)
    doAssert x - y == initBigInt(a - b)
    doAssert x * y == initBigInt(a * b)
    doAssert x + b == initBigInt(a + b)
    doAssert a + y == initBigInt(a + b)
    doAssert x - b == initBigInt(a - b)
    doAssert a - y == initBigInt(a - b)
    doAssert x * b == initBigInt(a * b)
    doAssert a * y == initBigInt(a * b)
    doAssert (x == y) == (a == b)
    doAssert (x != y) == (a != b)
    doAssert (x < y) == (a < b)
    doAssert (x <= y) == (a <= b)
    doAssert (x > y) == (a > b)
    doAssert (x >= y) == (a >= b)
    doAssert cmp(x, y) == cmp(a, b)
    doAssert (x == b) == (a == b)
    doAssert (a == y) == (a == b)
    doAssert (x < b) == (a < b)
    doAssert (a < y) == (a < b)
    doAssert (x <= b) == (a <= b)
    doAssert (a <= y) == (a <= b)
    doAssert (x > b) == (a > b)
    doAssert (a > y) == (a > b)
    doAssert (x >= b) == (a >= b)
    doAssert (a >= y) == (a >= b)
    var assigned = x
    assigned += y
    doAssert assigned == x + y
    assigned = x
    assigned -= y
    doAssert assigned == x - y
    assigned = x
    assigned *= y
    doAssert assigned == x * y
    if b != 0:
        let (quotient, remainder) = divmod(x, y)
        doAssert quotient == initBigInt(a div b)
        doAssert remainder == initBigInt(a mod b)
        doAssert x div y == quotient
        doAssert x mod y == remainder
        doAssert x div b == quotient
        doAssert a div y == quotient
        doAssert x mod b == remainder
        doAssert a mod y == remainder
        assigned = x
        `div=`(assigned, y)
        doAssert assigned == quotient
        assigned = x
        `mod=`(assigned, y)
        doAssert assigned == remainder
    doAssert $x == $a
    doAssert $y == $b

for a in -12..12:
    for b in -12..12:
        checkSmall(a, b)
var rng = initRand(20260908)
for _ in 0..<2000:
    checkSmall(rng.rand(-30000..30000), rng.rand(-30000..30000))

block:
    let a = initBigInt("123456789012345678901234567890")
    let b = initBigInt("98765432109876543210")
    doAssert $(a + b) == "123456789111111111011111111100"
    doAssert $(a - b) == "123456788913580246791358024680"
    doAssert $(a * b) == "12193263113702179522496570642237463801111263526900"
    let carry = initBigInt("999999999999999999999999999")
    doAssert $(carry + 1) == "1000000000000000000000000000"
    doAssert $(carry + 1 - carry) == "1"
    doAssert $(-carry - 1) == "-1000000000000000000000000000"
    doAssert $(a - a) == "0"
    doAssert $(a * 0) == "0"
    doAssert (a * 0).sgn == 0
    doAssert a < a + 1
    doAssert -a < -b
    doAssert a > b
    doAssert initBigInt(low(int)) div -1 == -initBigInt(low(int))
    doAssert initBigInt(low(int)) mod -1 == 0

proc decimalProduct(a, b: string): string =
    ## 非負整数の積を独立した 10 進の筆算で求める。
    var digits = newSeq[int](a.len + b.len)
    for i in 0..<a.len:
        for j in 0..<b.len:
            digits[i + j] += (ord(a[a.high - i]) - ord('0')) *
                (ord(b[b.high - j]) - ord('0'))
    for i in 0..<digits.high:
        digits[i + 1] += digits[i] div 10
        digits[i] = digits[i] mod 10
    while digits.len > 1 and digits[^1] == 0:
        digits.setLen(digits.len - 1)
    result = newString(digits.len)
    for i in 0..<digits.len:
        result[result.high - i] = char(ord('0') + digits[i])

proc decimalSum(a, b: string): string =
    ## 非負整数の和を独立した 10 進の筆算で求める。
    result = newString(max(a.len, b.len) + 1)
    var carry = 0
    for offset in 0..<result.len:
        if offset < a.len:
            carry += ord(a[a.high - offset]) - ord('0')
        if offset < b.len:
            carry += ord(b[b.high - offset]) - ord('0')
        result[result.high - offset] = char(ord('0') + carry mod 10)
        carry = carry div 10
    if result[0] == '0':
        result = result[1..^1]

proc decimalPredecessor(a: string): string =
    ## 正整数から 1 を引いた値を独立した 10 進の筆算で求める。
    result = a
    var i = result.high
    while result[i] == '0':
        result[i] = '9'
        dec i
    result[i] = char(ord(result[i]) - 1)
    if result.len > 1 and result[0] == '0':
        result = result[1..^1]

proc randomDecimal(rng: var Rand, length: int): string =
    ## 先頭が 0 ではない指定桁数の乱数文字列を返す。
    result = newString(length)
    result[0] = char(ord('0') + rng.rand(1..9))
    for i in 1..<length:
        result[i] = char(ord('0') + rng.rand(0..9))

proc checkLargeProduct(aText, bText, expected: string, allSigns = false) =
    ## 大整数の積・交換法則・代入演算と入力値の保持を確認する。
    for aSign in (if allSigns: @[-1, 1] else: @[1]):
        for bSign in (if allSigns: @[-1, 1] else: @[1]):
            let signedA = (if aSign < 0: "-" else: "") & aText
            let signedB = (if bSign < 0: "-" else: "") & bText
            let a = initBigInt(signedA)
            let b = initBigInt(signedB)
            let signedExpected =
                (if aSign != bSign and expected != "0": "-" else: "") & expected
            doAssert $(a * b) == signedExpected
            doAssert $(b * a) == signedExpected
            var assigned = a
            assigned *= b
            doAssert $assigned == signedExpected
            doAssert a == initBigInt(signedA)
            doAssert b == initBigInt(signedB)

block:
    const nines = repeat('9', 2400)
    const squared = $(initBigInt(nines) * initBigInt(nines))
    doAssert squared == repeat('9', 2399) & "8" & repeat('0', 2399) & "1"

block:
    doAssert decimalProduct("0", "123") == "0"
    doAssert decimalProduct("99", "99") == "9801"
    doAssert decimalProduct("123456789", "987654321") == "121932631112635269"
    var multiplicationRng = initRand(20260909)
    for limbs in [255, 256, 257]:
        for missingDigits in [0, 1, 2]:
            let aText = multiplicationRng.randomDecimal(9 * limbs - missingDigits)
            let bText = multiplicationRng.randomDecimal(9 * limbs - 2 + missingDigits)
            checkLargeProduct(aText, bText, decimalProduct(aText, bText),
                allSigns = missingDigits == 1)
        let nines = repeat('9', 9 * limbs)
        let expected = repeat('9', nines.len - 1) & "8" &
            repeat('0', nines.len - 1) & "1"
        checkLargeProduct(nines, nines, expected)
        let original = initBigInt(nines)
        var squared = original
        squared *= squared
        doAssert $squared == expected
        doAssert $original == nines

    let longText = multiplicationRng.randomDecimal(5432)
    for shortText in ["0", "1", "999", "1000", "999999999", "1000000000",
            multiplicationRng.randomDecimal(9 * 255),
            multiplicationRng.randomDecimal(9 * 256),
            multiplicationRng.randomDecimal(9 * 257)]:
        checkLargeProduct(longText, shortText, decimalProduct(longText, shortText),
            allSigns = true)
    for _ in 0..<24:
        let aText = multiplicationRng.randomDecimal(multiplicationRng.rand(2305..3600))
        let bText = multiplicationRng.randomDecimal(multiplicationRng.rand(2305..3600))
        checkLargeProduct(aText, bText, decimalProduct(aText, bText))

    for length in [3068, 3069, 3070, 6137, 6138, 6139, 30000, 30001]:
        let nines = repeat('9', length)
        let expected = repeat('9', length - 1) & "8" & repeat('0', length - 1) & "1"
        checkLargeProduct(nines, nines, expected, allSigns = true)
        let powerOfTen = "1" & repeat('0', length)
        let sparse = "1" & repeat('0', length - 1) & "1"
        checkLargeProduct(powerOfTen, sparse, sparse & repeat('0', length))
        let original = initBigInt(nines)
        var squared = original
        squared *= squared
        doAssert $squared == expected
        doAssert $original == nines

# Python の整数演算で求めた商と余りを、すべての符号の組合せで確認する。
const divisionCases = [
    ("2000000000000000001", "1000000000000000001", "1", "1000000000000000000"),
    ("1000000000000000000000000001", "500000000000000000000000001", "1", "500000000000000000000000000"),
    ("9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999", "100000000000000000000000000000000000000000000000001", "99999999999999999999999999999999999999999999999999", "0"),
    ("10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001", "9", "999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999991"),
    ("1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000001", "1000000000000000000000000000001", "1000000000000000000000000000000000000000000000000000000000000", "1"),
    ("999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999", "999999999999999999999999999999", "1000000000000000000000000000001000000000000000000000000000001", "0"),
    ("999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999", "500000000000000000000000000999999999000000000000000000000000000000000001", "1999999999999999999999999996000000004", "3999999992000000002000000000000000000000000003999999995"),
    ("999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999", "999999999000000000000000000000000000000000000000000000000000000000000001", "1000000001000000001000000001000000001", "999999999999999999999999998999999998999999998999999998999999998"),
    ("123456789012345678901234567890", "98765432109876543210", "1249999988", "60185185207253086410"),
    ("3796052693489564843253710304040655603295954567943613205390690926345308868081920963", "65221160938", "58202777118581759447762351084212091387289230161903212293762910607473076", "32784015675"),
    ("601683709998136956527839735741885860425411888647", "79495099288022836431966841303039098631547246743370831594175098982", "0", "601683709998136956527839735741885860425411888647"),
    ("2913724607330040846456734216287175774859309675541302074084378887193146695666474313520521350831219807083802683926809969102496", "1136657516803566048503413535873373530396301528475286832158510543890417887", "2563414717498923229959648078627694839670758663288883", "489563967881475992376338984662834979163097076109434830969080709297652275"),
    ("6425616253610195704805707157032601658589479184557362782218667037111511517641532311655576424827274220028248486674369795463398", "66317544685625043304904237", "96891648870151988021814780755673848282446186190168654300365260228848864137085678350534844942733101", "16247344136848681940414461"),
    ("926577822074079225583833867330555517271863708837179740757190366418533930174844131424064490168045088372293954428243192518195264755018126920551509936966838127", "3608707898", "256761657707902194300524643718491265172458607465042253956679307386417322651046036928108413547203949498573119045015926783164444626107592740539264875", "3440355377"),
    ("1304210434873779084743550067431254846598502647807810549096427220381417913693718366677991532915226604275583604020901987682098446835615860809572888779138525128185", "408831999948629823273198786739002560839462725514092689819678885360233", "3190088924148927961977760174182266970648955966534006982076541817250068305186199564582499833", "170170546547957694000813903976652546844236802053942770404764657787096"),
    ("50986593485365203686530924358555874778344517159083891922445851614812536465351666912423747", "1620840360163328120", "31456887882670573015348383284727863138483601531897975216641221403736474", "1195684987638574867")]

for (aText, bText, qText, rText) in divisionCases:
    for aSign in [-1, 1]:
        for bSign in [-1, 1]:
            let a = initBigInt(aText) * aSign
            let b = initBigInt(bText) * bSign
            let expectedQ = initBigInt(qText) * (aSign * bSign)
            let expectedR = initBigInt(rText) * aSign
            let qr = divmod(a, b)
            doAssert qr.quotient == expectedQ
            doAssert qr.remainder == expectedR
            doAssert a div b == expectedQ
            doAssert a mod b == expectedR
            doAssert qr.quotient * b + qr.remainder == a
            doAssert qr.remainder.abs < b.abs

proc checkLargeDivision(aText, bText, qText, rText: string, allSigns = false) =
    ## 既知の商と余りを使い、大整数の除算・剰余・代入演算と入力値の保持を確認する。
    for aSign in (if allSigns: @[-1, 1] else: @[1]):
        for bSign in (if allSigns: @[-1, 1] else: @[1]):
            let signedA = (if aSign < 0: "-" else: "") & aText
            let signedB = (if bSign < 0: "-" else: "") & bText
            let expectedQ =
                (if aSign != bSign and qText != "0": "-" else: "") & qText
            let expectedR =
                (if aSign < 0 and rText != "0": "-" else: "") & rText
            let a = initBigInt(signedA)
            let b = initBigInt(signedB)
            let qr = divmod(a, b)
            doAssert $qr.quotient == expectedQ
            doAssert $qr.remainder == expectedR
            doAssert $(a div b) == expectedQ
            doAssert $(a mod b) == expectedR
            doAssert qr.quotient * b + qr.remainder == a
            doAssert qr.remainder.abs < b.abs
            var assigned = a
            `div=`(assigned, b)
            doAssert $assigned == expectedQ
            assigned = a
            `mod=`(assigned, b)
            doAssert $assigned == expectedR
            doAssert $a == signedA
            doAssert $b == signedB

block:
    doAssert decimalSum("0", "0") == "0"
    doAssert decimalSum("999", "1") == "1000"
    doAssert decimalSum("12", "345") == "357"
    doAssert decimalPredecessor("1") == "0"
    doAssert decimalPredecessor("1000") == "999"
    doAssert decimalPredecessor("12345") == "12344"
    var divisionRng = initRand(20260910)
    for leadingLimb in ["1", "500000000", "999999999"]:
        let bText = leadingLimb & divisionRng.randomDecimal(9 * 1280)
        let qText = divisionRng.randomDecimal(9 * 1283 - 5)
        let product = decimalProduct(qText, bText)
        for rText in ["0", "1", decimalPredecessor(bText),
                divisionRng.randomDecimal(bText.len - 1)]:
            checkLargeDivision(decimalSum(product, rText), bText, qText, rText,
                allSigns = leadingLimb == "1")

block:
    const length = 9 * 1281
    const dividend = initBigInt("1" & repeat('0', 2 * length))
    const divisor = initBigInt(repeat('9', length))
    const qr = divmod(dividend, divisor)
    doAssert $qr.quotient == "1" & repeat('0', length - 1) & "1"
    doAssert qr.remainder == 1

block:
    for length in [9 * 511, 9 * 512, 9 * 513, 9 * 1279, 9 * 1280,
            9 * 1281, 30000]:
        let divisor = repeat('9', length)
        let powerOfTen = "1" & repeat('0', length)
        let powerPlusOne = "1" & repeat('0', length - 1) & "1"
        let powerMinusTwo = repeat('9', length - 1) & "8"
        checkLargeDivision(repeat('9', 2 * length), divisor, powerPlusOne, "0")
        checkLargeDivision("1" & repeat('0', 2 * length), divisor,
            powerPlusOne, "1", allSigns = length == 30000)
        checkLargeDivision(repeat('9', length - 1) & "8" & repeat('0', length),
            divisor, powerMinusTwo, powerMinusTwo, allSigns = length == 30000)
        checkLargeDivision(divisor & repeat('0', length), divisor, powerOfTen, "0")
        checkLargeDivision(repeat('9', 2 * length), powerOfTen, divisor, divisor)

    for length in [18, 9 * 1281]:
        let blocks = if length == 18: 4096 else: 8
        let divisor = repeat('9', length)
        let quotient = "1" & repeat(repeat('0', length - 1) & "1", blocks - 1)
        checkLargeDivision(repeat('9', length * blocks), divisor, quotient, "0")

    let originalText = repeat("987654321001234567", 1800)
    let original = initBigInt(originalText)
    checkLargeDivision(decimalPredecessor(originalText), originalText, "0",
        decimalPredecessor(originalText), allSigns = true)
    checkLargeDivision(originalText, originalText, "1", "0", allSigns = true)
    var copied = original
    `div=`(copied, copied)
    doAssert copied == 1
    copied = original
    `mod=`(copied, copied)
    doAssert copied == 0
    doAssert $original == originalText

block:
    let original = initBigInt("999999999999999999999999999999999999")
    var copied = original
    copied += 1
    doAssert $original == "999999999999999999999999999999999999"
    doAssert $copied == "1000000000000000000000000000000000000"
    copied = original
    copied += copied
    doAssert copied == original * 2
    copied = original
    copied -= copied
    doAssert copied == 0
    copied = original
    copied *= copied
    doAssert copied == original * original
    copied = original
    `div=`(copied, copied)
    doAssert copied == 1
    copied = original
    `mod=`(copied, copied)
    doAssert copied == 0
    var negative = -original
    var absolute = negative.abs
    absolute += 1
    negative -= 1
    doAssert absolute == original + 1
    doAssert negative == -original - 1
    doAssert $original == "999999999999999999999999999999999999"
    let values = @[original, -original, original + 1, initBigInt(0)]
    var copiedValues = values
    copiedValues[0] += 1
    doAssert values[0] == original
    doAssert copiedValues[0] == original + 1

block:
    doAssert initBigInt(0).pow(0) == 1
    doAssert initBigInt(0).pow(15) == 0
    doAssert initBigInt(-2).pow(5) == -32
    doAssert initBigInt(-2).pow(6) == 64
    doAssert $initBigInt(2).pow(256) == "115792089237316195423570985008687907853269984665640564039457584007913129639936"
    doAssertRaises(ValueError):
        discard initBigInt(2).pow(-1)
    let factor = initBigInt("123456789012345678901234567890")
    for aSign in [-1, 1]:
        for bSign in [-1, 1]:
            let a = factor * (12 * aSign)
            let b = factor * (18 * bSign)
            doAssert gcd(a, b) == factor * 6
            doAssert lcm(a, b) == factor * 36
    doAssert gcd(initBigInt(0), initBigInt(0)) == 0
    doAssert gcd(-factor, initBigInt(0)) == factor
    doAssert gcd(initBigInt(0), -factor) == factor
    doAssert lcm(factor, initBigInt(0)) == 0
    doAssert lcm(initBigInt(0), -factor) == 0
    doAssert lcm(initBigInt(0), initBigInt(0)) == 0

block:
    let zero = initBigInt(0)
    for value in [initBigInt(0), initBigInt(1), initBigInt(-1), initBigInt("123456789012345678901234567890")]:
        doAssertRaises(DivByZeroDefect):
            discard value div zero
        doAssertRaises(DivByZeroDefect):
            discard value mod zero
        doAssertRaises(DivByZeroDefect):
            discard divmod(value, zero)
        var assigned = value
        doAssertRaises(DivByZeroDefect):
            `div=`(assigned, zero)
        doAssert assigned == value
        doAssertRaises(DivByZeroDefect):
            `mod=`(assigned, zero)
        doAssert assigned == value

block:
    var values = initHashSet[BigInt]()
    for s in ["0", "000", "-0", "+0", "1", "+01", "-1", "-001", "999999999999999999999999999999"]:
        values.incl(initBigInt(s))
    doAssert values.len == 4
    doAssert initBigInt(0) in values
    doAssert initBigInt(-1) in values
    var counts = initTable[BigInt, int]()
    counts[initBigInt("00012345678901234567890")] = 7
    doAssert counts[initBigInt("+12345678901234567890")] == 7

echo "Hello World"
