# verification-helper: PROBLEM https://judge.yosupo.jp/problem/kth_root_integer
import cplib/math/kth_root_integer

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)
proc ui(): uint64 {.inline.} = scanf("%llu", addr result)

let t = ii()
for _ in 0..<t:
    let a = ui()
    let k = ii()
    echo kth_root(a, k)
