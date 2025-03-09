---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/nearest_equiv.nim
    title: cplib/math/nearest_equiv.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/nearest_equiv.nim
    title: cplib/math/nearest_equiv.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc342/tasks/abc342_e
    links:
    - https://atcoder.jp/contests/abc342/tasks/abc342_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc342/tasks/abc342_e\n\
    import sequtils, heapqueue\nimport cplib/math/nearest_equiv\nimport cplib/graph/graph\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar n, m = ii()\nvar g = initWeightedDirectedStaticGraph(n,\
    \ (int, int, int, int), m)\nfor i in 0..<m:\n    var l, d, k, c = ii()\n    var\
    \ a, b = ii() - 1\n    g.add_edge(b, a, (l, d, k, c))\ng.build\n\nvar inf = int(3003003003003003003)\n\
    var dp = newSeqWith(n, -inf)\nvar q = initHeapQueue[(int, int)]()\nq.push((-inf,\
    \ n-1))\ndp[n-1] = inf\n\nwhile q.len > 0:\n    var (t, x) = q.pop\n    t = -t\n\
    \    # echo t, \" \", x\n    if t != dp[x]: continue\n    for (y, cost) in g[x]:\n\
    \        var (l, d, k, c) = cost\n        var nt = nearest_equiv(l, t - c + 1,\
    \ d) - d\n        if nt < l: continue\n        if nt >= l + k * d: nt = l + (k\
    \ - 1) * d\n        if dp[y] > nt: continue\n        dp[y] = nt\n        q.push((-nt,\
    \ y))\n\nfor i in 0..<n-1:\n    if dp[i] == -inf: echo \"Unreachable\"\n    else:\
    \ echo dp[i]\n"
  dependsOn:
  - cplib/math/nearest_equiv.nim
  - cplib/graph/graph.nim
  - cplib/math/nearest_equiv.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/math/nearear_equiv_abc342e_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/nearear_equiv_abc342e_test.nim
layout: document
redirect_from:
- /verify/verify/math/nearear_equiv_abc342e_test.nim
- /verify/verify/math/nearear_equiv_abc342e_test.nim.html
title: verify/math/nearear_equiv_abc342e_test.nim
---
