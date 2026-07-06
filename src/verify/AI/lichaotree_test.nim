# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/lichaotree
import cplib/utils/constants

let lct = initLiChaoTree(@[-2, -1, 0, 1, 2, 3])
assert lct.get_min(0) == INF64
lct.add_line(2, 3)
lct.add_line(-1, 4)
assert lct.get_min(-2) == -1
assert lct.get_min(2) == 2
lct.add_segment(0, -5, -1, 2)
assert lct.get_min(0) == -5
assert lct.get_min(2) == 2
