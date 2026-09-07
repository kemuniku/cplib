# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/can_reverse_hash_string

let aba = "aba".tohash
let ab = "ab".tohash
assert aba.isPalindrome
assert not ab.isPalindrome
assert ab.reversed == "ba".tohash
assert "ab".tohash & "c".tohash == "abc".tohash
assert "ab".tohash * 3 == "ababab".tohash
assert get_emptystring_hash() & aba == aba
assert 65.tohash == 'A'.tohash
assert ['a', 'b', 'a'].tohash == aba
assert [65, 66].tohash == "AB".tohash

const hashMod = (1 shl 61) - 1
let boundaryValues = [0, 1, hashMod - 1]
assert newSeq[int]().tohash == get_emptystring_hash()
var values: seq[int]
var concatenated = get_emptystring_hash()
var reverseConcatenated = get_emptystring_hash()
for i in 0..<4096:
    let value = boundaryValues[i mod boundaryValues.len]
    values.add(value)
    concatenated = concatenated & value.tohash
    reverseConcatenated = value.tohash & reverseConcatenated
assert values.tohash == concatenated
assert values.tohash.reversed == reverseConcatenated
assert values.toOpenArray(1, values.high - 1).tohash.reversed ==
    values[1..^2].tohash.reversed

when compileOption("assertions"):
    for value in [int.low, -1, hashMod, hashMod + 1, int.high]:
        for index in 0..<5:
            var invalidValues = @[0, 1, 2, 3, 4]
            invalidValues[index] = value
            var rejected = false
            try:
                discard invalidValues.tohash
            except AssertionDefect:
                rejected = true
            doAssert rejected

let rh = initRollingHash("abacaba")
assert $rh[0..2] == "aba"
assert rh[0..2].isPalindrome
assert rh[0..2].reversed == rh[0..2]
assert rh[0..2] == rh[4..6]
assert rh[0] == 'a'
assert rh[0..6].LCP(rh[4..6]) == 3
assert cmp(rh[0..2], rh[1..3]) < 0
let hs: HashString = rh[0..2]
assert hs == aba
let arrayRh = initRollingHash(['a', 'b', 'a', 'c', 'a', 'b', 'a'])
assert arrayRh[0..2] == rh[0..2]
assert initRollingHash(newSeq[char]()).len == 0
