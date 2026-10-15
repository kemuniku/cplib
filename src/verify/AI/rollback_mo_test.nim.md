---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_static_op.nim
    title: cplib/collections/segtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_static_op.nim
    title: cplib/collections/segtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/offline_dynamic_queries.nim
    title: cplib/utils/offline_dynamic_queries.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/offline_dynamic_queries.nim
    title: cplib/utils/offline_dynamic_queries.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/rollback_mo.nim
    title: cplib/utils/rollback_mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/rollback_mo.nim
    title: cplib/utils/rollback_mo.nim
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
    import random\nimport cplib/utils/rollback_mo\nimport cplib/utils/offline_dynamic_queries\n\
    import cplib/collections/unionfind\nimport cplib/collections/segtree_static_op\n\
    \nblock:\n    var solver = initRollbackMo(0)\n    var calls = 0\n    proc add(idx:\
    \ int) = inc calls\n    proc answer(idx: int) = inc calls\n    solver.runAutoRollback(add,\
    \ answer)\n    doAssert calls == 0\n    doAssert solver.insert(0, 0) == 0\n  \
    \  solver.runAutoRollback(add, answer)\n    doAssert calls == 1\n\nproc testFrequencies(values:\
    \ seq[int], ranges: seq[(int, int)], width: int) =\n    var solver = initRollbackMo(values.len,\
    \ ranges.len, width)\n    var expected: seq[int]\n    for idx, query in ranges:\n\
    \        doAssert solver.insert(query[0], query[1]) == idx\n        var counts:\
    \ array[8, int]\n        counts[0] = 2\n        for i in query[0]..<query[1]:\
    \ inc counts[values[i]]\n        var best = 2\n        for count in counts: best\
    \ = max(best, count)\n        expected.add(best)\n    var counts: array[8, int]\n\
    \    counts[0] = 2\n    var best = 2\n    var answers = newSeq[int](ranges.len)\n\
    \    var seen = newSeq[int](ranges.len)\n    proc increment(value: int) =\n  \
    \      inc counts[value]\n        best = max(best, counts[value])\n    proc add(idx:\
    \ int) = increment(values[idx])\n    proc answer(idx: int) =\n        answers[idx]\
    \ = best\n        inc seen[idx]\n    for repeat in 0..<2:\n        solver.runAutoRollback(add,\
    \ answer)\n        doAssert answers == expected\n        doAssert best == 2 and\
    \ counts[0] == 2\n        for i in 1..<counts.len: doAssert counts[i] == 0\n \
    \       for count in seen: doAssert count == repeat + 1\n    var history: seq[(int,\
    \ int)]\n    var additions = 0\n    proc manualAdd(idx: int) =\n        history.add((values[idx],\
    \ best))\n        increment(values[idx])\n        inc additions\n    proc rollback()\
    \ =\n        let previous = history.pop()\n        dec counts[previous[0]]\n \
    \       best = previous[1]\n    solver.run(manualAdd, rollback, answer)\n    doAssert\
    \ answers == expected\n    doAssert best == 2 and counts[0] == 2 and history.len\
    \ == 0\n    for i in 1..<counts.len: doAssert counts[i] == 0\n    for count in\
    \ seen: doAssert count == 3\n    if width > 0:\n        let b = min(width, max(1,\
    \ values.len))\n        doAssert additions <= values.len * (values.len div b +\
    \ 1) + ranges.len * b\n    solver.insert(0, 0)\n    answers.add(0)\n    seen.add(0)\n\
    \    solver.runAutoRollback(add, answer)\n    doAssert answers[^1] == 2 and seen[^1]\
    \ == 1\n    doAssert best == 2 and counts[0] == 2\n\nvar rng = initRand(230791)\n\
    for n in 0..12:\n    var values = newSeq[int](n)\n    for value in values.mitems:\
    \ value = rng.rand(7)\n    var ranges: seq[(int, int)]\n    for l in 0..n:\n \
    \       for r in l..n: ranges.add((l, r))\n    rng.shuffle(ranges)\n    for width\
    \ in [0, 1, 2, 3, n, n + 5]:\n        testFrequencies(values, ranges, width)\n\
    \nfor trial in 0..<40:\n    let n = rng.rand(80) + 1\n    var values = newSeq[int](n)\n\
    \    for value in values.mitems: value = rng.rand(7)\n    var ranges: seq[(int,\
    \ int)]\n    for i in 0..<150:\n        let l = rng.rand(n)\n        ranges.add((l,\
    \ rng.rand(l..n)))\n    testFrequencies(values, ranges, rng.rand(n) + 1)\n\nfor\
    \ width in [1, 2, 4]:\n    let values = [2, 0, 2, 3, 1, 0, 3]\n    var mo = initRollbackMo(values.len,\
    \ width = width)\n    var ranges: seq[(int, int)]\n    for l in 0..values.len:\n\
    \        for r in l..values.len:\n            mo.insert(l, r)\n            ranges.add((l,\
    \ r))\n    var tree = newSegWith(4, l + r, 0)\n    for i in 0..<4: tree[i] = 1\n\
    \    let original = tree.arr\n    var total = 0\n    proc add(idx: int) =\n  \
    \      tree[values[idx]] = tree[values[idx]] + 1\n        total = tree[0..3]\n\
    \    proc answer(idx: int) =\n        var expected = [1, 1, 1, 1]\n        let\
    \ (l, r) = ranges[idx]\n        for i in l..<r: inc expected[values[i]]\n    \
    \    for i in 0..<4: doAssert tree[i] == expected[i]\n        doAssert tree[1..2]\
    \ == expected[1] + expected[2]\n        doAssert total == (if l == r: 0 else:\
    \ 4 + r - l)\n    for repeat in 0..<2:\n        mo.runAutoRollback(add, answer)\n\
    \        doAssert tree.arr == original and total == 0\n\nproc testDirections(n,\
    \ width: int) =\n    var mo = initRollbackMo(n, width = width)\n    var ranges:\
    \ seq[(int, int)]\n    for l in 0..n:\n        for r in l..n: ranges.add((l, r))\n\
    \    rng.shuffle(ranges)\n    for query in ranges: mo.insert(query[0], query[1])\n\
    \    const powers = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000]\n\
    \    var digits = 0\n    var length = 0\n    var first = -1\n    var last = -1\n\
    \    var seen = 0\n    proc addLeft(idx: int) =\n        if length > 0: doAssert\
    \ idx == first - 1\n        else: last = idx\n        first = idx\n        digits\
    \ = (idx + 1) * powers[length] + digits\n        inc length\n    proc addRight(idx:\
    \ int) =\n        if length > 0: doAssert idx == last + 1\n        else: first\
    \ = idx\n        last = idx\n        digits = digits * 10 + idx + 1\n        inc\
    \ length\n    proc answer(idx: int) =\n        let (l, r) = ranges[idx]\n    \
    \    var expected = 0\n        for i in l..<r: expected = expected * 10 + i +\
    \ 1\n        doAssert digits == expected and length == r - l\n        if l < r:\
    \ doAssert first == l and last == r - 1\n        inc seen\n    for repeat in 0..<2:\n\
    \        mo.runAutoRollback(addLeft, addRight, answer)\n        doAssert digits\
    \ == 0 and length == 0 and first == -1 and last == -1\n        doAssert seen ==\
    \ (repeat + 1) * ranges.len\n    var history: seq[(int, int, int, int)]\n    proc\
    \ manualLeft(idx: int) =\n        history.add((digits, length, first, last))\n\
    \        addLeft(idx)\n    proc manualRight(idx: int) =\n        history.add((digits,\
    \ length, first, last))\n        addRight(idx)\n    proc rollback() = (digits,\
    \ length, first, last) = history.pop()\n    mo.run(manualLeft, manualRight, rollback,\
    \ answer)\n    doAssert seen == 3 * ranges.len and history.len == 0\n    doAssert\
    \ digits == 0 and length == 0 and first == -1 and last == -1\n\nfor n in 0..8:\n\
    \    for width in [0, 1, 2, 3, n, n + 5]: testDirections(n, width)\n\nblock:\n\
    \    var mo = initRollbackMo(3, width = 1)\n    mo.insert(0, 3)\n    var state\
    \ = 7\n    proc addLeft(idx: int) = inc state\n    proc addRight(idx: int) = state\
    \ += 2\n    proc failingLeft(idx: int) =\n        addLeft(idx)\n        state\
    \ += 10 div idx\n    proc failingRight(idx: int) =\n        addRight(idx)\n  \
    \      state += 10 div (idx - 1)\n    proc answer(idx: int) = discard\n    try:\n\
    \        mo.runAutoRollback(failingLeft, addRight, answer)\n        doAssert false\n\
    \    except DivByZeroDefect:\n        doAssert state == 7\n    try:\n        mo.runAutoRollback(addLeft,\
    \ failingRight, answer)\n        doAssert false\n    except DivByZeroDefect:\n\
    \        doAssert state == 7\n\nfor trial in 0..<30:\n    const vertices = 10\n\
    \    var edges: seq[(int, int)]\n    for i in 0..<40: edges.add((rng.rand(vertices\
    \ - 1), rng.rand(vertices - 1)))\n    var mo = initRollbackMo(edges.len)\n   \
    \ var expected: seq[int]\n    for i in 0..<100:\n        let l = rng.rand(edges.len)\n\
    \        let r = rng.rand(l..edges.len)\n        mo.insert(l, r)\n        var\
    \ labels: array[vertices, int]\n        for v in 0..<vertices: labels[v] = v\n\
    \        labels[1] = 0\n        var count = vertices - 1\n        for e in l..<r:\n\
    \            let a = labels[edges[e][0]]\n            let b = labels[edges[e][1]]\n\
    \            if a != b:\n                dec count\n                for v in 0..<vertices:\n\
    \                    if labels[v] == b: labels[v] = a\n        expected.add(count)\n\
    \    var uf = initUnionFind(vertices)\n    uf.unite(0, 1)\n    proc add(idx: int)\
    \ = uf.unite(edges[idx][0], edges[idx][1])\n    var seen = 0\n    proc answer(idx:\
    \ int) =\n        doAssert uf.count == expected[idx]\n        inc seen\n    mo.runAutoRollback(add,\
    \ answer)\n    doAssert seen == expected.len\n    doAssert uf.count == vertices\
    \ - 1 and uf.siz(0) == 2\n    for v in 2..<vertices: doAssert uf.siz(v) == 1\n\
    \nblock:\n    var mo = initRollbackMo(3, width = 1)\n    mo.insert(0, 3)\n   \
    \ var state = 7\n    proc add(idx: int) = inc state\n    proc answer(idx: int)\
    \ = raise newException(ValueError, \"test\")\n    try:\n        mo.runAutoRollback(add,\
    \ answer)\n        doAssert false\n    except ValueError:\n        doAssert state\
    \ == 7\n\nblock:\n    var mo = initRollbackMo(3, width = 1)\n    mo.insert(0,\
    \ 3)\n    var state = 7\n    proc add(idx: int) =\n        inc state\n       \
    \ state += 10 div idx\n    proc answer(idx: int) = discard\n    try:\n       \
    \ mo.runAutoRollback(add, answer)\n        doAssert false\n    except DivByZeroDefect:\n\
    \        doAssert state == 7\n\nblock:\n    var offline = initOfflineDynamicQueries(int)\n\
    \    var mo = initRollbackMo(3)\n    var total = 0\n    proc apply(idx, value:\
    \ int) = total += value\n    proc add(idx: int) = total += idx\n    proc answer(idx:\
    \ int) = doAssert total == idx\n    offline.add(0, 3)\n    offline.output(3)\n\
    \    offline.runAutoRollback(apply, answer)\n    mo.insert(0, 0)\n    mo.insert(0,\
    \ 2)\n    mo.runAutoRollback(add, answer)\n    doAssert total == 0\n\nstatic:\n\
    \    doAssert not compiles(block:\n        var mo = initRollbackMo(1)\n      \
    \  var values: seq[int]\n        proc add(idx: int) = values.add(idx)\n      \
    \  proc answer(idx: int) = discard\n        mo.runAutoRollback(add, answer)\n\
    \    )\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/rollback_mo.nim
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/rollback_mo.nim
  - cplib/collections/segtree_static_op.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/unionfind.nim
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/collections/unionfind.nim
  - cplib/utils/backwards_index.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/collections/segtree_static_op.nim
  isVerificationFile: true
  path: verify/AI/rollback_mo_test.nim
  requiredBy: []
  timestamp: '2026-10-14 21:35:25+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/rollback_mo_test.nim
layout: document
redirect_from:
- /verify/verify/AI/rollback_mo_test.nim
- /verify/verify/AI/rollback_mo_test.nim.html
title: verify/AI/rollback_mo_test.nim
---
