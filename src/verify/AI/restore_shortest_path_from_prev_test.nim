# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/restore_shortest_path_from_prev

assert restore_shortest_path_from_prev(@[-1, 0, 1, 2], 3) == @[0, 1, 2, 3]
assert restore_shortest_path_from_prev(@[-1, 0, 0], 2) == @[0, 2]
