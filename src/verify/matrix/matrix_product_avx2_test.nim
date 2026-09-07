# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_product
include cplib/tmpl/fastio
import cplib/matrix/matrix_product_avx2

when defined(matrixProductBenchmark):
    import std/monotimes, times

let n = input(int)
let m = input(int)
let k = input(int)
let a = input(n * m, uint32)
let b = input(m * k, uint32)
when defined(matrixProductBenchmark):
    let start = getMonoTime()
let c = matrixProduct(a, b, n, m, k)
when defined(matrixProductBenchmark):
    stderr.writeLine("matrix_product_ms=", (getMonoTime() - start).inNanoseconds.float / 1e6)
for i in 0 ..< n:
    print(*c.toOpenArray(i * k, (i + 1) * k - 1))
