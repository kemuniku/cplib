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
    import random, sequtils\nimport cplib/collections/parallel_unionfind\n\nvar rng\
    \ = initRand(368415)\nfor n in [0, 1, 2, 3, 4, 5, 15, 16, 17, 63, 64, 65]:\n \
    \   let uf = initParallelUnionFind(n)\n    var labels = toSeq(0..<n)\n    var\
    \ sums = toSeq(1..n)\n    var calls = 0\n    proc onMerge(x, y: int) =\n     \
    \   doAssert x != y\n        doAssert uf.root(x) == x and uf.root(y) == y\n  \
    \      doAssert uf.siz(x) >= uf.siz(y)\n        sums[x] += sums[y]\n        inc\
    \ calls\n    for query in 0..<200:\n        let len = rng.rand(n)\n        let\
    \ a = rng.rand(n - len)\n        let b = rng.rand(n - len)\n        var merged\
    \ = 0\n        for i in 0..<len:\n            let x = labels[a + i]\n        \
    \    let y = labels[b + i]\n            if x != y:\n                inc merged\n\
    \                for j in 0..<n:\n                    if labels[j] == y: labels[j]\
    \ = x\n        let before = calls\n        if len == 1 and query mod 2 == 0:\n\
    \            doAssert uf.unite(a, b, onMerge) == (merged != 0)\n        else:\n\
    \            doAssert uf.unite(a, b, len, onMerge) == merged\n        doAssert\
    \ calls - before == merged\n        doAssert uf.count == n - calls\n        doAssert\
    \ uf.roots().len == uf.count\n        for x in 0..<n:\n            var size, sum:\
    \ int\n            for y in 0..<n:\n                doAssert uf.issame(x, y) ==\
    \ (labels[x] == labels[y])\n                if labels[x] == labels[y]:\n     \
    \               inc size\n                    sum += y + 1\n            doAssert\
    \ uf.siz(x) == size\n            doAssert sums[uf.root(x)] == sum\n\nlet uf =\
    \ initParallelUnionFind(20)\nuf.unite(0, 5, 5)\nlet cp = uf.copy()\ndoAssert cp.unite(0,\
    \ 10, 10) == 10\ndoAssert uf.count == 15\ndoAssert not uf.issame(0, 10)\ndoAssert\
    \ uf.unite(0, 10)\ndoAssert not uf.unite(0, 10)\ndoAssert not cp.issame(0, 1)\n\
    cp.unite(0, 1, 19)\ndoAssert cp.count == 1\ndoAssert uf.count == 14\necho \"Hello\
    \ World\"\n"
  dependsOn:
  - cplib/collections/parallel_unionfind.nim
  - cplib/collections/parallel_unionfind.nim
  isVerificationFile: true
  path: verify/AI/parallel_unionfind_test.nim
  requiredBy: []
  timestamp: '2026-09-08 16:08:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/parallel_unionfind_test.nim
layout: document
redirect_from:
- /verify/verify/AI/parallel_unionfind_test.nim
- /verify/verify/AI/parallel_unionfind_test.nim.html
title: verify/AI/parallel_unionfind_test.nim
---
