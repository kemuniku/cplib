---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/unionfind
    links:
    - https://judge.yosupo.jp/problem/unionfind
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind\n\
    import cplib/collections/ppunionfind\nimport algorithm\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N,Q = ii()\nvar UF = initPartialPersistentUnionFind(N)\n\
    for i in 0..<Q:\n    var t,u,v = ii()\n    if t == 0:\n        UF.unite(u,v)\n\
    \    else:\n        echo if UF.issame(u,v): 1 else: 0"
  dependsOn:
  - cplib/collections/ppunionfind.nim
  - cplib/collections/ppunionfind.nim
  isVerificationFile: true
  path: verify/collections/ppunionfind/yosupo_unionfind_test.nim
  requiredBy: []
  timestamp: '2025-02-26 01:40:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/ppunionfind/yosupo_unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/collections/ppunionfind/yosupo_unionfind_test.nim
- /verify/verify/collections/ppunionfind/yosupo_unionfind_test.nim.html
title: verify/collections/ppunionfind/yosupo_unionfind_test.nim
---
