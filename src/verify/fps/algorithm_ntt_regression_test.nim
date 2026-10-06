# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, options
import cplib/convolution/algorithm_ntt
import cplib/convolution/relaxed_convolution
import cplib/fps/formal_power_series
import cplib/fps/power_projection
import cplib/fps/product_tree
include cplib/fps/polynomial_interpolation
include cplib/fps/sparse_formal_power_series

proc naive[T](a, b: seq[T]): seq[T] =
    if a.len == 0 or b.len == 0: return @[]
    result = newSeq[T](a.len + b.len - 1)
    for i in 0..<a.len:
        for j in 0..<b.len: result[i+j] += a[i] * b[j]

proc check[T]() =
    var rng = initRand(796231)
    for n in [1, 31, 32, 33, 63, 64, 65, 127, 128, 129, 255, 256, 257, 513]:
        var a, b, xs = newSeq[T](n)
        for i in 0..<n:
            a[i] = -init(T, rng.rand(T.umod.int - 1))
            b[i] = -init(T, rng.rand(T.umod.int - 1))
            xs[i] = init(T, i)
        let product = naive(a, b)
        var online = initRelaxedConvolution[T](product.len)
        for i in 0..<product.len:
            let x = if i < n: a[i] else: init(T, 0)
            let y = if i < n: b[i] else: init(T, 0)
            doAssert online.add(x, y) == product[i]
        let tree = initPolynomialProductTree[T](xs)
        let ys = evaluate[T](tree, a)
        for i in 0..<n: doAssert ys[i] == a.eval(xs[i])
        doAssert polynomialInterpolation[T](xs, ys) == a
        let longValues = multipointEvaluation[T](product, xs)
        for i in 0..<n: doAssert longValues[i] == product.eval(xs[i])
        if n <= 65:
            for constant in 0..1:
                a[0] = init(T, constant)
                let projected = a.powerProjection(b, n + 3)
                var power = b
                for k in 0..n+3:
                    doAssert projected[k] == power[n - 1]
                    power = naive(power, a)
                    power.setLen(n)
    for dimension in [2, 3]:
        var left, right = newSeq[seq[T]](dimension * dimension)
        for i in 0..<left.len:
            if i mod 3 != 0:
                left[i] = newSeq[T](63 + i)
                for x in left[i].mitems: x = -init(T, rng.rand(T.umod.int - 1))
            if i mod 4 != 0:
                right[i] = newSeq[T](65 + i)
                for x in right[i].mitems: x = -init(T, rng.rand(T.umod.int - 1))
        let got = multiplyPolynomialMatrices[T](left, right, dimension)
        for row in 0..<dimension:
            for column in 0..<dimension:
                var expected: seq[T]
                for k in 0..<dimension:
                    let product = naive(left[row * dimension + k], right[k * dimension + column])
                    if expected.len < product.len: expected.setLen(product.len)
                    for i in 0..<product.len: expected[i] += product[i]
                doAssert got[row * dimension + column] == expected

check[modint998244353_barrett]()
check[modint998244353_montgomery]()
check[modint1000000007_barrett]()
for p in [167772161, 998244353]:
    modint_barrett.setMod(p)
    modint_montgomery.setMod(p)
    check[modint_barrett]()
    check[modint_montgomery]()

proc largeNewtonSteps[T]() =
    const n = 65537
    var f = newSeq[T](n)
    for i in 1..<n: f[i] = init(T, i * i + 5)
    let e = f.exp(n)
    doAssert e.log(n) == f
    f[0] = init(T, 1)
    let root = f.sqrt(n).get
    doAssert prefix(root * root, n) == f

largeNewtonSteps[modint998244353_barrett]()
largeNewtonSteps[modint998244353_montgomery]()

block sparseCoefficients:
    type T = modint998244353_barrett
    const degree = 20000
    let f = sfps[T](3*x + 7*x^2)
    doAssert f.expCoefficient(degree) == f.exp(degree + 1)[degree]
    let unit = f + 1
    doAssert unit.powCoefficient(123456, degree) == unit.pow(123456, degree + 1)[degree]

echo "Hello World"
