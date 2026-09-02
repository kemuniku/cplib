# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/random
import cplib/collections/cht

proc brute(lines: seq[(int, int)], x: int, objective: CHTObjective): int =
    result = lines[0][0] * x + lines[0][1]
    for (a, b) in lines:
        let y = a * x + b
        if objective == minimize: result = min(result, y)
        else: result = max(result, y)

randomize(20260713)

for objective in [minimize, maximize]:
    for slopeOrder in [increasing, decreasing]:
        var lines: seq[(int, int)]
        var binaryCht = initMonotoneAddCHT(slopeOrder, objective)
        for i in 0 .. 40:
            let a = (if slopeOrder == increasing: i - 20 else: 20 - i)
            let b = rand(200) - 100
            lines.add((a, b))
            binaryCht.addLine(a, b)
        for x in -50 .. 50:
            assert binaryCht.query(x) == brute(lines, x, objective)

        for queryOrder in [increasing, decreasing]:
            var monotoneCht = initMonotoneCHT(slopeOrder, queryOrder, objective)
            for (a, b) in lines: monotoneCht.addLine(a, b)
            for i in 0 .. 100:
                let x = (if queryOrder == increasing: i - 50 else: 50 - i)
                assert monotoneCht.query(x) == brute(lines, x, objective)

for objective in [minimize, maximize]:
    for trial in 0 .. 50:
        var cht = initDynamicCHT(objective)
        var lines: seq[(int, int)]
        for i in 0 .. 100:
            let a = rand(40) - 20
            let b = rand(200) - 100
            lines.add((a, b))
            cht.addLine(a, b)
            for q in 0 .. 4:
                let x = rand(100) - 50
                assert cht.query(x) == brute(lines, x, objective)
