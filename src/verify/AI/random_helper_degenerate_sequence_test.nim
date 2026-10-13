# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/utils/random_helper

randomize(734901)
doAssert randomseq_from_sum(1, 0) == @[0]
doAssert random_01sequence(0, 0) == newSeq[int]()
for n in 0..8:
    for total in 0..20:
        if n == 0 and total != 0: continue
        for trial in 0..<20:
            let values = randomseq_from_sum(n, total)
            doAssert values.len == n
            doAssert values.allIt(it >= 0)
            doAssert values.foldl(a + b, 0) == total
            if n == 1: doAssert values == @[total]
    for ones in 0..n:
        for trial in 0..<20:
            let values = random_01sequence(n, ones)
            doAssert values.len == n
            doAssert values.allIt(it == 0 or it == 1)
            doAssert values.foldl(a + b, 0) == ones

echo "Hello World"
