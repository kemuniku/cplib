# verification-helper: PROBLEM https://judge.yosupo.jp/problem/rational_approximation
import cplib/math/stern_brocot_tree
import strutils

let t = stdin.readLine.parseInt
for _ in 0..<t:
    let query = stdin.readLine.splitWhitespace
    let n = query[0].parseInt
    let x = query[1].parseInt
    let y = query[2].parseInt
    let bounds = get_bounds(proc(v: SBTNode[int]): bool =
        v.den() != 0 and v.num() * y <= x * v.den()
    , n)
    if bounds.p * y == bounds.q * x:
        echo bounds.p, " ", bounds.q, " ", bounds.p, " ", bounds.q
    else:
        echo bounds.p, " ", bounds.q, " ", bounds.r, " ", bounds.s
