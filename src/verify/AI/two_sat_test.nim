# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/two_sat
import random

template expectValueError(body: untyped) =
    block:
        var raised = false
        try:
            body
        except ValueError:
            raised = true
        doAssert raised

for op in 0..8:
    for mask in 0..<16:
        let p = initTwoSat(2)
        let a = (mask and 1) != 0
        let b = (mask and 2) != 0
        let negateA = (mask and 4) != 0
        let negateB = (mask and 8) != 0
        let lhs = if negateA: not p[0] else: not (not p[0])
        let rhs = if negateB: not p[1] else: not (not p[1])
        let av = a xor negateA
        let bv = b xor negateB
        var expected: bool
        case op
        of 0:
            p += lhs or rhs
            expected = av or bv
        of 1:
            p += lhs xor rhs
            expected = av xor bv
        of 2:
            p += lhs ^ rhs
            expected = av xor bv
        of 3:
            p += lhs == rhs
            expected = av == bv
        of 4:
            p += lhs != rhs
            expected = av != bv
        of 5:
            p += implies(lhs, rhs)
            expected = not av or bv
        of 6:
            p += (not lhs) or (not rhs)
            expected = not av or not bv
        of 7:
            p += nand(lhs, rhs)
            expected = not (av and bv)
        else:
            p += lhs.nand(rhs)
            expected = not (av and bv)
        p += p[0] == a
        p += b == p[1]
        doAssert p.solve() == expected
        if expected:
            doAssert p[0].get() == a
            doAssert p[1].get() == b
            doAssert lhs.get() == av
            doAssert p.solve()
        else:
            expectValueError: discard p[0].get()

block:
    var p = initTwoSat(7)
    expectValueError: discard p[0].get()
    p += p[0] or p[1]
    p += p[0] == p[1]
    p += p[2] != p[0]
    p += p[3] ^ (not p[6])
    p += (not p[3]) == p[2]
    p += p[4] xor p[5]
    p += implies(p[0], p[3])
    p += p[4] != false
    p += true != p[5]
    p += (not p[5]) == true
    p += false != (not p[5])
    p += (not p[4]) != true
    p += false == (not p[4])
    doAssert p.solve()
    doAssert p[0].get() and p[1].get() and not p[2].get()
    doAssert p[3].get() and p[6].get()
    p += p[0] == false
    expectValueError: discard p[0].get()
    doAssert not p.solve()
    expectValueError: discard p[0].get()

block:
    let p = initTwoSat(1)
    let q = initTwoSat(1)
    expectValueError: discard p[0] or q[0]
    expectValueError: p += q[0] == true
    expectValueError: p += Constraint2sat()
    doAssert p.solve() and q.solve()
    p += p[0] == (not p[0])
    doAssert not p.solve()
    let empty = initTwoSat(0)
    doAssert empty.solve()
    expectValueError: discard initTwoSat(-1)
    doAssert not compiles((p[0] or p[0]) or p[0])

var rng = initRand(20260914)
for trial in 0..<500:
    let n = rng.rand(1..7)
    let p = initTwoSat(n)
    var clauses: seq[tuple[i, j: int, f, g: bool]]
    for step in 0..<20:
        let i = rng.rand(n - 1)
        let j = rng.rand(n - 1)
        let f = rng.rand(1) == 1
        let g = rng.rand(1) == 1
        clauses.add((i, j, f, g))
        let a = if f: not (not p[i]) else: not p[i]
        let b = if g: not (not p[j]) else: not p[j]
        p += a or b
        var possible = false
        for mask in 0..<(1 shl n):
            var valid = true
            for c in clauses:
                if (((mask shr c.i) and 1) == 1) != c.f and
                   (((mask shr c.j) and 1) == 1) != c.g:
                    valid = false
                    break
            if valid:
                possible = true
                break
        doAssert p.solve() == possible
        if possible:
            for c in clauses:
                doAssert p[c.i].get() == c.f or p[c.j].get() == c.g

block:
    let p = initTwoSat(1)
    let negated = not p[0]
    doAssert $p[0] == "-"
    doAssert $negated == "-"
    doAssert $Literal2sat() == "-"
    p += p[0] == true
    doAssert p.solve()
    doAssert $p[0] == "1"
    doAssert $negated == "0"
    p += p[0] == false
    doAssert $p[0] == "-"
    doAssert $negated == "-"
    doAssert not p.solve()
    doAssert $p[0] == "-"
    doAssert $negated == "-"
    let q = initTwoSat(1)
    q += q[0] == false
    doAssert q.solve()
    doAssert $q[0] == "0"
    doAssert $(not q[0]) == "1"

block:
    let n = 100000
    let p = initTwoSat(n)
    for i in 1..<n:
        p += implies(p[i - 1], p[i])
    p += p[0] == true
    doAssert p.solve()
    doAssert p.solve()
    for i in 0..<n:
        doAssert p[i].get()
    p += p[n - 1] == false
    doAssert not p.solve()
    doAssert not p.solve()
    doAssert $p[0] == "-"

echo "Hello World"
