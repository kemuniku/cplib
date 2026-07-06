# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/lcs

assert LCS(@[1, 3, 4, 1], @[3, 4, 1, 2]) == 3
assert LCS("abcbdab", "bdcaba") == 4
assert restoreLCS(@['a', 'b', 'c', 'b', 'd', 'a', 'b'], @['b', 'd', 'c', 'a', 'b', 'a']) == @['b', 'c', 'b', 'a']
