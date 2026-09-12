# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/floor_sum

for n in 0..20:
    for m in 1..20:
        for a in 0..30:
            for b in 0..30:
                var expected = 0
                for i in 0..<n:
                    expected += (a * i + b) div m
                doAssert floor_sum(n, m, a, b) == expected

let limit = high(int)
doAssert floor_sum(0, 1, limit, limit) == 0
doAssert floor_sum(limit, limit, 0, limit) == limit
doAssert floor_sum(limit, limit, 1, 0) == 0
doAssert floor_sum(limit, limit, 1, limit - 1) == limit - 1
doAssert floor_sum(1, 1, limit, limit) == limit
doAssert floor_sum(2, limit, limit, limit) == 3
let large = int(4_000_000_000)
doAssert floor_sum(large, 1, 1, 0) == 7_999_999_998_000_000_000
doAssert floor_sum(large, large, large - 1, large - 1) == 7_999_999_998_000_000_000

echo "Hello World"
