# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math
import cplib/math/fractions

proc sumOpenArray[T](values: openArray[Fraction[T]]): Fraction[T] =
    values.sum()

proc sumGeneric[T](values: openArray[T]): auto =
    sum(values)

proc check[T]() =
    let values = [initFraction(T(1), T(2)), initFraction(T(1), T(3)),
                  initFraction(T(-1), T(6))]
    let expected = initFraction(T(2), T(3))
    doAssert sum(values) == expected
    doAssert values.sum() == expected
    doAssert fractions.sum(values) == expected
    doAssert sum(@values) == expected
    doAssert sumOpenArray(values) == expected
    doAssert sumGeneric(values) == expected
    doAssert sumOpenArray(values.toOpenArray(1, 2)) == initFraction(T(1), T(6))

    let emptySeq: seq[Fraction[T]] = @[]
    let emptyArray: array[0, Fraction[T]] = []
    for zero in [sum(emptySeq), sum(emptyArray), sumOpenArray(emptySeq)]:
        doAssert zero.num == T(0)
        doAssert zero.den == T(1)
        doAssert not zero.isNaN

    let unreduced = initFraction(T(-6), T(10), false)
    doAssert sum([unreduced]) == initFraction(T(-3), T(5))
    doAssert sum([values[0], -values[0]]) == initFraction(T(0))

    let positive = initFraction(T(1), T(0))
    let negative = initFraction(T(-1), T(0))
    let nan = initFraction(T(0), T(0))
    doAssert sum([values[0], positive]) == positive
    doAssert sum([positive, values[0]]) == positive
    doAssert sum([values[0], negative]) == negative
    doAssert sum([negative, values[0]]) == negative
    doAssert sum([positive, positive]) == positive
    doAssert sum([negative, negative]) == negative
    doAssert sum([positive, negative]).isNaN
    doAssert sum([negative, positive]).isNaN
    doAssert sum([nan]).isNaN
    doAssert sum([values[0], nan]).isNaN
    doAssert sum([nan, values[0]]).isNaN

check[int]()
check[int64]()
check[int32]()
doAssert sum([1, 2, 3]) == 6
doAssert @[1, 2, 3].sum() == 6
doAssert sum[int]([1, 2, 3]) == 6
doAssert math.sum([1, 2, 3]) == 6
let emptyInts: seq[int] = @[]
doAssert sum(emptyInts) == 0
echo "Hello World"
