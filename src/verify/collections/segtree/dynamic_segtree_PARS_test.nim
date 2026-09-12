# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum
import cplib/collections/dynamic_segtree

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)

let n = ii()
let q = ii()
let st = newDynamicSegWith(n, l + r, 0)
for i in 0..<n:
    st[i] = ii()
for i in 0..<q:
    let t = ii()
    let a = ii()
    let b = ii()
    if t == 0:
        st[a] = st[a] + b
    else:
        echo st.get(a, b)
