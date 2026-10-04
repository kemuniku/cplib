# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import options, random
import cplib/collections/dynamic_lichaotree

static:
    doAssert sizeof(int) <= 8

type Segment = tuple[a, b, l, r: int]

template rejects(body: untyped) =
    block:
        var caught = false
        try: body
        except ValueError: caught = true
        doAssert caught

proc check(l, r, seed: int) =
    let tree = initDynamicLiChaoTree(l, r)
    var segments: seq[Segment]
    var rng = initRand(seed)
    proc verify() =
        let count = tree.node_count
        for x in l..<r:
            var expected = none(int)
            for s in segments:
                if s.l <= x and x < s.r:
                    let value = s.a * x + s.b
                    if expected.isNone or value < expected.get:
                        expected = some(value)
            doAssert tree.get_min(x) == expected
        doAssert tree.node_count == count
        doAssert count <= 2 * (r - l) - 1
    verify()
    for step in 0..<200:
        let a = rng.rand(-20..20)
        let b = rng.rand(-100..100)
        if step mod 4 == 0:
            let count = tree.node_count
            tree.add_line(a, b)
            doAssert tree.node_count <= count + 1
            segments.add((a, b, l, r))
        else:
            let ql = rng.rand((l - 10)..(r + 10))
            let qr = rng.rand((l - 10)..(r + 10))
            tree.add_segment(a, b, ql, qr)
            segments.add((a, b, ql, qr))
        verify()

for (l, r) in [(-33, 32), (-20, -1), (-7, -6), (-1, 0), (0, 1), (0, 2),
               (1, 4), (7, 24), (1_500_000_000, 1_500_000_033)]:
    for seed in 0..<3: check(l, r, seed + 499)

# 全傾き・切片の組と順序を小さい領域で総当たりする。
for a in -2..2:
    for b in -2..2:
        for c in -2..2:
            for d in -2..2:
                let tree = initDynamicLiChaoTree(-3, 4)
                tree.add_line(a, b)
                tree.add_line(c, d)
                tree.add_line(a, b)
                tree.add_segment(-a, -b, -2, 3)
                for x in -3..3:
                    var expected = min(a*x+b, c*x+d)
                    if -2 <= x and x < 3: expected = min(expected, -a*x-b)
                    doAssert tree.get_min(x) == some(expected)

let clipped = initDynamicLiChaoTree(-2, 3)
clipped.add_segment(0, -5, low(int), -1)
clipped.add_segment(0, -7, 2, high(int))
doAssert clipped.get_min(-2) == some(-5)
doAssert clipped.get_min(-1).isNone
doAssert clipped.get_min(1).isNone
doAssert clipped.get_min(2) == some(-7)
let count = clipped.node_count
clipped.add_segment(0, low(int), 0, 0)
clipped.add_segment(0, low(int), 2, 1)
clipped.add_segment(0, low(int), 3, high(int))
clipped.add_segment(0, low(int), low(int), -2)
doAssert clipped.node_count == count
let alias = clipped
alias.add_segment(0, -9, -1, 2)
doAssert clipped.get_min(0) == some(-9)
let independent = initDynamicLiChaoTree(-2, 3)
doAssert independent.get_min(0).isNone

# INFを含むintの全範囲を空と区別する。
for value in [low(int), -1, 0, int(3_300_300_300_300_300_491), high(int)]:
    let tree = initDynamicLiChaoTree(-1, 2)
    tree.add_line(0, value)
    for x in -1..1: doAssert tree.get_min(x) == some(value)

# 中点の和・差がintを越える領域。整数端点も事前登録なしで使う。
let wide = initDynamicLiChaoTree(low(int), high(int))
wide.add_line(1, 0)
wide.add_line(-1, -1)
for x in [low(int), low(int)+1, -3, -1, 0, 1, 7, high(int)-2, high(int)-1]:
    let expected = if x < 0: x else: -x-1
    doAssert wide.get_min(x) == some(expected)
wide.add_segment(0, low(int), low(int), low(int)+1)
doAssert wide.get_min(low(int)) == some(low(int))
doAssert wide.get_min(low(int)+1) == some(low(int)+1)
wide.add_segment(0, low(int), high(int)-1, high(int))
doAssert wide.get_min(high(int)-1) == some(low(int))
let negativeEdge = initDynamicLiChaoTree(low(int), low(int)+2)
negativeEdge.add_segment(0, high(int), low(int)+1, low(int)+2)
doAssert negativeEdge.get_min(low(int)).isNone
doAssert negativeEdge.get_min(low(int)+1) == some(high(int))
let positiveEdge = initDynamicLiChaoTree(high(int)-2, high(int))
positiveEdge.add_segment(0, -1, high(int)-2, high(int)-1)
doAssert positiveEdge.get_min(high(int)-2) == some(-1)
doAssert positiveEdge.get_min(high(int)-1).isNone

# 積はoverflowするが加算後はintに収まるケースと、結果のoverflow拒否。
let cancellation = initDynamicLiChaoTree(2, 3)
cancellation.add_line(high(int), low(int))
doAssert cancellation.get_min(2) == some(high(int)-1)
let overflowing = initDynamicLiChaoTree(-2, 3)
overflowing.add_line(low(int), low(int))
rejects:
    discard overflowing.get_min(-2)
rejects:
    discard overflowing.get_min(1)
doAssert overflowing.get_min(-1) == some(0)
overflowing.add_line(0, high(int))
doAssert overflowing.get_min(-2) == some(high(int))
rejects:
    discard overflowing.get_min(1)

let maximalProduct = initDynamicLiChaoTree(low(int), low(int)+1)
maximalProduct.add_line(low(int), high(int))
rejects:
    discard maximalProduct.get_min(low(int))
maximalProduct.add_line(0, high(int))
doAssert maximalProduct.get_min(low(int)) == some(high(int))
maximalProduct.add_line(high(int), low(int))
rejects:
    discard maximalProduct.get_min(low(int))

rejects:
    discard initDynamicLiChaoTree(1, 1)
rejects:
    discard initDynamicLiChaoTree(1, -1)
rejects:
    discard clipped.get_min(-3)
rejects:
    discard clipped.get_min(3)
var uninitialized: DynamicLiChaoTree
rejects:
    uninitialized.add_line(0, 0)
rejects:
    uninitialized.add_segment(0, 0, 0, 1)
rejects:
    discard uninitialized.get_min(0)
rejects:
    discard uninitialized.node_count

# 交点が移動する直線列。重複・同傾きの悪い直線やqueryでノードを増やさない。
let hull = initDynamicLiChaoTree(0, 100_000)
for i in 0..<10_000:
    let before = hull.node_count
    hull.add_line(-2*i, i*i)
    doAssert hull.node_count <= before+1
for i in 0..<10_000: doAssert hull.get_min(i) == some(-i*i)
let hullCount = hull.node_count
for i in 0..<10_000:
    hull.add_line(-2*i, i*i)
    hull.add_line(-2*i, i*i+1)
doAssert hull.node_count == hullCount

# 巨大領域の疎な点線分。各点だけを被覆し、pool再配置後もリンクを保つ。
let sparse = initDynamicLiChaoTree(-1_000_000_000, 1_000_000_001)
for i in 0..<10_000:
    let x = i*7919
    sparse.add_segment(0, -i, x, x+1)
for i in 0..<10_000:
    let x = i*7919
    doAssert sparse.get_min(x) == some(-i)
    doAssert sparse.get_min(x+1).isNone
doAssert sparse.node_count <= 1 + 10_000*32

echo "Hello World"
