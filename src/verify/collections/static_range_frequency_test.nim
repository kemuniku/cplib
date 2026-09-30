# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_frequency
include cplib/tmpl/sheep
import cplib/collections/static_range_frequency

let n, q = ii()
let a = lii(n)
let frequency = initStaticRangeFrequency(a)
for _ in 0..<q:
    let l, r, x = ii()
    print frequency.count(l, r, x)
