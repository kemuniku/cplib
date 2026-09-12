# verification-helper: PROBLEM https://judge.yosupo.jp/problem/sum_of_floor_of_linear
import cplib/math/floor_sum
import strutils

let t = stdin.readLine.parseInt
for _ in 0..<t:
    let query = stdin.readLine.splitWhitespace
    echo floor_sum(query[0].parseInt, query[1].parseInt,
                   query[2].parseInt, query[3].parseInt)
