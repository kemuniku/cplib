# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_product_mod_2
import cplib/matrix/static_matrix_mod2
import strutils,sequtils

let nmk = stdin.readLine.split.map(parseInt)
let (N,M,K) = (nmk[0], nmk[1], nmk[2])

var A = initStaticMatrixMod2[4096,4096]()
var B = initStaticMatrixMod2[4096,4096]()

for i in 0..<N:
    A.setRowBits(i, stdin.readLine())

for i in 0..<M:
    B.setRowBits(i, stdin.readLine())

var C = A * B

for i in 0..<N:
    stdout.writeLine C.rowBits(i, K)
