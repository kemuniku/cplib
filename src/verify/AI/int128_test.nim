# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/int128

let a = parseInt128("123456789012345678901234567890")
let b = parseInt128("10")
assert $a == "123456789012345678901234567890"
assert $(a + b) == "123456789012345678901234567900"
assert $((a + b) - a) == "10"
assert $(b * b) == "100"
assert $(parseInt128("100") div b) == "10"
assert $(parseInt128("103") mod b) == "3"
assert (parseInt128("5") & parseInt128("3")).to_int == 1
assert (parseInt128("5") | parseInt128("2")).to_int == 7
assert (parseInt128("5") ^ parseInt128("1")).to_int == 4
assert (parseInt128("1") << parseInt128("5")).to_int == 32
assert (parseInt128("32") >> parseInt128("2")).to_int == 8
assert -b < b
assert abs(-b) == b
assert cmp(b, parseInt128("10")) == 0
assert pow(parseInt128("2"), parseInt128("10")).to_int == 1024
assert pow(parseInt128("2"), parseInt128("10"), parseInt128("1000")).to_int == 24

import hashes, tables

let boundaryStrings = @[
    "0", "1", "-1", "9999", "10000", "-10000",
    "18446744073709551616", "-18446744073709551616",
    "170141183460469231731687303715884105727",
    "-170141183460469231731687303715884105728"
]
var values = initTable[Int128, string]()
for s in boundaryStrings:
    let x = parseInt128(s)
    assert $x == s
    assert hash(x) == hash(parseInt128(s))
    values[x] = s
for s in boundaryStrings:
    assert values[parseInt128(s)] == s
assert values.len == boundaryStrings.len
assert $(parseInt128(boundaryStrings[^1]) + 1) == "-170141183460469231731687303715884105727"
assert $(parseInt128(boundaryStrings[^2]) - 1) == "170141183460469231731687303715884105726"
assert $parseInt128("0") == "0"

assert sizeof(Int128) == 16
assert $to_Int128(high(uint64)) == "18446744073709551615"
assert $to_Int128(low(int64)) == "-9223372036854775808"
assert to_Int128(high(int64)).to_int == high(int64)
assert to_Int128(low(int64)).to_int == low(int64)
assert to_Int128(high(uint8)) == 255
assert to_Int128(low(int8)) == -128
assert to_Int128(high(uint16)) == 65535
assert to_Int128(low(int16)) == -32768
assert $to_Int128(high(uint32)) == "4294967295"
assert to_Int128(low(int32)) == -2147483648

let wide = parseInt128("18446744073709551616")
var updated = wide
updated += updated
assert updated == wide * 2
updated -= wide
updated *= 3
updated.div= to_Int128(3)
assert updated == wide
updated.mod= to_Int128(3)
assert updated == 1
updated <<= 65
assert updated == wide * 2
updated >>= 64
assert updated == 2
updated |= wide
updated ^= 3
updated &= wide + 1
assert updated == wide + 1
updated = -wide
updated >>= 64
assert updated == -1
assert (-wide - 1) div to_Int128(3) == -parseInt128("6148914691236517205")
assert (-wide - 1) mod to_Int128(3) == -2
assert wide > wide - 1
assert wide >= wide
assert -wide <= -wide
assert -wide < 0

type Int128Holder = object
    value: Int128
    marker: int

var holders = newSeq[Int128Holder](2)
assert holders[0].value == 0
holders[0] = Int128Holder(value: wide, marker: 7)
holders[1] = Int128Holder(value: -wide, marker: 9)
for i in 0..<100:
    holders.add(Int128Holder(value: wide + i, marker: i))
swap(holders[0], holders[1])
assert holders[0].value == -wide and holders[0].marker == 9
assert holders[1].value == wide and holders[1].marker == 7
for i in 0..<100:
    assert holders[i + 2].value == wide + i
    assert holders[i + 2].marker == i
