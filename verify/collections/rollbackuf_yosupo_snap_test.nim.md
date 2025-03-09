---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rollback_unionfind.nim
    title: cplib/collections/rollback_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rollback_unionfind.nim
    title: cplib/collections/rollback_unionfind.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/persistent_unionfind
    links:
    - https://judge.yosupo.jp/problem/persistent_unionfind
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_unionfind\n\
    import sequtils, strutils\nimport cplib/collections/rollback_unionfind\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar n, q = ii()\nvar g = newSeqWith(q+1, newseq[(int,\
    \ int, int)]())\nvar query = newSeqWith(q+1, newSeq[(int, int, int)]())\nvar ans\
    \ = newSeq[int]()\nfor i in 0..<q:\n    var t, k, u, v = ii()\n    k += 1\n  \
    \  if t == 0:\n        g[k].add((i+1, u, v))\n    else:\n        query[k].add((ans.len,\
    \ u, v))\n        ans.add(-1)\nvar uf = initRollbackUnionFind(n)\nproc dfs(x:\
    \ int) =\n    var s = uf.get_state\n    for (id, u, v) in query[x]:\n        ans[id]\
    \ = int(uf.issame(u, v))\n    for (y, u, v) in g[x]:\n        uf.unite(u, v)\n\
    \        dfs(y)\n        uf.snapshot\n        uf.rollback\n        uf.rollback(s)\n\
    dfs(0)\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/rollback_unionfind.nim
  - cplib/collections/rollback_unionfind.nim
  isVerificationFile: true
  path: verify/collections/rollbackuf_yosupo_snap_test.nim
  requiredBy: []
  timestamp: '2024-04-30 17:08:19+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/rollbackuf_yosupo_snap_test.nim
layout: document
redirect_from:
- /verify/verify/collections/rollbackuf_yosupo_snap_test.nim
- /verify/verify/collections/rollbackuf_yosupo_snap_test.nim.html
title: verify/collections/rollbackuf_yosupo_snap_test.nim
---
