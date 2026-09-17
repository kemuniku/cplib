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
    PROBLEM: https://judge.yosupo.jp/problem/point_set_tree_path_composite_sum_fixed_root
    links:
    - https://judge.yosupo.jp/problem/point_set_tree_path_composite_sum_fixed_root
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_tree_path_composite_sum_fixed_root\n\
    import sequtils, strutils\nimport atcoder/modint\nimport cplib/graph/graph\nimport\
    \ cplib/tree/heavylightdecomposition\nimport cplib/tree/static_top_tree\nimport\
    \ cplib/tree/static_top_tree_dp\n\nproc scanf(formatstr: cstring) {.header: \"\
    <stdio.h>\", varargs.}\nproc ii(): int = scanf(\"%lld\", addr result)\n\ntype\n\
    \    mint = modint998244353\n    Data = object\n        mul, add, count, sum:\
    \ mint\n\nproc compress(l, r: Data): Data =\n    Data(mul: l.mul * r.mul, add:\
    \ l.mul * r.add + l.add,\n        count: l.count + r.count, sum: l.sum + l.mul\
    \ * r.sum + l.add * r.count)\n\nproc rake(l, r: Data): Data =\n    Data(mul: l.mul,\
    \ add: l.add, count: l.count + r.count, sum: l.sum + r.sum)\n\nlet n = ii()\n\
    let q = ii()\nvar a = newSeqWith(n, mint(ii()))\nvar g = initUnWeightedUnDirectedStaticGraph(n)\n\
    var edges = newSeq[(int, int)](n - 1)\nvar b, c = newSeq[mint](n - 1)\nfor e in\
    \ 0..<n-1:\n    let u = ii()\n    let v = ii()\n    edges[e] = (u, v)\n    b[e]\
    \ = mint(ii())\n    c[e] = mint(ii())\n    g.add_edge(u, v)\ng.build()\nlet hld\
    \ = initHld(g, 0)\nlet tree = initStaticTopTree(hld)\nvar edgeChild = newSeq[int](n\
    \ - 1)\nvar mul = newSeqWith(n, mint(1))\nvar add = newSeq[mint](n)\nfor e, edge\
    \ in edges:\n    let (u, v) = edge\n    let child = if hld.parentOf(u) == v: u\
    \ else: v\n    edgeChild[e] = child\n    mul[child] = b[e]\n    add[child] = c[e]\n\
    \nproc leaf(v: int): Data =\n    Data(mul: mul[v], add: add[v], count: mint(1),\
    \ sum: mul[v] * a[v] + add[v])\n\nlet dp = initStaticTopTreeDP(tree, (0..<n).toSeq.mapIt(leaf(it)),\
    \ compress, rake)\nvar answers = newSeqOfCap[int](q)\nfor query in 0..<q:\n  \
    \  let kind = ii()\n    var v: int\n    if kind == 0:\n        v = ii()\n    \
    \    a[v] = mint(ii())\n    else:\n        v = edgeChild[ii()]\n        mul[v]\
    \ = mint(ii())\n        add[v] = mint(ii())\n    dp.set(v, leaf(v))\n    answers.add(dp.getAll().sum.val)\n\
    echo answers.join(\"\\n\")\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/static_top_tree.nim
  - cplib/graph/graph.nim
  - cplib/tree/static_top_tree_dp.nim
  - cplib/tree/static_top_tree_dp.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/static_top_tree.nim
  isVerificationFile: true
  path: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
  requiredBy: []
  timestamp: '2026-09-14 07:58:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
layout: document
redirect_from:
- /verify/verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
- /verify/verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim.html
title: verify/tree/point_set_tree_path_composite_sum_fixed_root_test.nim
---
