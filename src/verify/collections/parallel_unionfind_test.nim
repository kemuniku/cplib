# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_parallel_unionfind
import cplib/collections/parallel_unionfind

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)

let n = ii()
let q = ii()
const modulus = 998244353
var values = newSeq[int](n)
for i in 0..<n: values[i] = ii()
let uf = initParallelUnionFind(n)
var answer = 0
proc onMerge(x, y: int) =
    answer = (answer + values[x] * values[y]) mod modulus
    values[x] = (values[x] + values[y]) mod modulus
for _ in 0..<q:
    let k = ii()
    let a = ii()
    let b = ii()
    uf.unite(a, b, k, onMerge)
    echo answer
