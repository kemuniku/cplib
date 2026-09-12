---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_segtree.nim
    title: cplib/collections/dynamic_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_segtree.nim
    title: cplib/collections/dynamic_segtree.nim
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
    import random, sets\nimport cplib/collections/dynamic_segtree\n\nvar rng = initRand(20260912)\n\
    \nblock:\n    let st = newDynamicSegWith(0, l + r, 0)\n    assert st.len == 0\n\
    \    assert st.get_all() == 0\n    assert st.get(0, 0) == 0\n    assert st[0..<0]\
    \ == 0\n    assert st.node_count == 0\n\nfor n in [1, 2, 3, 7, 16, 31, 64, 99]:\n\
    \    let st = newDynamicSegWith(n, l + r, 0)\n    var expected = newSeq[int](n)\n\
    \    var touched = initHashSet[int]()\n    for step in 0..<1500:\n        let\
    \ p = rng.rand(n - 1)\n        let value = rng.rand(-100..100)\n        st[p]\
    \ = value\n        expected[p] = value\n        touched.incl(p)\n        var a\
    \ = rng.rand(n)\n        var b = rng.rand(n)\n        if a > b: swap(a, b)\n \
    \       var total, part: int\n        for i in 0..<n:\n            total += expected[i]\n\
    \            if a <= i and i < b: part += expected[i]\n            assert st[i]\
    \ == expected[i]\n        assert st.get(a, b) == part\n        assert st[a..<b]\
    \ == part\n        assert st.get_all() == total\n        assert st.node_count\
    \ == touched.len\n\nblock:\n    let n = 37\n    let st = newDynamicSegWith(n,\
    \ l & r, \"\")\n    var expected = newSeq[string](n)\n    for step in 0..<500:\n\
    \        let p = rng.rand(n - 1)\n        let value = if step mod 5 == 0: \"\"\
    \ else: $char(ord('a') + rng.rand(25))\n        st.update(p, value)\n        expected[p]\
    \ = value\n        for a in 0..n:\n            var part = \"\"\n            for\
    \ b in a..n:\n                assert st.get(a, b) == part\n                if\
    \ b < n: part.add(expected[b])\n\nblock:\n    let st = newDynamicSegWith(11, min(l,\
    \ r), int.high)\n    assert st[5] == int.high\n    st[3] = 9\n    st[8] = -2\n\
    \    assert st.get(0, 3) == int.high\n    assert st[3..7] == 9\n    assert st.get_all()\
    \ == -2\n    st[8] = int.high\n    assert st.get_all() == 9\n    assert st.node_count\
    \ == 2\n\nfor descending in [false, true]:\n    let n = int.high\n    let st =\
    \ newDynamicSegWith(n, l + r, 0)\n    let stride = n div 8192\n    for i in 0..<4096:\n\
    \        let p = if descending: n - 1 - i * stride else: i * stride\n        st[p]\
    \ = 1\n        assert st.node_count == i + 1\n    assert st.get_all() == 4096\n\
    \    assert st.get(0, n) == 4096\n    for i in 0..<4096:\n        let p = if descending:\
    \ n - 1 - i * stride else: i * stride\n        assert st[p] == 1\n        assert\
    \ st.get(p, p + 1) == 1\n        assert st.get(p + 1, p + min(n - p, stride))\
    \ == 0\n        st[p] = 0\n        assert st.node_count == 4096\n    assert st.get_all()\
    \ == 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/dynamic_segtree.nim
  - cplib/collections/dynamic_segtree.nim
  isVerificationFile: true
  path: verify/AI/dynamic_segtree_test.nim
  requiredBy: []
  timestamp: '2026-09-12 20:28:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dynamic_segtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dynamic_segtree_test.nim
- /verify/verify/AI/dynamic_segtree_test.nim.html
title: verify/AI/dynamic_segtree_test.nim
---
