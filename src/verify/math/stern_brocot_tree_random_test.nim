# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/stern_brocot_tree
import options, random

proc naivePath[T](a, b: T): seq[(char, T)] =
    var a = a
    var b = b
    while a != b:
        let direction = if a > b: 'R' else: 'L'
        if result.len > 0 and result[^1][0] == direction:
            inc result[^1][1]
        else:
            result.add((direction, T(1)))
        if a > b:
            a -= b
        else:
            b -= a

proc referencePath[T](a, b: T): seq[(char, T)] =
    var cf = continued_fraction_expansion(a, b)
    dec cf[^1]
    for i, count in cf:
        if count > 0:
            result.add(((if i mod 2 == 0: 'R' else: 'L'), count))

proc referenceAncestor[T](path: seq[(char, T)], k: T): Option[SBTNode[T]] =
    if k < 0:
        return none(SBTNode[T])
    var prefix: seq[(char, T)]
    var remaining = k
    for (direction, count) in path:
        let take = min(remaining, count)
        prefix.add((direction, take))
        remaining -= take
        if remaining == 0:
            break
    if remaining == 0:
        return some(decode_path(prefix))
    return none(SBTNode[T])

proc referenceLCA[T](a, b: seq[(char, T)]): SBTNode[T] =
    var prefix: seq[(char, T)]
    for i in 0..<min(a.len, b.len):
        if a[i][0] != b[i][0]:
            break
        prefix.add((a[i][0], min(a[i][1], b[i][1])))
        if a[i][1] != b[i][1]:
            break
    return decode_path(prefix)

proc checkNode[T](a, b: T, path: seq[(char, T)]) =
    let node = to_SBTNode(a, b)
    doAssert node == decode_path(path)
    doAssert encode_path(a, b) == path
    doAssert encode_path(node) == path
    doAssert get_range(a, b) == get_range(node)
    for k in [T(-1), T(0), T(1), node.depth div 2, node.depth, node.depth+1]:
        let expected = referenceAncestor(path, k)
        doAssert ancestor(a, b, k) == expected
        doAssert ancestor(node, k) == expected

proc testSmall[T]() =
    for a in 1..20:
        for b in 1..20:
            let path = naivePath(T(a), T(b))
            checkNode(T(a), T(b), path)
            for k in 0..a+b:
                doAssert ancestor(T(a), T(b), T(k)) == referenceAncestor(path, T(k))
            for c in 1..12:
                for d in 1..12:
                    let expected = referenceLCA(path, naivePath(T(c), T(d)))
                    doAssert LCA(T(a), T(b), T(c), T(d)) == expected
                    doAssert LCA(to_SBTNode(T(a), T(b)), to_SBTNode(T(c), T(d))) == expected
            for bound in 1..8:
                var lo = (T(0), T(1))
                var hi = (T(1), T(0))
                for x in 1..bound:
                    for y in 1..bound:
                        if x*b < a*y and T(x)*lo[1] > lo[0]*T(y):
                            lo = (T(x), T(y))
                        if x*b > a*y and T(x)*hi[1] < hi[0]*T(y):
                            hi = (T(x), T(y))
                let node = to_SBTNode(T(a), T(b))
                let lower = max_less_with_den_at_most(node, T(bound))
                let upper = min_greater_with_den_at_most(node, T(bound))
                let lowerNode = if lo[0] == 0: sbt_zero(T) else: to_SBTNode(lo[0], lo[1])
                let upperNode = if hi[1] == 0: sbt_inf(T) else: to_SBTNode(hi[0], hi[1])
                doAssert lower == lowerNode
                doAssert upper == upperNode

proc testLarge[T]() =
    var rng = initRand(20260930)
    for trial in 0..<10000:
        let a = T(rng.rand(999999999)+1)
        let b = T(rng.rand(999999999)+1)
        let c = T(rng.rand(999999999)+1)
        let d = T(rng.rand(999999999)+1)
        let path = referencePath(a, b)
        checkNode(a, b, path)
        doAssert LCA(a, b, c, d) == referenceLCA(path, referencePath(c, d))
        let node = to_SBTNode(a, b)
        doAssert LCA(node, node) == node
        let parent = ancestor(node, node.depth div 2).get()
        doAssert LCA(node, parent) == parent
    for (a, b) in [(T.high, T(1)), (T(1), T.high), (T.high, T.high),
                   (T.high, T.high-1), (T.high-1, T.high),
                   (T(701408733), T(433494437)), (T(433494437), T(701408733))]:
        let path = referencePath(a, b)
        checkNode(a, b, path)
        doAssert LCA(a, b, a, b) == decode_path(path)
        doAssert LCA(a, b, b, a) == sbt_root(T)

for path in [@[], @[('L', 0)], @[('R', 0)], @[('L', 3), ('L', 4), ('R', 2)]]:
    let node = decode_path(path)
    doAssert to_SBTNode(node.num(), node.den()) == node

testSmall[int]()
testSmall[int32]()
testSmall[int64]()
testLarge[int]()
testLarge[int32]()
testLarge[int64]()
echo "Hello World"
