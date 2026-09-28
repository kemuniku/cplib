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
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/stern_brocot_tree.nim
    title: cplib/math/stern_brocot_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/stern_brocot_tree.nim
    title: cplib/math/stern_brocot_tree.nim
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
    import cplib/math/stern_brocot_tree\n\nproc checkSmall[T](n, x, y: T, strict,\
    \ inverted: bool) =\n    proc isBelow(a, b: T): bool =\n        if b == 0:\n \
    \           return false\n        if strict:\n            return a * y < x * b\n\
    \        return a * y <= x * b\n\n    let bounds = get_bounds(proc(v: SBTNode[T]):\
    \ bool =\n        isBelow(v.num(), v.den()) xor inverted\n    , n)\n    var p\
    \ = T(0)\n    var q = T(1)\n    var r = T(1)\n    var s = T(0)\n    for a in 1..int(n):\n\
    \        for b in 1..int(n):\n            if isBelow(T(a), T(b)):\n          \
    \      if T(a) * q > p * T(b):\n                    p = T(a)\n               \
    \     q = T(b)\n            elif T(a) * s < r * T(b):\n                r = T(a)\n\
    \                s = T(b)\n    doAssert bounds.p * q == p * bounds.q\n    doAssert\
    \ bounds.r * s == r * bounds.s\n    doAssert bounds.q * bounds.r - bounds.p *\
    \ bounds.s == 1\n    doAssert bounds.p <= n and bounds.q <= n\n    doAssert bounds.r\
    \ <= n and bounds.s <= n\n    doAssert bounds.num() > n or bounds.den() > n\n\n\
    proc testSmall[T]() =\n    for n in 1..12:\n        for x in 0..16:\n        \
    \    for y in 1..16:\n                for strict in [false, true]:\n         \
    \           if strict and x == 0:\n                        continue\n        \
    \            for inverted in [false, true]:\n                        checkSmall(T(n),\
    \ T(x), T(y), strict, inverted)\n\ntestSmall[int]()\ntestSmall[int32]()\ntestSmall[int64]()\n\
    \nproc checkLarge(n, x, y: int) =\n    var calls = 0\n    let bounds = get_bounds(proc(v:\
    \ SBTNode[int]): bool =\n        inc calls\n        v.den() != 0 and v.num() *\
    \ y <= x * v.den()\n    , n)\n    doAssert bounds.p * y <= x * bounds.q\n    doAssert\
    \ bounds.r * y > x * bounds.s\n    doAssert bounds.q * bounds.r - bounds.p * bounds.s\
    \ == 1\n    doAssert bounds.p <= n and bounds.q <= n\n    doAssert bounds.r <=\
    \ n and bounds.s <= n\n    doAssert bounds.num() > n or bounds.den() > n\n   \
    \ doAssert calls <= 128\n\nfor n in [500000000, 1000000000]:\n    checkLarge(n,\
    \ 433494437, 701408733)\n    checkLarge(n, 701408733, 433494437)\n    checkLarge(n,\
    \ 1, 1000000000)\n    checkLarge(n, 1000000000, 1)\n    checkLarge(n, 1, 2)\n\
    \    checkLarge(n, 2, 1)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/graph/graph.nim
  - cplib/math/stern_brocot_tree.nim
  - cplib/graph/graph.nim
  - cplib/math/stern_brocot_tree.nim
  isVerificationFile: true
  path: verify/math/stern_brocot_tree_bounds_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:47:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/stern_brocot_tree_bounds_test.nim
layout: document
redirect_from:
- /verify/verify/math/stern_brocot_tree_bounds_test.nim
- /verify/verify/math/stern_brocot_tree_bounds_test.nim.html
title: verify/math/stern_brocot_tree_bounds_test.nim
---
