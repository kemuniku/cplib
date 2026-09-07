# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/hash_string

let a = "ab".tohash
let b = 'c'.tohash
let abc = "abc".tohash
assert len(a) == 2
assert a & b == abc
assert get_emptystring_hash() & abc == abc
assert "xy".tohash * 3 == "xyxyxy".tohash
assert "abc".tohash.removePrefix("ab".tohash) == "c".tohash
assert 65.tohash == 'A'.tohash
assert ['a', 'b', 'c'].tohash == abc
assert [65, 66].tohash == "AB".tohash

const hashMod = (1 shl 61) - 1
let boundaryValues = [int.low, -hashMod, -1, 0, 1, hashMod - 1,
                      hashMod, hashMod + 1, int.high]
for value in boundaryValues:
    assert [value].tohash == value.tohash
assert newSeq[int]().tohash == get_emptystring_hash()
var values: seq[int]
var concatenated = get_emptystring_hash()
for i in 0..<4096:
    let value = boundaryValues[i mod boundaryValues.len]
    values.add(value)
    concatenated = concatenated & value.tohash
assert values.tohash == concatenated
assert values.toOpenArray(1, values.high - 1).tohash ==
    values[1..^2].tohash

let rh = initRollingHash("banana")
assert $rh[1..3] == "ana"
assert rh[1..3] == rh[3..5]
assert rh[0] == 'b'
assert rh[1..5].LCP(rh[3..5]) == 3
assert cmp(rh[1..3], rh[1..3]) == 0
assert rh[1..3] < rh[0..2]
let hs: HashString = rh[1..3]
assert hs == "ana".tohash
let arrayRh = initRollingHash(['b', 'a', 'n', 'a', 'n', 'a'])
assert arrayRh[1..3] == rh[1..3]
assert initRollingHash(newSeq[char]()).len == 0
