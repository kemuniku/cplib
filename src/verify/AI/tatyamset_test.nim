# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import options, sequtils
import cplib/collections/tatyamset

var st = initSortedMultiset(@[3, 1, 2, 2])
assert st.len == 4
assert st.toSeq == @[1, 2, 2, 3]
assert st.contains(2)
assert st.count(2) == 2
assert st.lt(2).get == 1
assert st.le(2).get == 2
assert st.gt(2).get == 3
assert st.ge(2).get == 2
assert st[0] == 1
assert st[-1] == 3
assert st.index(2) == 1
assert st.index_right(2) == 3
st.incl(4)
assert st.pop(-1) == 4
assert st.pop(1) == 2
assert st.excl(2)
assert not st.excl(9)
assert st.toSeq == @[1, 3]
