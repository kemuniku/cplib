# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/minplus
import cplib/math/maxplus
import cplib/matrix/matrix
import random

proc make[T](_: typedesc[MinPlus[T]], value: T): MinPlus[T] = initMinPlus(value)
proc make[T](_: typedesc[MaxPlus[T]], value: T): MaxPlus[T] = initMaxPlus(value)

template raises(kind, body: untyped) =
    block:
        var caught = false
        try: discard body
        except kind: caught = true
        doAssert caught

proc checkProduct[S; H, K, W: static int]() =
    var rng = initRand(H * 101 + K * 17 + W)
    for seed in 0..<20:
        var a = initMatrix(H, K, S.zero)
        var b = initMatrix(K, W, S.zero)
        for i in 0..<H:
            for k in 0..<K:
                if rng.rand(0..3) != 0: a[i, k] = make(S, rng.rand(-10..10))
        for k in 0..<K:
            for j in 0..<W:
                if rng.rand(0..3) != 0: b[k, j] = make(S, rng.rand(-10..10))
        let savedA = a
        let savedB = b
        let c = a * b
        doAssert c.h == H and c.w == W
        var inPlace = a
        inPlace *= b
        doAssert inPlace == c
        for i in 0..<H:
            for j in 0..<W:
                var found = false
                var expected = 0
                for k in 0..<K:
                    if a[i, k].isFinite and b[k, j].isFinite:
                        let candidate = a[i, k].val + b[k, j].val
                        when S is MinPlus:
                            if not found or candidate < expected: expected = candidate
                        else:
                            if not found or candidate > expected: expected = candidate
                        found = true
                doAssert c[i, j].isFinite == found
                if found: doAssert c[i, j].val == expected
        doAssert a == savedA and b == savedB

template checkPower(S: typedesc, N: static int) =
    block:
        var rng = initRand(N * 83)
        for seed in 0..<30:
            var a = initMatrix(N, N, S.zero)
            for i in 0..<N:
                for j in 0..<N:
                    if rng.rand(0..3) != 0: a[i, j] = make(S, rng.rand(-5..5))
            let saved = a
            let identity = identity_matrix[S](N)
            doAssert a * identity == a and identity * a == a
            for exponent in 0..8:
                let actual = a.pow(exponent)
                doAssert actual == a ** exponent
                doAssert actual.h == N and actual.w == N
                for start in 0..<N:
                    var reachable: array[N, bool]
                    var distance: array[N, int]
                    reachable[start] = true
                    for step in 0..<exponent:
                        var nextReachable: array[N, bool]
                        var nextDistance: array[N, int]
                        for dest in 0..<N:
                            for via in 0..<N:
                                if reachable[via] and a[via, dest].isFinite:
                                    let candidate = distance[via] + a[via, dest].val
                                    when S is MinPlus:
                                        if not nextReachable[dest] or candidate < nextDistance[dest]: nextDistance[dest] = candidate
                                    else:
                                        if not nextReachable[dest] or candidate > nextDistance[dest]: nextDistance[dest] = candidate
                                    nextReachable[dest] = true
                        reachable = nextReachable
                        distance = nextDistance
                    for dest in 0..<N:
                        doAssert actual[start, dest].isFinite == reachable[dest]
                        if reachable[dest]: doAssert actual[start, dest].val == distance[dest]
                doAssert a == saved
            raises(ValueError, a.pow(-1))
        for value in [low(int), high(int)]:
            var a = initMatrix(1, 1, S.zero)
            a[0, 0] = make(S, value)
            doAssert a.pow(1) == a
            raises(OverflowDefect, a.pow(2))
        let rect = initMatrix(2, 3, S.zero)
        raises(ValueError, rect.pow(0))
        raises(ValueError, rect.pow(1))
        doAssert initMatrix(0, 3, S.zero).sum == S.zero
        var small = initMatrix(1, 2, S.zero)
        small[0, 0] = make(S, 2)
        small[0, 1] = make(S, -3)
        doAssert small.sum == make(S, 2) + make(S, -3)

template check(S: typedesc) =
    checkProduct[S, 0, 0, 0]()
    checkProduct[S, 0, 2, 3]()
    checkProduct[S, 2, 0, 3]()
    checkProduct[S, 2, 3, 0]()
    checkProduct[S, 1, 1, 1]()
    checkProduct[S, 2, 3, 4]()
    checkProduct[S, 3, 2, 2]()
    checkPower(S, 0)
    checkPower(S, 1)
    checkPower(S, 2)
    checkPower(S, 3)
check(MinPlus[int])
check(MaxPlus[int])

type CustomSemiring = object
    value: int
proc zero(_: typedesc[CustomSemiring]): CustomSemiring = CustomSemiring(value: 1000000)
proc one(_: typedesc[CustomSemiring]): CustomSemiring = CustomSemiring(value: 0)
proc `+`(a, b: CustomSemiring): CustomSemiring = CustomSemiring(value: min(a.value, b.value))
proc `*`(a, b: CustomSemiring): CustomSemiring =
    if a == CustomSemiring.zero or b == CustomSemiring.zero: CustomSemiring.zero
    else: CustomSemiring(value: a.value + b.value)
proc `+=`(a: var CustomSemiring, b: CustomSemiring) = a = a + b
proc `*=`(a: var CustomSemiring, b: CustomSemiring) = a = a * b
var custom = initMatrix(2, 2, CustomSemiring.zero)
custom[0, 0] = CustomSemiring(value: 3)
custom[1, 1] = CustomSemiring(value: 4)
doAssert custom.pow(2)[0, 0].value == 6
doAssert custom.pow(0)[0, 0].value == 0
doAssert custom.pow(0)[0, 1] == CustomSemiring.zero
doAssert custom.pow(2)[0, 1] == CustomSemiring.zero
for i in 0..<2:
    for j in 0..<2:
        let minId = identity_matrix[MinPlus[int]](2)
        let maxId = identity_matrix[MaxPlus[int]](2)
        doAssert minId[i, j] == (if i == j: MinPlus[int].one else: MinPlus[int].zero)
        doAssert maxId[i, j] == (if i == j: MaxPlus[int].one else: MaxPlus[int].zero)

doAssert initMatrix[MinPlus[int]](2, 3).sum == MinPlus[int].zero
doAssert initMatrix[MaxPlus[int]](2, 3).sum == MaxPlus[int].zero
doAssert initMatrix[CustomSemiring](2, 3).sum == CustomSemiring.zero

static:
    template rejectField(S: typedesc) =
        var a: Matrix[S]
        doAssert not compiles(a.rank)
        doAssert not compiles(a.determinant)
        doAssert not compiles(a.inverse)
        doAssert not compiles(a.adjugate)
        doAssert not compiles(a.solveLinearSystem([S.one, S.one]))
    rejectField(MinPlus[int])
    rejectField(MaxPlus[int])
echo "Hello World"
