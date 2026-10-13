# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_reverse_range_sum
import cplib/collections/range_reverse_array_monoid

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)
proc op(l, r: int): int = l + r

let n = ii()
let q = ii()
var values = newSeq[int](n)
for i in 0..<n: values[i] = ii()
let seg = initRangeReverseArrayMonoid(values, op, 0)
for i in 0..<q:
    let t = ii()
    let l = ii()
    let r = ii()
    if t == 0:
        seg.reverse(l, r)
    else:
        echo seg.get(l, r)
