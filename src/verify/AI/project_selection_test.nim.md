---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/project_selection.nim
    title: cplib/utils/project_selection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/project_selection.nim
    title: cplib/utils/project_selection.nim
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
    import cplib/utils/project_selection\nimport random\n\nblock:\n    var opt = initProjectSelection(0)\n\
    \    doAssert opt is ProjectSelection[int]\n    doAssert opt.solve().feasible\n\
    \    opt.add_gain_if_all([], false, 7)\n    let ans = opt.solve()\n    doAssert\
    \ ans.feasible and ans.min_cost == -7 and ans.assignment.len == 0\n\nblock:\n\
    \    var opt = initProjectSelection(3, int64)\n    doAssert opt is ProjectSelection[int64]\n\
    \    opt.add_gain(0, true, 100)\n    opt.add_cost(0, true, 30)\n    opt.imply(0,\
    \ 1)\n    opt.add_cost_if_different(1, 2, 20)\n    opt.add_gain_if_all(@[0, 1,\
    \ 2], true, 50)\n    let ans = opt.solve()\n    doAssert ans.feasible and ans.min_cost\
    \ == -120\n    doAssert ans.assignment == @[true, true, true]\n    doAssert opt.solve()\
    \ == ans\n    opt.force(2, false)\n    doAssert opt.solve().min_cost == -50\n\
    \    opt.force(0, true)\n    opt.force(1, false)\n    doAssert not opt.solve().feasible\n\
    \nblock:\n    var opt = initProjectSelection(1, int32)\n    opt.add_pair_cost(0,\
    \ 0, -4, low(int32), high(int32), -2)\n    opt.imply(0, 0)\n    opt.equal(0, 0)\n\
    \    opt.add_cost_if_true_false(0, 0, 100)\n    opt.add_cost_if_different(0, 0,\
    \ 100)\n    doAssert opt.solve().min_cost == -4\n\nfor value in [false, true]:\n\
    \    for mask in 0..<4:\n        var opt = initProjectSelection(2, int64)\n  \
    \      opt.add_gain_if_all([0, 1], value, 7)\n        opt.add_gain_if_all([0],\
    \ value, 3)\n        opt.add_gain_if_all([1, 1], value, 5)\n        let x0 = (mask\
    \ and 1) != 0\n        let x1 = (mask and 2) != 0\n        opt.force(0, x0)\n\
    \        opt.force(1, x1)\n        var expected = 0'i64\n        if x0 == value\
    \ and x1 == value: expected -= 7\n        if x0 == value: expected -= 3\n    \
    \    if x1 == value: expected -= 5\n        let ans = opt.solve()\n        doAssert\
    \ ans.feasible and ans.min_cost == expected\n        doAssert ans.assignment ==\
    \ @[x0, x1]\n\nvar rng = initRand(472193)\nfor trial in 0..<1000:\n    let n =\
    \ rng.rand(1..7)\n    var opt = initProjectSelection(n, int64)\n    var costs\
    \ = newSeq[int64](1 shl n)\n    var allowed = newSeq[bool](1 shl n)\n    for mask\
    \ in 0..<allowed.len: allowed[mask] = true\n    for step in 0..<35:\n        let\
    \ kind = rng.rand(0..(if trial mod 2 == 0: 6 else: 9))\n        let i = rng.rand(n\
    \ - 1)\n        let j = rng.rand(n - 1)\n        let value = rng.rand(1) == 1\n\
    \        let w = int64(rng.rand((if kind in {1, 2}: -30 else: 0)..30))\n     \
    \   var c: array[4, int64]\n        var ids: seq[int]\n        case kind\n   \
    \     of 0:\n            c[0] = int64(rng.rand(-30..30))\n            c[1] = int64(rng.rand(-30..30))\n\
    \            opt.add_unary_cost(i, c[0], c[1])\n        of 1: opt.add_cost(i,\
    \ value, w)\n        of 2: opt.add_gain(i, value, w)\n        of 3: opt.add_cost_if_true_false(i,\
    \ j, w)\n        of 4: opt.add_cost_if_different(i, j, w)\n        of 5:\n   \
    \         c[0] = int64(rng.rand(-30..30))\n            c[1] = int64(rng.rand(-30..30))\n\
    \            c[2] = int64(rng.rand(-30..30))\n            c[3] = c[1] + c[2] -\
    \ c[0] - w\n            opt.add_pair_cost(i, j, c[0], c[1], c[2], c[3])\n    \
    \    of 6:\n            for k in 0..<rng.rand(0..n + 2): ids.add(rng.rand(n -\
    \ 1))\n            opt.add_gain_if_all(ids, value, w)\n        of 7: opt.force(i,\
    \ value)\n        of 8: opt.imply(i, j)\n        else: opt.equal(i, j)\n     \
    \   for mask in 0..<costs.len:\n            let xi = (mask and (1 shl i)) != 0\n\
    \            let xj = (mask and (1 shl j)) != 0\n            case kind\n     \
    \       of 0: costs[mask] += c[ord(xi)]\n            of 1:\n                if\
    \ xi == value: costs[mask] += w\n            of 2:\n                if xi == value:\
    \ costs[mask] -= w\n            of 3:\n                if xi and not xj: costs[mask]\
    \ += w\n            of 4:\n                if xi != xj: costs[mask] += w\n   \
    \         of 5: costs[mask] += c[2 * ord(xi) + ord(xj)]\n            of 6:\n \
    \               var allMatch = true\n                for k in ids:\n         \
    \           if ((mask and (1 shl k)) != 0) != value: allMatch = false\n      \
    \          if allMatch: costs[mask] -= w\n            of 7: allowed[mask] = allowed[mask]\
    \ and xi == value\n            of 8: allowed[mask] = allowed[mask] and (not xi\
    \ or xj)\n            else: allowed[mask] = allowed[mask] and xi == xj\n     \
    \   if step mod 7 == 0 or step == 34:\n            var best = high(int64)\n  \
    \          for mask in 0..<costs.len:\n                if allowed[mask]: best\
    \ = min(best, costs[mask])\n            let ans = opt.solve()\n            doAssert\
    \ ans.feasible == (best != high(int64))\n            if ans.feasible:\n      \
    \          doAssert ans.min_cost == best\n                doAssert ans.assignment.len\
    \ == n\n                var mask = 0\n                for k, v in ans.assignment:\n\
    \                    if v: mask = mask or (1 shl k)\n                doAssert\
    \ allowed[mask] and costs[mask] == best\n            doAssert opt.solve() == ans\n\
    \ntemplate expectError(errorType: typedesc, body: untyped) =\n    block:\n   \
    \     var caught = false\n        try: body\n        except errorType: caught\
    \ = true\n        doAssert caught\n\nblock:\n    expectError(ValueError): discard\
    \ initProjectSelection(-1, int)\n    var opt = initProjectSelection(2, int64)\n\
    \    expectError(ValueError): opt.add_cost(-1, true, 1)\n    expectError(ValueError):\
    \ opt.force(2, false)\n    expectError(OverflowDefect): opt.add_gain(0, true,\
    \ low(int64))\n    expectError(ValueError): opt.add_cost_if_different(0, 1, -1)\n\
    \    expectError(ValueError): opt.add_gain_if_all([0, 2], true, 5)\n    expectError(ValueError):\
    \ opt.add_pair_cost(0, 1, 0, 0, 0, 1)\n    doAssert opt.solve().min_cost == 0\n\
    \nblock:\n    var opt = initProjectSelection(1, int64)\n    opt.add_unary_cost(0,\
    \ low(int64), low(int64))\n    doAssert opt.solve().min_cost == low(int64)\n \
    \   opt.add_gain(0, false, 1)\n    expectError(OverflowDefect): discard opt.solve()\n\
    \nblock:\n    var opt = initProjectSelection(1, int64)\n    opt.add_unary_cost(0,\
    \ low(int64), high(int64))\n    expectError(OverflowDefect): discard opt.solve()\n\
    \nblock:\n    var opt = initProjectSelection(1, int64)\n    opt.add_cost(0, true,\
    \ high(int64))\n    doAssert opt.solve().min_cost == 0\n    opt.force(0, true)\n\
    \    expectError(OverflowDefect): discard opt.solve()\n\nblock:\n    var opt =\
    \ initProjectSelection(2, int64)\n    opt.add_cost(0, true, high(int64))\n   \
    \ opt.add_cost(1, true, 1)\n    expectError(OverflowDefect): discard opt.solve()\n\
    \nblock:\n    var opt = initProjectSelection(1, int64)\n    opt.add_unary_cost(0,\
    \ high(int64), high(int64))\n    opt.add_cost(0, true, 1)\n    opt.force(0, true)\n\
    \    expectError(OverflowDefect): discard opt.solve()\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/project_selection.nim
  - cplib/graph/maxflow.nim
  - cplib/graph/maxflow.nim
  - cplib/utils/project_selection.nim
  isVerificationFile: true
  path: verify/AI/project_selection_test.nim
  requiredBy: []
  timestamp: '2026-09-14 12:19:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/project_selection_test.nim
layout: document
redirect_from:
- /verify/verify/AI/project_selection_test.nim
- /verify/verify/AI/project_selection_test.nim.html
title: verify/AI/project_selection_test.nim
---
