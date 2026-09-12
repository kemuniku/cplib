---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_lazysegtree.nim
    title: cplib/collections/dynamic_lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_lazysegtree.nim
    title: cplib/collections/dynamic_lazysegtree.nim
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
    import random, sets, strutils\ninclude cplib/collections/dynamic_lazysegtree\n\
    \ntype\n    S = tuple[sum, size: int]\n    F = tuple[a, b: int]\n\nproc makeTree(n:\
    \ int): DynamicLazySegmentTree[S, F] =\n    newDynamicLazySegWith(n, (l.sum +\
    \ r.sum, l.size + r.size), (sum: 0, size: 0),\n        (f.a * x.sum + f.b * x.size,\
    \ x.size),\n        (f.a * g.a, f.a * g.b + f.b), (a: 1, b: 0),\n        ((l +\
    \ r - 1) * (r - l) div 2, r - l))\n\nproc checkTree[S, F](node: DynamicLazySegmentTreeNode[S,\
    \ F]): int =\n    if node == nil: return 0\n    assert node.a < node.b\n    assert\
    \ node.height == max(height(node.left), height(node.right)) + 1\n    assert abs(height(node.left)\
    \ - height(node.right)) <= 1\n    if node.left != nil:\n        assert node.left.hi\
    \ == node.a\n        assert node.lo == node.left.lo\n    else:\n        assert\
    \ node.lo == node.a\n    if node.right != nil:\n        assert node.b == node.right.lo\n\
    \        assert node.hi == node.right.hi\n    else:\n        assert node.hi ==\
    \ node.b\n    1 + checkTree(node.left) + checkTree(node.right)\n\nvar rng = initRand(20260912)\n\
    for n in [0, 1, 2, 3, 17, 64, 99]:\n    let st = makeTree(n)\n    assert st.len\
    \ == n\n    var expected = newSeq[int](n)\n    for i in 0..<n: expected[i] = i\n\
    \    var boundaries = initHashSet[int]()\n    boundaries.incl(0)\n    boundaries.incl(n)\n\
    \    for step in 0..<2000:\n        var l = rng.rand(n)\n        var r = rng.rand(n)\n\
    \        if l > r: swap(l, r)\n        if n > 0 and step mod 7 == 0:\n       \
    \     let p = rng.rand(n - 1)\n            let value = rng.rand(-100..100)\n \
    \           st[p] = (value, 1)\n            expected[p] = value\n            boundaries.incl(p)\n\
    \            boundaries.incl(p + 1)\n        else:\n            let f: F = (rng.rand(-1..1),\
    \ rng.rand(-10..10))\n            st.apply(l..<r, f)\n            for i in l..<r:\
    \ expected[i] = f.a * expected[i] + f.b\n            if l < r:\n             \
    \   boundaries.incl(l)\n                boundaries.incl(r)\n        assert st.node_count\
    \ == boundaries.len - 1\n        assert checkTree(st.root) == st.node_count\n\
    \        var total = 0\n        for i in 0..<n:\n            total += expected[i]\n\
    \            assert st[i] == (expected[i], 1)\n        assert st.get_all() ==\
    \ (total, n)\n        for rep in 0..<5:\n            var a = rng.rand(n)\n   \
    \         var b = rng.rand(n)\n            if a > b: swap(a, b)\n            var\
    \ part = 0\n            for i in a..<b: part += expected[i]\n            assert\
    \ st[a..<b] == (part, b - a)\n        assert st.node_count == boundaries.len -\
    \ 1\n\nblock:\n    let n = 1001\n    let st = makeTree(n)\n    var expected =\
    \ newSeq[int](n)\n    for i in 0..<n: expected[i] = i\n    for step in 0..<500:\n\
    \        st.apply(0, n, (-1, 3))\n        for i in 0..<n: expected[i] = -expected[i]\
    \ + 3\n        let p = (step * 173) mod n\n        st.apply(p, n, (1, 2))\n  \
    \      for i in p..<n: expected[i] += 2\n        if step mod 11 == 0:\n      \
    \      st[p] = (17, 1)\n            expected[p] = 17\n        assert checkTree(st.root)\
    \ == st.node_count\n    for i in 0..<n: assert st[i] == (expected[i], 1)\n\nblock:\n\
    \    let n = 53\n    let st = newDynamicLazySegWith(n, l & r, \"\",\n        (if\
    \ f == '\\0': x else: repeat(f, x.len)),\n        (if f == '\\0': g else: f),\
    \ '\\0', repeat('a', r - l))\n    var expected = repeat('a', n)\n    for step\
    \ in 0..<500:\n        let f = char(ord('a') + rng.rand(25))\n        var a =\
    \ rng.rand(n)\n        var b = rng.rand(n)\n        if a > b: swap(a, b)\n   \
    \     st.apply(a, b, f)\n        for i in a..<b: expected[i] = f\n        if step\
    \ mod 3 == 0:\n            let p = rng.rand(n - 1)\n            st[p] = \"Z\"\n\
    \            expected[p] = 'Z'\n        assert st.get_all() == expected\n    \
    \    for i in 0..n:\n            assert st.get(i, n) == expected[i..<n]\n    \
    \    assert checkTree(st.root) == st.node_count\n\nblock:\n    let n = int.high\n\
    \    let st = newDynamicLazySegWith(n, min(l, r), int.high,\n        min(f, x),\
    \ min(f, g), int.high, 100)\n    st.apply(0, n, 50)\n    assert st.node_count\
    \ == 1\n    assert st.get(1, n - 1) == 50\n    assert st.node_count == 1\n   \
    \ st[n - 1] = 80\n    st[0] = 70\n    assert st.node_count == 3\n    assert st.get(0,\
    \ 1) == 70\n    assert st[n - 1] == 80\n    assert st.get(1, n - 1) == 50\n  \
    \  for step in 0..<1000:\n        st.apply(1, n - 1, 40)\n        assert st.node_count\
    \ == 3\n    assert st.get_all() == 40\n    assert checkTree(st.root) == 3\n\n\
    for descending in [false, true]:\n    let n = int.high\n    let st = newDynamicLazySegWith(n,\
    \ l + r, 0, x, 0, 0, 0)\n    for i in 0..<5000:\n        let p = if descending:\
    \ n - 1 - i else: i\n        st[p] = 1\n        if i mod 100 == 0:\n         \
    \   st.apply(0, n, 0)\n            assert checkTree(st.root) == st.node_count\n\
    \    assert st.get_all() == 5000\n    assert st.node_count == 5001\n    assert\
    \ checkTree(st.root) == 5001\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/dynamic_lazysegtree.nim
  - cplib/collections/dynamic_lazysegtree.nim
  isVerificationFile: true
  path: verify/AI/dynamic_lazysegtree_test.nim
  requiredBy: []
  timestamp: '2026-09-12 20:28:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dynamic_lazysegtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dynamic_lazysegtree_test.nim
- /verify/verify/AI/dynamic_lazysegtree_test.nim.html
title: verify/AI/dynamic_lazysegtree_test.nim
---
