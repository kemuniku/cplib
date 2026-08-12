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

# General (weighted) slope changes.  A large coefficient must not be expanded
# into that many heap entries.
let weighted = initSlopeTrick()
weighted.add_x_minus_a(2, 1_000_000_000)
weighted.add_a_minus_x(5, 1_000_000_000)
assert weighted.min == 3_000_000_000
assert weighted.get_value(0) == 5_000_000_000
assert weighted.get_value(3) == 3_000_000_000
assert weighted.get_value(7) == 5_000_000_000
weighted.add_abs(4, 3)
assert weighted.min == 3_000_000_000
assert weighted.get_value(3) == 3_000_000_003
assert weighted.get_value(4) == 3_000_000_000

# A coefficient can be split across several breakpoints.
let split = initSlopeTrick()
split.add_a_minus_x(0, 2)
split.add_a_minus_x(10, 3)
split.add_x_minus_a(5, 4)
for x in -2..22:
    let expected = 2 * max(0, -x) + 3 * max(0, 10-x) +
                   4 * max(0, x-5)
    assert split.get_value(x) == expected
