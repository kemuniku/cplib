# verification-helper: PROBLEM https://judge.yosupo.jp/problem/many_aplusb

include cplib/tmpl/fastio

let queryCount = input(int)
let values = input(queryCount * 2, int)
for query in 0 ..< queryCount:
    print(values[query * 2] + values[query * 2 + 1])
