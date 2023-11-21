# verification-helper: PROBLEM https://judge.yosupo.jp/problem/deque_operate_all_composite
import cplib/collections/SWAG
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
const MOD = 998244353
proc op(a, b: (int, int)): (int, int) =
    return ((a[0]*b[0]) mod MOD, ((a[1]*b[0] mod MOD) + b[1]) mod MOD)

var Q = ii()
var swag = initSWAG(op, (1, 0))
for i in 0..<Q:
    var q = ii()
    if q == 0:
        var a, b = ii()
        swag.addFirst((a, b))
    elif q == 1:
        var a, b = ii()
        swag.addLast((a, b))
    elif q == 2:
        discard swag.popFirst()
    elif q == 3:
        discard swag.popLast()
    else:
        var x = ii()
        var (a, b) = swag.fold()
        echo (a*x mod MOD + b) mod MOD
