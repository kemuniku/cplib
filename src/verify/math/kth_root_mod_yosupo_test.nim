# verification-helper: PROBLEM https://judge.yosupo.jp/problem/kth_root_mod
import cplib/math/kth_root_mod
import std/strutils

let t = stdin.readLine.parseInt
for _ in 0..<t:
    let input = stdin.readLine.split
    let
        k = input[0].parseInt
        a = input[1].parseInt
        p = input[2].parseInt
    echo kthRootMod(a, k, p)
