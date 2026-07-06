# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/kth_element

let values = @[7, 1, 5, 3, 5, 9]
assert kth_element(values, 0) == 1
assert kth_element(values, 2) == 5
var mutable = values
assert kth_element_break(mutable, 4) == 7
