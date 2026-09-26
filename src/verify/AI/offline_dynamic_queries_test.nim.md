---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rollback_unionfind.nim
    title: cplib/collections/rollback_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rollback_unionfind.nim
    title: cplib/collections/rollback_unionfind.nim
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
    import random\nimport cplib/utils/offline_dynamic_queries\nimport cplib/collections/rollback_unionfind\n\
    \nblock:\n    var solver = initOfflineDynamicQueries()\n    var calls = 0\n  \
    \  solver.add(1000000000)\n    solver.remove(1000000000)\n    solver.run((proc(idx:\
    \ int) = inc calls),\n        (proc() = inc calls), (proc(idx: int) = inc calls))\n\
    \    doAssert calls == 0\n\nblock:\n    var solver = initOfflineDynamicQueries()\n\
    \    var stack: seq[int]\n    var total = 17\n    var answers: seq[(int, int)]\n\
    \    proc apply(idx: int) =\n        stack.add(idx)\n        total += idx\n  \
    \  proc rollback() = total -= stack.pop()\n    proc answer(idx: int) = answers.add((idx,\
    \ total))\n    solver.output(90)\n    solver.add(3)\n    solver.add(5)\n    solver.output(12)\n\
    \    solver.remove(3)\n    solver.output(12)\n    solver.add(3)\n    solver.remove(5)\n\
    \    solver.output(-1)\n    solver.add(99)\n    solver.remove(99)\n    for repeat\
    \ in 0..<2:\n        answers.setLen(0)\n        solver.run(apply, rollback, answer)\n\
    \        doAssert answers == @[(90, 17), (12, 25), (12, 22), (-1, 20)]\n     \
    \   doAssert total == 17 and stack.len == 0\n    solver.remove(3)\n    solver.output(42)\n\
    \    answers.setLen(0)\n    solver.run(apply, rollback, answer)\n    doAssert\
    \ answers[^1] == (42, 17)\n    doAssert total == 17 and stack.len == 0\n\nblock:\n\
    \    type Query = tuple[amount: int, name: string]\n    var solver = initOfflineDynamicQueries(Query)\n\
    \    var stack: seq[int]\n    var total = 0\n    var answers: seq[int]\n    proc\
    \ apply(idx: int, value: Query) =\n        doAssert idx == 7\n        doAssert\
    \ value.name == \"value\" & $value.amount\n        stack.add(value.amount)\n \
    \       total += value.amount\n    proc rollback() = total -= stack.pop()\n  \
    \  proc answer(idx: int) =\n        doAssert idx == answers.len\n        answers.add(total)\n\
    \    solver.add(7, (99, \"value99\"))\n    solver.remove(7)\n    solver.output(0)\n\
    \    solver.add(7, (3, \"value3\"))\n    solver.output(1)\n    solver.remove(7)\n\
    \    solver.add(7, (8, \"value8\"))\n    solver.output(2)\n    for repeat in 0..<2:\n\
    \        answers.setLen(0)\n        solver.run(apply, rollback, answer)\n    \
    \    doAssert answers == @[0, 3, 8]\n        doAssert total == 0 and stack.len\
    \ == 0\n    solver.remove(7)\n    solver.output(3)\n    answers.setLen(0)\n  \
    \  solver.run(apply, rollback, answer)\n    doAssert answers == @[0, 3, 8, 0]\n\
    \    doAssert total == 0 and stack.len == 0\n\nvar rng = initRand(712367)\nfor\
    \ trial in 0..<100:\n    const n = 8\n    var edges: seq[(int, int)]\n    for\
    \ i in 0..<24: edges.add((rng.rand(n - 1), rng.rand(n - 1)))\n    var active =\
    \ newSeq[bool](edges.len)\n    var expected: seq[seq[int]]\n    var solver = initOfflineDynamicQueries()\n\
    \    var typedSolver = initOfflineDynamicQueries((int, int))\n    for step in\
    \ 0..<200:\n        if rng.rand(2) == 0:\n            var labels = newSeq[int](n)\n\
    \            for i in 0..<n: labels[i] = i\n            for idx, edge in edges:\n\
    \                if active[idx]:\n                    let oldLabel = labels[edge[1]]\n\
    \                    let newLabel = labels[edge[0]]\n                    for i\
    \ in 0..<n:\n                        if labels[i] == oldLabel: labels[i] = newLabel\n\
    \            solver.output(expected.len)\n            typedSolver.output(expected.len)\n\
    \            expected.add(labels)\n        else:\n            let idx = rng.rand(edges.high)\n\
    \            if active[idx]:\n                solver.remove(idx)\n           \
    \     typedSolver.remove(idx)\n            else:\n                solver.add(idx)\n\
    \                typedSolver.add(idx, edges[idx])\n            active[idx] = not\
    \ active[idx]\n    var uf = initRollbackUnionFind(n)\n    var answered = 0\n \
    \   proc apply(idx: int) = uf.unite(edges[idx][0], edges[idx][1])\n    proc rollback()\
    \ = uf.undo()\n    proc answer(idx: int) =\n        doAssert idx == answered\n\
    \        inc answered\n        for u in 0..<n:\n            for v in 0..<n:\n\
    \                doAssert uf.issame(u, v) == (expected[idx][u] == expected[idx][v])\n\
    \    solver.run(apply, rollback, answer)\n    doAssert answered == expected.len\n\
    \    doAssert uf.get_state == 0 and uf.count == n\n    answered = 0\n    proc\
    \ applyTyped(idx: int, edge: (int, int)) = uf.unite(edge[0], edge[1])\n    typedSolver.run(applyTyped,\
    \ rollback, answer)\n    doAssert answered == expected.len\n    doAssert uf.get_state\
    \ == 0 and uf.count == n\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/collections/rollback_unionfind.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/collections/rollback_unionfind.nim
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/offline_dynamic_queries.nim
  isVerificationFile: true
  path: verify/AI/offline_dynamic_queries_test.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/offline_dynamic_queries_test.nim
layout: document
redirect_from:
- /verify/verify/AI/offline_dynamic_queries_test.nim
- /verify/verify/AI/offline_dynamic_queries_test.nim.html
title: verify/AI/offline_dynamic_queries_test.nim
---
