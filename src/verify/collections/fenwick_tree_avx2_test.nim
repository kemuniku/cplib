# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum
include cplib/tmpl/fastio
import cplib/collections/fenwick_avx2

proc main() =
    let n = input(int)
    let q = input(int)
    var bit = initFenwickTreeAvx2(input(n, int))
    var answers = newSeqOfCap[int](q)
    for _ in 0..<q:
        let t = input(int)
        let l = input(int)
        let r = input(int)
        if t == 0:
            bit.add(l, r)
        else:
            answers.add(bit.get(l, r))
    if answers.len > 0:
        print(*answers, sep="\n")

main()
