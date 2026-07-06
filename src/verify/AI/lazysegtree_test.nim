# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/lazysegtree

proc merge(x, y: int): int = min(x, y)
proc mapping(f, x: int): int = f + x
proc composition(f, g: int): int = f + g

var st = initLazySegmentTree(@[1, 2, 3, 4, 5], merge, int.high, mapping, composition, 0)
assert st.len == 5
assert st.get(0, 5) == 1
st.apply(1, 4, 10)
assert st[1] == 12
assert st.get(1, 4) == 12
st[0] = 20
assert st.get(0, 5) == 5
st.apply(2..4, -3)
assert st[2] == 10
assert st[4] == 2
assert $st == "20 12 10 11 2"

var st2 = newLazySegWith(@[1, 2, 3], min(l, r), int.high, f + x, f + g, 0)
st2.apply(0, 3, 4)
assert st2.get(0, 3) == 5
