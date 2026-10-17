# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
const XOR_BASIS_INTERSECTION_REGRESSION = true
include ../math/xor_basis_intersection_test
import sets, random, algorithm

proc subsetSpan(values: openArray[int]): HashSet[int] =
    result = initHashSet[int]()
    for mask in 0..<(1 shl values.len):
        var value = 0
        for i in 0..<values.len:
            if (mask and (1 shl i)) != 0:
                value = value xor values[i]
        result.incl(value)

var checks = 0
proc check(u, v: seq[int]) =
    let xs = subsetSpan(u)
    let ys = subsetSpan(v)
    let beforeU = u
    let beforeV = v
    let answer = intersectWithRestore(u, v)
    let actual = subsetSpan(answer)
    doAssert actual == xs * ys
    doAssert actual.len == (1 shl answer.len)
    doAssert u == beforeU and v == beforeV
    doAssert intersectWithRestore(v, u).len == answer.len
    inc checks

# Yの各要素はXに属さないが、Yの2要素のXORは共通部分に属する。
doAssert intersectWithRestore([3], [5, 6]) == @[3]

var inputs: seq[seq[int]] = @[newSeq[int]()]
for a in 0..7:
    inputs.add(@[a])
    for b in 0..7:
        inputs.add(@[a, b])
        for c in 0..7:
            inputs.add(@[a, b, c])
for u in inputs:
    for v in inputs:
        check(u, v)

var rng = initRand(939)
for trial in 0..<300:
    var u, v: seq[int]
    for i in 0..<rng.rand(7): u.add(rng.rand(255))
    for i in 0..<rng.rand(7): v.add(rng.rand(255))
    check(u, v)
    u.reverse()
    v.reverse()
    check(u, v)

block:
    var u: seq[int]
    for bit in 0..<30: u.add(1 shl bit)
    var v = u
    v.reverse()
    doAssert intersectWithRestore(u, v) == u
    doAssert intersectWithRestore(u, []).len == 0
    doAssert intersectWithRestore([], v).len == 0
    for bit in 0..<29: v[bit] = v[bit] xor v[^1]
    doAssert intersectWithRestore(u, v) == u

block:
    var u: seq[int]
    for i in 0..<100: u.add(3)
    doAssert intersectWithRestore(u, [5, 6]) == @[3]

stderr.writeLine("XOR intersection oracle cases: ", checks)
echo "Hello World"
