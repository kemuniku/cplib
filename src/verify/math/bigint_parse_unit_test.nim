# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, strutils
import cplib/math/bigint

static:
    for text in ["123456789", "123456789012345678", "+000000000000000001", "-999999999999999999"]:
        doAssert $parseBigInt(text) == $parseBigInt($parseBigInt(text))
    for text in ["12345678a", "a12345678", "12345678\x00", "+12345678/", "123456789\xff00000000"]:
        doAssertRaises(ValueError):
            discard parseBigInt(text)

block:
    for background in ["000000000", "999999999", "123456789"]:
        for position in 0..<9:
            for value in 0..255:
                var text = background
                text[position] = char(value)
                if value >= ord('0') and value <= ord('9'):
                    doAssert parseBigInt(text) == initBigInt(parseInt(text))
                else:
                    doAssertRaises(ValueError):
                        discard parseBigInt("0" & text)
                    doAssertRaises(ValueError):
                        discard parseBigInt("+" & text & "123456789")
                    doAssertRaises(ValueError):
                        discard parseBigInt("-123456789" & text)

block:
    var rng = initRand(20261002)
    for _ in 0..<10000:
        let value = rng.rand(999999999)
        let text = align($value, 9, '0')
        doAssert parseBigInt(text) == initBigInt(value)
        doAssert parseBigInt("-" & text) == initBigInt(-value)
        doAssert parseBigInt(text & text) == initBigInt(value) * 1000000000 + value
    for length in 1..64:
        let nines = repeat('9', length)
        let power = "1" & repeat('0', length)
        doAssert $(parseBigInt(nines) + 1) == power
        doAssert $(parseBigInt("-" & nines) - 1) == "-" & power
        doAssert parseBigInt("+" & repeat('0', length)).isZero
        doAssert parseBigInt("-" & repeat('0', length)).sgn == 0
        let value = parseBigInt(nines)
        var assigned = value
        assigned += assigned
        doAssert assigned == value + value
        doAssert parseBigInt(nines) + parseBigInt("-" & nines) == 0

echo "Hello World"
