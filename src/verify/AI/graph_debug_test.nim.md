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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport os, strutils\nimport cplib/graph/graph\nimport\
    \ cplib/graph/graph_debug\n\nvar g = initWeightedDirectedGraph(3)\ng.add_edge(0,\
    \ 1, 5)\ng.add_edge(1, 2, 7)\nlet url = g.to_graph_graph(true)\nassert url.contains(\"\
    indexed=true\")\nassert url.contains(\"weighted=true\")\nassert url.contains(\"\
    directed=true\")\nassert url.contains(\"%0A1+2+5\")\n\nlet path = \"/tmp/cplib_graph_debug_ai_test.txt\"\
    \nvar f = open(path, fmWrite)\ng.dump_graph(f)\nf.close()\nassert readFile(path).strip\
    \ == \"3 2\\n0 1 5\\n1 2 7\"\n\nvar ug = initUnWeightedUnDirectedGraph(3)\nug.add_edge(0,\
    \ 2)\nassert ug.to_graph_graph(false).contains(\"weighted=false\")\nremoveFile(path)\n\
    \nproc checkDump(g: DirectedGraph or UnDirectedGraph, expected: string) =\n  \
    \  var f = open(path, fmWrite)\n    g.dump_graph(1, f)\n    f.close()\n    assert\
    \ readFile(path).strip == expected\n    f = open(path, fmWrite)\n    g.dump_graph(indexed\
    \ = 1, output = f)\n    f.close()\n    assert readFile(path).strip == expected\n\
    \    f = open(path, fmWrite)\n    g.dump_graph(output = f)\n    f.close()\n  \
    \  removeFile(path)\n\ncheckDump(g, \"3 2\\n1 2 5\\n2 3 7\")\ncheckDump(ug, \"\
    3 1\\n1 3\")\nvar ud = initUnWeightedDirectedGraph(3)\nvar wu = initWeightedUnDirectedGraph(3)\n\
    var uds = initUnWeightedDirectedStaticGraph(3)\nvar uus = initUnWeightedUnDirectedStaticGraph(3)\n\
    var wds = initWeightedDirectedStaticGraph(3)\nvar wus = initWeightedUnDirectedStaticGraph(3)\n\
    ud.add_edge(2, 0)\nwu.add_edge(2, 0, 8)\nuds.add_edge(2, 0)\nuus.add_edge(2, 0)\n\
    wds.add_edge(2, 0, 8)\nwus.add_edge(2, 0, 8)\nuds.build()\nuus.build()\nwds.build()\n\
    wus.build()\ncheckDump(ud, \"3 1\\n3 1\")\ncheckDump(wu, \"3 1\\n1 3 8\")\ncheckDump(uds,\
    \ \"3 1\\n3 1\")\ncheckDump(uus, \"3 1\\n1 3\")\ncheckDump(wds, \"3 1\\n3 1 8\"\
    )\ncheckDump(wus, \"3 1\\n1 3 8\")\nf = open(path, fmWrite)\ng.dump_graph(10,\
    \ f)\nf.close()\nassert readFile(path).strip == \"3 2\\n10 11 5\\n11 12 7\"\n\
    removeFile(path)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph_debug.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph_debug.nim
  isVerificationFile: true
  path: verify/AI/graph_debug_test.nim
  requiredBy: []
  timestamp: '2026-09-18 00:20:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/graph_debug_test.nim
layout: document
redirect_from:
- /verify/verify/AI/graph_debug_test.nim
- /verify/verify/AI/graph_debug_test.nim.html
title: verify/AI/graph_debug_test.nim
---
