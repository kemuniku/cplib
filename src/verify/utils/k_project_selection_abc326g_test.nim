# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
# https://atcoder.jp/contests/abc326/tasks/abc326_g
import cplib/utils/k_project_selection
import strutils, sequtils, streams, random

proc solve(input: Stream): int64 =
    let nm = input.readLine.split.map(parseInt)
    let n = nm[0]
    let m = nm[1]
    let c = input.readLine.split.map(parseBiggestInt)
    let a = input.readLine.split.map(parseBiggestInt)
    var opt = initKProjectSelection(n, 5, int64)
    for i in 0..<n:
        var costs = newSeq[int64](5)
        for level in 0..<5: costs[level] = int64(level) * c[i]
        opt.add_unary_cost(i, costs)
    for i in 0..<m:
        let levels = input.readLine.split.map(parseInt)
        var conditions: seq[tuple[variable, threshold: int]]
        for j in 0..<n: conditions.add((j, levels[j] - 1))
        opt.add_gain_if_all_ge(conditions, a[i])
    return -opt.solve().min_cost

proc solveText(text: string): int64 =
    let input = newStringStream(text)
    defer: input.close()
    return solve(input)

proc brute(c, a: seq[int64], levels: seq[seq[int]]): int64 =
    var count = 1
    for _ in c: count *= 5
    for mask in 0..<count:
        var code = mask
        var chosen = newSeq[int](c.len)
        var profit = 0'i64
        for j in 0..<c.len:
            chosen[j] = code mod 5 + 1
            code = code div 5
            profit -= int64(chosen[j] - 1) * c[j]
        for i in 0..<a.len:
            var achieved = true
            for j in 0..<c.len:
                if chosen[j] < levels[i][j]: achieved = false
            if achieved: profit += a[i]
        result = max(result, profit)

proc encode(c, a: seq[int64], levels: seq[seq[int]]): string =
    result = $c.len & " " & $a.len & "\n" & c.join(" ") & "\n" & a.join(" ") & "\n"
    for row in levels: result.add(row.join(" ") & "\n")

when defined(abc326gStandalone):
    echo solve(newFileStream(stdin))
else:
    doAssert solveText("2 2\n10 20\n100 50\n3 1\n1 4\n") == 80
    doAssert solveText("2 2\n10 20\n100 50\n3 2\n1 4\n") == 70
    doAssert solveText("""10 10
10922 23173 32300 22555 29525 16786 3135 17046 11245 20310
177874 168698 202247 31339 10336 14825 56835 6497 12440 110702
2 1 4 1 3 4 4 5 1 4
2 3 4 4 5 3 5 5 2 3
2 3 5 1 4 2 2 2 2 5
3 5 5 3 5 2 2 1 5 4
3 1 1 4 4 1 1 5 3 1
1 2 3 2 4 2 4 3 3 1
4 4 4 2 5 1 4 2 2 2
5 3 1 2 3 4 2 5 2 2
5 4 3 4 3 1 5 1 5 4
2 3 2 5 2 3 1 2 2 4
""") == 66900
    var rng = initRand(326823)
    for trial in 0..<200:
        let n = rng.rand(1..5)
        let m = rng.rand(1..8)
        let c = newSeqWith(n, int64(rng.rand(1..100)))
        let a = newSeqWith(m, int64(rng.rand(1..1000)))
        let levels = newSeqWith(m, newSeqWith(n, rng.rand(1..5)))
        doAssert solveText(encode(c, a, levels)) == brute(c, a, levels)
    let cheap = newSeqWith(50, 1'i64)
    let expensive = newSeqWith(50, 1000000'i64)
    let highest = newSeqWith(50, newSeqWith(50, 5))
    let lowest = newSeqWith(50, newSeqWith(50, 1))
    doAssert solveText(encode(cheap, expensive, highest)) == 50000000 - 200
    doAssert solveText(encode(expensive, cheap, highest)) == 0
    doAssert solveText(encode(expensive, expensive, lowest)) == 50000000
    echo "Hello World"
