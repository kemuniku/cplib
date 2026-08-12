# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/utils/subset_sum

proc check(a: seq[int], target: int) =
    let ans = subsetSum(a, target)
    var sum = 0
    var used = newSeq[bool](a.len)
    for i in ans:
        assert i in 0..<a.len
        assert not used[i]
        used[i] = true
        sum += a[i]
    assert hasSubsetSum(a, target) == (target == 0 or ans.len > 0)
    if ans.len > 0:
        assert sum == target

check(@[], 0)
check(@[], 1)
check(@[3, 1, 4, 1, 5, 9], 10)
check(@[100, 2, 3], 5)
check(@[2, 4, 6], 5)
assert subsetSum(@[3, 1, 4, 1, 5, 9], 10).mapIt(@[3, 1, 4, 1, 5, 9][it]).foldl(a + b) == 10

var seed = 88172645463393265'u64
proc random(n: int): int =
    seed = seed xor (seed shl 7)
    seed = seed xor (seed shr 9)
    int(seed mod uint64(n))

for n in 0..12:
    for trial in 0..<200:
        var a = newSeq[int](n)
        for x in a.mitems:
            x = random(10) + 1
        let target = random(50)
        var naive = false
        for bits in 0..<(1 shl n):
            var sum = 0
            for i in 0..<n:
                if ((bits shr i) and 1) != 0:
                    sum += a[i]
            if sum == target:
                naive = true
        assert hasSubsetSum(a, target) == naive
        let ans = subsetSum(a, target)
        assert (target == 0 or ans.len > 0) == naive
        if ans.len > 0:
            var sum = 0
            for i in ans:
                sum += a[i]
            assert sum == target
