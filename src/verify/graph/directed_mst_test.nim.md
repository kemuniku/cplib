---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/directed_mst.nim
    title: cplib/graph/directed_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/directed_mst.nim
    title: cplib/graph/directed_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/directedmst
    links:
    - https://judge.yosupo.jp/problem/directedmst
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/directedmst\n\
    import cplib/graph/graph\nimport cplib/graph/directed_mst\nimport options\ninclude\
    \ cplib/tmpl/fastio\nlet n = ii()\nlet m = ii()\nlet root = ii()\nvar g = initWeightedDirectedStaticGraph(n,\
    \ int64, capacity = m)\nfor id in 0..<m:\n    let u = ii()\n    let v = ii()\n\
    \    let w = int64(ii())\n    g.add_edge(u, v, w)\nlet tree = g.directedMST(root).get()\n\
    var parents = newSeq[int](n)\nparents[root] = root\nfor v in 0..<n:\n    if v\
    \ != root: parents[v] = g.edge_info[tree.inEdge[v]].src\necho tree.cost\necho\
    \ parents.join(\" \")\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/math/int128.nim
  - cplib/collections/lazy_leftist_heap.nim
  - cplib/math/int128.nim
  - cplib/graph/directed_mst.nim
  - cplib/graph/directed_mst.nim
  - cplib/collections/lazy_leftist_heap.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/graph/directed_mst_test.nim
  requiredBy: []
  timestamp: '2026-10-04 00:13:01+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/directed_mst_test.nim
layout: document
redirect_from:
- /verify/verify/graph/directed_mst_test.nim
- /verify/verify/graph/directed_mst_test.nim.html
title: verify/graph/directed_mst_test.nim
---
