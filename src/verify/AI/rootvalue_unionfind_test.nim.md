---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rootvalue_unionfind.nim
    title: cplib/collections/rootvalue_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rootvalue_unionfind.nim
    title: cplib/collections/rootvalue_unionfind.nim
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
    echo \"Hello World\"\n\nimport cplib/collections/rootvalue_unionfind\n\nproc merge(x,\
    \ y: var int) =\n  x += y\n\nlet uf0 = initRootValueUnionFind(3, merge, 1)\nassert\
    \ uf0.count == 3\nassert uf0.siz(0) == 1\nassert uf0.get(0) == 1\nuf0.unite(0,\
    \ 1)\nassert uf0.issame(0, 1)\nassert uf0.siz(1) == 2\nassert uf0.get(0) == 2\n\
    uf0.set(1, 7)\nassert uf0.get(0) == 7\n\nproc defaultValue(): int = 2\nlet uf1\
    \ = initRootValueUnionFind(2, merge, defaultValue)\nassert uf1.get(0) == 2\nlet\
    \ uf2 = initRootValueUnionFind(2, merge, @[3, 4])\nuf2.unite(0, 1)\nassert uf2.get(0)\
    \ == 7\n"
  dependsOn:
  - cplib/collections/rootvalue_unionfind.nim
  - cplib/collections/rootvalue_unionfind.nim
  isVerificationFile: true
  path: verify/AI/rootvalue_unionfind_test.nim
  requiredBy: []
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/rootvalue_unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/AI/rootvalue_unionfind_test.nim
- /verify/verify/AI/rootvalue_unionfind_test.nim.html
title: verify/AI/rootvalue_unionfind_test.nim
---
