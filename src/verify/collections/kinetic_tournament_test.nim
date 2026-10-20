# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/kinetic_tournament
import cplib/math/int128

type Line = tuple[a, b: int]

proc check(tree: KineticTournament, lines: seq[Line], active: seq[bool]) =
    doAssert tree.len == lines.len
    for l in 0..lines.len:
        var expected = to_Int128(high(int))
        var found = false
        doAssert tree.query(l, l) == high(int)
        for r in l + 1..lines.len:
            if active[r - 1]:
                let line = lines[r - 1]
                let value = to_Int128(line.a) * to_Int128(tree.temperature) + to_Int128(line.b)
                if not found or value < expected: expected = value
                found = true
            if not found or (to_Int128(low(int)) <= expected and expected <= to_Int128(high(int))):
                doAssert tree.query(l, r) == expected.to_int
                doAssert tree.query(l..<r) == expected.to_int
                doAssert tree[l..r - 1] == expected.to_int
                if l == 0 and r == lines.len:
                    doAssert tree.get_all == expected.to_int

block:
    let tree = initKineticTournament(2)
    tree.update(0, 2, 10)
    tree.update(1, 4, 1)
    tree.heaten(1)
    doAssert tree.query(0, 1) == 12
    doAssert tree.query(1, 2) == 5
    doAssert tree[0..<2] == 5
    tree.heaten(5)
    doAssert tree.query(0, 1) == 20
    doAssert tree.query(1, 2) == 21
    doAssert tree.get_all == 20
    tree.erase(0)
    doAssert tree.get_all == 21
    tree.erase(0)
    tree.erase(1)
    tree.heaten(high(int))
    doAssert tree.get_all == high(int)
    tree.update(1, 0, -1)
    doAssert tree.get_all == -1

block:
    let tree = initKineticTournament(0, low(int))
    check(tree, @[], @[])
    tree.heaten(high(int))
    doAssert tree.get_all == high(int)
    doAssert tree[0..<0] == high(int)
    let fromEmpty = initKineticTournament(newSeq[Line]())
    doAssert fromEmpty.len == 0
    doAssert fromEmpty.get_all == high(int)

for lines in [@[(a: 2, b: 0), (a: 0, b: 3)],
        @[(a: 2, b: 0), (a: 0, b: 4)],
        @[(a: 2, b: 0), (a: 0, b: -3)],
        @[(a: 2, b: 0), (a: 0, b: -4)],
        @[(a: 1, b: 0), (a: -1, b: 0)],
        @[(a: 7, b: -3), (a: 7, b: -3), (a: 7, b: 10)]]:
    let tree = initKineticTournament(lines, -5)
    var active = newSeq[bool](lines.len)
    for i in 0..<active.len: active[i] = true
    for t in -5..5:
        tree.heaten(t)
        check(tree, lines, active)
        tree.heaten(t)
        check(tree, lines, active)

block:
    let lines = @[(a: 0, b: high(int)), (a: -1, b: 0)]
    let tree = initKineticTournament(lines, low(int))
    check(tree, lines, @[true, true])
    tree.heaten(low(int) + 1)
    check(tree, lines, @[true, true])

block:
    let lines = @[(a: 0, b: high(int)), (a: 1, b: 0)]
    let tree = initKineticTournament(lines)
    tree.heaten(high(int) - 1)
    check(tree, lines, @[true, true])
    tree.heaten(high(int))
    check(tree, lines, @[true, true])
    tree.update(0, 0, high(int) - 1)
    doAssert tree.get_all == high(int) - 1

block:
    let lines = @[(a: 0, b: high(int)), (a: 1, b: low(int))]
    let tree = initKineticTournament(lines)
    tree.heaten(high(int))
    check(tree, lines, @[true, true])

block:
    let extremes = @[low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]
    var lines: seq[Line]
    var active: seq[bool]
    for a in extremes:
        for b in extremes:
            lines.add((a, b))
            active.add(true)
    let tree = initKineticTournament(lines, low(int))
    for t in extremes:
        tree.heaten(t)
        check(tree, lines, active)
    for i in 0..<lines.len:
        tree.erase(i)
        active[i] = false
        check(tree, lines, active)

var rng = initRand(20261020)
for n in [1, 2, 3, 5, 8, 13, 16, 31]:
    for trial in 0..<12:
        var lines = newSeq[Line](n)
        var active = newSeq[bool](n)
        let tree = initKineticTournament(n, -100)
        for step in 0..<120:
            case rng.rand(4)
            of 0, 1:
                let i = rng.rand(n - 1)
                lines[i] = (rng.rand(-30..30), rng.rand(-500..500))
                active[i] = true
                tree.update(i, lines[i].a, lines[i].b)
            of 2:
                let i = rng.rand(n - 1)
                active[i] = false
                tree.erase(i)
            else:
                tree.heaten(tree.temperature + rng.rand(0..20))
            check(tree, lines, active)
            let rebuilt = initKineticTournament(lines, tree.temperature)
            for i in 0..<n:
                if not active[i]: rebuilt.erase(i)
            doAssert rebuilt.get_all == tree.get_all

block:
    const n = 4096
    var lines = newSeq[Line](n)
    for i in 0..<n: lines[i] = (n - i, i * i)
    let tree = initKineticTournament(lines)
    for t in 0..n * 2:
        tree.heaten(t)
        let i = min(n - 1, t div 2)
        doAssert tree.get_all == (n - i) * t + i * i
        doAssert tree.query(n div 2, n) ==
            (n - max(n div 2, i)) * t + max(n div 2, i) * max(n div 2, i)
    tree.heaten(1000000000)
    doAssert tree.get_all == 1000000000 + (n - 1) * (n - 1)

when compileOption("assertions"):
    template rejects(body: untyped) =
        block:
            var rejected = false
            try:
                body
            except AssertionDefect:
                rejected = true
            doAssert rejected
    rejects:
        discard initKineticTournament(-1)
    rejects:
        initKineticTournament(1).heaten(-1)
    rejects:
        initKineticTournament(1).update(-1, 0, 0)
    rejects:
        initKineticTournament(1).update(1, 0, 0)
    rejects:
        initKineticTournament(1).erase(1)
    rejects:
        discard initKineticTournament(1).query(-1, 0)
    rejects:
        discard initKineticTournament(1).query(1, 0)
    rejects:
        discard initKineticTournament(1).query(0, 2)
    rejects:
        let tree = initKineticTournament(@[(a: high(int), b: high(int))])
        tree.heaten(1)
        discard tree.get_all

echo "Hello World"
