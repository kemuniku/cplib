# verification-helper: PROBLEM https://judge.yosupo.jp/problem/kth_root_integer
import strutils
import cplib/math/ikth_root

let t = stdin.readLine.parseInt
for _ in 0..<t:
    let input = stdin.readLine.splitWhitespace
    let a = uint64(parseBiggestUInt(input[0]))
    let k = parseInt(input[1])
    echo ikthRoot(a, k)
