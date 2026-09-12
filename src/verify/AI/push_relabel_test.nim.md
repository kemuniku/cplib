---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/push_relabel.nim
    title: cplib/graph/push_relabel.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/push_relabel.nim
    title: cplib/graph/push_relabel.nim
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
    import cplib/graph/push_relabel\nimport random\n\nproc cutCapacity(g: PushRelabel[int64],\
    \ n, src, dst: int): int64 =\n    result = high(int64)\n    let edges = g.get_edges()\n\
    \    for mask in 0..<(1 shl n):\n        if (mask and (1 shl src)) == 0 or (mask\
    \ and (1 shl dst)) != 0:\n            continue\n        var capacity = 0'i64\n\
    \        for e in edges:\n            if (mask and (1 shl e.src)) != 0 and (mask\
    \ and (1 shl e.dst)) == 0:\n                capacity += e.cap\n        result\
    \ = min(result, capacity)\n\nproc checkFlow(g: PushRelabel[int64], n, src, dst:\
    \ int, total: int64) =\n    var balance = newSeq[int64](n)\n    for e in g.get_edges():\n\
    \        doAssert e.flow >= 0 and e.flow <= e.cap\n        balance[e.src] -= e.flow\n\
    \        balance[e.dst] += e.flow\n    for v in 0..<n:\n        if v == src:\n\
    \            doAssert balance[v] == -total\n        elif v == dst:\n         \
    \   doAssert balance[v] == total\n        else:\n            doAssert balance[v]\
    \ == 0\n\nblock:\n    var g = initPushRelabel(3)\n    doAssert g is PushRelabel[int]\n\
    \    doAssert g.add_edge(0, 0, 7) == 0\n    g.add_edge(0, 1, 5)\n    g.add_edge(0,\
    \ 1, 2)\n    g.add_edge(1, 2, 6)\n    doAssert g.flow(0, 2, 0) == 0\n    doAssert\
    \ g.flow(0, 2, 2) == 2\n    doAssert g.flow(0, 2) == 4\n    doAssert g.flow(0,\
    \ 2) == 0\n    doAssert g.get_edge(0).cap == 7 and g.get_edge(0).flow == 0\n \
    \   doAssert g.min_cut(0) == @[true, true, false]\n    doAssert g.flow(2, 0) ==\
    \ 6\n    for e in g.get_edges():\n        doAssert e.flow == 0\n\nblock:\n   \
    \ var g = initPushRelabel[int32](5)\n    g.add_edge(0, 1, 100)\n    g.add_edge(1,\
    \ 2, 100)\n    g.add_edge(2, 1, 100)\n    doAssert g.flow(0, 4) == 0\n    for\
    \ e in g.get_edges():\n        doAssert e.flow == 0\n    g.add_edge(2, 4, 3)\n\
    \    doAssert g.flow(0, 4) == 3\n\nblock:\n    var g = initPushRelabel[uint64](4)\n\
    \    let capacity = high(uint64)\n    g.add_edge(0, 1, capacity)\n    g.add_edge(0,\
    \ 2, capacity)\n    g.add_edge(1, 3, 1)\n    g.add_edge(2, 3, 2)\n    doAssert\
    \ g.flow(0, 3) == 3\n    doAssert g.get_edge(0).flow == 1\n    doAssert g.get_edge(1).flow\
    \ == 2\n    doAssert g.flow(0, 3) == 0\n\nblock:\n    var g = initPushRelabel[uint64](4)\n\
    \    let capacity = high(uint64)\n    g.add_edge(0, 1, capacity)\n    g.add_edge(1,\
    \ 2, capacity)\n    g.add_edge(2, 3, capacity)\n    doAssert g.flow(0, 3, capacity\
    \ - 1) == capacity - 1\n    doAssert g.flow(0, 3) == 1\n\nblock:\n    var g =\
    \ initPushRelabel[int64](4)\n    let capacity = high(int64)\n    g.add_edge(0,\
    \ 1, capacity)\n    g.add_edge(0, 2, capacity)\n    g.add_edge(1, 3, capacity)\n\
    \    g.add_edge(2, 3, capacity)\n    doAssert g.flow(0, 3) == capacity\n    doAssert\
    \ g.flow(0, 3) == capacity\n    doAssert g.flow(0, 3) == 0\n\nvar rng = initRand(947125)\n\
    for trial in 0..<1000:\n    let n = rng.rand(2..8)\n    let src = rng.rand(n -\
    \ 1)\n    let dst = (src + rng.rand(1..<n)) mod n\n    var g = initPushRelabel[int64](n)\n\
    \    for i in 0..<rng.rand(0..50):\n        g.add_edge(rng.rand(n - 1), rng.rand(n\
    \ - 1), int64(rng.rand(0..100)))\n    let original = g.get_edges()\n    let maximum\
    \ = g.cutCapacity(n, src, dst)\n    var total = 0'i64\n    while true:\n     \
    \   let limit = int64(rng.rand(1..150))\n        let added = g.flow(src, dst,\
    \ limit)\n        doAssert added >= 0 and added <= limit\n        total += added\n\
    \        g.checkFlow(n, src, dst, total)\n        if added < limit:\n        \
    \    break\n    doAssert total == maximum\n    let cut = g.min_cut(src)\n    doAssert\
    \ cut[src] and not cut[dst]\n    var capacity = 0'i64\n    for i, e in g.get_edges():\n\
    \        doAssert e.cap == original[i].cap\n        doAssert e.src == original[i].src\
    \ and e.dst == original[i].dst\n        if cut[e.src] and not cut[e.dst]:\n  \
    \          capacity += e.cap\n    doAssert capacity == maximum\n    for i in 0..<5:\n\
    \        g.add_edge(rng.rand(n - 1), rng.rand(n - 1), int64(rng.rand(0..100)))\n\
    \    total += g.flow(src, dst)\n    doAssert total == g.cutCapacity(n, src, dst)\n\
    \    g.checkFlow(n, src, dst, total)\n\nblock:\n    const components = 1000\n\
    \    const src = 3 * components\n    const dst = src + 1\n    var g = initPushRelabel[int64](dst\
    \ + 1)\n    for i in 0..<components:\n        g.add_edge(src, 3 * i, 1)\n    \
    \    g.add_edge(src, 3 * i + 1, 1)\n        g.add_edge(3 * i, 3 * i + 2, 1)\n\
    \        g.add_edge(3 * i + 1, 3 * i + 2, 1)\n        g.add_edge(3 * i + 2, dst,\
    \ 1)\n    doAssert g.flow(src, dst) == components\n    g.checkFlow(dst + 1, src,\
    \ dst, components)\n    doAssert g.flow(src, dst) == 0\n\nblock:\n    const n\
    \ = 100000\n    var g = initPushRelabel[int](n)\n    for v in 0..<n - 1:\n   \
    \     g.add_edge(v, v + 1, 1)\n    doAssert g.flow(0, n - 1) == 1\n    doAssert\
    \ g.get_edges().len == n - 1\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/push_relabel.nim
  - cplib/graph/push_relabel.nim
  isVerificationFile: true
  path: verify/AI/push_relabel_test.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/push_relabel_test.nim
layout: document
redirect_from:
- /verify/verify/AI/push_relabel_test.nim
- /verify/verify/AI/push_relabel_test.nim.html
title: verify/AI/push_relabel_test.nim
---
