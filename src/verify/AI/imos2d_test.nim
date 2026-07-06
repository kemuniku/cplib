# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/imos2d

let im = initImos2D(3, 4)
im.rectangle_add(0, 2, 1, 3, 5)
im.rectangle_add(1, 3, 2, 4, 2)
assert im.build == @[
  @[0, 5, 5, 0],
  @[0, 5, 7, 2],
  @[0, 0, 2, 2],
]
