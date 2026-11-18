# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/mo

proc solve(a: seq[int], queries: seq[(int, int, int)], width: int,
        inlineCallbacks: static[bool]): (seq[int], seq[int]) =
    var solver = if width == 0: initMo(a.len, queries.len)
                 else: initMo(a.len, queries.len, width)
    for (l, r, x) in queries: solver.insert(l, r)
    var counts = newSeq[int](17)
    var distinctCount = 0
    var frequencies = newSeq[int](queries.len)
    var distinctCounts = newSeq[int](queries.len)
    template addValue(i: int) =
        if counts[a[i]] == 0: inc distinctCount
        inc counts[a[i]]
    template deleteValue(i: int) =
        dec counts[a[i]]
        if counts[a[i]] == 0: dec distinctCount
    template remember(q: int) =
        frequencies[q] = counts[queries[q][2]]
        distinctCounts[q] = distinctCount
    when inlineCallbacks:
        solver.runInline(addValue, addValue, deleteValue, deleteValue, remember)
    else:
        proc addCallback(i: int) = addValue(i)
        proc deleteCallback(i: int) = deleteValue(i)
        proc rememberCallback(q: int) = remember(q)
        solver.run(addCallback, addCallback, deleteCallback, deleteCallback, rememberCallback)
    (frequencies, distinctCounts)

proc checkRandom() =
    for seed in [11, 29, 47]:
        var rng = initRand(seed)
        for n in [0, 1, 2, 7, 40]:
            var a = newSeq[int](n)
            for value in a.mitems: value = rng.rand(16)
            for q in [0, 1, 100]:
                var queries: seq[(int, int, int)]
                var expectedFreq, expectedDistinct: seq[int]
                for query in 0..<q:
                    let l = rng.rand(n)
                    let r = rng.rand(l..n)
                    let x = rng.rand(16)
                    queries.add((l, r, x))
                    var counts = newSeq[int](17)
                    for i in l..<r: inc counts[a[i]]
                    expectedFreq.add(counts[x])
                    var distinctCount = 0
                    for count in counts:
                        if count > 0: inc distinctCount
                    expectedDistinct.add(distinctCount)
                for width in [0, 1, 2, n + 1]:
                    let expected = (expectedFreq, expectedDistinct)
                    doAssert solve(a, queries, width, true) == expected
                    doAssert solve(a, queries, width, false) == expected

proc endpointTrace(inlineCallbacks: static[bool]): seq[(char, int)] =
    let queries = @[(5, 0), (3, -1), (0, 5), (0, -1), (5, 5), (2, 1), (3, -1)]
    var solver = initMo(5, queries.len, 2)
    for (l, r) in queries: solver.insert(l, r)
    var l, r, evaluations: int
    var visited = newSeq[int](queries.len)
    var trace: seq[(char, int)]
    proc getSolver(): var Mo =
        inc evaluations
        return solver
    template addLeft(i: int) =
        doAssert i == l - 1
        l = i
        trace.add(('L', i))
    template addRight(i: int) =
        doAssert i == r
        r = i + 1
        trace.add(('R', i))
    template deleteLeft(i: int) =
        doAssert i == l
        l = i + 1
        trace.add(('l', i))
    template deleteRight(i: int) =
        doAssert i == r - 1
        r = i
        trace.add(('r', i))
    template remember(q: int) =
        doAssert (l, r) == queries[q]
        inc visited[q]
        trace.add(('q', q))
    for repetition in 0..<2:
        l = 0
        r = 0
        when inlineCallbacks:
            getSolver().runInline(addLeft, addRight, deleteLeft, deleteRight, remember)
        else:
            proc al(i: int) = addLeft(i)
            proc ar(i: int) = addRight(i)
            proc dl(i: int) = deleteLeft(i)
            proc dr(i: int) = deleteRight(i)
            proc rem(q: int) = remember(q)
            getSolver().run(al, ar, dl, dr, rem)
    doAssert evaluations == 2
    for count in visited: doAssert count == 2
    trace

block:
    let a = @[1, 2, 1, 3, 2]
    let queries = @[(0, 5, 1), (1, 4, 2), (2, 5, 2)]
    var solver = initMo(a.len, queries.len)
    for (l, r, x) in queries: solver.insert(l, r)
    var freq = newSeq[int](4)
    var answers = newSeq[int](queries.len)
    template addValue(i: int) = inc freq[a[i]]
    template deleteValue(i: int) = dec freq[a[i]]
    template remember(q: int) = answers[q] = freq[queries[q][2]]
    solver.runInline(addValue, addValue, deleteValue, deleteValue, remember)
    doAssert answers == @[2, 1, 1]

checkRandom()
doAssert endpointTrace(true) == endpointTrace(false)
echo "Hello World"
