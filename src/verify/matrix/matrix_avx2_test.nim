# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_product
include cplib/tmpl/fastio
import cplib/modint/modint
import cplib/matrix/matrix_avx2

when defined(matrixProductBenchmark):
    import std/monotimes, times

type Mint = modint998244353_barrett
let n = input(int)
let m = input(int)
let k = input(int)
let a = initMatrix[Mint](n, m, input(n * m, uint32))
let b = initMatrix[Mint](m, k, input(m * k, uint32))
when defined(matrixProductBenchmark):
    let start = getMonoTime()
let c = a * b
when defined(matrixProductBenchmark):
    stderr.writeLine("matrix_product_ms=", (getMonoTime() - start).inNanoseconds.float / 1e6)
for i in 0 ..< n:
    c[i].writeRow()
