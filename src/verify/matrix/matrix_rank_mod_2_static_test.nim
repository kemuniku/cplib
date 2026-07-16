# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_rank_mod_2
{.checks: off.}
import cplib/matrix/static_matrix_mod2
import std/[strutils, sequtils]

const
    MaxCellCount = 1 shl 24
    MaxStaticCellCount = 2 * MaxCellCount

proc solve[H: static int, W: static int](n: int) =
    var a: ref StaticMatrixMod2[H, W]
    new a
    for i in 0..<n:
        a[].setRowBits(i, stdin.readLine)
    echo a[].rank

proc selectWidth[H: static int, W: static int](n, m: int) =
    if m <= W:
        solve[H, W](n)
    else:
        when H * W < MaxStaticCellCount:
            selectWidth[H, 2 * W](n, m)
        else:
            raise newException(ValueError, "matrix is too large")

proc selectHeight[H: static int](n, m: int) =
    if n <= H:
        selectWidth[H, 1](n, m)
    else:
        when H < MaxCellCount:
            selectHeight[2 * H](n, m)
        else:
            raise newException(ValueError, "matrix is too large")

let nm = stdin.readLine.split.map(parseInt)
selectHeight[1](nm[0], nm[1])
