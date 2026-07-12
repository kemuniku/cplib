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
    echo \"Hello World\"\n\nimport algorithm, sequtils\nimport cplib/graph/graph\n\
    import cplib/tree/heavylightdecomposition\n\nvar g = initUnWeightedUnDirectedStaticGraph(6)\n\
    g.add_edge(0, 1)\ng.add_edge(0, 2)\ng.add_edge(1, 3)\ng.add_edge(1, 4)\ng.add_edge(2,\
    \ 5)\ng.build()\n\nlet hld = g.initHld(0)\nassert hld.numVertices == 6\nassert\
    \ hld.parentOf(0) == -1\nassert hld.parentOf(3) == 1\nassert hld.depth(5) == 2\n\
    for v in 0..<6:\n  assert hld.toVtx(hld.toSeq(v)) == v\n\nassert hld.lca(3, 4)\
    \ == 1\nassert hld.lca(3, 5) == 0\nassert hld.dist(3, 5) == 4\nassert hld.median(3,\
    \ 4, 5) == 1\nassert hld.la(3, 5, 0) == 3\nassert hld.la(3, 5, 1) == 1\nassert\
    \ hld.la(3, 5, 2) == 0\nassert hld.la(3, 5, 4) == 5\nassert hld.la(3, 5, 5) ==\
    \ -1\n\nvar subtree: seq[int]\nfor v in hld.subtreeV(1):\n  subtree.add(v)\nsubtree.sort()\n\
    assert subtree == @[1, 3, 4]\n\nvar children: seq[int]\nfor v in hld.children(1):\n\
    \  children.add(v)\nchildren.sort()\nassert children == @[3, 4]\n\nlet aux = hld.initAuxiliaryTree(@[3,\
    \ 4, 5])\nvar auxVertices = aux.v\nauxVertices.sort()\nassert auxVertices == @[0,\
    \ 1, 3, 4, 5]\n\nlet waux = hld.initAuxiliaryWeightedTree(@[3, 5])\nassert waux.v\
    \ == @[0, 3, 5]\nvar weightedEdges = waux.graph.edges[0].mapIt((it[0].int, it[1]))\n\
    weightedEdges.sort()\nassert weightedEdges == @[(1, 2), (2, 2)]\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/heavylightdecomposition_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/heavylightdecomposition_test.nim
layout: document
redirect_from:
- /verify/verify/AI/heavylightdecomposition_test.nim
- /verify/verify/AI/heavylightdecomposition_test.nim.html
title: verify/AI/heavylightdecomposition_test.nim
---
