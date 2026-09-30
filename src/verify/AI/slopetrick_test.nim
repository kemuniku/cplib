# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/slopetrick

let st = initSlopeTrick(0)
doAssert st.min == 0
st.add_abs(3)
doAssert st.min == 0
doAssert st.min_index == 3
doAssert st.get_value(1) == 2
st.add_x_minus_a(5)
doAssert st.get_value(6) == 4
st.add_a_minus_x(0)
st.add_all(7)
doAssert st.min >= 7
st.shift(2)
doAssert st.get_value(5) >= st.min
st.shift(-1, 1)
doAssert st.get_value(5) >= st.min
st.clearL()
st.clearR()
doAssert st.get_value(0) == st.min

import cplib/utils/constants

block:
  let constant = initSlopeTrick(7)
  doAssert constant.get_value(INF64 + 1) == 7
  doAssert constant.get_value(-INF64 - 1) == 7
  constant.shift(INF64 - 1)
  doAssert constant.get_value(-2) == 7
  constant.add_x_minus_a(-2)
  doAssert constant.min == 7
  doAssert constant.get_value(-3) == 7
  doAssert constant.get_value(0) == 9

block:
  let constant = initSlopeTrick(7)
  constant.shift(-INF64 + 1)
  doAssert constant.get_value(2) == 7
  constant.add_a_minus_x(2)
  doAssert constant.min == 7
  doAssert constant.get_value(3) == 7
  doAssert constant.get_value(0) == 9

block:
  let cleared = initSlopeTrick(0)
  cleared.shift(10)
  cleared.add_abs(3)
  cleared.clearL()
  doAssert cleared.get_value(-INF64 - 1) == 0
  doAssert cleared.get_value(4) == 1
  cleared.clearR()
  doAssert cleared.get_value(INF64 + 1) == 0
  cleared.shift(INF64 - 1)
  cleared.add_abs(2)
  doAssert cleared.min == 0
  doAssert cleared.min_index == 2
  doAssert cleared.get_value(0) == 2
  doAssert cleared.get_value(4) == 2
