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
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc221/tasks/abc221_f
    links:
    - https://atcoder.jp/contests/abc221/tasks/abc221_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc221/tasks/abc221_f\n\
    import sequtils, math\nimport cplib/tree/tree\nimport cplib/tree/diameter\nimport\
    \ cplib/modint/modint\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\",\
    \ varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\ntype\
    \ mint = modint998244353_montgomery\n\nvar n = ii()\nvar g = initUnWeightedStaticTree(n)\n\
    for i in 0..<n-1:\n    var u, v = ii() - 1\n    g.add_edge(u, v)\ng.build\n\n\
    var (d, path) = g.diameter_path\nif d mod 2 == 0:\n    var center = path[d div\
    \ 2]\n    var cnt = 0\n    proc find_leaf(x, par, di: int) =\n        if di ==\
    \ d div 2 - 1: cnt += 1\n        for y in g[x]:\n            if y == par: continue\n\
    \            find_leaf(y, x, di+1)\n    var t = newSeq[mint]()\n    for x in g[center]:\n\
    \        cnt = 0\n        find_leaf(x, center, 0)\n        t.add(mint(cnt + 1))\n\
    \    echo (t.foldl(a * b) - t.sum + t.len - 1)\nelse:\n    var c1 = path[d div\
    \ 2]\n    var c2 = path[(d+1) div 2]\n    proc find_leaf(x, par, di: int): int\
    \ =\n        if di == d div 2: result += 1\n        for y in g[x]:\n         \
    \   if y == par: continue\n            result += find_leaf(y, x, di+1)\n    var\
    \ ch1 = find_leaf(c1, c2, 0)\n    var ch2 = find_leaf(c2, c1, 0)\n    echo (mint(ch1)\
    \ * mint(ch2))\n"
  dependsOn:
  - cplib/tree/diameter.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/tree/tree.nim
  - cplib/math/isqrt.nim
  - cplib/tree/tree.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/diameter.nim
  isVerificationFile: true
  path: verify/tree/diameter_path_static_test.nim
  requiredBy: []
  timestamp: '2024-07-08 10:27:10+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/diameter_path_static_test.nim
layout: document
redirect_from:
- /verify/verify/tree/diameter_path_static_test.nim
- /verify/verify/tree/diameter_path_static_test.nim.html
title: verify/tree/diameter_path_static_test.nim
---
