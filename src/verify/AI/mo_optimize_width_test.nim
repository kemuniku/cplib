# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/mo

proc checkFrequency() =
    for seed in [11, 29, 47]:
        var rng = initRand(seed)
        for n in [1, 2, 20, 100]:
            var a = newSeq[int](n)
            for v in a.mitems: v = rng.rand(15)
            for q in [0, 1, 2, 100, 1000]:
                var queries: seq[(int,int,int)]
                for i in 0..<q:
                    let l = rng.rand(n)
                    let r = rng.rand(l..n)
                    queries.add((l,r,rng.rand(15)))
                for width in [1, 3, 16, n+1, high(int)]:
                    var solver = initMo(n,q,width)
                    for (l,r,x) in queries: solver.insert(l,r)
                    solver.optimizeWidth()
                    solver.optimizeWidth()
                    # 調整後の追加でも登録番号を維持する。
                    solver.insert(0,n)
                    var freq = newSeq[int](16)
                    var answers = newSeq[int](q+1)
                    var visited = newSeq[int](q+1)
                    template addValue(i:int) = inc freq[a[i]]
                    template deleteValue(i:int) = dec freq[a[i]]
                    template remember(i:int) =
                        inc visited[i]
                        answers[i] = freq[if i == q: 0 else: queries[i][2]]
                    solver.runInline(addValue,addValue,deleteValue,deleteValue,remember)
                    for i in 0..q:
                        let (l,r,x) = if i==q: (0,n,0) else: queries[i]
                        var expected = 0
                        for j in l..<r:
                            if a[j] == x: inc expected
                        doAssert answers[i] == expected
                        doAssert visited[i] == 1

proc checkEndpoints() =
    for width in [1, 2, 64, high(int)]:
        let queries = @[(5,0),(3,-1),(0,5),(0,-3),(5,5),(2,1),(0,5)]
        var solver = initMo(5,queries.len,width)
        for (l,r) in queries: solver.insert(l,r)
        solver.optimizeWidth()
        var l,r,factories:int
        var visited = newSeq[int](queries.len)
        proc makeCallback(side,delta:int): proc(i:int) {.closure.} =
            inc factories
            result = proc(i:int) =
                if side == 0:
                    doAssert i == (if delta < 0: l-1 else: l)
                    l += delta
                else:
                    doAssert i == (if delta < 0: r-1 else: r)
                    r += delta
        proc recordAnswer(i:int) =
            doAssert (l,r) == queries[i]
            inc visited[i]
        solver.run(makeCallback(0,-1),makeCallback(1,1),
                   makeCallback(0,1),makeCallback(1,-1),recordAnswer)
        doAssert factories == 4
        for count in visited: doAssert count == 1

block:
    var empty = initMo(0,0)
    empty.optimizeWidth()
    var calls = 0
    template visit(i:int) = inc calls
    empty.runInline(visit,visit,visit,visit,visit)
    doAssert calls == 0

checkFrequency()
checkEndpoints()
echo "Hello World"
