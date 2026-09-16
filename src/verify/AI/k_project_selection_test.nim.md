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
    path: cplib/utils/k_project_selection.nim
    title: cplib/utils/k_project_selection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/k_project_selection.nim
    title: cplib/utils/k_project_selection.nim
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
    import cplib/utils/k_project_selection\nimport random\n\nblock:\n    var opt =\
    \ initKProjectSelection([], int64)\n    opt.add_gain_if_all_ge([], 7)\n    opt.add_gain_if_all_le([],\
    \ 3)\n    let ans = opt.solve()\n    doAssert ans.feasible and ans.min_cost ==\
    \ -10 and ans.assignment.len == 0\n\nblock:\n    var opt = initKProjectSelection(2,\
    \ 3)\n    doAssert opt is KProjectSelection[int]\n    opt.add_unary_cost(0, [0,\
    \ 3, 8])\n    opt.add_unary_cost(1, [0, 4, 9])\n    opt.add_gain_if_all_ge([(0,\
    \ 2), (1, 1)], 20)\n    let ans = opt.solve()\n    doAssert ans.feasible and ans.min_cost\
    \ == -8 and ans.assignment == @[2, 1]\n    doAssert opt.solve() == ans\n    opt.set_max(0,\
    \ 1)\n    doAssert opt.solve().min_cost == 0\n    opt.force(0, 2)\n    doAssert\
    \ not opt.solve().feasible\n\nblock:\n    var opt = initKProjectSelection([1,\
    \ 3], int32)\n    doAssert opt is KProjectSelection[int32]\n    opt.add_pair_cost(0,\
    \ 1, @[@[4'i32, -3, 2]])\n    opt.add_pair_cost(1, 1, @[@[1'i32, -999, 999], @[999'i32,\
    \ -5, -999], @[-999'i32, 999, 1]])\n    doAssert opt.solve().assignment == @[0,\
    \ 1]\n    doAssert opt.solve().min_cost == -8\n\nvar rng = initRand(967231)\n\
    for trial in 0..<600:\n    let n = rng.rand(1..4)\n    var sizes = newSeq[int](n)\n\
    \    var count = 1\n    for i in 0..<n:\n        sizes[i] = rng.rand(1..4)\n \
    \       count *= sizes[i]\n    var assignments = newSeq[seq[int]](count)\n   \
    \ for mask in 0..<count:\n        var x = mask\n        assignments[mask] = newSeq[int](n)\n\
    \        for i in 0..<n:\n            assignments[mask][i] = x mod sizes[i]\n\
    \            x = x div sizes[i]\n    var scores = newSeq[int64](count)\n    var\
    \ allowed = newSeq[bool](count)\n    for v in allowed.mitems: v = true\n    var\
    \ opt = initKProjectSelection(sizes, int64)\n    for step in 0..<25:\n       \
    \ let kind = rng.rand(0..(if trial mod 2 == 0: 6 else: 10))\n        let i = rng.rand(n\
    \ - 1)\n        let j = rng.rand(n - 1)\n        let value = rng.rand(sizes[i]\
    \ - 1)\n        let lowerI = rng.rand(sizes[i])\n        let lowerJ = rng.rand(sizes[j])\n\
    \        let w = int64(rng.rand((if kind in {1, 2}: -15 else: 0)..15))\n     \
    \   var unary = newSeq[int64](sizes[i])\n        var pair: seq[seq[int64]]\n \
    \       var conditions: seq[tuple[variable, threshold: int]]\n        case kind\n\
    \        of 0:\n            for c in unary.mitems: c = int64(rng.rand(-15..15))\n\
    \            opt.add_unary_cost(i, unary)\n        of 1: opt.add_cost(i, value,\
    \ w)\n        of 2: opt.add_gain(i, value, w)\n        of 3:\n            pair\
    \ = newSeq[seq[int64]](sizes[i])\n            for a in 0..<sizes[i]:\n       \
    \         pair[a] = newSeq[int64](sizes[j])\n                pair[a][0] = int64(rng.rand(-15..15))\n\
    \            for b in 1..<sizes[j]: pair[0][b] = int64(rng.rand(-15..15))\n  \
    \          for a in 1..<sizes[i]:\n                for b in 1..<sizes[j]:\n  \
    \                  pair[a][b] = pair[a - 1][b] + pair[a][b - 1] - pair[a - 1][b\
    \ - 1] - int64(rng.rand(0..8))\n            opt.add_pair_cost(i, j, pair)\n  \
    \      of 4: opt.add_cost_if_ge_lt(i, lowerI, j, lowerJ, w)\n        of 5, 6:\n\
    \            for c in 0..<rng.rand(0..n + 2):\n                let v = rng.rand(n\
    \ - 1)\n                let t = rng.rand(sizes[v]) - (if kind == 6: 1 else: 0)\n\
    \                conditions.add((v, t))\n            if kind == 5: opt.add_gain_if_all_ge(conditions,\
    \ w)\n            else: opt.add_gain_if_all_le(conditions, w)\n        of 7: opt.set_min(i,\
    \ lowerI)\n        of 8: opt.set_max(i, lowerI - 1)\n        of 9: opt.force(i,\
    \ value)\n        else: opt.imply(i, lowerI, j, lowerJ)\n        for mask, x in\
    \ assignments:\n            case kind\n            of 0: scores[mask] += unary[x[i]]\n\
    \            of 1:\n                if x[i] == value: scores[mask] += w\n    \
    \        of 2:\n                if x[i] == value: scores[mask] -= w\n        \
    \    of 3: scores[mask] += pair[x[i]][x[j]]\n            of 4:\n             \
    \   if x[i] >= lowerI and x[j] < lowerJ: scores[mask] += w\n            of 5,\
    \ 6:\n                var matches = true\n                for c in conditions:\n\
    \                    if kind == 5 and x[c.variable] < c.threshold: matches = false\n\
    \                    if kind == 6 and x[c.variable] > c.threshold: matches = false\n\
    \                if matches: scores[mask] -= w\n            of 7: allowed[mask]\
    \ = allowed[mask] and x[i] >= lowerI\n            of 8: allowed[mask] = allowed[mask]\
    \ and x[i] < lowerI\n            of 9: allowed[mask] = allowed[mask] and x[i]\
    \ == value\n            else: allowed[mask] = allowed[mask] and (x[i] < lowerI\
    \ or x[j] >= lowerJ)\n        if step mod 5 == 0 or step == 24:\n            var\
    \ best = high(int64)\n            for mask in 0..<count:\n                if allowed[mask]:\
    \ best = min(best, scores[mask])\n            let ans = opt.solve()\n        \
    \    doAssert ans.feasible == (best != high(int64))\n            if ans.feasible:\n\
    \                doAssert ans.min_cost == best\n                doAssert ans.assignment.len\
    \ == n\n                var mask = 0\n                var multiplier = 1\n   \
    \             for v in 0..<n:\n                    doAssert ans.assignment[v]\
    \ in 0..<sizes[v]\n                    mask += ans.assignment[v] * multiplier\n\
    \                    multiplier *= sizes[v]\n                doAssert allowed[mask]\
    \ and scores[mask] == best\n            doAssert opt.solve() == ans\n\ntemplate\
    \ expectError(errorType: typedesc, body: untyped) =\n    block:\n        var caught\
    \ = false\n        try: body\n        except errorType: caught = true\n      \
    \  doAssert caught\n\nblock:\n    expectError(ValueError): discard initKProjectSelection([0])\n\
    \    expectError(ValueError): discard initKProjectSelection(-1, 2)\n    expectError(ValueError):\
    \ discard initKProjectSelection(0, 0)\n    var opt = initKProjectSelection([2,\
    \ 3], int64)\n    expectError(ValueError): opt.add_unary_cost(0, [1'i64])\n  \
    \  expectError(ValueError): opt.add_cost(0, 2, 1)\n    expectError(OverflowDefect):\
    \ opt.add_gain(0, 1, low(int64))\n    expectError(ValueError): opt.add_pair_cost(0,\
    \ 1, @[@[0'i64, 0, 0]])\n    expectError(ValueError): opt.add_pair_cost(0, 1,\
    \ @[@[0'i64, 0, 0], @[0'i64, 0]])\n    expectError(ValueError): opt.add_pair_cost(0,\
    \ 1, @[@[0'i64, 0, 0], @[0'i64, 0, 1]])\n    expectError(ValueError): opt.set_min(0,\
    \ -1)\n    expectError(ValueError): opt.set_min(0, 3)\n    expectError(ValueError):\
    \ opt.set_max(0, -2)\n    expectError(ValueError): opt.set_max(0, 2)\n    expectError(ValueError):\
    \ opt.force(2, 0)\n    expectError(ValueError): opt.add_gain_if_all_ge([(0, 1),\
    \ (1, 4)], 7)\n    expectError(ValueError): opt.add_gain_if_all_le([(0, 1)], -1)\n\
    \    expectError(OverflowDefect): opt.add_unary_cost(0, [low(int64), high(int64)])\n\
    \    expectError(OverflowDefect): opt.add_pair_cost(0, 1, @[@[low(int64), high(int64),\
    \ 0], @[0'i64, 0, 0]])\n    doAssert opt.solve().feasible and opt.solve().min_cost\
    \ == 0\n\nblock:\n    var opt = initKProjectSelection([1], int64)\n    opt.add_unary_cost(0,\
    \ [low(int64)])\n    doAssert opt.solve().min_cost == low(int64)\n    opt.add_gain(0,\
    \ 0, 1)\n    expectError(OverflowDefect): discard opt.solve()\n\nblock:\n    var\
    \ opt = initKProjectSelection([2], int64)\n    opt.add_cost(0, 1, high(int64))\n\
    \    expectError(OverflowDefect): discard opt.solve()\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/maxflow.nim
  - cplib/utils/project_selection.nim
  - cplib/utils/project_selection.nim
  - cplib/utils/k_project_selection.nim
  - cplib/graph/maxflow.nim
  - cplib/utils/k_project_selection.nim
  isVerificationFile: true
  path: verify/AI/k_project_selection_test.nim
  requiredBy: []
  timestamp: '2026-09-14 12:19:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/k_project_selection_test.nim
layout: document
redirect_from:
- /verify/verify/AI/k_project_selection_test.nim
- /verify/verify/AI/k_project_selection_test.nim.html
title: verify/AI/k_project_selection_test.nim
---
