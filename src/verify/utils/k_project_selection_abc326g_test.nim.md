---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':question:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':question:'
    path: cplib/utils/k_project_selection.nim
    title: cplib/utils/k_project_selection.nim
  - icon: ':question:'
    path: cplib/utils/k_project_selection.nim
    title: cplib/utils/k_project_selection.nim
  - icon: ':question:'
    path: cplib/utils/project_selection.nim
    title: cplib/utils/project_selection.nim
  - icon: ':question:'
    path: cplib/utils/project_selection.nim
    title: cplib/utils/project_selection.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc326/tasks/abc326_g
    links:
    - https://atcoder.jp/contests/abc326/tasks/abc326_g
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc326/tasks/abc326_g\n\
    import cplib/utils/k_project_selection\nimport strutils, sequtils\n\nlet nm =\
    \ stdin.readLine.split.map(parseInt)\nlet n = nm[0]\nlet m = nm[1]\nlet c = stdin.readLine.split.map(parseBiggestInt)\n\
    let a = stdin.readLine.split.map(parseBiggestInt)\nvar opt = initKProjectSelection(n,\
    \ 5, int64)\nfor i in 0..<n:\n    var costs = newSeq[int64](5)\n    for level\
    \ in 0..<5: costs[level] = int64(level) * c[i]\n    opt.add_unary_cost(i, costs)\n\
    for i in 0..<m:\n    let levels = stdin.readLine.split.map(parseInt)\n    var\
    \ conditions: seq[tuple[variable, threshold: int]]\n    for j in 0..<n: conditions.add((j,\
    \ levels[j] - 1))\n    opt.add_gain_if_all_ge(conditions, a[i])\necho -opt.solve().min_cost\n"
  dependsOn:
  - cplib/graph/maxflow.nim
  - cplib/utils/k_project_selection.nim
  - cplib/utils/project_selection.nim
  - cplib/utils/project_selection.nim
  - cplib/utils/k_project_selection.nim
  - cplib/graph/maxflow.nim
  isVerificationFile: true
  path: verify/utils/k_project_selection_abc326g_test.nim
  requiredBy: []
  timestamp: '2026-09-14 12:19:06+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/utils/k_project_selection_abc326g_test.nim
layout: document
redirect_from:
- /verify/verify/utils/k_project_selection_abc326g_test.nim
- /verify/verify/utils/k_project_selection_abc326g_test.nim.html
title: verify/utils/k_project_selection_abc326g_test.nim
---
