# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/matrix/matrix_avx2
import cplib/modint/modint
import cplib/collections/segtree

type Mint = modint998244353_montgomery
type Mat = Matrix[Mint]

proc make(value: int): Mat =
    initMatrix[Mint](1, 1, value)

proc merge(a, b: Mat): Mat = a * b

var inputs = newSeq[Mat](100000)
for i in 0 ..< inputs.len: inputs[i] = make(i)
var noise = newSeq[Mat](100000)
for i in 0 ..< noise.len: noise[i] = make(i + 100000)
GC_fullCollect()

var copied = inputs
copied[7][0, 0] = 9
var nested = @[inputs]
nested[0][8][0, 0] = 10
GC_fullCollect()
for i in 0 ..< inputs.len:
    doAssert inputs[i][0, 0].val == i
    doAssert noise[i][0, 0].val == i + 100000
    doAssert copied[i][0, 0].val == (if i == 7: 9 else: i)
    doAssert nested[0][i][0, 0].val == (if i == 8: 10 else: i)

var views = newSeq[MutableMatrixRow[Mint]](1000)
for i in 0 ..< views.len:
    var owner = make(i)
    views[i] = owner[0]
GC_fullCollect()
for i in 0 ..< views.len:
    doAssert views[i][0].val == i
    views[i][0] += Mint.init(1)
GC_fullCollect()
for i in 0 ..< views.len: doAssert views[i][0].val == i + 1

let tree = initSegmentTree(inputs, merge, make(1))
GC_fullCollect()
doAssert tree.get(2, 5)[0, 0].val == 24
tree.update(3, make(7))
GC_fullCollect()
doAssert tree.get(2, 5)[0, 0].val == 56
doAssert inputs[3][0, 0].val == 3

var empty: Mat
doAssert empty.clone().h == 0 and empty.clone().w == 0
echo "Hello World"
