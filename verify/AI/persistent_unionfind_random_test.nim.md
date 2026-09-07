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
    import cplib/collections/persistent_unionfind\nimport std/[random, sequtils]\n\
    \nrandomize(20260906)\ndoAssert initPersistentUnionFind(0).count == 0\nfor n in\
    \ [1, 2, 15, 16, 17, 63, 64, 65, 255, 256, 257, 4095, 4096, 4097]:\n    var versions\
    \ = @[initPersistentUnionFind(n)]\n    var labels = @[toSeq(0..<n)]\n    for step\
    \ in 0..<600:\n        let k = if step mod 3 == 0: rand(versions.high) else: versions.high\n\
    \        let u = rand(n - 1)\n        let v = if step mod 7 == 0: u else: rand(n\
    \ - 1)\n        var expected = labels[k]\n        let oldLabel = expected[v]\n\
    \        let newLabel = expected[u]\n        for x in expected.mitems:\n     \
    \       if x == oldLabel: x = newLabel\n        versions.add(versions[k].unite(u,\
    \ v))\n        labels.add(expected)\n        for ver in [k, versions.high, rand(versions.high)]:\n\
    \            var sizes = newSeq[int](n)\n            for x in labels[ver]: inc\
    \ sizes[x]\n            doAssert versions[ver].count == sizes.countIt(it > 0)\n\
    \            for _ in 0..<20:\n                let x = rand(n - 1)\n         \
    \       let y = rand(n - 1)\n                let root = versions[ver].root(x)\n\
    \                doAssert labels[ver][root] == labels[ver][x]\n              \
    \  doAssert versions[ver].root(root) == root\n                doAssert versions[ver].siz(x)\
    \ == sizes[labels[ver][x]]\n                doAssert versions[ver].issame(x, y)\
    \ == (labels[ver][x] == labels[ver][y])\n    # \u516C\u958B\u3055\u308C\u3066\u3044\
    \u308B count \u3092\u5909\u66F4\u3057\u3066\u3082\u4ED6\u30D0\u30FC\u30B8\u30E7\
    \u30F3\u306B\u306F\u5F71\u97FF\u3057\u306A\u3044\u3002\n    let same = versions[0].unite(0,\
    \ 0)\n    same.count = -123\n    doAssert versions[0].count == n\n    var balanced\
    \ = initPersistentUnionFind(n)\n    var stride = 1\n    while stride < n:\n  \
    \      var x = 0\n        while x + stride < n:\n            balanced = balanced.unite(x,\
    \ x + stride)\n            x += 2 * stride\n        stride *= 2\n    doAssert\
    \ balanced.count == 1\n    for x in 0..<n:\n        doAssert balanced.root(x)\
    \ == 0\n        doAssert balanced.siz(x) == n\n        doAssert balanced.issame(0,\
    \ x)\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/persistent_unionfind.nim
  - cplib/collections/persistent_unionfind.nim
  isVerificationFile: true
  path: verify/AI/persistent_unionfind_random_test.nim
  requiredBy: []
  timestamp: '2026-09-06 11:24:34+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/persistent_unionfind_random_test.nim
layout: document
redirect_from:
- /verify/verify/AI/persistent_unionfind_random_test.nim
- /verify/verify/AI/persistent_unionfind_random_test.nim.html
title: verify/AI/persistent_unionfind_random_test.nim
---
