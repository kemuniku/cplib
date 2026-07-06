# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/knapsack

let items = @[(v: 6, w: 2), (v: 10, w: 4), (v: 12, w: 6)]
assert solve_01knapsack_NW(items, 8) == 18
assert solve_01knapsack_NV(items, 8) == 18
assert solve_01knapsack_meet_in_middle(items, 8) == 18
assert solve_UBknapsack_NW(@[(v: 3, w: 2), (v: 4, w: 3)], 7) == 10
assert solve_BoundedKnapsack(@[(v: 5, w: 2, m: 2), (v: 6, w: 3, m: 1)], 5) == 11
