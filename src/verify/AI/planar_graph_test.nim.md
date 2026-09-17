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
    path: cplib/graph/planar_graph.nim
    title: cplib/graph/planar_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/planar_graph.nim
    title: cplib/graph/planar_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/random_helper.nim
    title: cplib/utils/random_helper.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/random_helper.nim
    title: cplib/utils/random_helper.nim
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
    import random\nimport cplib/graph/graph\nimport cplib/graph/planar_graph\nimport\
    \ cplib/utils/random_helper\n\nproc complete(n: int): UnWeightedUnDirectedGraph\
    \ =\n    result = initUnWeightedUnDirectedGraph(n)\n    for u in 0..<n:\n    \
    \    for v in u+1..<n: result.add_edge(u, v)\n\nassert initUnWeightedUnDirectedGraph(0).is_planar_graph()\n\
    assert initUnWeightedUnDirectedGraph(10).is_planar_graph()\nassert complete(4).is_planar_graph()\n\
    assert not complete(5).is_planar_graph()\nvar k33 = initUnWeightedUnDirectedGraph(6)\n\
    for u in 0..<3:\n    for v in 3..<6: k33.add_edge(u, v)\nassert not k33.is_planar_graph()\n\
    for base in [complete(5), k33]:\n    var subdivided = initUnWeightedUnDirectedGraph(base.len\
    \ + base.edge_count + 5)\n    for i, e in base.edge_info:\n        subdivided.add_edge(e.src,\
    \ base.len + i)\n        subdivided.add_edge(base.len + i, e.dst)\n    assert\
    \ not subdivided.is_planar_graph()\n    for removed in 0..<base.edge_count:\n\
    \        var subgraph = initUnWeightedUnDirectedGraph(base.len)\n        for i,\
    \ e in base.edge_info:\n            if i != removed: subgraph.add_edge(e.src,\
    \ e.dst)\n        assert subgraph.is_planar_graph()\nvar cube = initUnWeightedUnDirectedGraph(8)\n\
    for u in 0..<8:\n    for bit in 0..<3:\n        let v = u xor (1 shl bit)\n  \
    \      if u < v: cube.add_edge(u, v)\nassert cube.is_planar_graph()\nvar octahedron\
    \ = initUnWeightedUnDirectedGraph(6)\nfor u in 0..<6:\n    for v in u+1..<6:\n\
    \        if u div 2 != v div 2: octahedron.add_edge(u,v)\nassert octahedron.is_planar_graph()\n\
    var petersen = initUnWeightedUnDirectedGraph(10)\nfor u in 0..<5:\n    petersen.add_edge(u,(u+1)\
    \ mod 5)\n    petersen.add_edge(u,u+5)\n    petersen.add_edge(u+5,(u+2) mod 5+5)\n\
    assert not petersen.is_planar_graph()\nvar disconnected = initUnWeightedUnDirectedGraph(20)\n\
    for e in cube.edge_info: disconnected.add_edge(e.src,e.dst)\nfor e in k33.edge_info:\
    \ disconnected.add_edge(e.src+10,e.dst+10)\nassert not disconnected.is_planar_graph()\n\
    var multi = complete(4)\nfor u in 0..<4:\n    for v in 0..<4:\n        multi.add_edge(u,\
    \ v)\nassert multi.is_planar_graph()\nvar weighted = initWeightedUnDirectedGraph(6,\
    \ float)\nvar weightedStatic = initWeightedUnDirectedStaticGraph(6, float)\nvar\
    \ unweightedStatic = initUnWeightedUnDirectedStaticGraph(6)\nfor e in k33.edge_info:\n\
    \    weighted.add_edge(e.src, e.dst, 1.5)\n    weightedStatic.add_edge(e.src,\
    \ e.dst, 1.5)\n    unweightedStatic.add_edge(e.src, e.dst)\nassert not weighted.is_planar_graph()\n\
    assert not weightedStatic.is_planar_graph()\nassert not unweightedStatic.is_planar_graph()\n\
    weightedStatic.build()\nunweightedStatic.build()\nassert not weightedStatic.is_planar_graph()\n\
    assert not unweightedStatic.is_planar_graph()\nrandomize(20260917)\nfor n in 0..35:\n\
    \    let maximum = if n < 3: n*(n-1) div 2 else: 3*n-6\n    for m in 0..maximum:\n\
    \        let g = random_planar_graph(n, m)\n        assert g.len == n and g.edge_count\
    \ == m\n        assert g.is_planar_graph()\n        var seen = newSeq[bool](n*n)\n\
    \        for e in g.edge_info:\n            assert e.src != e.dst\n          \
    \  let index = min(e.src,e.dst)*n + max(e.src,e.dst)\n            assert not seen[index]\n\
    \            seen[index] = true\n        var occurrences = newSeq[int](m)\n  \
    \      for u in 0..<n:\n            for (v,id) in g.to_and_id(u):\n          \
    \      assert id in 0..<m\n                let e = g.get_edge(id)\n          \
    \      assert (e.src == u and e.dst == v) or (e.src == v and e.dst == u)\n   \
    \             inc occurrences[id]\n        for count in occurrences: assert count\
    \ == 2\nvar generatedOctahedron = false\nfor seed in 0..<500:\n    randomize(seed)\n\
    \    let g = random_planar_graph(6,12)\n    var regular = true\n    for u in 0..<6:\n\
    \        if g.edges[u].len != 4: regular = false\n    if regular:\n        generatedOctahedron\
    \ = true\n        break\nassert generatedOctahedron\nfor (n,m) in [(-1,0),(0,1),(1,1),(2,2),(3,4),(5,10),(5,-1)]:\n\
    \    var rejected = false\n    try: discard random_planar_graph(n,m)\n    except\
    \ AssertionDefect: rejected = true\n    assert rejected\nvar path = initUnWeightedUnDirectedGraph(100000)\n\
    for v in 1..<path.len: path.add_edge(v-1,v)\nassert path.is_planar_graph()\npath.add_edge(0,path.len-1)\n\
    assert path.is_planar_graph()\nassert random_planar_graph(100,294).is_planar_graph()\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/math/isprime.nim
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  - cplib/utils/random_helper.nim
  - cplib/graph/graph.nim
  - cplib/graph/planar_graph.nim
  - cplib/graph/graph.nim
  - cplib/utils/random_helper.nim
  - cplib/graph/planar_graph.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/AI/planar_graph_test.nim
  requiredBy: []
  timestamp: '2026-09-18 00:20:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/planar_graph_test.nim
layout: document
redirect_from:
- /verify/verify/AI/planar_graph_test.nim
- /verify/verify/AI/planar_graph_test.nim.html
title: verify/AI/planar_graph_test.nim
---
