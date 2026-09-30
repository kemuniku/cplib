# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/fractions

let positive = initFraction(1, 0)
let negative = initFraction(-1, 0)
for magnitude in 1..3:
    let positives = [initFraction(magnitude, 0, false), positive * magnitude]
    let negatives = [initFraction(-magnitude, 0, false), negative * magnitude]
    for value in positives:
        doAssert value == positive
        doAssert not (value < positive)
        doAssert not (value > positive)
        doAssert not (positive < value)
        doAssert not (positive > value)
        doAssert value <= positive and value >= positive
        doAssert cmp(value, positive) == 0
        doAssert cmp(positive, value) == 0
    for value in negatives:
        doAssert value == negative
        doAssert not (value < negative)
        doAssert not (value > negative)
        doAssert not (negative < value)
        doAssert not (negative > value)
        doAssert value <= negative and value >= negative
        doAssert cmp(value, negative) == 0
        doAssert cmp(negative, value) == 0
    for pos in positives:
        for neg in negatives:
            doAssert pos > neg and neg < pos
            doAssert not (pos < neg) and not (neg > pos)
            doAssert cmp(pos, neg) == 1 and cmp(neg, pos) == -1
        for finite in [initFraction(-5, 2), initFraction(0), initFraction(7, 3)]:
            doAssert pos > finite and finite < pos
            for neg in negatives:
                doAssert neg < finite and finite > neg

let nan = initFraction(0, 0)
doAssert not (nan < positive) and not (nan > positive)
doAssert not (positive < nan) and not (positive > nan)
echo "Hello World"
