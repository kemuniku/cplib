# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/merged_static_string
import cplib/str/static_string

let ss = toStaticStrings(@["ab", "cd", "abce"])
let m1 = ss[0] & ss[1]
assert $m1 == "abcd"
assert m1.len == 4
assert m1[2] == 'c'
assert $m1[1..2] == "bc"
var m2 = initMergedStaticString(@[ss[0]])
m2 &= ss[1]
assert m1 == m2
let m3 = ss[0] & ss[2]
assert lcp(m1, m3) == 2
assert cmp(m1, m3) > 0
assert m3 < m1
assert m1 >= m2

let integerStatic = toStaticString([1, 2, 3, 1, 2, 4])
let integerMerged = integerStatic[0..1] & integerStatic[2..3]
assert $integerMerged == "1 2 3 1"
assert integerMerged.len == 4
assert integerMerged[2] == 3
assert $integerMerged[1..2] == "2 3"
var integerMerged2 = initMergedStaticString(@[integerStatic[0..1]])
integerMerged2 &= integerStatic[2..3]
assert integerMerged == integerMerged2
let integerMerged3 = integerStatic[0..1] & integerStatic[4..5]
assert lcp(integerMerged, integerMerged3) == 2
assert integerMerged > integerMerged3
var emptyIntegerMerged: MergedStaticString[int]
assert $emptyIntegerMerged == ""
let initializedEmptyIntegerMerged = initMergedStaticString(newSeq[StaticString[int]]())
assert initializedEmptyIntegerMerged.len == 0

let integerMergedFromRanges = initMergedStaticString(integerStatic, @[(0, 2), (2, 4)])
assert integerMergedFromRanges == integerMerged
let integerSubStatic = integerStatic[1..5]
let integerSubMergedFromRanges = initMergedStaticString(integerSubStatic, @[(0, 2), (3, 5)])
assert $integerSubMergedFromRanges == "2 3 2 4"
let emptyIntegerMergedFromRanges = initMergedStaticString(integerStatic, newSeq[(int, int)]())
assert emptyIntegerMergedFromRanges.len == 0
let integerMergedWithEmptyRange = initMergedStaticString(integerStatic, @[(1, 1), (0, 2)])
assert $integerMergedWithEmptyRange == "1 2"
let allEmptyIntegerMerged = initMergedStaticString(integerStatic, @[(0, 0), (2, 2)])
let integerMergedWithTrailingEmpty = initMergedStaticString(integerStatic, @[(0, 2), (3, 3)])
assert cmp(allEmptyIntegerMerged, integerMergedWithEmptyRange) < 0
assert cmp(integerMergedWithEmptyRange, allEmptyIntegerMerged) > 0
assert cmp(allEmptyIntegerMerged, allEmptyIntegerMerged) == 0
assert cmp(integerMergedWithEmptyRange, integerMergedWithTrailingEmpty) == 0

let reversibleIntegerStatic = toStaticString([1, 2, 3, 4], reversible=true).reversed
let reversedIntegerMergedFromRanges = initMergedStaticString(reversibleIntegerStatic, @[(1, 3), (0, 1)])
assert $reversedIntegerMergedFromRanges == "3 2 4"
