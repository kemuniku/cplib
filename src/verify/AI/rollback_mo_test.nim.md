---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
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
    import cplib/collections/unionfind\n\nblock:\n    var solver = initRollbackMo(0)\n\
    \    var calls = 0\n    proc add(idx: int) = inc calls\n    proc answer(idx: int)\
    \ = inc calls\n    solver.runAutoRollback(add, answer)\n    doAssert calls ==\
    \ 0\n    doAssert solver.insert(0, 0) == 0\n    solver.runAutoRollback(add, answer)\n\
    \    doAssert calls == 1\n\nproc testFrequencies(values: seq[int], ranges: seq[(int,\
    \ int)], width: int) =\n    var solver = initRollbackMo(values.len, ranges.len,\
    \ width)\n    var expected: seq[int]\n    for idx, query in ranges:\n        doAssert\
    \ solver.insert(query[0], query[1]) == idx\n        var counts: array[8, int]\n\
    \        counts[0] = 2\n        for i in query[0]..<query[1]: inc counts[values[i]]\n\
    \        var best = 2\n        for count in counts: best = max(best, count)\n\
    \        expected.add(best)\n    var counts: array[8, int]\n    counts[0] = 2\n\
    \    var best = 2\n    var answers = newSeq[int](ranges.len)\n    var seen = newSeq[int](ranges.len)\n\
    \    proc increment(value: int) =\n        inc counts[value]\n        best = max(best,\
    \ counts[value])\n    proc add(idx: int) = increment(values[idx])\n    proc answer(idx:\
    \ int) =\n        answers[idx] = best\n        inc seen[idx]\n    for repeat in\
    \ 0..<2:\n        solver.runAutoRollback(add, answer)\n        doAssert answers\
    \ == expected\n        doAssert best == 2 and counts[0] == 2\n        for i in\
    \ 1..<counts.len: doAssert counts[i] == 0\n        for count in seen: doAssert\
    \ count == repeat + 1\n    var history: seq[(int, int)]\n    var additions = 0\n\
    \    proc manualAdd(idx: int) =\n        history.add((values[idx], best))\n  \
    \      increment(values[idx])\n        inc additions\n    proc rollback() =\n\
    \        let previous = history.pop()\n        dec counts[previous[0]]\n     \
    \   best = previous[1]\n    solver.run(manualAdd, rollback, answer)\n    doAssert\
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
    \ trial in 0..<30:\n    const vertices = 10\n    var edges: seq[(int, int)]\n\
    \    for i in 0..<40: edges.add((rng.rand(vertices - 1), rng.rand(vertices - 1)))\n\
    \    var mo = initRollbackMo(edges.len)\n    var expected: seq[int]\n    for i\
    \ in 0..<100:\n        let l = rng.rand(edges.len)\n        let r = rng.rand(l..edges.len)\n\
    \        mo.insert(l, r)\n        var labels: array[vertices, int]\n        for\
    \ v in 0..<vertices: labels[v] = v\n        labels[1] = 0\n        var count =\
    \ vertices - 1\n        for e in l..<r:\n            let a = labels[edges[e][0]]\n\
    \            let b = labels[edges[e][1]]\n            if a != b:\n           \
    \     dec count\n                for v in 0..<vertices:\n                    if\
    \ labels[v] == b: labels[v] = a\n        expected.add(count)\n    var uf = initUnionFind(vertices)\n\
    \    uf.unite(0, 1)\n    proc add(idx: int) = uf.unite(edges[idx][0], edges[idx][1])\n\
    \    var seen = 0\n    proc answer(idx: int) =\n        doAssert uf.count == expected[idx]\n\
    \        inc seen\n    mo.runAutoRollback(add, answer)\n    doAssert seen == expected.len\n\
    \    doAssert uf.count == vertices - 1 and uf.siz(0) == 2\n    for v in 2..<vertices:\
    \ doAssert uf.siz(v) == 1\n\nblock:\n    var mo = initRollbackMo(3, width = 1)\n\
    \    mo.insert(0, 3)\n    var state = 7\n    proc add(idx: int) = inc state\n\
    \    proc answer(idx: int) = raise newException(ValueError, \"test\")\n    try:\n\
    \        mo.runAutoRollback(add, answer)\n        doAssert false\n    except ValueError:\n\
    \        doAssert state == 7\n\nblock:\n    var mo = initRollbackMo(3, width =\
    \ 1)\n    mo.insert(0, 3)\n    var state = 7\n    proc add(idx: int) =\n     \
    \   inc state\n        state += 10 div idx\n    proc answer(idx: int) = discard\n\
    \    try:\n        mo.runAutoRollback(add, answer)\n        doAssert false\n \
    \   except DivByZeroDefect:\n        doAssert state == 7\n\nblock:\n    var offline\
    \ = initOfflineDynamicQueries(int)\n    var mo = initRollbackMo(3)\n    var total\
    \ = 0\n    proc apply(idx, value: int) = total += value\n    proc add(idx: int)\
    \ = total += idx\n    proc answer(idx: int) = doAssert total == idx\n    offline.add(0,\
    \ 3)\n    offline.output(3)\n    offline.runAutoRollback(apply, answer)\n    mo.insert(0,\
    \ 0)\n    mo.insert(0, 2)\n    mo.runAutoRollback(add, answer)\n    doAssert total\
    \ == 0\n\nstatic:\n    doAssert not compiles(block:\n        var mo = initRollbackMo(1)\n\
    \        var values: seq[int]\n        proc add(idx: int) = values.add(idx)\n\
    \        proc answer(idx: int) = discard\n        mo.runAutoRollback(add, answer)\n\
    \    )\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/collections/unionfind.nim
  - cplib/utils/rollback_mo.nim
  - cplib/collections/unionfind.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/rollback_mo.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: true
  path: verify/AI/rollback_mo_test.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/rollback_mo_test.nim
layout: document
redirect_from:
- /verify/verify/AI/rollback_mo_test.nim
- /verify/verify/AI/rollback_mo_test.nim.html
title: verify/AI/rollback_mo_test.nim
---
