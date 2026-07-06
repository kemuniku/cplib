---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph_debug.nim
    title: cplib/graph/graph_debug.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph_debug.nim
    title: cplib/graph/graph_debug.nim
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import os, strutils

    import cplib/graph/graph

    import cplib/graph/graph_debug


    var g = initWeightedDirectedGraph(3)

    g.add_edge(0, 1, 5)

    g.add_edge(1, 2, 7)

    let url = g.to_graph_graph(true)

    assert url.contains("indexed=true")

    assert url.contains("weighted=true")

    assert url.contains("directed=true")

    assert url.contains("%0A1+2+5")


    let path = "/tmp/cplib_graph_debug_ai_test.txt"

    var f = open(path, fmWrite)

    g.dump_graph(f)

    f.close()

    assert readFile(path).strip == "3 2\n0 1 5\n1 2 7"


    var ug = initUnWeightedUnDirectedGraph(3)

    ug.add_edge(0, 2)

    assert ug.to_graph_graph(false).contains("weighted=false")

    removeFile(path)

    '
  dependsOn:
  - cplib/graph/graph_debug.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph_debug.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/graph_debug_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/graph_debug_test.nim
layout: document
redirect_from:
- /verify/verify/AI/graph_debug_test.nim
- /verify/verify/AI/graph_debug_test.nim.html
title: verify/AI/graph_debug_test.nim
---
