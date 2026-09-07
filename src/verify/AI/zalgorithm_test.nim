# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/zalgorithm

assert zalgorithm("ababa") == @[5, 0, 3, 0, 1]
assert zalgorithm("aaaa") == @[4, 3, 2, 1]
assert zalgorithm([1, 2, 1, 2, 1]) == @[5, 0, 3, 0, 1]
assert zalgorithm(newSeq[int]()) == @[]

proc checkOpenArray(s: openArray[int]) =
    assert zalgorithm(s) == @[4, 0, 2, 0]

checkOpenArray([1, 2, 1, 2])
