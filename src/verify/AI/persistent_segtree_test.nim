# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/persistent_segtree

let st = initSegmentTree(@[1, 2, 3, 4], proc(l, r: int): int = l + r, 0)
assert st.query(0, 4) == 10
assert st.query(1, 3) == 5
let st2 = st.update(2, 10)
assert st.query(0, 4) == 10
assert st2.query(0, 4) == 17
assert st2.query(2, 3) == 10
