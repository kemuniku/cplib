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
    path: cplib/graph/remove_edge.nim
    title: cplib/graph/remove_edge.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/remove_edge.nim
    title: cplib/graph/remove_edge.nim
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
    import sequtils\nimport cplib/graph/graph\nimport cplib/graph/remove_edge\n\n\
    template checkGraph(init: untyped, weighted, undirected, isStatic: static bool)\
    \ =\n    block:\n        var g = init\n        template add(u, v, cost: int):\
    \ int =\n            when weighted: g.add_edge(u, v, cost)\n            else:\
    \ g.add_edge(u, v)\n        discard add(2, 0, 5)\n        discard add(0, 1, 7)\n\
    \        discard add(0, 1, 9)\n        discard add(0, 0, 11)\n        let original\
    \ = g.edge_info\n        when isStatic:\n            doAssert g.start.len == 0\n\
    \        for removed in 0..<g.edge_count:\n            var h = g.remove_edge(removed)\n\
    \            static: doAssert h is typeof(g)\n            doAssert h != g\n  \
    \          doAssert h.len == g.len\n            doAssert h.edge_count == 3\n \
    \           doAssert g.edge_info == original\n            when isStatic:\n   \
    \             doAssert g.start.len == 0\n            var expectedId = 0\n    \
    \        for oldId in 0..<g.edge_count:\n                if oldId == removed:\
    \ continue\n                doAssert h.get_edge(expectedId) == g.get_edge(oldId)\n\
    \                inc expectedId\n            for u in 0..<g.len:\n           \
    \     var expected: seq[tuple[dst, id: int]]\n                for id, e in h.edge_info:\n\
    \                    if e.src == u: expected.add((e.dst, id))\n              \
    \      when undirected:\n                        if e.dst == u: expected.add((e.src,\
    \ id))\n                doAssert toSeq(h.to_and_id(u)) == expected\n         \
    \       for (dst, cost, id) in h.to_and_cost_and_id(u):\n                    doAssert\
    \ (dst, id) in expected\n                    when weighted: doAssert cost == h.get_edge(id).cost\n\
    \                    else: doAssert cost == 1\n            when weighted: h.add_edge(1,\
    \ 2, 13)\n            else: h.add_edge(1, 2)\n            doAssert h.edge_count\
    \ == 4\n            doAssert g.edge_info == original\n        when isStatic: g.build()\n\
    \        let originalAdjacent = toSeq(g.to_and_id(0))\n        let all = toSeq(g.remove_each_edge())\n\
    \        doAssert all.len == 4\n        for id, h in all:\n            doAssert\
    \ h.edge_info == g.remove_edge(id).edge_info\n        doAssert toSeq(g.to_and_id(0))\
    \ == originalAdjacent\n        var h = all[0]\n        when weighted: h.add_edge(1,\
    \ 2, 17)\n        else: h.add_edge(1, 2)\n        doAssert all[1].edge_count ==\
    \ 3\n        doAssert g.edge_info == original\n        var single = init\n   \
    \     when weighted: single.add_edge(0, 0, 19)\n        else: single.add_edge(0,\
    \ 0)\n        let empty = single.remove_edge(0)\n        doAssert empty.len ==\
    \ single.len\n        doAssert empty.edge_count == 0\n        for u in 0..<empty.len:\n\
    \            doAssert toSeq(empty.to_and_id(u)).len == 0\n        doAssert toSeq(empty.remove_each_edge()).len\
    \ == 0\n        for id in [-1, g.edge_count, high(int)]:\n            var raised\
    \ = false\n            try: discard g.remove_edge(id)\n            except ValueError:\
    \ raised = true\n            doAssert raised\n        var raised = false\n   \
    \     try: discard empty.remove_edge(0)\n        except ValueError: raised = true\n\
    \        doAssert raised\n\ncheckGraph(initWeightedDirectedGraph(4), true, false,\
    \ false)\ncheckGraph(initWeightedUnDirectedGraph(4), true, true, false)\ncheckGraph(initUnWeightedDirectedGraph(4),\
    \ false, false, false)\ncheckGraph(initUnWeightedUnDirectedGraph(4), false, true,\
    \ false)\ncheckGraph(initWeightedDirectedStaticGraph(4), true, false, true)\n\
    checkGraph(initWeightedUnDirectedStaticGraph(4), true, true, true)\ncheckGraph(initUnWeightedDirectedStaticGraph(4),\
    \ false, false, true)\ncheckGraph(initUnWeightedUnDirectedStaticGraph(4), false,\
    \ true, true)\n\ntype Cost = object\n    name: string\n    value: float\nvar custom\
    \ = initWeightedUnDirectedStaticGraph(2, Cost)\ncustom.add_edge(0, 1, Cost(name:\
    \ \"first\", value: 1.5))\ncustom.add_edge(1, 0, Cost(name: \"second\", value:\
    \ 2.5))\nlet copied = custom.remove_edge(0)\ndoAssert copied.get_edge(0).cost\
    \ == Cost(name: \"second\", value: 2.5)\ndoAssert toSeq(copied[0]) == @[(1, Cost(name:\
    \ \"second\", value: 2.5))]\ndoAssert custom.edge_count == 2\nlet noVertices =\
    \ initUnWeightedDirectedGraph(0)\ndoAssert toSeq(noVertices.remove_each_edge()).len\
    \ == 0\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/remove_edge.nim
  - cplib/graph/remove_edge.nim
  isVerificationFile: true
  path: verify/graph/remove_edge_test.nim
  requiredBy: []
  timestamp: '2026-10-27 08:51:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/remove_edge_test.nim
layout: document
redirect_from:
- /verify/verify/graph/remove_edge_test.nim
- /verify/verify/graph/remove_edge_test.nim.html
title: verify/graph/remove_edge_test.nim
---
