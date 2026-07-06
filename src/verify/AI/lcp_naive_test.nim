# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/lcp_naive

assert lcp_naive("abcde", "abxyz") == 2
assert lcp_naive(@[1, 2, 3], @[1, 2, 4]) == 2
assert lcp_naive("abc", "abcde") == 3
