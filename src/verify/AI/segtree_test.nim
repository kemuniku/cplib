# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/segtree

let merge = proc(x, y: int): int = x + y
var st = initSegmentTree(@[1, 2, 3, 4, 5], merge, 0)
assert st.len == 5
assert st.get(0, 5) == 15
assert st.get(1, 4) == 9
assert st[1..3] == 9
assert st[2] == 3
st.update(2, 10)
assert st[2] == 10
st[0] = 7
assert st.get_all() == 28
assert $st == "7 2 10 4 5"
assert st.max_right(0, proc(x: int): bool = x <= 19) == 3
assert st.min_left(5, proc(x: int): bool = x <= 11) == 3

let st2 = initSegmentTree[int](3, merge, 0)
assert st2.get_all() == 0

let st3 = newSegWith(@[1, 2, 3], l + r, 0)
assert st3.get_all() == 6
