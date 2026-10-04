---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/dsu_on_tree.nim
    title: cplib/tree/dsu_on_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/dsu_on_tree.nim
    title: cplib/tree/dsu_on_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
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
    import random, sequtils, macros\nimport cplib/utils/private/auto_rollback\nimport\
    \ cplib/utils/private/temporary_rollback_log\nimport cplib/tree/dsu_on_tree\n\
    import cplib/tree/heavylightdecomposition\nimport cplib/graph/graph\n\nproc testTree(g:\
    \ seq[seq[int]], root: int, colors: seq[int]) =\n    let n = g.len\n    var parent\
    \ = newSeqWith(n, -2)\n    parent[root] = -1\n    var order = @[root]\n    var\
    \ index = 0\n    while index < order.len:\n        let v = order[index]\n    \
    \    inc index\n        for u in g[v]:\n            if u != parent[v]:\n     \
    \           parent[u] = v\n                order.add(u)\n    var expected = newSeq[seq[int]](n)\n\
    \    for v in 0..<n:\n        expected[v] = newSeq[int](n)\n        var u = v\n\
    \        while u != -1:\n            expected[v][u] = 1\n            u = parent[u]\n\
    \    var counts: array[8, int]\n    var active = newSeq[int](n)\n    var colorKinds,\
    \ best, modeSum: int\n    var seen = newSeq[int](n)\n    proc increment(v: int)\
    \ =\n        let c = colors[v]\n        inc active[v]\n        if counts[c] ==\
    \ 0: inc colorKinds\n        inc counts[c]\n        if counts[c] > best:\n   \
    \         best = counts[c]\n            modeSum = c\n        elif counts[c] ==\
    \ best:\n            modeSum += c\n    proc add(v: int) = increment(v)\n    proc\
    \ answer(v: int) =\n        inc seen[v]\n        var expectedCounts: array[8,\
    \ int]\n        var expectedDistinct, expectedBest, expectedSum: int\n       \
    \ for u in 0..<n:\n            doAssert active[u] == expected[u][v]\n        \
    \    if expected[u][v] == 1: inc expectedCounts[colors[u]]\n        for c in 0..<8:\n\
    \            if expectedCounts[c] > 0: inc expectedDistinct\n            if expectedCounts[c]\
    \ > expectedBest:\n                expectedBest = expectedCounts[c]\n        \
    \        expectedSum = c\n            elif expectedCounts[c] == expectedBest:\n\
    \                expectedSum += c\n        doAssert counts == expectedCounts\n\
    \        doAssert (colorKinds, best, modeSum) == (expectedDistinct, expectedBest,\
    \ expectedSum)\n    proc checkEmpty() =\n        doAssert colorKinds == 0 and\
    \ best == 0 and modeSum == 0\n        for c in counts: doAssert c == 0\n     \
    \   for value in active: doAssert value == 0\n    for repeat in 0..<2:\n     \
    \   dsuOnTree(g, add, answer, root = root)\n        checkEmpty()\n    let hld\
    \ = initHld(g, root)\n    dsuOnTree(hld, add, answer)\n    checkEmpty()\n    var\
    \ clearCalls, addCalls: int\n    proc manualAdd(v: int) =\n        doAssert active[v]\
    \ == 0\n        inc addCalls\n        increment(v)\n    proc clearState(v: int)\
    \ =\n        doAssert active[v] == 1\n        dec active[v]\n        dec counts[colors[v]]\n\
    \        if counts[colors[v]] == 0: dec colorKinds\n        best = 0\n       \
    \ modeSum = 0\n        for c in 0..<counts.len:\n            if counts[c] > best:\n\
    \                best = counts[c]\n                modeSum = c\n            elif\
    \ counts[c] == best and best > 0:\n                modeSum += c\n        inc clearCalls\n\
    \    dsuOnTree(g, manualAdd, answer, clear = clearState, root = root)\n    checkEmpty()\n\
    \    doAssert clearCalls == addCalls\n    dsuOnTree(hld, manualAdd, answer, clear\
    \ = clearState)\n    checkEmpty()\n    doAssert clearCalls == addCalls\n    var\
    \ levels = 1\n    var size = n\n    while size > 1:\n        inc levels\n    \
    \    size = size div 2\n    doAssert addCalls <= 2 * n * levels\n    for count\
    \ in seen: doAssert count == 5\n\nvar rng = initRand(329001)\nfor n in [1, 2,\
    \ 3, 10, 31, 60]:\n    for shape in 0..<4:\n        var g = newSeq[seq[int]](n)\n\
    \        var colors = newSeq[int](n)\n        for v in 1..<n:\n            let\
    \ p = case shape\n                of 0: v - 1\n                of 1: 0\n     \
    \           of 2: (v - 1) div 2\n                else: rng.rand(v - 1)\n     \
    \       g[v].add(p)\n            g[p].add(v)\n        for v in 0..<n: colors[v]\
    \ = rng.rand(7)\n        for root in [0, n - 1, n div 2]: testTree(g, root, colors)\n\
    for trial in 0..<100:\n    let n = rng.rand(60) + 1\n    var g = newSeq[seq[int]](n)\n\
    \    var colors = newSeq[int](n)\n    for v in 1..<n:\n        let p = rng.rand(v\
    \ - 1)\n        g[v].add(p)\n        g[p].add(v)\n    for v in 0..<n: colors[v]\
    \ = rng.rand(7)\n    testTree(g, rng.rand(n - 1), colors)\n\nblock:\n    var graph\
    \ = initWeightedUnDirectedStaticGraph(3, int)\n    graph.add_edge(0, 1, 7)\n \
    \   graph.add_edge(1, 2, 9)\n    graph.build()\n    var total = 0\n    var answers\
    \ = newSeq[int](3)\n    proc add(v: int) = total += v + 1\n    proc answer(v:\
    \ int) = answers[v] = total\n    proc clearState(v: int) = total -= v + 1\n  \
    \  dsuOnTree(graph, add, answer)\n    doAssert answers == @[6, 5, 3] and total\
    \ == 0\n    dsuOnTree(graph, add, answer, clear = clearState, root = 2)\n    doAssert\
    \ answers == @[1, 3, 6] and total == 0\n    var dynamic = initUnWeightedUnDirectedGraph(3)\n\
    \    dynamic.add_edge(0, 1)\n    dynamic.add_edge(1, 2)\n    dsuOnTree(dynamic,\
    \ add, answer, root = 2)\n    doAssert answers == @[1, 3, 6] and total == 0\n\
    \    let children = [@[1], @[2], newSeq[int]()]\n    dsuOnTree(children, add,\
    \ answer, root = 1)\n    doAssert answers == @[1, 6, 3] and total == 0\n\nblock:\n\
    \    let g = @[@[1, 2], @[0], @[0]]\n    var value = 17\n    var answers = newSeq[int](3)\n\
    \    proc add(v: int) = value += v + 1\n    proc answer(v: int) = answers[v] =\
    \ value\n    dsuOnTree(g, add, answer)\n    doAssert value == 17 and answers ==\
    \ @[23, 19, 20]\n\nblock:\n    let g = @[@[1, 2], @[0], @[0]]\n    var values\
    \ = [1, 2]\n    var shouldFail = true\n    let failure = newException(ValueError,\
    \ \"test\")\n    proc add(v: int) =\n        values = [3, 4]\n        values[0]\
    \ = 5\n        if shouldFail: raise failure\n    proc answer(v: int) = raise failure\n\
    \    for repeat in 0..<3:\n        try:\n            dsuOnTree(g, add, answer)\n\
    \            doAssert false\n        except ValueError:\n            doAssert\
    \ values == [1, 2]\n        shouldFail = false\n\nblock:\n    let g = @[@[1],\
    \ @[0]]\n    var active: seq[int]\n    var clears = 0\n    proc add(v: int) =\
    \ active.add(v)\n    proc answer(v: int) = raise newException(ValueError, \"test\"\
    )\n    proc clearState(v: int) =\n        let index = active.find(v)\n       \
    \ doAssert index >= 0\n        active.delete(index)\n        inc clears\n    try:\n\
    \        dsuOnTree(g, add, answer, clear = clearState)\n        doAssert false\n\
    \    except ValueError:\n        doAssert active.len == 0 and clears == 1\n\n\
    block:\n    const n = 200000\n    var parent = newSeq[int](n)\n    for v in 0..<n:\
    \ parent[v] = v - 1\n    let hld = initHldFromParent(parent, 0)\n    var count,\
    \ seen: int\n    proc add(v: int) = inc count\n    proc answer(v: int) =\n   \
    \     doAssert count == n - v\n        inc seen\n    dsuOnTree(hld, add, answer)\n\
    \    doAssert count == 0 and seen == n\n    var removed = newSeq[bool](n)\n  \
    \  proc clearState(v: int) =\n        doAssert not removed[v]\n        removed[v]\
    \ = true\n        dec count\n    dsuOnTree(hld, add, answer, clear = clearState)\n\
    \    doAssert count == 0 and seen == 2 * n\n    for value in removed: doAssert\
    \ value\n\nblock:\n    let g = @[@[1, 2, 3], @[0], @[0], @[0]]\n    let hld =\
    \ initHld(g, 0)\n    var active: array[4, bool]\n    var calls, cleared: int\n\
    \    var failAt = 0\n    proc add(v: int) =\n        inc calls\n        if calls\
    \ == failAt: raise newException(ValueError, \"test\")\n        doAssert not active[v]\n\
    \        active[v] = true\n    proc answer(v: int) = discard\n    proc clearState(v:\
    \ int) =\n        doAssert active[v]\n        active[v] = false\n        inc cleared\n\
    \    dsuOnTree(hld, add, answer, clear = clearState)\n    let totalCalls = calls\n\
    \    for stop in 1..totalCalls:\n        calls = 0\n        cleared = 0\n    \
    \    failAt = stop\n        try:\n            dsuOnTree(hld, add, answer, clear\
    \ = clearState)\n            doAssert false\n        except ValueError:\n    \
    \        doAssert cleared == calls - 1\n            for value in active: doAssert\
    \ not value\n\nstatic:\n    doAssert not compiles(block:\n        var g = @[@[1],\
    \ @[0]]\n        var values: seq[int]\n        proc add(v: int) = values.add(v)\n\
    \        proc answer(v: int) = discard\n        dsuOnTree(g, add, answer)\n  \
    \  )\n\nmacro checkFirstWrites(update: proc(v: int)): untyped =\n    let history\
    \ = genSym(nskVar, \"history\")\n    let code = buildAutoRollback(update, history,\
    \ \"test\", temporaryMode = true)\n    let declarations = code.declarations\n\
    \    let call = newCall(code.transformed, history, newLit(0))\n    result = quote\
    \ do:\n        block:\n            var `history`: TemporaryRollbackLog\n     \
    \       `declarations`\n            for batch in 0..<3:\n                for repeat\
    \ in 0..<1000:\n                    `call`\n                doAssert `history`.len\
    \ == 2\n                `history`.restore(0)\n\nblock:\n    var values = @[4]\n\
    \    var maximum = 7\n    proc add(v: int) =\n        inc values[v]\n        maximum\
    \ = max(maximum, values[v])\n    checkFirstWrites(add)\n    doAssert values ==\
    \ @[4] and maximum == 7\n\nblock:\n    let g = @[@[1, 2], @[0], @[0]]\n    var\
    \ values = [7, 8, 9]\n    var seen = 0\n    proc add(v: int) =\n        values[1]\
    \ += v + 1\n        values = [4, 5, 6]\n        values[2] += 10\n    proc answer(v:\
    \ int) =\n        doAssert values == [4, 5, 16]\n        inc seen\n    dsuOnTree(g,\
    \ add, answer)\n    doAssert values == [7, 8, 9] and seen == 3\n\nblock:\n   \
    \ let g = @[@[1], @[0]]\n    var values = [7, 8, 9]\n    proc add(v: int) =\n\
    \        values = [4, 5, 6]\n        values[2] += v\n    proc answer(v: int) =\
    \ discard\n    dsuOnTree(g, add, answer)\n    doAssert values == [7, 8, 9]\n\n\
    proc testNested(n: int) =\n    var parent = newSeq[int](n)\n    for v in 0..<n:\
    \ parent[v] = v - 1\n    let hld = initHldFromParent(parent, 0)\n    var values\
    \ = newSeq[int](n)\n    var count, seen: int\n    proc add(v: int) =\n       \
    \ inc values[v]\n        inc count\n    proc answer(v: int) =\n        doAssert\
    \ count == n - v\n        for u in 0..<n: doAssert values[u] == int(u >= v)\n\
    \        inc seen\n        if v == 0 and n > 1:\n            testNested(n - 1)\n\
    \            doAssert count == n\n            for value in values: doAssert value\
    \ == 1\n    dsuOnTree(hld, add, answer)\n    doAssert count == 0 and seen == n\n\
    \    for value in values: doAssert value == 0\n\ntestNested(6)\n\nblock:\n   \
    \ var values: seq[int]\n    var prepared, answerCreated, seen: int\n    proc prepare():\
    \ HeavyLightDecomposition =\n        inc prepared\n        values = newSeq[int](3)\n\
    \        initHldFromParent(@[-1, 0, 0], 0)\n    proc makeAnswer(): proc(v: int)\
    \ =\n        inc answerCreated\n        values = newSeq[int](3)\n        result\
    \ = proc(v: int) =\n            doAssert values[v] == 1\n            inc seen\n\
    \    proc add(v: int) = inc values[v]\n    dsuOnTree(prepare(), add, makeAnswer())\n\
    \    doAssert prepared == 1 and answerCreated == 1 and seen == 3\n    doAssert\
    \ values == @[0, 0, 0]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/private/auto_rollback.nim
  - cplib/graph/graph.nim
  - cplib/tree/dsu_on_tree.nim
  - cplib/graph/graph.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/tree/dsu_on_tree.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: true
  path: verify/AI/dsu_on_tree_test.nim
  requiredBy: []
  timestamp: '2026-09-30 05:10:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dsu_on_tree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dsu_on_tree_test.nim
- /verify/verify/AI/dsu_on_tree_test.nim.html
title: verify/AI/dsu_on_tree_test.nim
---
