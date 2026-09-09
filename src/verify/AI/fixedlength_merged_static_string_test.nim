# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/fixedlength_merged_static_string
import cplib/str/static_string

let strings = toStaticStrings(@["ab", "cd", "abce"])
let merged: FixedLengthMergedStaticString[char, 2] =
    initFixedLengthMergedStaticString([strings[0], strings[1]])
assert $merged == "abcd"
assert merged.len == 4
assert merged[2] == 'c'
assert $merged[1..2] == "bc"
let leftHalf = initFixedLengthMergedStaticString([strings[0]])
let rightHalf = initFixedLengthMergedStaticString([strings[1]])
let mergedByOperator: FixedLengthMergedStaticString[char, 2] = leftHalf & rightHalf
assert mergedByOperator == merged

let appended: FixedLengthMergedStaticString[char, 3] = merged & strings[2]
assert $appended == "abcdabce"

let compared = initFixedLengthMergedStaticString([strings[0], strings[2]])
assert lcp(merged, compared) == 2
assert merged > compared
assert compared < merged

let ranged = initFixedLengthMergedStaticString(strings[2], [(0, 2), (2, 4)])
assert $ranged == "abce"

let integers = toStaticString([1, 2, 3, 1, 2, 4])
let integerMerged = initFixedLengthMergedStaticString([integers[0..1], integers[2..3]])
assert $integerMerged == "1 2 3 1"
assert integerMerged[2] == 3
assert $integerMerged[1..2] == "2 3"
let integerCompared = initFixedLengthMergedStaticString(integers, [(0, 2), (4, 6)])
assert lcp(integerMerged, integerCompared) == 2
assert integerMerged > integerCompared

let empty = initFixedLengthMergedStaticString(integers, [(0, 0), (1, 1)])
assert empty.len == 0
assert $empty == ""
let integerMergedWithEmptyRanges = initFixedLengthMergedStaticString(integers, [(0, 0), (0, 2), (3, 3)])
let integerMergedWithTrailingEmpty = initFixedLengthMergedStaticString(integers, [(0, 2), (3, 3)])
assert cmp(empty, integerMergedWithEmptyRanges) < 0
assert cmp(integerMergedWithEmptyRanges, empty) > 0
assert cmp(empty, empty) == 0
assert cmp(integerMergedWithEmptyRanges, integerMergedWithTrailingEmpty) == 0
