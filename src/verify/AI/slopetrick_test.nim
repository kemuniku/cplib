# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/slopetrick

let st = initSlopeTrick(0)
assert st.min == 0
st.add_abs(3)
assert st.min == 0
assert st.min_index == 3
assert st.get_value(1) == 2
st.add_x_minus_a(5)
assert st.get_value(6) == 4
st.add_a_minus_x(0)
st.add_all(7)
assert st.min >= 7
st.shift(2)
assert st.get_value(5) >= st.min
st.shift(-1, 1)
assert st.get_value(5) >= st.min
st.clearL()
st.clearR()
assert st.get_value(0) == st.min
