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
    - https://atcoder.jp/contests/abc326/tasks/abc326_g
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    # https://atcoder.jp/contests/abc326/tasks/abc326_g\nimport cplib/utils/k_project_selection\n\
    import strutils, sequtils, streams, random\n\nproc solve(input: Stream): int64\
    \ =\n    let nm = input.readLine.split.map(parseInt)\n    let n = nm[0]\n    let\
    \ m = nm[1]\n    let c = input.readLine.split.map(parseBiggestInt)\n    let a\
    \ = input.readLine.split.map(parseBiggestInt)\n    var opt = initKProjectSelection(n,\
    \ 5, int64)\n    for i in 0..<n:\n        var costs = newSeq[int64](5)\n     \
    \   for level in 0..<5: costs[level] = int64(level) * c[i]\n        opt.add_unary_cost(i,\
    \ costs)\n    for i in 0..<m:\n        let levels = input.readLine.split.map(parseInt)\n\
    \        var conditions: seq[tuple[variable, threshold: int]]\n        for j in\
    \ 0..<n: conditions.add((j, levels[j] - 1))\n        opt.add_gain_if_all_ge(conditions,\
    \ a[i])\n    return -opt.solve().min_cost\n\nproc solveText(text: string): int64\
    \ =\n    let input = newStringStream(text)\n    defer: input.close()\n    return\
    \ solve(input)\n\nproc brute(c, a: seq[int64], levels: seq[seq[int]]): int64 =\n\
    \    var count = 1\n    for _ in c: count *= 5\n    for mask in 0..<count:\n \
    \       var code = mask\n        var chosen = newSeq[int](c.len)\n        var\
    \ profit = 0'i64\n        for j in 0..<c.len:\n            chosen[j] = code mod\
    \ 5 + 1\n            code = code div 5\n            profit -= int64(chosen[j]\
    \ - 1) * c[j]\n        for i in 0..<a.len:\n            var achieved = true\n\
    \            for j in 0..<c.len:\n                if chosen[j] < levels[i][j]:\
    \ achieved = false\n            if achieved: profit += a[i]\n        result =\
    \ max(result, profit)\n\nproc encode(c, a: seq[int64], levels: seq[seq[int]]):\
    \ string =\n    result = $c.len & \" \" & $a.len & \"\\n\" & c.join(\" \") & \"\
    \\n\" & a.join(\" \") & \"\\n\"\n    for row in levels: result.add(row.join(\"\
    \ \") & \"\\n\")\n\nwhen defined(abc326gStandalone):\n    echo solve(newFileStream(stdin))\n\
    else:\n    doAssert solveText(\"2 2\\n10 20\\n100 50\\n3 1\\n1 4\\n\") == 80\n\
    \    doAssert solveText(\"2 2\\n10 20\\n100 50\\n3 2\\n1 4\\n\") == 70\n    doAssert\
    \ solveText(\"\"\"10 10\n10922 23173 32300 22555 29525 16786 3135 17046 11245\
    \ 20310\n177874 168698 202247 31339 10336 14825 56835 6497 12440 110702\n2 1 4\
    \ 1 3 4 4 5 1 4\n2 3 4 4 5 3 5 5 2 3\n2 3 5 1 4 2 2 2 2 5\n3 5 5 3 5 2 2 1 5 4\n\
    3 1 1 4 4 1 1 5 3 1\n1 2 3 2 4 2 4 3 3 1\n4 4 4 2 5 1 4 2 2 2\n5 3 1 2 3 4 2 5\
    \ 2 2\n5 4 3 4 3 1 5 1 5 4\n2 3 2 5 2 3 1 2 2 4\n\"\"\") == 66900\n    var rng\
    \ = initRand(326823)\n    for trial in 0..<200:\n        let n = rng.rand(1..5)\n\
    \        let m = rng.rand(1..8)\n        let c = newSeqWith(n, int64(rng.rand(1..100)))\n\
    \        let a = newSeqWith(m, int64(rng.rand(1..1000)))\n        let levels =\
    \ newSeqWith(m, newSeqWith(n, rng.rand(1..5)))\n        doAssert solveText(encode(c,\
    \ a, levels)) == brute(c, a, levels)\n    let cheap = newSeqWith(50, 1'i64)\n\
    \    let expensive = newSeqWith(50, 1000000'i64)\n    let highest = newSeqWith(50,\
    \ newSeqWith(50, 5))\n    let lowest = newSeqWith(50, newSeqWith(50, 1))\n   \
    \ doAssert solveText(encode(cheap, expensive, highest)) == 50000000 - 200\n  \
    \  doAssert solveText(encode(expensive, cheap, highest)) == 0\n    doAssert solveText(encode(expensive,\
    \ expensive, lowest)) == 50000000\n    echo \"Hello World\"\n"
  dependsOn:
  - cplib/graph/maxflow.nim
  - cplib/utils/k_project_selection.nim
  - cplib/utils/k_project_selection.nim
  - cplib/utils/project_selection.nim
  - cplib/graph/maxflow.nim
  - cplib/utils/project_selection.nim
  isVerificationFile: true
  path: verify/utils/k_project_selection_abc326g_test.nim
  requiredBy: []
  timestamp: '2026-09-14 17:53:26+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/k_project_selection_abc326g_test.nim
layout: document
redirect_from:
- /verify/verify/utils/k_project_selection_abc326g_test.nim
- /verify/verify/utils/k_project_selection_abc326g_test.nim.html
title: verify/utils/k_project_selection_abc326g_test.nim
---
