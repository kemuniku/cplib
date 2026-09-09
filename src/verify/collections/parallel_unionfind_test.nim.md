---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/parallel_unionfind.nim
    title: cplib/collections/parallel_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/parallel_unionfind.nim
    title: cplib/collections/parallel_unionfind.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/range_parallel_unionfind
    links:
    - https://judge.yosupo.jp/problem/range_parallel_unionfind
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_parallel_unionfind\n\
    import cplib/collections/parallel_unionfind\n\nproc scanf(formatstr: cstring)\
    \ {.header: \"<stdio.h>\", varargs.}\nproc ii(): int = scanf(\"%lld\", addr result)\n\
    \nlet n = ii()\nlet q = ii()\nconst modulus = 998244353\nvar values = newSeq[int](n)\n\
    for i in 0..<n: values[i] = ii()\nlet uf = initParallelUnionFind(n)\nvar answer\
    \ = 0\nproc onMerge(x, y: int) =\n    answer = (answer + values[x] * values[y])\
    \ mod modulus\n    values[x] = (values[x] + values[y]) mod modulus\nfor _ in 0..<q:\n\
    \    let k = ii()\n    let a = ii()\n    let b = ii()\n    uf.unite(a, b, k, onMerge)\n\
    \    echo answer\n"
  dependsOn:
  - cplib/collections/parallel_unionfind.nim
  - cplib/collections/parallel_unionfind.nim
  isVerificationFile: true
  path: verify/collections/parallel_unionfind_test.nim
  requiredBy: []
  timestamp: '2026-09-08 16:08:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/parallel_unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/collections/parallel_unionfind_test.nim
- /verify/verify/collections/parallel_unionfind_test.nim.html
title: verify/collections/parallel_unionfind_test.nim
---
