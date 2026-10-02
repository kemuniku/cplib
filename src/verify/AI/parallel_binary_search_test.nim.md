---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/parallel_binary_search.nim
    title: cplib/utils/parallel_binary_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/parallel_binary_search.nim
    title: cplib/utils/parallel_binary_search.nim
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
    import random\nimport cplib/utils/parallel_binary_search\nimport cplib/collections/unionfind\n\
    \nblock:\n    var calls = 0\n    proc reset() = inc calls\n    proc apply(idx:\
    \ int) = inc calls\n    proc check(idx: int): bool =\n        inc calls\n    \
    \    true\n    doAssert parallelBinarySearch(0, 0, reset, apply, check).len ==\
    \ 0\n    doAssert parallelBinarySearch(100, 0, reset, apply, check).len == 0\n\
    \    doAssert calls == 0\n\nfor m in 0..65:\n    var count = -1\n    var resets,\
    \ applications: int\n    var checks = newSeq[int](m + 2)\n    proc reset() =\n\
    \        count = 0\n        inc resets\n    proc apply(idx: int) =\n        doAssert\
    \ idx == count and idx < m\n        inc count\n        inc applications\n    proc\
    \ check(q: int): bool =\n        doAssert 0 <= count and count <= m\n        inc\
    \ checks[q]\n        count >= q\n    let answers = parallelBinarySearch(m, m +\
    \ 2, reset, apply, check)\n    for q, answer in answers: doAssert answer == q\n\
    \    var rounds = 0\n    var width = m + 1\n    while width > 0:\n        inc\
    \ rounds\n        width = width div 2\n    doAssert resets <= rounds\n    doAssert\
    \ applications <= m * rounds\n    for calls in checks: doAssert 1 <= calls and\
    \ calls <= rounds\n\nvar rng = initRand(723491)\nfor trial in 0..<100:\n    let\
    \ m = rng.rand(80)\n    let q = rng.rand(100) + 1\n    let initial = rng.rand(20)\n\
    \    var updates = newSeq[int](m)\n    for value in updates.mitems: value = rng.rand(10)\n\
    \    var targets = newSeq[int](q)\n    for target in targets.mitems: target =\
    \ rng.rand(500)\n    var expected = newSeq[int](q)\n    for idx, target in targets:\n\
    \        expected[idx] = m + 1\n        var total = initial\n        for count\
    \ in 0..m:\n            if total >= target:\n                expected[idx] = count\n\
    \                break\n            if count < m: total += updates[count]\n  \
    \  var total, position: int\n    var fingerprint: int64\n    var prefixes = newSeq[int64](m\
    \ + 1)\n    for i, value in updates:\n        prefixes[i + 1] = (prefixes[i] *\
    \ 31 + value) mod 1000000007\n    proc reset() =\n        total = initial\n  \
    \      position = 0\n        fingerprint = 0\n    proc apply(idx: int) =\n   \
    \     doAssert idx == position\n        total += updates[idx]\n        fingerprint\
    \ = (fingerprint * 31 + updates[idx]) mod 1000000007\n        inc position\n \
    \   proc check(idx: int): bool =\n        doAssert fingerprint == prefixes[position]\n\
    \        total >= targets[idx]\n    for repeat in 0..<2:\n        doAssert parallelBinarySearch(m,\
    \ q, reset, apply, check) == expected\n\nfor trial in 0..<40:\n    let n = rng.rand(14)\
    \ + 1\n    let m = rng.rand(40)\n    var edges = newSeq[(int, int)](m)\n    for\
    \ edge in edges.mitems: edge = (rng.rand(n - 1), rng.rand(n - 1))\n    var labels\
    \ = newSeq[int](n)\n    for v in 0..<n: labels[v] = v\n    var expected = newSeq[int](n\
    \ * n)\n    for answer in expected.mitems: answer = m + 1\n    for count in 0..m:\n\
    \        for u in 0..<n:\n            for v in 0..<n:\n                if labels[u]\
    \ == labels[v] and expected[u * n + v] == m + 1:\n                    expected[u\
    \ * n + v] = count\n        if count < m:\n            let a = labels[edges[count][0]]\n\
    \            let b = labels[edges[count][1]]\n            for label in labels.mitems:\n\
    \                if label == b: label = a\n    var uf: UnionFind\n    proc reset()\
    \ = uf = initUnionFind(n)\n    proc apply(idx: int) = uf.unite(edges[idx][0],\
    \ edges[idx][1])\n    proc check(idx: int): bool = uf.issame(idx div n, idx mod\
    \ n)\n    doAssert parallelBinarySearch(m, n * n, reset, apply, check) == expected\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/parallel_binary_search.nim
  - cplib/utils/parallel_binary_search.nim
  - cplib/collections/unionfind.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: true
  path: verify/AI/parallel_binary_search_test.nim
  requiredBy: []
  timestamp: '2026-09-30 05:21:31+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/parallel_binary_search_test.nim
layout: document
redirect_from:
- /verify/verify/AI/parallel_binary_search_test.nim
- /verify/verify/AI/parallel_binary_search_test.nim.html
title: verify/AI/parallel_binary_search_test.nim
---
