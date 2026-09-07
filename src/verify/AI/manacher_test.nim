# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/str/manacher

assert manacher("ababa".toSeq)[2] == 3
assert manacher(@[1, 2, 2, 1])[1] == 1
assert manacher([1, 2, 2, 1])[2] == 1
assert manacher(newSeq[int]()) == @[]
let pals = get_palindromes("abba".toSeq, '$')
assert pals[0] == (0, 1)
assert pals[3] == (0, 4)
assert pals[5] == (-1, -1)
let arrayPals = get_palindromes(['a', 'b', 'b', 'a'], '$')
assert arrayPals == pals
assert get_palindromes(newSeq[int](), -1) == @[]

proc checkOpenArray(s: openArray[int]) =
    assert manacher(s)[1] == 1
    assert get_palindromes(s, -1)[3] == (0, 4)

checkOpenArray([1, 2, 2, 1])
