# verification-helper: PROBLEM https://judge.yosupo.jp/problem/addition_of_big_integers
include cplib/tmpl/fastio
import cplib/math/bigint

proc tryParseSmallDecimal(s: string, value: var int64): bool =
    let first = ord(s.len > 0 and (s[0] == '+' or s[0] == '-'))
    if s.len - first notin 1..18:
        return false
    var magnitude = 0'u64
    for i in first..<s.len:
        if s[i] < '0' or s[i] > '9':
            return false
        magnitude = magnitude * 10 + uint64(ord(s[i]) - ord('0'))
    value = if s[0] == '-': -int64(magnitude) else: int64(magnitude)
    true

static:
    for text in ["0", "+0", "-0", "000000000000000000",
            "+000000000000000001", "999999999999999999",
            "-999999999999999999"]:
        var value: int64
        doAssert tryParseSmallDecimal(text, value)
        doAssert initBigInt(value) == parseBigInt(text)
    for text in ["", "+", "-", "1_000", " 1", "1 ", "--1",
            "1234567890123456789", "0000000000000000001",
            "-0000000000000000001"]:
        var value: int64
        doAssert not tryParseSmallDecimal(text, value)
    for position in 0..<18:
        for byte in 0..255:
            var text = "123456789012345678"
            text[position] = char(byte)
            for sign in ["", "+", "-"]:
                var value: int64
                let accepted = tryParseSmallDecimal(sign & text, value)
                let expected = (byte >= ord('0') and byte <= ord('9')) or
                    (position == 0 and sign.len == 0 and char(byte) in ['+', '-'])
                doAssert accepted == expected
                if accepted:
                    doAssert initBigInt(value) == parseBigInt(sign & text)
    for a in [999999999999999999'i64, -999999999999999999'i64, 0'i64]:
        for b in [999999999999999999'i64, -999999999999999999'i64, 0'i64]:
            doAssert initBigInt(a + b) == initBigInt(a) + initBigInt(b)

let queryCount = input(int)
for _ in 0..<queryCount:
    let a = input(string)
    let b = input(string)
    var smallA, smallB: int64
    if tryParseSmallDecimal(a, smallA) and tryParseSmallDecimal(b, smallB):
        print(smallA + smallB)
    else:
        print(parseBigInt(a) + parseBigInt(b))
