# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/lis

let a = @[3, 1, 2, 1, 8, 5, 6]
assert lis(a) == 4
assert restore_lis(a) == @[1, 2, 5, 6]
assert lis(@[3, 2, 1]) == 1
