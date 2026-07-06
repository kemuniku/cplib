# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/segtree_var

let merge = proc(x, y: int): int = x + y
var st = initSegmentTree(@[1, 2, 3, 4], merge, 0)
assert st.len == 4
assert st.get(0, 4) == 10
assert st[1..2] == 5
st[2] += 7
assert int(st[2]) == 10
assert st.get_all() == 17
st[0] = 5
assert st.get(0, 2) == 7
assert $st == "5 2 10 4"
assert st.max_right(0, proc(x: int): bool = x <= 7) == 2
assert st.min_left(4, proc(x: int): bool = x <= 14) == 2

let st2 = newSegWith(@[2, 3], l * r, 1)
assert st2.get_all() == 6
