---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/two_sat.nim
    title: cplib/graph/two_sat.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/two_sat.nim
    title: cplib/graph/two_sat.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/graph/two_sat\nimport random\n\ntemplate expectValueError(body: untyped)\
    \ =\n    block:\n        var raised = false\n        try:\n            body\n\
    \        except ValueError:\n            raised = true\n        doAssert raised\n\
    \nfor op in 0..8:\n    for mask in 0..<16:\n        let p = initTwoSat(2)\n  \
    \      let a = (mask and 1) != 0\n        let b = (mask and 2) != 0\n        let\
    \ negateA = (mask and 4) != 0\n        let negateB = (mask and 8) != 0\n     \
    \   let lhs = if negateA: not p[0] else: not (not p[0])\n        let rhs = if\
    \ negateB: not p[1] else: not (not p[1])\n        let av = a xor negateA\n   \
    \     let bv = b xor negateB\n        var expected: bool\n        case op\n  \
    \      of 0:\n            p += lhs or rhs\n            expected = av or bv\n \
    \       of 1:\n            p += lhs xor rhs\n            expected = av xor bv\n\
    \        of 2:\n            p += lhs ^ rhs\n            expected = av xor bv\n\
    \        of 3:\n            p += lhs == rhs\n            expected = av == bv\n\
    \        of 4:\n            p += lhs != rhs\n            expected = av != bv\n\
    \        of 5:\n            p += implies(lhs, rhs)\n            expected = not\
    \ av or bv\n        of 6:\n            p += (not lhs) or (not rhs)\n         \
    \   expected = not av or not bv\n        of 7:\n            p += nand(lhs, rhs)\n\
    \            expected = not (av and bv)\n        else:\n            p += lhs.nand(rhs)\n\
    \            expected = not (av and bv)\n        p += p[0] == a\n        p +=\
    \ b == p[1]\n        doAssert p.solve() == expected\n        if expected:\n  \
    \          doAssert p[0].get() == a\n            doAssert p[1].get() == b\n  \
    \          doAssert lhs.get() == av\n            doAssert p.solve()\n        else:\n\
    \            expectValueError: discard p[0].get()\n\nblock:\n    var p = initTwoSat(7)\n\
    \    expectValueError: discard p[0].get()\n    p += p[0] or p[1]\n    p += p[0]\
    \ == p[1]\n    p += p[2] != p[0]\n    p += p[3] ^ (not p[6])\n    p += (not p[3])\
    \ == p[2]\n    p += p[4] xor p[5]\n    p += implies(p[0], p[3])\n    p += p[4]\
    \ != false\n    p += true != p[5]\n    p += (not p[5]) == true\n    p += false\
    \ != (not p[5])\n    p += (not p[4]) != true\n    p += false == (not p[4])\n \
    \   doAssert p.solve()\n    doAssert p[0].get() and p[1].get() and not p[2].get()\n\
    \    doAssert p[3].get() and p[6].get()\n    p += p[0] == false\n    expectValueError:\
    \ discard p[0].get()\n    doAssert not p.solve()\n    expectValueError: discard\
    \ p[0].get()\n\nblock:\n    let p = initTwoSat(1)\n    let q = initTwoSat(1)\n\
    \    expectValueError: discard p[0] or q[0]\n    expectValueError: p += q[0] ==\
    \ true\n    expectValueError: p += Constraint2sat()\n    doAssert p.solve() and\
    \ q.solve()\n    p += p[0] == (not p[0])\n    doAssert not p.solve()\n    let\
    \ empty = initTwoSat(0)\n    doAssert empty.solve()\n    expectValueError: discard\
    \ initTwoSat(-1)\n    doAssert not compiles((p[0] or p[0]) or p[0])\n\nvar rng\
    \ = initRand(20260914)\nfor trial in 0..<500:\n    let n = rng.rand(1..7)\n  \
    \  let p = initTwoSat(n)\n    var clauses: seq[tuple[i, j: int, f, g: bool]]\n\
    \    for step in 0..<20:\n        let i = rng.rand(n - 1)\n        let j = rng.rand(n\
    \ - 1)\n        let f = rng.rand(1) == 1\n        let g = rng.rand(1) == 1\n \
    \       clauses.add((i, j, f, g))\n        let a = if f: not (not p[i]) else:\
    \ not p[i]\n        let b = if g: not (not p[j]) else: not p[j]\n        if (step\
    \ and 1) == 0:\n            p.add_clause(i, f, j, g)\n        else:\n        \
    \    p += a or b\n        var possible = false\n        for mask in 0..<(1 shl\
    \ n):\n            var valid = true\n            for c in clauses:\n         \
    \       if (((mask shr c.i) and 1) == 1) != c.f and\n                   (((mask\
    \ shr c.j) and 1) == 1) != c.g:\n                    valid = false\n         \
    \           break\n            if valid:\n                possible = true\n  \
    \              break\n        doAssert p.solve() == possible\n        if possible:\n\
    \            for c in clauses:\n                doAssert p[c.i].get() == c.f or\
    \ p[c.j].get() == c.g\n\nblock:\n    let p = initTwoSat(1)\n    let negated =\
    \ not p[0]\n    doAssert $p[0] == \"-\"\n    doAssert $negated == \"-\"\n    doAssert\
    \ $Literal2sat() == \"-\"\n    p += p[0] == true\n    doAssert p.solve()\n   \
    \ doAssert $p[0] == \"1\"\n    doAssert $negated == \"0\"\n    p += p[0] == false\n\
    \    doAssert $p[0] == \"-\"\n    doAssert $negated == \"-\"\n    doAssert not\
    \ p.solve()\n    doAssert $p[0] == \"-\"\n    doAssert $negated == \"-\"\n   \
    \ let q = initTwoSat(1)\n    q += q[0] == false\n    doAssert q.solve()\n    doAssert\
    \ $q[0] == \"0\"\n    doAssert $(not q[0]) == \"1\"\n\nblock:\n    let n = 100000\n\
    \    let p = initTwoSat(n)\n    for i in 1..<n:\n        p += implies(p[i - 1],\
    \ p[i])\n    p += p[0] == true\n    doAssert p.solve()\n    doAssert p.solve()\n\
    \    for i in 0..<n:\n        doAssert p[i].get()\n    p += p[n - 1] == false\n\
    \    doAssert not p.solve()\n    doAssert not p.solve()\n    doAssert $p[0] ==\
    \ \"-\"\n\nblock:\n    let p = initTwoSat(2)\n    expectValueError: discard p.answer()\n\
    \    p += p[0] == true\n    p += p[1] == false\n    doAssert p.satisfiable()\n\
    \    doAssert p.answer() == @[true, false]\n    var snapshot = p.answer()\n  \
    \  snapshot[0] = false\n    doAssert p[0].get()\n    doAssert p.solve() and p.satisfiable()\n\
    \    p.add_clause(0, false, 0, false)\n    expectValueError: discard p.answer()\n\
    \    doAssert not p.satisfiable()\n    doAssert not p.solve()\n    expectValueError:\
    \ discard p.answer()\n    doAssert snapshot == @[false, false]\n    let empty\
    \ = initTwoSat(0)\n    doAssert empty.satisfiable()\n    doAssert empty.answer().len\
    \ == 0\n    let uninitialized: Problem2sat = nil\n    expectValueError: discard\
    \ uninitialized.satisfiable()\n    expectValueError: discard uninitialized.answer()\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/two_sat.nim
  - cplib/graph/two_sat.nim
  isVerificationFile: true
  path: verify/AI/two_sat_test.nim
  requiredBy: []
  timestamp: '2026-09-14 01:57:18+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/two_sat_test.nim
layout: document
redirect_from:
- /verify/verify/AI/two_sat_test.nim
- /verify/verify/AI/two_sat_test.nim.html
title: verify/AI/two_sat_test.nim
---
