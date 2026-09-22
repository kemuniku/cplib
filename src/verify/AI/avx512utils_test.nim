# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/avx512utils
import random

proc checkType[T: Avx512Integer]() =
    var rng = initRand(512)
    for size in 0..143:
        let n = if size <= 140: size else: [1023, 1024, 4097][size-141]
        var a, b = newSeq[T](n)
        for i in 0..<n:
            a[i] = cast[T](rng.next())
            b[i] = cast[T](rng.next())
        if n > 1:
            a[0] = low(T)
            a[n - 1] = high(T)
        let add = avx512Add(a, b)
        let sub = avx512Sub(a, b)
        let mn = avx512Min(a, b)
        let mx = avx512Max(a, b)
        let ba = avx512And(a, b)
        let bo = avx512Or(a, b)
        let bx = avx512Xor(a, b)
        var dst = newSeq[T](n)
        avx512Add(a, b, dst)
        doAssert dst == add
        for i in 0..<n:
            when T is SomeUnsignedInt:
                doAssert add[i] == a[i] + b[i]
                doAssert sub[i] == a[i] - b[i]
            else:
                doAssert add[i] == a[i] +% b[i]
                doAssert sub[i] == a[i] -% b[i]
            doAssert mn[i] == min(a[i], b[i])
            doAssert mx[i] == max(a[i], b[i])
            doAssert ba[i] == (a[i] and b[i])
            doAssert bo[i] == (a[i] or b[i])
            doAssert bx[i] == (a[i] xor b[i])
        if n > 0:
            var lo = a[0]
            var hi = a[0]
            for x in a:
                lo = min(lo, x)
                hi = max(hi, x)
            doAssert avx512Min(a) == lo
            doAssert avx512Max(a) == hi
            if n > 2:
                avx512Sub(a.toOpenArray(1, n-2), b.toOpenArray(1, n-2), dst.toOpenArray(1, n-2))
                for i in 1..<n-1: doAssert dst[i] == sub[i]
                lo = a[1]
                hi = a[1]
                for i in 1..<n-1:
                    lo = min(lo, a[i])
                    hi = max(hi, a[i])
                doAssert avx512Min(a.toOpenArray(1, n-2)) == lo
                doAssert avx512Max(a.toOpenArray(1, n-2)) == hi
        avx512Xor(a, b, a)
        doAssert a == bx
        let expected = avx512Xor(a, b)
        avx512Xor(a, b, b)
        doAssert b == expected
        avx512Sub(a, a, a)
        for x in a: doAssert x == 0
    var emptyA, emptyB: array[0, T]
    let emptyResult: array[0, T] = avx512And(emptyA, emptyB)
    doAssert emptyResult.len == 0
    var offsetA, offsetB: array[5..8, T]
    offsetA[5] = T(12)
    offsetB[5] = T(3)
    let offsetResult: array[5..8, T] = avx512Xor(offsetA, offsetB)
    doAssert offsetResult[5] == T(15)
    var a, b: array[32, T]
    for i in 0..<32:
        a[i] = T(i)
        b[i] = T(31-i)
    let c: array[32, T] = avx512Add(a, b)
    for x in c: doAssert x == 31
    doAssert avx512Min(a) == 0
    doAssert avx512Max(a) == 31
    var failed = false
    try: discard avx512Min(newSeq[T]())
    except ValueError: failed = true
    doAssert failed
    failed = false
    try: discard avx512Max(newSeq[T]())
    except ValueError: failed = true
    doAssert failed
    failed = false
    try: discard avx512Add(@[T(1)], newSeq[T]())
    except ValueError: failed = true
    doAssert failed
    failed = false
    var dst = @[T(42)]
    try: avx512Add(newSeq[T](), newSeq[T](), dst)
    except ValueError: failed = true
    doAssert failed and dst == @[T(42)]

checkType[int8]()
checkType[uint8]()
checkType[int16]()
checkType[uint16]()
checkType[int32]()
checkType[uint32]()
checkType[int64]()
checkType[uint64]()
checkType[int]()
checkType[uint]()
echo "Hello World"
