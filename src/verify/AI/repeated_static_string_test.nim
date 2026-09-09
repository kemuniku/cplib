# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/repeated_static_string
import cplib/str/static_string

let strings = toStaticStrings(@["ab", "aba", "abab", "ababa", "ac", "", "b"])
let ab = initRepeatedStaticString(strings[0], 7)
let aba = initRepeatedStaticString(strings[1], 8)
let abab = initRepeatedStaticString(strings[2], 9)

assert len(ab) == 7
assert $ab == "abababa"
assert ab[0] == 'a'
assert ab[5] == 'b'
assert lcp(ab, aba) == 3
assert lcp(aba, ab) == 3
assert ab > aba
assert aba < ab

# 異なる周期でも同じ無限列を表せる。
assert lcp(ab, abab) == 7
assert ab < abab
let ababa = initRepeatedStaticString(strings[0], 5)
assert ababa == strings[3]
assert strings[3] == ababa
assert cmp(ababa, strings[3]) == 0
assert lcp(ab, strings[4]) == 1
assert ab < strings[4]
assert strings[4] > ab

let emptyRepeat = initRepeatedStaticString(strings[0], 0)
let emptyPeriod = initRepeatedStaticString(strings[5], 0)
assert len(emptyRepeat) == 0
assert emptyRepeat == strings[5]
assert emptyPeriod == strings[5]
assert emptyRepeat < strings[0]
assert strings[0] > emptyRepeat

let integers = toStaticString([1, 2, 1, 2, 3])
let integerRepeat = initRepeatedStaticString(integers[0..1], 7)
assert integerRepeat[6] == 1
assert lcp(integerRepeat, integers[0..3]) == 4
assert integerRepeat < integers

proc naiveLcp(S, T: string): int =
    result = min(len(S), len(T))
    for i in 0..<result:
        if S[i] != T[i]:
            return i

proc sign(x: int): int =
    if x < 0: -1
    elif x > 0: 1
    else: 0

# O(1)の各操作を、実体化した文字列による計算結果と総当たりで比較する。
let source = toStaticString("aababb")
var periods: seq[StaticString[char]]
for l in 0..<len(source):
    for r in l..<len(source):
        periods.add(source[l..r])

var repeated: seq[RepeatedStaticString[char]]
for period in periods:
    for k in 0..10:
        repeated.add(initRepeatedStaticString(period, k))

for left in repeated:
    let materializedLeft = $left
    for right in repeated:
        let materializedRight = $right
        assert lcp(left, right) == naiveLcp(materializedLeft, materializedRight)
        assert cmp(left, right) == sign(cmp(materializedLeft, materializedRight))
    for right in periods:
        let materializedRight = $right
        assert lcp(left, right) == naiveLcp(materializedLeft, materializedRight)
        assert lcp(right, left) == naiveLcp(materializedRight, materializedLeft)
        assert cmp(left, right) == sign(cmp(materializedLeft, materializedRight))
        assert cmp(right, left) == sign(cmp(materializedRight, materializedLeft))
