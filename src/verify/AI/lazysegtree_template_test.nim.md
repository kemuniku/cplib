---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree_static_op.nim
    title: cplib/collections/lazysegtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree_static_op.nim
    title: cplib/collections/lazysegtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree_template.nim
    title: cplib/collections/lazysegtree_template.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree_template.nim
    title: cplib/collections/lazysegtree_template.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
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
    import random\nimport cplib/collections/lazysegtree_template\nimport cplib/collections/lazysegtree_static_op\n\
    import cplib/modint/modint\n\nvar rng = initRand(20260910)\nfor n in [0, 1, 2,\
    \ 5, 16, 23]:\n    var added, assigned, affine: seq[int]\n    for i in 0..<n:\n\
    \        let value = rng.rand(-10..10)\n        added.add(value)\n    assigned\
    \ = added\n    affine = added\n    var amin = initRangeAddRangeMinIndex(added)\n\
    \    var amax = initRangeAddRangeMaxIndex(added)\n    var asum = initRangeAddRangeSum(added)\n\
    \    var cmin = initRangeAssignRangeMinIndex(assigned)\n    var cmax = initRangeAssignRangeMaxIndex(assigned)\n\
    \    var csum = initRangeAssignRangeSum(assigned)\n    var fsum = initRangeAffineRangeSum(affine)\n\
    \    assert amin.len == n\n    for step in 0..<300:\n        let l = rng.rand(n)\n\
    \        let r = rng.rand(l..n)\n        let value = rng.rand(-10..10)\n     \
    \   let a = rng.rand(-1..1)\n        amin.apply(l, r, value)\n        amax.apply(l..<r,\
    \ value)\n        asum.apply(l, r, value)\n        cmin.apply(l, r, value)\n \
    \       cmax.apply(l, r, value)\n        csum.apply(l..<r, value)\n        fsum.apply(l,\
    \ r, (a, value))\n        for i in l..<r:\n            added[i] += value\n   \
    \         assigned[i] = value\n            affine[i] = a * affine[i] + value\n\
    \        for q in 0..<5:\n            let ql = rng.rand(n)\n            let qr\
    \ = rng.rand(ql..n)\n            var sa, sc, sf = 0\n            var iaMin, iaMax,\
    \ icMin, icMax = -1\n            for i in ql..<qr:\n                sa += added[i]\n\
    \                sc += assigned[i]\n                sf += affine[i]\n        \
    \        if iaMin < 0 or added[i] < added[iaMin]: iaMin = i\n                if\
    \ iaMax < 0 or added[i] > added[iaMax]: iaMax = i\n                if icMin <\
    \ 0 or assigned[i] < assigned[icMin]: icMin = i\n                if icMax < 0\
    \ or assigned[i] > assigned[icMax]: icMax = i\n            assert asum.get(ql,\
    \ qr) == (sa, qr - ql)\n            assert csum[ql..<qr] == (sc, qr - ql)\n  \
    \          assert fsum.get(ql, qr) == (sf, qr - ql)\n            assert amin.get(ql,\
    \ qr).index == iaMin\n            assert amax.get(ql, qr).index == iaMax\n   \
    \         assert cmin.get(ql, qr).index == icMin\n            assert cmax.get(ql,\
    \ qr).index == icMax\n            if ql < qr:\n                assert amin.get(ql,\
    \ qr).value == added[iaMin]\n                assert amax.get(ql, qr).value ==\
    \ added[iaMax]\n                assert cmin.get(ql, qr).value == assigned[icMin]\n\
    \                assert cmax.get(ql, qr).value == assigned[icMax]\n\nblock:\n\
    \    var seg = initRangeAssignRangeMinIndex(@[9, 1, 8, 2, 7])\n    seg.apply(0,\
    \ 5, 0)\n    assert seg.get(0, 5).index == 0\n    assert seg.get(1, 4).index ==\
    \ 1\n    seg[2] = (value: -1, index: 2, left: 2)\n    assert seg.get(0, 5).index\
    \ == 2\n    seg.apply(0, 5, int.high)\n    assert seg.get(0, 5).value == int.high\n\
    \    assert seg.get(0, 5).index == 0\nblock:\n    var seg = initRangeAddRangeMaxIndex(@[int.low,\
    \ int.low])\n    seg.apply(0, 2, 1)\n    assert seg.get(0, 2).value == int.low\
    \ + 1\n    assert seg.get(0, 2).index == 0\nblock:\n    var seg = initRangeAffineRangeSum(@[1.0,\
    \ 2.0, 3.0])\n    seg.apply(0, 3, (2.0, 1.0))\n    assert seg.get(0, 3).sum ==\
    \ 15.0\nblock:\n    type Mint = modint998244353_montgomery\n    var seg = initRangeAffineRangeSum(@[Mint.init(1),\
    \ Mint.init(2), Mint.init(3)])\n    seg.apply(0, 3, (Mint.init(2), Mint.init(3)))\n\
    \    seg.apply(0, 3, (Mint.init(4), Mint.init(5)))\n    assert seg.get(1, 3).sum.val\
    \ == 74\n    var add = initRangeAddRangeSum(@[Mint.init(1), Mint.init(2)])\n \
    \   add.apply(0, 2, Mint.init(3))\n    assert add.get(0, 2).sum.val == 9\n   \
    \ var assign = initRangeAssignRangeSum(@[Mint.init(1), Mint.init(2)])\n    assign.apply(0,\
    \ 2, Mint.init(0))\n    assert assign.get(0, 2).sum.val == 0\nfor n in [0, 1,\
    \ 2, 5, 16, 23]:\n    var added = newSeq[int](n)\n    var assigned = newSeq[int](n)\n\
    \    for i in 0..<n:\n        added[i] = rng.rand(-10..10)\n        assigned[i]\
    \ = added[i]\n    var amin = initRangeAddRangeMin(added)\n    var amax = initRangeAddRangeMax(added)\n\
    \    var cmin = initRangeAssignRangeMin(assigned)\n    var cmax = initRangeAssignRangeMax(assigned)\n\
    \    assert amin.len == n\n    static:\n        doAssert typeof(amin.arr[0]) is\
    \ int\n    for step in 0..<300:\n        let l = rng.rand(n)\n        let r =\
    \ rng.rand(l..n)\n        let value = rng.rand(-10..10)\n        amin.apply(l,\
    \ r, value)\n        amax.apply(l..<r, value)\n        cmin.apply(l, r, value)\n\
    \        cmax.apply(l..<r, value)\n        for i in l..<r:\n            added[i]\
    \ += value\n            assigned[i] = value\n        if n > 0 and step mod 3 ==\
    \ 0:\n            let p = rng.rand(n - 1)\n            amin[p] = value\n     \
    \       amax[p] = value\n            cmin[p] = value\n            cmax[p] = value\n\
    \            added[p] = value\n            assigned[p] = value\n            assert\
    \ amin[p] == value\n        for q in 0..<5:\n            let ql = rng.rand(n)\n\
    \            let qr = rng.rand(ql..n)\n            var ma, mc = int.high\n   \
    \         var xa, xc = int.low\n            for i in ql..<qr:\n              \
    \  ma = min(ma, added[i])\n                xa = max(xa, added[i])\n          \
    \      mc = min(mc, assigned[i])\n                xc = max(xc, assigned[i])\n\
    \            assert amin.get(ql, qr) == ma\n            assert amax[ql..<qr] ==\
    \ xa\n            assert cmin.get(ql, qr) == mc\n            assert cmax[ql..<qr]\
    \ == xc\nblock:\n    var lo = initRangeAddRangeMin(@[int.high, int.high, int.high])\n\
    \    lo.apply(0, 3, -1)\n    assert lo.get(0, 3) == int.high - 1\n    assert lo[2]\
    \ == int.high - 1\n    var hi = initRangeAddRangeMax(@[int.low, int.low, int.low])\n\
    \    hi.apply(0, 3, 1)\n    assert hi.get(0, 3) == int.low + 1\n    assert hi[2]\
    \ == int.low + 1\n    var cmin = initRangeAssignRangeMin(@[1, 2, 3])\n    var\
    \ cmax = initRangeAssignRangeMax(@[1, 2, 3])\n    for value in [int.high, int.low,\
    \ 0]:\n        cmin.apply(0, 3, value)\n        cmax.apply(0, 3, value)\n    \
    \    assert cmin.get(1, 3) == value\n        assert cmax.get(1, 3) == value\n\
    block:\n    var seg = initRangeAddRangeMin(@[1.0, 2.0, 3.0])\n    seg.apply(0,\
    \ 3, 0.5)\n    assert seg.get(0, 3) == 1.5\n    assert seg.get(1, 1) == float.high\n\
    \    var hi = initRangeAssignRangeMax(@[1.0, 2.0, 3.0])\n    hi.apply(0, 3, -0.5)\n\
    \    assert hi.get(1, 3) == -0.5\n    assert hi.get(1, 1) == float.low\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/collections/lazysegtree_static_op.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/collections/lazysegtree_static_op.nim
  - cplib/collections/lazysegtree_template.nim
  - cplib/modint/modint.nim
  - cplib/collections/lazysegtree_template.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/AI/lazysegtree_template_test.nim
  requiredBy: []
  timestamp: '2026-09-11 05:37:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lazysegtree_template_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lazysegtree_template_test.nim
- /verify/verify/AI/lazysegtree_template_test.nim.html
title: verify/AI/lazysegtree_template_test.nim
---
