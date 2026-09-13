# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/waveletmatrix_fenwick

block:
    let wm = initWaveletMatrixFenwick(@[(3, 10), (1, 20), (3, -5), (7, 8)])
    assert wm.len == 4
    assert wm.range_sum(0, 4, 3) == 25
    assert wm.range_sum(1, 4, 3, 7) == -5
    assert wm.range_sum(0, 4) == 33
    wm.add(2, 12)
    assert wm[2] == 7
    assert wm.range_sum(0, 4, 3) == 37
    wm[1] = -4
    assert wm.range_sum(0, 4, 3) == 13
    assert wm.range_sum(1, 3) == 3

proc check(values: seq[(int, int)]) =
    let wm = initWaveletMatrixFenwick(values)
    var expected = values
    for i in 0..<values.len:
        assert wm[i] == values[i][1]
    var thresholds = @[int.low, -101, -1, 0, 1, 101, int.high]
    for value in values:
        thresholds.add(value[0])
    thresholds.sort()
    for step in 0..<30:
        if values.len > 0:
            let i = rand(values.high)
            let value = rand(-100..100)
            if step mod 2 == 0:
                wm.add(i, value)
                expected[i][1] += value
            else:
                wm[i] = value
                expected[i][1] = value
        for i in 0..<values.len:
            assert wm[i] == expected[i][1]
        for l in 0..values.len:
            for r in l..values.len:
                var total = 0
                for i in l..<r:
                    total += expected[i][1]
                assert wm.range_sum(l, r) == total
                for x in thresholds:
                    var sum = 0
                    for i in l..<r:
                        if expected[i][0] <= x:
                            sum += expected[i][1]
                    assert wm.range_sum(l, r, x) == sum
                let a = rand(thresholds.high)
                let b = rand(a..thresholds.high)
                let lower = thresholds[a]
                let upper = thresholds[b]
                var sum = 0
                for i in l..<r:
                    if lower <= expected[i][0] and expected[i][0] < upper:
                        sum += expected[i][1]
                assert wm.range_sum(l, r, lower, upper) == sum

randomize(20260909)
check(@[])
check(@[(0, 5)])
check(@[(-3, 1), (-3, -2), (-3, 7)])
check(@[(int.low, 4), (int.high, -3), (0, 8), (int.low, -2)])
for n in 0..16:
    var values = newSeq[(int, int)](n)
    for i in 0..<n:
        values[i] = (rand(-10..10), rand(-100..100))
    check(values)

for n in [63, 64, 65, 127, 128, 129]:
    var values = newSeq[(int, int)](n)
    for i in 0..<n:
        values[i] = (i - 64, i mod 7 - 3)
    let wm = initWaveletMatrixFenwick(values)
    for step in 0..<300:
        let i = rand(n - 1)
        let delta = rand(-100..100)
        wm.add(i, delta)
        values[i][1] += delta
        let l = rand(n)
        let r = rand(l..n)
        let x = rand(-100..100)
        var sum = 0
        for j in l..<r:
            if values[j][0] <= x:
                sum += values[j][1]
        assert wm.range_sum(l, r, x) == sum

echo "Hello World"
