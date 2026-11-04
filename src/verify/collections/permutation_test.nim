# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, sequtils
import cplib/collections/permutation

template rejects(errorType: typedesc, action: untyped) =
    block:
        var caught = false
        try:
            action
        except errorType:
            caught = true
        doAssert caught

proc powerOracle(p: seq[int], k: int): seq[int] =
    result = toSeq(0..<p.len)
    var base = newSeq[int](p.len)
    var exponent: uint
    if k < 0:
        for i, x in p:
            base[x] = i
        exponent = uint(-(k+1))+1'u
    else:
        for i, x in p:
            base[i] = x
        exponent = uint(k)
    while exponent != 0:
        if (exponent and 1'u) != 0:
            for i in 0..<p.len:
                result[i] = base[result[i]]
        var squared = newSeq[int](p.len)
        for i in 0..<p.len:
            squared[i] = base[base[i]]
        base = squared
        exponent = exponent shr 1

proc check(p: seq[int]) =
    let perm = initPermutation(p)
    doAssert perm.len == p.len
    var minima: seq[int]
    for x in 0..<p.len:
        doAssert perm[x] == p[x]
        doAssert perm.index(x) == p.find(x)
        var path = @[x]
        var v = p[x]
        while v != x:
            path.add(v)
            v = p[v]
        if x == min(path):
            minima.add(x)
    for x in 0..<p.len:
        var path = @[x]
        var v = p[x]
        while v != x:
            path.add(v)
            v = p[v]
        doAssert perm.cycleLen(x) == path.len
        doAssert perm.cycle(x) == path
        doAssert toSeq(perm.cycleItems(x)) == path
        doAssert perm.cycleId(x) == minima.find(min(path))
        doAssert perm.cyclePosition(x) == (path.len-path.find(min(path))) mod path.len
        var forward = x
        var backward = x
        for k in 0..2*p.len:
            doAssert perm.applyPow(x, k) == forward
            doAssert perm.applyPow(x, -k) == backward
            forward = p[forward]
            backward = p.find(backward)
    for k in [low(int), low(int)+1, low(int)+2, high(int)-2, high(int)-1, high(int)]:
        let expected = powerOracle(p, k)
        for x in 0..<p.len:
            doAssert perm.applyPow(x, k) == expected[x]

static:
    var p = initPermutation([1, 2, 0, 3])
    doAssert p.index(0) == 2
    doAssert p.cycle(1) == @[1, 2, 0]
    doAssert p.applyPow(2, low(int)) == powerOracle(@[1, 2, 0, 3], low(int))[2]
    doAssert not compiles(p[0] = 0)

var checked = 0
for n in 0..7:
    var p = toSeq(0..<n)
    while true:
        check(p)
        inc checked
        if not nextPermutation(p):
            break
doAssert checked == 5914

var state = 329'u32
for n in 8..71:
    var p = toSeq(0..<n)
    for i in countdown(n-1, 1):
        state = state*1664525'u32+1013904223'u32
        swap(p[i], p[int(state mod uint32(i+1))])
    check(p)

for invalid in [@[-1], @[1], @[0, 0], @[2, 1], @[0, 2, 2], @[low(int)], @[high(int)]]:
    rejects(ValueError):
        discard initPermutation(invalid)

for perm in [default(Permutation), initPermutation(newSeq[int]()), initPermutation([1, 0, 2])]:
    for x in [-1, perm.len, low(int), high(int)]:
        rejects(IndexDefect): discard perm[x]
        rejects(IndexDefect): discard perm.index(x)
        rejects(IndexDefect): discard perm.cycleId(x)
        rejects(IndexDefect): discard perm.cyclePosition(x)
        rejects(IndexDefect): discard perm.cycleLen(x)
        rejects(IndexDefect): discard perm.cycle(x)
        rejects(IndexDefect): discard perm.applyPow(x, 0)
        rejects(IndexDefect):
            for v in perm.cycleItems(x): discard v

block:
    var source = @[1, 2, 0, 3]
    let perm = initPermutation(source)
    source[0] = 0
    var returned = perm.cycle(1)
    returned[0] = 99
    returned.add(100)
    var copied = perm
    copied = initPermutation([0])
    doAssert copied.len == 1
    doAssert perm[0] == 1 and perm.index(0) == 2
    doAssert perm.cycle(1) == @[1, 2, 0]

block:
    const n = 200000
    var p = toSeq(0..<n)
    let identity = initPermutation(p)
    for x in 0..<n:
        doAssert identity.cycleId(x) == x
        doAssert identity.cyclePosition(x) == 0
        doAssert identity.cycleLen(x) == 1
        doAssert identity.applyPow(x, low(int)) == x
        p[x] = if x+1 == n: 0 else: x+1
    let longCycle = initPermutation(p)
    doAssert longCycle.cycle(1).len == n
    for x in 0..<n:
        doAssert longCycle.index(p[x]) == x
        doAssert longCycle.cycleLen(x) == n
        doAssert longCycle.cyclePosition(x) == x
        doAssert longCycle.applyPow(x, n) == x
        doAssert longCycle.applyPow(x, -n) == x
        doAssert longCycle.applyPow(x, 1) == p[x]
        doAssert longCycle.applyPow(x, -1) == (if x == 0: n-1 else: x-1)

echo "Hello World"
