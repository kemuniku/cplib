# verification-helper: PROBLEM https://judge.yosupo.jp/problem/many_aplusb

include cplib/tmpl/fastio
import cplib/tmpl/replayable_input

replayableInput:
    let q = ii()
    var sums: seq[int]
    peekInput:
        for _ in 0 ..< q:
            let values = lii(2)
            sums.add(values[0] + values[1])
    for i in 0 ..< q:
        let a = ii()
        let b = input(int)
        doAssert a + b == sums[i]
        print(a + b)
