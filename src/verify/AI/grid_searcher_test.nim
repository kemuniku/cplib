# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, options
import cplib/utils/grid_searcher

var gs = initGridSearcher()
gs.incl(1, 2)
gs.incl((3, 2))
gs.incl(2, 0)
gs.incl(2, 5)
assert gs.len == 4
assert gs.contains(1, 2)
assert gs.contains((2, 5))
assert not gs.contains(0, 0)

assert gs.up(2, 2).get == (1, 2)
assert gs.down((2, 2)).get == (3, 2)
assert gs.left(2, 2).get == (2, 0)
assert gs.right((2, 2)).get == (2, 5)
assert gs.up_move(2, 2).get == (2, 2)
assert gs.down_move(2, 2).get == (2, 2)
assert gs.left_move(2, 2).get == (2, 1)
assert gs.right_move(2, 2).get == (2, 4)
assert gs.up(0, 0).isNone

assert gs.updownleftright_get(2, 2).sorted == @[(1, 2), (2, 0), (2, 5), (3, 2)]
assert gs.updownleftright_move_get((2, 2)).sorted == @[(2, 1), (2, 2), (2, 2), (2, 4)]
gs.excl(1, 2)
gs.excl((3, 2))
assert gs.len == 2
assert gs.up(2, 2).isNone
