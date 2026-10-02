# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/xor_basis
import options, sets, random, algorithm

var queries = 0

proc checkWitness(basis: XorBasisWithRestore, inputs: openArray[int],
                  target: int, possible: bool) =
    let before = basis
    let found = basis.restore(target)
    doAssert found.isSome == possible
    doAssert basis.can_make(target) == possible
    doAssert basis == before
    doAssert basis.restore(target) == found
    if found.isSome:
        let ids = found.get
        var actual = 0
        var used = initHashSet[int]()
        for id in ids:
            doAssert id >= 0 and id < inputs.len
            doAssert id notin used
            used.incl(id)
            actual = actual xor inputs[id]
        doAssert actual == target
        doAssert ids.len <= basis.len_basis
        doAssert ids.isSorted
        if target == 0:
            doAssert ids.len == 0
    inc queries

proc checkSmall(inputs: seq[int], targets: openArray[int], compareOld: bool) =
    var basis = initXorBasisWithRestore()
    for n in 0..inputs.len:
        if n > 0:
            basis.incl(inputs[n - 1])
        let prefix = inputs[0..<n]
        let built = initXorBasisWithRestore(prefix)
        doAssert basis == built
        doAssert basis.len == n
        var span = initHashSet[int]()
        for mask in 0..<(1 shl n):
            var value = 0
            for i in 0..<n:
                if (mask and (1 shl i)) != 0:
                    value = value xor inputs[i]
            span.incl(value)
        doAssert (1 shl basis.len_basis) == span.len
        let old = initXorBasis(prefix)
        for target in targets:
            checkWitness(basis, prefix, target, target in span)
            if compareOld:
                doAssert old.can_make(target) == (target in span)

proc enumerate(prefix: var seq[int], remaining: int) =
    checkSmall(prefix, [0, 1, 2, 3, 4, 5, 6, 7, 8, 15], true)
    if remaining > 0:
        for value in 0..7:
            prefix.add(value)
            enumerate(prefix, remaining - 1)
            prefix.setLen(prefix.len - 1)

var prefix: seq[int]
enumerate(prefix, 4)

var rng = initRand(19260817)
for trial in 0..<150:
    var inputs: seq[int]
    for i in 0..<8:
        let value = rng.rand(31)
        inputs.add(if rng.rand(1) == 0: value else: not value)
    var targets: seq[int]
    for value in 0..63:
        targets.add(value)
        targets.add(not value)
    checkSmall(inputs, targets, false)
    inputs.reverse()
    checkSmall(inputs, targets, false)

checkSmall(@[0, low(int), high(int), -1, 1, low(int)],
           [0, low(int), high(int), -1, 1, 2, high(int) - 1], false)

block:
    const width = sizeof(int) * 8
    var basis: XorBasisWithRestore
    var inputs: seq[int]
    for i in 0..<130:
        inputs.add(0)
        basis.incl(0)
    for bit in 0..<width:
        let value = cast[int](1'u shl bit)
        inputs.add(value)
        basis.incl(value)
        doAssert basis.len_basis == bit + 1
        checkWitness(basis, inputs, value, true)
        checkWitness(basis, inputs, -1, bit == width - 1)
    for i in 0..<150:
        inputs.add(if i mod 2 == 0: -1 else: 0)
        basis.incl(inputs[^1])
    doAssert basis.len == inputs.len
    doAssert basis.len_basis == width
    for target in [0, 1, -1, low(int), high(int), low(int) + 1, high(int) - 1]:
        checkWitness(basis, inputs, target, true)
        for id in basis.restore(target).get:
            doAssert id >= 130 and id < 130 + width
    for i in 0..<1000:
        let target = cast[int](uint(rng.rand(high(int)))) xor
            (if rng.rand(1) == 0: 0 else: low(int))
        checkWitness(basis, inputs, target, true)

block:
    var a = initXorBasisWithRestore([0, 3, 3])
    var b = a
    b.incl(4)
    doAssert a.len == 3 and b.len == 4
    doAssert a.restore(4).isNone
    checkWitness(b, [0, 3, 3, 4], 7, true)
    a.incl(8)
    doAssert b.restore(8).isNone
    checkWitness(a, [0, 3, 3, 8], 11, true)
    var ids = b.restore(7).get
    ids[0] = 10000
    checkWitness(b, [0, 3, 3, 4], 7, true)
    a = initXorBasisWithRestore()
    doAssert a.len == 0 and a.len_basis == 0
    checkWitness(a, [], 0, true)
    checkWitness(a, [], -1, false)

stderr.writeLine("XOR restore queries checked: ", queries)
echo "Hello World"
