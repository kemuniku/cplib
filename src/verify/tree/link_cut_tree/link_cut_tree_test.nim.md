---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tree/lazy_subtree_link_cut_tree.nim
    title: cplib/tree/lazy_subtree_link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/lazy_subtree_link_cut_tree.nim
    title: cplib/tree/lazy_subtree_link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/link_cut_tree.nim
    title: cplib/tree/link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/link_cut_tree.nim
    title: cplib/tree/link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/private/link_cut_tree_base.nim
    title: cplib/tree/private/link_cut_tree_base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/private/link_cut_tree_base.nim
    title: cplib/tree/private/link_cut_tree_base.nim
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
    import algorithm, random, sequtils\nimport cplib/tree/link_cut_tree\nimport cplib/tree/lazy_subtree_link_cut_tree\n\
    \ntype SumCount = tuple[sum: int64, count: int]\ntype Affine = tuple[a, b: int64]\n\
    const Mod = 998244353'i64\n\nproc merge(l, r: SumCount): SumCount =\n    (sum:\
    \ l.sum + r.sum, count: l.count + r.count)\nproc inverse(x: SumCount): SumCount\
    \ =\n    (sum: -x.sum, count: -x.count)\nproc mapping(f: int64, x: SumCount):\
    \ SumCount =\n    (sum: x.sum + f * int64(x.count), count: x.count)\nproc composition(f,\
    \ g: int64): int64 = f + g\nproc inverseAction(f: int64): int64 = -f\nproc compose(l,\
    \ r: Affine): Affine =\n    (a: l.a * r.a mod Mod, b: (l.b * r.a + r.b) mod Mod)\n\
    \nproc vertices(adj: seq[seq[int]], start: int, blocked = -1): seq[int] =\n  \
    \  var seen = newSeq[bool](adj.len)\n    if blocked >= 0: seen[blocked] = true\n\
    \    seen[start] = true\n    result = @[start]\n    var i = 0\n    while i < result.len:\n\
    \        for v in adj[result[i]]:\n            if not seen[v]:\n             \
    \   seen[v] = true\n                result.add(v)\n        inc i\n\nproc path(adj:\
    \ seq[seq[int]], u, v: int): seq[int] =\n    var parent = newSeqWith(adj.len,\
    \ -1)\n    parent[u] = u\n    var queue = @[u]\n    var i = 0\n    while i < queue.len:\n\
    \        for x in adj[queue[i]]:\n            if parent[x] == -1:\n          \
    \      parent[x] = queue[i]\n                queue.add(x)\n        inc i\n   \
    \ if parent[v] == -1: return\n    var x = v\n    while x != u:\n        result.add(x)\n\
    \        x = parent[x]\n    result.add(u)\n    result.reverse()\n\nproc total(values:\
    \ seq[int64], ids: seq[int]): SumCount =\n    result.count = ids.len\n    for\
    \ v in ids: result.sum += values[v]\n\nblock:\n    let empty = newLinkCutTreeWith(0,\
    \ l + r, 0)\n    doAssert empty.len == 0\n    let single = newLinkCutTreeWith(1,\
    \ l & r, \"\")\n    single[0] = \"abc\"\n    doAssert single.get(0, 0) == \"abc\"\
    \n    doAssert single.findRoot(0) == 0\n    doAssert single.connected(0, 0)\n\
    \    let sums = initLinkCutTree(3, merge, (sum: 0'i64, count: 0), inverse)\n \
    \   sums.link(0, 1)\n    sums.link(2, 1)\n    sums.update(0, (sum: 1000000000000'i64,\
    \ count: 1))\n    doAssert sums.componentProd(2) == (sum: 1000000000000'i64, count:\
    \ 1)\n\nblock:\n    type Shift = object\n        value: int64\n    proc shiftedMerge(l,\
    \ r: SumCount): SumCount =\n        (sum: l.sum + r.sum - 11, count: l.count +\
    \ r.count)\n    proc shiftedInverse(x: SumCount): SumCount =\n        (sum: 22\
    \ - x.sum, count: -x.count)\n    proc shift(f: Shift, x: SumCount): SumCount =\n\
    \        (sum: x.sum + (f.value - 7) * int64(x.count), count: x.count)\n    proc\
    \ shiftCompose(f, g: Shift): Shift = Shift(value: f.value + g.value - 7)\n   \
    \ proc shiftInverse(f: Shift): Shift = Shift(value: 14 - f.value)\n    proc `==`(f,\
    \ g: Shift): bool {.error: \"\u4F5C\u7528\u306B\u7B49\u5024\u6BD4\u8F03\u306F\u4E0D\
    \u8981\".}\n\n    let tree = initLazySubtreeLinkCutTree(\n        3, shiftedMerge,\
    \ (sum: 11'i64, count: 0), shift, shiftCompose,\n        Shift(value: 7), shiftedInverse,\
    \ shiftInverse\n    )\n    doAssert tree.len == 3\n    tree[0] = (sum: 12'i64,\
    \ count: 1)\n    tree[1] = (sum: 13'i64, count: 1)\n    tree[2] = (sum: 14'i64,\
    \ count: 1)\n    tree.link(0, 1)\n    tree.componentApply(0, Shift(value: 17))\n\
    \    tree.link(1, 2)\n    doAssert tree[2] == (sum: 14'i64, count: 1)\n    tree.subtreeApply(1,\
    \ 0, Shift(value: 27))\n    doAssert tree.componentProd(0) == (sum: 77'i64, count:\
    \ 3)\n    doAssert tree.subtreeProd(2, 1) == (sum: 34'i64, count: 1)\n    tree.pathApply(0,\
    \ 1, Shift(value: 12))\n    tree.pathApply(1, 1, Shift(value: 4))\n    doAssert\
    \ tree.componentProd(0) == (sum: 84'i64, count: 3)\n    doAssert tree.subtreeProd(2,\
    \ 1) == (sum: 34'i64, count: 1)\n\nblock:\n    let initial = (1..6).toSeq.mapIt((sum:\
    \ int64(it), count: 1))\n    let tree = initLazySubtreeLinkCutTree(initial, merge,\
    \ (sum: 0'i64, count: 0),\n        mapping, composition, 0'i64, inverse, inverseAction)\n\
    \    for (u, v) in [(0, 1), (1, 2), (1, 3), (0, 4), (4, 5)]: tree.link(u, v)\n\
    \    tree.pathApply(2, 5, 10)\n    tree.subtreeApply(1, 0, 20)\n    tree.componentApply(0,\
    \ -5)\n    tree.pathApply(3, 2, -7)\n    tree.pathApply(2, 3, 3)\n    tree[1]\
    \ = (sum: 100'i64, count: 1)\n    doAssert tree.pathProd(2, 5) == (sum: 151'i64,\
    \ count: 5)\n    doAssert tree.componentProd(0) == (sum: 166'i64, count: 6)\n\
    \    doAssert tree.subtreeProd(1, 0) == (sum: 139'i64, count: 3)\n    tree.cut(1,\
    \ 0)\n    tree.componentApply(0, 1000)\n    tree.link(1, 5)\n    tree.pathApply(0,\
    \ 2, -2)\n    tree.pathApply(2, 3, 0)\n    let expected = [1004'i64, 98, 22, 15,\
    \ 1008, 1009]\n    for v in 0..<6: doAssert tree[v] == (sum: expected[v], count:\
    \ 1)\n    doAssert tree.subtreeProd(1, 5) == (sum: 135'i64, count: 3)\n    doAssert\
    \ tree.componentProd(0) == (sum: 3156'i64, count: 6)\n\nblock:\n    let tree =\
    \ newLazySubtreeLinkCutTreeWith(\n        newSeqWith(8, (sum: 0'i64, count: 1)),\n\
    \        (sum: l.sum + r.sum, count: l.count + r.count), (sum: 0'i64, count: 0),\n\
    \        (sum: x.sum + f * int64(x.count), count: x.count), f + g, 0'i64,\n  \
    \      (sum: -x.sum, count: -x.count), -f\n    )\n    for v in 1..<8: tree.link(v,\
    \ 0)\n    for i in 0..<100:\n        tree.componentApply(i mod 8, int64(i + 1))\n\
    \    tree.cut(0, 1)\n    tree.componentApply(0, 10000)\n    tree.link(1, 7)\n\
    \    doAssert tree[1].sum == 5050\n    doAssert tree.subtreeProd(1, 7).sum ==\
    \ 5050\n    doAssert tree.componentProd(1).sum == 5050 * 8 + 70000\n\nvar rng\
    \ = initRand(840173)\nfor trial in 0..<24:\n    let n = if trial == 0: 1 else:\
    \ rng.rand(2..32)\n    var adj = newSeq[seq[int]](n)\n    var values = newSeqWith(n,\
    \ int64(rng.rand(-100..100)))\n    var functions = newSeqWith(n, (a: int64(rng.rand(0..100)),\
    \ b: int64(rng.rand(0..100))))\n    let initial = values.mapIt((sum: it, count:\
    \ 1))\n    let tree = initLinkCutTree(initial, merge, (sum: 0'i64, count: 0),\
    \ inverse)\n    let lazy = initLazySubtreeLinkCutTree(initial, merge, (sum: 0'i64,\
    \ count: 0),\n        mapping, composition, 0'i64, inverse, inverseAction)\n \
    \   let affine = initLinkCutTree(functions, compose, (a: 1'i64, b: 0'i64))\n\n\
    \    proc linkAll(u, v: int) =\n        adj[u].add(v)\n        adj[v].add(u)\n\
    \        tree.link(u, v)\n        lazy.link(u, v)\n        affine.link(u, v)\n\
    \n    proc cutAll(u, v: int) =\n        adj[u].delete(adj[u].find(v))\n      \
    \  adj[v].delete(adj[v].find(u))\n        tree.cut(u, v)\n        lazy.cut(u,\
    \ v)\n        affine.cut(u, v)\n\n    proc checkPath(u, v: int) =\n        let\
    \ ids = path(adj, u, v)\n        doAssert tree.connected(u, v) == (ids.len > 0)\n\
    \        doAssert lazy.connected(u, v) == (ids.len > 0)\n        doAssert affine.connected(u,\
    \ v) == (ids.len > 0)\n        if ids.len == 0: return\n        let expected =\
    \ total(values, ids)\n        doAssert tree.pathProd(u, v) == expected\n     \
    \   doAssert lazy.pathProd(u, v) == expected\n        var x = 12345'i64\n    \
    \    for id in ids: x = (functions[id].a * x + functions[id].b) mod Mod\n    \
    \    let f = affine.get(u, v)\n        doAssert (f.a * 12345 + f.b) mod Mod ==\
    \ x\n\n    for v in 1..<n:\n        let p = if trial mod 3 == 0: 0 elif trial\
    \ mod 3 == 1: v - 1 else: rng.rand(v - 1)\n        linkAll(v, p)\n\n    for step\
    \ in 0..<800:\n        let u = rng.rand(n - 1)\n        let v = rng.rand(n - 1)\n\
    \        case rng.rand(0..10)\n        of 0:\n            if path(adj, u, v).len\
    \ == 0: linkAll(u, v)\n        of 1:\n            if adj[u].len > 0: cutAll(u,\
    \ adj[u][rng.rand(adj[u].high)])\n        of 2:\n            values[u] = int64(rng.rand(-1000..1000))\n\
    \            tree[u] = (sum: values[u], count: 1)\n            lazy[u] = (sum:\
    \ values[u], count: 1)\n            functions[u] = (a: int64(rng.rand(0..100)),\
    \ b: int64(rng.rand(0..100)))\n            affine[u] = functions[u]\n        of\
    \ 3:\n            let f = int64(rng.rand(-100..100))\n            lazy.componentApply(u,\
    \ f)\n            for x in vertices(adj, u):\n                values[x] += f\n\
    \                tree[x] = (sum: values[x], count: 1)\n        of 4:\n       \
    \     if adj[u].len > 0:\n                let p = adj[u][rng.rand(adj[u].high)]\n\
    \                let f = int64(rng.rand(-100..100))\n                lazy.subtreeApply(u,\
    \ p, f)\n                for x in vertices(adj, u, p):\n                    values[x]\
    \ += f\n                    tree[x] = (sum: values[x], count: 1)\n        of 5,\
    \ 6:\n            checkPath(u, v)\n            checkPath(v, u)\n        of 7:\n\
    \            tree.makeRoot(u)\n            lazy.makeRoot(u)\n            affine.makeRoot(u)\n\
    \            for x in vertices(adj, u):\n                doAssert tree.findRoot(x)\
    \ == u\n                doAssert lazy.findRoot(x) == u\n                doAssert\
    \ affine.findRoot(x) == u\n        of 8, 9:\n            let ids = path(adj, u,\
    \ v)\n            if ids.len > 0:\n                let f = int64(rng.rand(-100..100))\n\
    \                lazy.pathApply(u, v, f)\n                for x in ids:\n    \
    \                values[x] += f\n                    tree[x] = (sum: values[x],\
    \ count: 1)\n        else:\n            if adj[u].len > 0:\n                let\
    \ p = adj[u][rng.rand(adj[u].high)]\n                let expected = total(values,\
    \ vertices(adj, u, p))\n                doAssert tree.subtreeProd(u, p) == expected\n\
    \                doAssert lazy.subtreeProd(u, p) == expected\n\n        if step\
    \ mod 17 == 0:\n            for x in 0..<n:\n                doAssert tree[x]\
    \ == (sum: values[x], count: 1)\n                doAssert lazy[x] == (sum: values[x],\
    \ count: 1)\n                let expected = total(values, vertices(adj, x))\n\
    \                doAssert tree.componentProd(x) == expected\n                doAssert\
    \ lazy.componentProd(x) == expected\n    for u in 0..<n:\n        for v in 0..<n:\
    \ checkPath(u, v)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/tree/link_cut_tree.nim
  - cplib/tree/lazy_subtree_link_cut_tree.nim
  - cplib/tree/link_cut_tree.nim
  - cplib/tree/lazy_subtree_link_cut_tree.nim
  - cplib/tree/private/link_cut_tree_base.nim
  - cplib/tree/private/link_cut_tree_base.nim
  isVerificationFile: true
  path: verify/tree/link_cut_tree/link_cut_tree_test.nim
  requiredBy: []
  timestamp: '2026-09-10 04:41:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/link_cut_tree/link_cut_tree_test.nim
layout: document
redirect_from:
- /verify/verify/tree/link_cut_tree/link_cut_tree_test.nim
- /verify/verify/tree/link_cut_tree/link_cut_tree_test.nim.html
title: verify/tree/link_cut_tree/link_cut_tree_test.nim
---
