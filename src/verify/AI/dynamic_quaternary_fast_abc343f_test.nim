# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
# ABC343 F: https://atcoder.jp/contests/abc343/tasks/abc343_f
# fixtureはすべて自作。通常は文字列入出力を検証し、Hello Worldだけを出力する。
# -d:dynamicQuadFastExample は実stdin解法への切替専用。ライブラリ最適化defineは不要。
import cplib/collections/dynamic_quaternary_waveletmatrix
import options

proc nextInt(input: string, cursor: var int): int =
    while cursor < input.len and input[cursor] <= ' ': inc cursor
    doAssert cursor < input.len and input[cursor] in {'0'..'9'}
    while cursor < input.len and input[cursor] in {'0'..'9'}:
        result = result * 10 + ord(input[cursor]) - ord('0')
        inc cursor

proc solve(input: string): string =
    var cursor = 0
    let n = nextInt(input, cursor)
    let q = nextInt(input, cursor)
    var a = newSeq[int](n)
    for x in a.mitems: x = nextInt(input, cursor)
    var wm = initDynamicQuadWaveletMatrixFast(a, H = 30)
    for query in 0..<q:
        let kind = nextInt(input, cursor)
        let p = nextInt(input, cursor)
        let x = nextInt(input, cursor)
        if kind == 1:
            wm[p - 1] = x
        else:
            doAssert kind == 2
            let l = p - 1
            let r = x
            let largest = wm.kth_largest(l, r, 0)
            let second = wm.prev_value(l, r, largest)
            let answer = if second.isNone(): 0 else: wm.count(l, r, second.get())
            result.add($answer)
            result.add('\n')
    while cursor < input.len and input[cursor] <= ' ': inc cursor
    doAssert cursor == input.len

when defined(dynamicQuadFastExample):
    stdout.write(solve(stdin.readAll()))
else:
    import algorithm, random

    proc checkFixtures() =
        doAssert solve("""4 9
5 5 5 5
2 1 4
1 1 9
2 1 4
2 1 1
1 4 9
2 1 4
1 2 1
2 2 4
2 2 2
""") == "0\n3\n0\n2\n1\n0\n"
        doAssert solve("""6 9
1000000000 999999999 999999999 1 1000000000 1
2 1 6
2 4 6
1 2 1000000000
2 1 3
1 3 1000000000
2 1 3
1 6 999999999
2 4 6
2 6 6
""") == "2\n2\n1\n0\n1\n0\n"
        doAssert solve(" \t1 5\r\n1\r\n2 1 1\r\n1 1 1000000000\r\n" &
            "2 1 1\r\n1 1 1000000000\r\n2 1 1") == "0\n0\n0\n"

    proc secondCount(a: seq[int], l, r: int): int =
        var sorted = a[l..<r]
        sorted.sort()
        var i = sorted.high
        while i >= 0 and sorted[i] == sorted[^1]: dec i
        if i < 0: return 0
        let second = sorted[i]
        while i >= 0 and sorted[i] == second:
            inc result
            dec i

    proc addRow(output: var string, values: openArray[int], mixed: bool) =
        for i, value in values:
            if i > 0: output.add(if mixed: '\t' else: ' ')
            output.add($value)
        output.add(if mixed: "\r\n" else: "\n")

    proc checkGenerated(n, q, seed: int) =
        var rng = initRand(343000 + seed)
        var a = newSeq[int](n)
        for i, value in a.mpairs:
            value = case seed mod 3
                of 0: 7
                of 1: 1 + i mod 4
                else: 1 + rng.rand(999999999)
        let mixed = seed mod 2 == 1
        var input, expected: string
        addRow(input, [n, q], mixed)
        addRow(input, a, mixed)
        for step in 0..<q:
            if step mod 5 in [0, 3]:
                let p = case step mod 4
                    of 0: 0
                    of 1: n - 1
                    of 2: min(32, n - 1)
                    else: rng.rand(n - 1)
                let x = case step mod 6
                    of 0: a[p]
                    of 1: 1
                    of 2: 1000000000
                    of 3: 1 shl 29
                    else: 1 + rng.rand(15)
                addRow(input, [1, p + 1, x], mixed)
                a[p] = x
            else:
                var l = 0
                var r = n
                case step mod 6
                of 0: discard
                of 1:
                    l = rng.rand(n - 1)
                    r = l + 1
                of 2: r = min(33, n)
                of 3: l = max(0, n - 33)
                else:
                    let first = rng.rand(n - 1)
                    let last = rng.rand(n - 1)
                    l = min(first, last)
                    r = max(first, last) + 1
                addRow(input, [2, l + 1, r], mixed)
                expected.add($secondCount(a, l, r))
                expected.add('\n')
        doAssert solve(input) == expected

    checkFixtures()
    for seed in 0..2:
        for n in [1, 2, 3, 31, 32, 33, 129]:
            checkGenerated(n, 64, seed)
    checkGenerated(8197, 48, 3)
    echo "Hello World"
