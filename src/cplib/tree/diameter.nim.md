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
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_dynamic_test.nim
    title: verify/tree/diameter_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_dynamic_test.nim
    title: verify/tree/diameter_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_dynamic_test.nim
    title: verify/tree/diameter_path_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_dynamic_test.nim
    title: verify/tree/diameter_path_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_static_test.nim
    title: verify/tree/diameter_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_static_test.nim
    title: verify/tree/diameter_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_static_test.nim
    title: verify/tree/diameter_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_static_test.nim
    title: verify/tree/diameter_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_yosupo_test.nim
    title: verify/tree/diameter_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_yosupo_test.nim
    title: verify/tree/diameter_yosupo_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TREE_DIAMETER:\n    const CPLIB_TREE_DIAMETER* =\
    \ 1\n    import cplib/tree/tree\n    proc diameter_and_edge*(g: TreeTypes): auto\
    \ =\n        var u, v: int\n        when g is WeightedTreeTypes:\n           \
    \ type Cost = g.T\n        else:\n            type Cost = int\n        var cur\
    \ = Cost(0)\n        proc dfs(x, par: int, d: Cost, u: var int) =\n          \
    \  if d > cur:\n                cur = d\n                u = x\n            for\
    \ (y, cost) in g.to_and_cost(x):\n                if y == par: continue\n    \
    \            dfs(y, x, d + cost, u)\n        dfs(0, -1, Cost(0), u)\n        cur\
    \ = Cost(0)\n        dfs(u, -1, Cost(0), v)\n        return (cur, u, v)\n\n  \
    \  proc diameter*(g: TreeTypes): auto =\n        var (d, _, _) = g.diameter_and_edge\n\
    \        return d\n\n    proc diameter_path*(g: TreeTypes): auto =\n        var\
    \ (d, u, v) = g.diameter_and_edge\n        var path = newSeq[int]()\n        proc\
    \ dfs(x, par: int): bool =\n            result = false\n            path.add(x)\n\
    \            if x == v: return true\n            for (y, cost) in g.to_and_cost(x):\n\
    \                if y == par: continue\n                result = result or dfs(y,\
    \ x)\n                if result: break\n            if not result:\n         \
    \       discard path.pop\n        discard dfs(u, -1)\n        return (d, path)\n"
  dependsOn:
  - cplib/tree/tree.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/tree.nim
  isVerificationFile: false
  path: cplib/tree/diameter.nim
  requiredBy: []
  timestamp: '2024-04-23 22:14:31+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/diameter_path_static_test.nim
  - verify/tree/diameter_path_static_test.nim
  - verify/tree/diameter_path_dynamic_test.nim
  - verify/tree/diameter_path_dynamic_test.nim
  - verify/tree/diameter_static_test.nim
  - verify/tree/diameter_static_test.nim
  - verify/tree/diameter_yosupo_test.nim
  - verify/tree/diameter_yosupo_test.nim
  - verify/tree/diameter_dynamic_test.nim
  - verify/tree/diameter_dynamic_test.nim
documentation_of: cplib/tree/diameter.nim
layout: document
redirect_from:
- /library/cplib/tree/diameter.nim
- /library/cplib/tree/diameter.nim.html
title: cplib/tree/diameter.nim
---
