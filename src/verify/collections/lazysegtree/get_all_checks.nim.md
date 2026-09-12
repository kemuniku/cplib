---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import random, sequtils\n\nblock:\n    type S = tuple[sum, size: int]\n \
    \   type F = tuple[a, b: int]\n    proc merge(x, y: S): S = (x.sum + y.sum, x.size\
    \ + y.size)\n    proc mapping(f: F, x: S): S = (f.a * x.sum + f.b * x.size, x.size)\n\
    \    proc composition(f, g: F): F = (f.a * g.a, f.a * g.b + f.b)\n    var rng\
    \ = initRand(20260912)\n    for n in [0, 1, 2, 3, 7, 8, 9, 31, 32, 33]:\n    \
    \    var values = newSeqWith(n, 1)\n        var seg = initLazySegmentTree[S, F](\n\
    \            values.mapIt((it, 1)), merge, (0, 0), mapping, composition, (1, 0))\n\
    \        assert seg.get_all() == (n, n)\n        for step in 0..<100:\n      \
    \      let f: F = (rng.rand(-1..1), rng.rand(-5..5))\n            if step mod\
    \ 3 != 2:\n                seg.apply(0, n, f)\n                for value in values.mitems:\n\
    \                    value = f.a * value + f.b\n            else:\n          \
    \      let l = rng.rand(n)\n                let r = rng.rand(l..n)\n         \
    \       seg.apply(l, r, f)\n                for i in l..<r:\n                \
    \    values[i] = f.a * values[i] + f.b\n            if n > 0 and step mod 5 ==\
    \ 0:\n                let p = rng.rand(n - 1)\n                values[p] = rng.rand(-10..10)\n\
    \                seg[p] = (values[p], 1)\n            var total = 0\n        \
    \    for value in values:\n                total += value\n            assert\
    \ seg.get_all() == (total, n)\n            if step mod 4 == 0:\n             \
    \   for i, value in values:\n                    assert seg[i] == (value, 1)\n\
    \                assert seg.get(0, n) == seg.get_all()\n\nblock:\n    for n in\
    \ [0, 1, 3, 4, 5]:\n        var seg = newLazySegWith(newSeqWith(n, 1), min(l,\
    \ r), int.high,\n            x + f, f + g, 0)\n        seg.apply(0, n, 10)\n \
    \       seg.apply(0, n, 20)\n        assert seg.get_all() == (if n == 0: int.high\
    \ else: 31)\n        if n > 0:\n            seg[n - 1] = 100\n            assert\
    \ seg.get_all() == (if n == 1: 100 else: 31)\n            assert seg.get(0, n)\
    \ == seg.get_all()\n"
  dependsOn: []
  isVerificationFile: false
  path: verify/collections/lazysegtree/get_all_checks.nim
  requiredBy: []
  timestamp: '2026-09-12 10:02:20+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/lazysegtree/get_all_checks.nim
layout: document
redirect_from:
- /library/verify/collections/lazysegtree/get_all_checks.nim
- /library/verify/collections/lazysegtree/get_all_checks.nim.html
title: verify/collections/lazysegtree/get_all_checks.nim
---
