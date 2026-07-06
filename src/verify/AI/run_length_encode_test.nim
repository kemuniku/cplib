# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/run_length_encode

assert run_length_encode(@[1, 1, 2, 2, 2, 1]) == @[(1, 2), (2, 3), (1, 1)]
assert run_length_encode("aaabbc") == @[('a', 3), ('b', 2), ('c', 1)]
assert run_length_encode(newSeq[int]()) == @[]
