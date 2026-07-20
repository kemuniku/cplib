# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/generalized_floor_sum

proc floorDiv(a, b: int): int =
    result = a div b
    if a mod b < 0: dec result

for n in 0..12:
    for m in 1..12:
        for a in -12..12:
            for b in -12..12:
                var expected: GeneralizedFloorSum
                for i in 0..<n:
                    let y = floorDiv(a * i + b, m)
                    expected.floorSum += y
                    expected.weightedFloorSum += i * y
                    expected.squaredFloorSum += y * y
                let actual = generalizedFloorSum(n, m, a, b)
                doAssert actual == expected,
                    $((n, m, a, b), actual, expected)
                doAssert floorSum(n, m, a, b) == expected.floorSum

echo "Hello World"
