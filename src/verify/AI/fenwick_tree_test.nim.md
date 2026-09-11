---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick.nim
    title: cplib/collections/fenwick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick.nim
    title: cplib/collections/fenwick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick_avx2.nim
    title: cplib/collections/fenwick_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick_avx2.nim
    title: cplib/collections/fenwick_avx2.nim
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
    import random\nimport cplib/collections/fenwick\nimport cplib/collections/fenwick_avx2\n\
    \nvar rng = initRand(712893)\n\nfor n in [0, 1, 2, 3, 15, 16, 17, 31, 32, 33,\
    \ 255, 256, 257,\n          1023, 1024, 1025, 4095, 4096, 4097, 65535, 65536,\
    \ 65537]:\n    var a = newSeq[int](n)\n    for x in a.mitems: x = rng.rand(-1000..1000)\n\
    \    var bit = initFenwickTree(a)\n    var wide = initFenwickTreeAvx2(a)\n   \
    \ var zero = initFenwickTree[int](n)\n    var wideZero = initFenwickTreeAvx2(n)\n\
    \    doAssert bit.len == n and wide.len == n\n    doAssert zero.get(0, n) == 0\
    \ and wideZero.get(0, n) == 0\n    var prefix = 0\n    for r in 0..n:\n      \
    \  doAssert bit.prefix(r) == prefix\n        doAssert wide.prefix(r) == prefix\n\
    \        doAssert bit.get(r, r) == 0\n        doAssert wide.get(r, r) == 0\n \
    \       if r < n: prefix += a[r]\n    for step in 0..<1000:\n        if n > 0\
    \ and step mod 3 != 0:\n            let p = rng.rand(n - 1)\n            let delta\
    \ = rng.rand(-1000..1000)\n            if step mod 3 == 1:\n                a[p]\
    \ += delta\n                bit.add(p, delta)\n                wide.add(p, delta)\n\
    \            else:\n                a[p] = delta\n                bit[p] = delta\n\
    \                wide[p] = delta\n            doAssert bit[p] == a[p] and wide[p]\
    \ == a[p]\n        else:\n            let l = rng.rand(n)\n            let r =\
    \ rng.rand(l..n)\n            var expected = 0\n            for i in l..<r: expected\
    \ += a[i]\n            doAssert bit.get(l, r) == expected\n            doAssert\
    \ wide.get(l, r) == expected\n            doAssert bit[l..<r] == expected\n  \
    \          doAssert wide[l..<r] == expected\n    if n > 0:\n        let old =\
    \ bit[0]\n        var other = bit\n        var otherWide = wide\n        other.add(0,\
    \ 1)\n        otherWide.add(0, 1)\n        doAssert bit[0] == old and wide[0]\
    \ == old\n        doAssert other[0] == old + 1 and otherWide[0] == old + 1\n\n\
    block:\n    var a = @[uint64.high, 1'u64, 1'u64 shl 63, 7'u64]\n    var bit =\
    \ initFenwickTree(a)\n    var signed = newSeq[int](a.len)\n    for i, x in a:\
    \ signed[i] = cast[int](x)\n    var wide = initFenwickTreeAvx2(signed)\n    for\
    \ step in 0..<200:\n        let p = rng.rand(3)\n        let delta = cast[uint64](rng.rand(-100..100))\n\
    \        a[p] += delta\n        bit.add(p, delta)\n        wide.add(p, cast[int](delta))\n\
    \        for l in 0..a.len:\n            var expected = 0'u64\n            for\
    \ r in l..a.len:\n                doAssert bit.get(l, r) == expected\n       \
    \         doAssert cast[uint64](wide.get(l, r)) == expected\n                if\
    \ r < a.len: expected += a[r]\n    wide[0] = cast[int](uint64.high)\n    doAssert\
    \ cast[uint64](wide.get(0, 1)) == uint64.high\n\nblock:\n    var bit = initFenwickTreeAvx2(@[-128,\
    \ 127, -1])\n    doAssert bit.get(0, 3) == -2\n    bit.add(2, -128)\n    doAssert\
    \ bit[2] == -129\n    bit[0] = int.low\n    doAssert bit[0] == int.low\n    bit.add(0,\
    \ int.low)\n    doAssert bit[0] == 0\n\nblock:\n    var bit = initFenwickTree(@[1.5,\
    \ -2.0, 3.0])\n    bit.add(1, 0.5)\n    doAssert bit.get(0, 3) == 3.0\n    var\
    \ empty: FenwickTree[int]\n    var emptyWide: FenwickTreeAvx2\n    doAssert empty.get(0,\
    \ 0) == 0 and empty.prefix(0) == 0\n    doAssert emptyWide.get(0, 0) == 0 and\
    \ emptyWide.prefix(0) == 0\n\nfor n in [(1 shl 20) - 1, 1 shl 20, (1 shl 20) +\
    \ 1]:\n    var wide = initFenwickTreeAvx2(n)\n    let positions = [0, 15, 16,\
    \ n div 2, n - 1]\n    for p in positions: wide.add(p, 7)\n    for r in [0, 1,\
    \ 15, 16, 17, n div 2, n div 2 + 1, n - 1, n]:\n        var expected = 0\n   \
    \     for p in positions:\n            if p < r: expected += 7\n        doAssert\
    \ wide.prefix(r) == expected\n        doAssert wide.get(r, n) == 35 - expected\n\
    \nwhen compileOption(\"assertions\"):\n    template expectAssertion(body: untyped)\
    \ =\n        block:\n            var caught = false\n            try:\n      \
    \          body\n            except AssertionDefect:\n                caught =\
    \ true\n            doAssert caught\n    var bit = initFenwickTree[int](2)\n \
    \   var wide = initFenwickTreeAvx2(2)\n    expectAssertion: bit.add(-1, 1)\n \
    \   expectAssertion: wide.add(-1, 1)\n    expectAssertion: bit.add(2, 1)\n   \
    \ expectAssertion: wide.add(2, 1)\n    expectAssertion: discard bit.prefix(3)\n\
    \    expectAssertion: discard wide.prefix(3)\n    expectAssertion: discard bit.get(1,\
    \ 0)\n    expectAssertion: discard wide.get(1, 0)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/fenwick.nim
  - cplib/collections/fenwick.nim
  - cplib/collections/fenwick_avx2.nim
  - cplib/collections/fenwick_avx2.nim
  isVerificationFile: true
  path: verify/AI/fenwick_tree_test.nim
  requiredBy: []
  timestamp: '2026-09-09 17:07:19+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fenwick_tree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fenwick_tree_test.nim
- /verify/verify/AI/fenwick_tree_test.nim.html
title: verify/AI/fenwick_tree_test.nim
---
