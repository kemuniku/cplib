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
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/rerooting_static_top_tree_dp.nim
    title: cplib/tree/rerooting_static_top_tree_dp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/rerooting_static_top_tree_dp.nim
    title: cplib/tree/rerooting_static_top_tree_dp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/static_top_tree.nim
    title: cplib/tree/static_top_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/static_top_tree.nim
    title: cplib/tree/static_top_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/static_top_tree_dp.nim
    title: cplib/tree/static_top_tree_dp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/static_top_tree_dp.nim
    title: cplib/tree/static_top_tree_dp.nim
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
    import random, sequtils\nimport cplib/tree/static_top_tree\nimport cplib/tree/static_top_tree_dp\n\
    import cplib/tree/rerooting_static_top_tree_dp\n\nconst modulus = 101\ntype\n\
    \    Forward = object\n        first, last, mul, add, count, sum: int\n    Backward\
    \ = object\n        value: Forward\n\nproc compress(l, r: Forward): Forward =\n\
    \    assert l.last == r.first\n    Forward(first: l.first, last: r.last, mul:\
    \ l.mul * r.mul mod modulus,\n        add: (l.mul * r.add + l.add) mod modulus,\
    \ count: l.count + r.count,\n        sum: (l.sum + l.mul * r.sum + l.add * r.count)\
    \ mod modulus)\n\nproc rake(l, r: Forward): Forward =\n    assert l.first == r.first\n\
    \    Forward(first: l.first, last: l.last, mul: l.mul, add: l.add,\n        count:\
    \ l.count + r.count, sum: (l.sum + r.sum) mod modulus)\n\nproc compressReverse(l,\
    \ r: Backward): Backward =\n    Backward(value: compress(l.value, r.value))\n\n\
    proc rakeAtRoot(l: Backward, r: Forward): Backward =\n    Backward(value: rake(l.value,\
    \ r))\n\nproc rakeAtEnd(l: Backward, r: Forward): Backward =\n    result.value\
    \ = compress(l.value, r)\n    result.value.last = l.value.last\n    result.value.mul\
    \ = l.value.mul\n    result.value.add = l.value.add\n\nproc checkStructure(tree:\
    \ StaticTopTree): int =\n    let n = tree.numVertices\n    assert tree.nodes.len\
    \ == 2 * n - 1\n    assert tree.root == tree.nodes.high\n    assert tree.nodes[tree.root].parent\
    \ == -1\n    assert tree.nodes[tree.root].size == n\n    var height = newSeq[int](tree.nodes.len)\n\
    \    for i, x in tree.nodes:\n        if i < n:\n            assert x.kind ==\
    \ sttLeaf and x.lower == i and x.size == 1\n            assert x.left == -1 and\
    \ x.right == -1\n        else:\n            assert 0 <= x.left and x.left < i\n\
    \            assert 0 <= x.right and x.right < i\n            assert tree.nodes[x.left].parent\
    \ == i\n            assert tree.nodes[x.right].parent == i\n            assert\
    \ x.size == tree.nodes[x.left].size + tree.nodes[x.right].size\n            height[i]\
    \ = max(height[x.left], height[x.right]) + 1\n        if i != tree.root:\n   \
    \         assert i < x.parent and x.parent < tree.nodes.len\n    var logN = 0\n\
    \    while (1 shl logN) < n:\n        inc logN\n    assert height[tree.root] <=\
    \ 6 * logN\n    return height[tree.root]\n\nvar rng = initRand(20260910)\n\nproc\
    \ checkSmall(parent: seq[int], root: int) =\n    let n = parent.len\n    let tree\
    \ = initStaticTopTreeFromParent(parent, root)\n    discard checkStructure(tree)\n\
    \    var adj = newSeq[seq[int]](n)\n    for v in 0..<n:\n        if v != root:\n\
    \            adj[v].add(parent[v])\n            adj[parent[v]].add(v)\n    var\
    \ a, upMul, upAdd, downMul, downAdd = newSeq[int](n)\n    for v in 0..<n:\n  \
    \      a[v] = rng.rand(modulus - 1)\n        upMul[v] = rng.rand(modulus - 1)\n\
    \        upAdd[v] = rng.rand(modulus - 1)\n        downMul[v] = rng.rand(modulus\
    \ - 1)\n        downAdd[v] = rng.rand(modulus - 1)\n    upMul[root] = 1\n    downMul[root]\
    \ = 1\n    upAdd[root] = 0\n    downAdd[root] = 0\n\n    proc forward(v: int):\
    \ Forward =\n        Forward(first: tree.nodes[v].upper, last: v, mul: upMul[v],\
    \ add: upAdd[v], count: 1,\n            sum: (upMul[v] * a[v] + upAdd[v]) mod\
    \ modulus)\n\n    proc backward(v: int): Backward =\n        Backward(value: Forward(first:\
    \ v, last: tree.nodes[v].upper,\n            mul: downMul[v], add: downAdd[v],\
    \ count: 1, sum: a[v]))\n\n    proc naive(v, p: int): tuple[count, sum: int] =\n\
    \        result = (1, a[v])\n        for u in adj[v]:\n            if u == p:\n\
    \                continue\n            let sub = naive(u, v)\n            result.count\
    \ += sub.count\n            if parent[u] == v:\n                result.sum +=\
    \ upMul[u] * sub.sum + upAdd[u] * sub.count\n            else:\n             \
    \   result.sum += downMul[v] * sub.sum + downAdd[v] * sub.count\n            result.sum\
    \ = result.sum mod modulus\n\n    let fixed = initStaticTopTreeDP(tree, (0..<n).toSeq.mapIt(forward(it)),\
    \ compress, rake)\n    let reroot = initRerootingStaticTopTreeDP(tree,\n     \
    \   (0..<n).toSeq.mapIt(forward(it)), (0..<n).toSeq.mapIt(backward(it)),\n   \
    \     compress, rake, compressReverse, rakeAtRoot, rakeAtEnd)\n    for step in\
    \ 0..<20:\n        for v in 0..<n:\n            let answer = reroot.prod(v).value\n\
    \            assert answer.first == v and answer.last == -1\n            assert\
    \ (answer.count, answer.sum) == naive(v, -1)\n        assert fixed.getAll().count\
    \ == n\n        assert fixed.getAll().sum == naive(root, -1).sum\n        assert\
    \ fixed.getAll() == reroot.getAll()\n        let v = rng.rand(n - 1)\n       \
    \ if step mod 2 == 0 or v == root:\n            a[v] = rng.rand(modulus - 1)\n\
    \        else:\n            upMul[v] = rng.rand(modulus - 1)\n            upAdd[v]\
    \ = rng.rand(modulus - 1)\n            downMul[v] = rng.rand(modulus - 1)\n  \
    \          downAdd[v] = rng.rand(modulus - 1)\n            if step mod 4 == 1:\n\
    \                upMul[v] = 0\n                downMul[v] = 0\n        fixed.set(v,\
    \ forward(v))\n        reroot.set(v, forward(v), backward(v))\n\ncheckSmall(@[-1],\
    \ 0)\ncheckSmall(@[1, -1], 1)\ncheckSmall(@[-1, 0, 0, 0, 0, 0, 0, 0], 0)\ncheckSmall(@[-1,\
    \ 0, 1, 2, 3, 4, 5, 6], 0)\ncheckSmall(@[-1, 0, 0, 1, 1, 2, 2], 0)\nfor trial\
    \ in 0..<120:\n    let n = rng.rand(1..45)\n    var adj = newSeq[seq[int]](n)\n\
    \    for v in 1..<n:\n        let p = rng.rand(v - 1)\n        adj[v].add(p)\n\
    \        adj[p].add(v)\n    let root = rng.rand(n - 1)\n    var parent = newSeqWith(n,\
    \ -1)\n    var order = @[root]\n    var i = 0\n    while i < order.len:\n    \
    \    let v = order[i]\n        for u in adj[v]:\n            if u != parent[v]:\n\
    \                parent[u] = v\n                order.add(u)\n        inc i\n\
    \    checkSmall(parent, root)\n\nproc checkLarge(parent: seq[int]) =\n    let\
    \ n = parent.len\n    let tree = initStaticTopTreeFromParent(parent)\n    let\
    \ height = checkStructure(tree)\n    var calls = 0\n    proc merge(l, r: int):\
    \ int =\n        inc calls\n        l + r\n    let fixed = initStaticTopTreeDP(tree,\
    \ newSeqWith(n, 1), merge, merge)\n    let reroot = initRerootingStaticTopTreeDP(tree,\
    \ newSeqWith(n, 1), newSeqWith(n, 1),\n        merge, merge, merge, merge, merge)\n\
    \    for v in [0, n div 3, n div 2, n - 1]:\n        calls = 0\n        fixed.set(v,\
    \ 2)\n        assert calls <= height\n        assert fixed.getAll() == n + 1\n\
    \        calls = 0\n        reroot.set(v, 2, 2)\n        assert calls <= 2 * height\n\
    \        for r in [0, n div 2, n - 1]:\n            calls = 0\n            assert\
    \ reroot.prod(r) == n + 1\n            assert calls <= 2 * height + 2\n      \
    \  fixed.set(v, 1)\n        reroot.set(v, 1, 1)\n\nconst largeN = 200000\nblock:\n\
    \    var parent = newSeq[int](largeN)\n    parent[0] = -1\n    for v in 1..<largeN:\n\
    \        parent[v] = v - 1\n    checkLarge(parent)\nblock:\n    var parent = newSeq[int](largeN)\n\
    \    parent[0] = -1\n    checkLarge(parent)\nblock:\n    var parent = newSeq[int](largeN)\n\
    \    parent[0] = -1\n    for v in 1..<largeN:\n        parent[v] = if v < largeN\
    \ div 2: v - 1 else: v - largeN div 2\n    checkLarge(parent)\nblock:\n    var\
    \ parent = @[-1]\n    proc appendTree(root, size: int) =\n        if size <= 1:\n\
    \            return\n        var v = root\n        let chain = size div 2 + 1\n\
    \        for i in 1..<chain:\n            parent.add(v)\n            v = parent.high\n\
    \        if chain < size:\n            parent.add(root)\n            appendTree(parent.high,\
    \ size - chain)\n    appendTree(0, largeN)\n    assert parent.len == largeN\n\
    \    checkLarge(parent)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/tree/rerooting_static_top_tree_dp.nim
  - cplib/graph/graph.nim
  - cplib/tree/static_top_tree_dp.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/rerooting_static_top_tree_dp.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/static_top_tree.nim
  - cplib/tree/static_top_tree_dp.nim
  - cplib/graph/graph.nim
  - cplib/tree/static_top_tree.nim
  isVerificationFile: true
  path: verify/AI/static_top_tree_test.nim
  requiredBy: []
  timestamp: '2026-09-14 07:58:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_top_tree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_top_tree_test.nim
- /verify/verify/AI/static_top_tree_test.nim.html
title: verify/AI/static_top_tree_test.nim
---
