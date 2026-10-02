---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_unionfind.nim
    title: cplib/collections/persistent_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_unionfind.nim
    title: cplib/collections/persistent_unionfind.nim
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
    import cplib/collections/persistent_unionfind\n\nproc checkBoundary(n, boundary:\
    \ int) =\n    let left = boundary - 1\n    let right = boundary\n    let last\
    \ = n - 1\n    let original = initPersistentUnionFind(n)\n    let first = original.unite(left,\
    \ right)\n    let sibling = original.unite(0, last)\n    let merged = first.unite(right,\
    \ last)\n    let redundant = merged.unite(left, last)\n    let selfUnion = first.unite(right,\
    \ right)\n    doAssert original.count == n\n    doAssert first.count == n - 1\n\
    \    doAssert sibling.count == n - 1\n    doAssert merged.count == n - 2\n   \
    \ doAssert redundant.count == merged.count\n    doAssert selfUnion.count == first.count\n\
    \    for x in [0, left, right, last]:\n        doAssert original.root(x) == x\n\
    \        doAssert original.siz(x) == 1\n        doAssert first.root(x) == (if\
    \ x == right: left else: x)\n        doAssert first.siz(x) == (if x == left or\
    \ x == right: 2 else: 1)\n        doAssert sibling.root(x) == (if x == last: 0\
    \ else: x)\n        doAssert sibling.siz(x) == (if x == 0 or x == last: 2 else:\
    \ 1)\n        doAssert merged.root(x) == (if x == right or x == last: left else:\
    \ x)\n        doAssert merged.siz(x) == (if x == left or x == right or x == last:\
    \ 3 else: 1)\n        doAssert redundant.root(x) == merged.root(x)\n        doAssert\
    \ redundant.siz(x) == merged.siz(x)\n        doAssert selfUnion.root(x) == first.root(x)\n\
    \        doAssert selfUnion.siz(x) == first.siz(x)\n        for y in [0, left,\
    \ right, last]:\n            doAssert original.issame(x, y) == (x == y)\n    \
    \        doAssert first.issame(x, y) == (first.root(x) == first.root(y))\n   \
    \         doAssert sibling.issame(x, y) == (sibling.root(x) == sibling.root(y))\n\
    \            doAssert merged.issame(x, y) == (merged.root(x) == merged.root(y))\n\
    \    redundant.count = -1\n    selfUnion.count = -2\n    doAssert merged.count\
    \ == n - 2\n    doAssert first.count == n - 1\n    doAssert original.count ==\
    \ n\n\nfor n in [0, 1, 7, 8, 9, 63, 64, 65, 511, 512, 513, 4095, 4096, 4097]:\n\
    \    let original = initPersistentUnionFind(n)\n    doAssert original.count ==\
    \ n\n    if n > 0:\n        let same = original.unite(n - 1, n - 1)\n        doAssert\
    \ same.root(n - 1) == n - 1\n        doAssert same.siz(n - 1) == 1\n        doAssert\
    \ same.count == n\n    if n > 1:\n        let endpoints = original.unite(0, n\
    \ - 1)\n        doAssert endpoints.count == n - 1\n        doAssert endpoints.root(n\
    \ - 1) == 0\n        doAssert endpoints.siz(n - 1) == 2\n        for x in 0..<n:\n\
    \            doAssert original.root(x) == x\n            doAssert original.siz(x)\
    \ == 1\n            doAssert endpoints.root(x) == (if x == n - 1: 0 else: x)\n\
    \            doAssert endpoints.siz(x) == (if x == 0 or x == n - 1: 2 else: 1)\n\
    \        for boundary in [8, 64, 512, 4096]:\n            if boundary + 1 < n:\n\
    \                checkBoundary(n, boundary)\n\nfor boundary in [8, 64, 512, 4096,\
    \ 32768, 262144, 2097152, 16777216, 134217728, 1073741824]:\n    checkBoundary(int32.high.int,\
    \ boundary)\nlet sparse = initPersistentUnionFind(int32.high.int)\nlet endpoints\
    \ = sparse.unite(0, int32.high.int - 1)\ndoAssert endpoints.count == int32.high.int\
    \ - 1\ndoAssert endpoints.root(int32.high.int - 1) == 0\ndoAssert endpoints.siz(0)\
    \ == 2\ndoAssert sparse.root(int32.high.int - 1) == int32.high.int - 1\ndoAssert\
    \ sparse.siz(0) == 1\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/persistent_unionfind.nim
  - cplib/collections/persistent_unionfind.nim
  isVerificationFile: true
  path: verify/AI/persistent_unionfind_branch_boundary_test.nim
  requiredBy: []
  timestamp: '2026-10-01 21:57:18+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/persistent_unionfind_branch_boundary_test.nim
layout: document
redirect_from:
- /verify/verify/AI/persistent_unionfind_branch_boundary_test.nim
- /verify/verify/AI/persistent_unionfind_branch_boundary_test.nim.html
title: verify/AI/persistent_unionfind_branch_boundary_test.nim
---
