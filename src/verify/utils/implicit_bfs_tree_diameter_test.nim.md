---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/implicit_bfs.nim
    title: cplib/utils/implicit_bfs.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/implicit_bfs.nim
    title: cplib/utils/implicit_bfs.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/tree_diameter
    links:
    - https://judge.yosupo.jp/problem/tree_diameter
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/tree_diameter\n\
    include cplib/tmpl/sheep\nimport cplib/utils/implicit_bfs\n\nlet N = ii()\nvar\
    \ edges = newSeq[seq[(int, int)]](N)\nvar neighbors = newSeq[seq[int]](N)\nfor\
    \ i in 0..<N - 1:\n    var a, b, c = ii()\n    edges[a].add((b, c))\n    edges[b].add((a,\
    \ c))\n    neighbors[a].add(b)\n    neighbors[b].add(a)\n\nlet adjacent: ImplicitBfsAdjacent[int]\
    \ = proc(v: int): seq[int] = neighbors[v]\n\nproc farthest(start: int): tuple[vertex,\
    \ cost: int] =\n    let restored = restore_implicit_bfs(@[start], adjacent)\n\
    \    var costs = newSeq[int](N)\n    var order = @[start]\n    var index = 0\n\
    \    result.vertex = start\n    # \u6728\u306E\u7D4C\u8DEF\u306F\u4E00\u610F\u306A\
    \u306E\u3067\u3001BFS \u306E\u89AA\u60C5\u5831\u306B\u6CBF\u3063\u3066\u5143\u306E\
    \u8FBA\u91CD\u307F\u3092\u7D2F\u7A4D\u3067\u304D\u308B\u3002\n    while index\
    \ < order.len:\n        let vertex = order[index]\n        inc index\n       \
    \ for (next, edgeCost) in edges[vertex]:\n            if restored.prev.hasKey(next)\
    \ and restored.prev[next] == vertex:\n                costs[next] = costs[vertex]\
    \ + edgeCost\n                order.add(next)\n                if costs[next]\
    \ > result.cost:\n                    result = (next, costs[next])\n\nlet first\
    \ = farthest(0).vertex\nlet (last, cost) = farthest(first)\nlet (path, _) = shortest_path_implicit_bfs(@[first],\
    \ @[last], adjacent)\necho cost, \" \", path.len\necho path.join(\" \")\n"
  dependsOn:
  - cplib/tmpl/sheep.nim
  - cplib/tmpl/fastio.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/fastio.nim
  - cplib/utils/implicit_bfs.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/implicit_bfs.nim
  isVerificationFile: true
  path: verify/utils/implicit_bfs_tree_diameter_test.nim
  requiredBy: []
  timestamp: '2026-10-17 20:24:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/implicit_bfs_tree_diameter_test.nim
layout: document
redirect_from:
- /verify/verify/utils/implicit_bfs_tree_diameter_test.nim
- /verify/verify/utils/implicit_bfs_tree_diameter_test.nim.html
title: verify/utils/implicit_bfs_tree_diameter_test.nim
---
