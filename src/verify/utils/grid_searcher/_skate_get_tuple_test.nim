# verification-helper: PROBLEM https://atcoder.jp/contests/abc241/tasks/abc241_f
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

import cplib/utils/grid_searcher
import options,tables,deques

var H,W,N = ii()
var sx,sy = ii()
var gx,gy = ii()
var grid = initGridSearcher()

for i in 0..<N:
    var X,Y = ii()
    grid.incl((X,Y))

var alr = initTable[(int,int),int]()
var d = initDeque[(int,int)]()
d.addLast((sx,sy))
alr[(sx,sy)] = 0

while len(d) != 0:
    var (x,y) = d.popFirst()
    for (i,j) in grid.updownleftright_move_get((x,y)):
        if (i,j) notin alr:
            alr[(i,j)] = alr[(x,y)] + 1
            d.addLast((i,j))

if (gx,gy) in alr:
    echo alr[(gx,gy)]
else:
    echo -1