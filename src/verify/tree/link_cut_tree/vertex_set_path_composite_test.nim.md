---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tree/link_cut_tree.nim
    title: cplib/tree/link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/link_cut_tree.nim
    title: cplib/tree/link_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/private/link_cut_tree_base.nim
    title: cplib/tree/private/link_cut_tree_base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/private/link_cut_tree_base.nim
    title: cplib/tree/private/link_cut_tree_base.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/dynamic_tree_vertex_set_path_composite
    links:
    - https://judge.yosupo.jp/problem/dynamic_tree_vertex_set_path_composite
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dynamic_tree_vertex_set_path_composite\n\
    import sequtils, strutils\nimport cplib/tree/link_cut_tree\n\nconst Mod = 998244353'i64\n\
    type Affine = tuple[a, b: int64]\n\nproc scanf(formatstr: cstring): cint {.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = discard scanf(\"%lld\"\
    , addr result)\nproc op(l, r: Affine): Affine =\n    (a: l.a * r.a mod Mod, b:\
    \ (l.b * r.a + r.b) mod Mod)\n\nlet n = ii()\nlet q = ii()\nlet values = newSeqWith(n,\
    \ (a: int64(ii()), b: int64(ii())))\nlet tree = initLinkCutTree(values, op, (a:\
    \ 1'i64, b: 0'i64))\nfor i in 0..<n - 1:\n    let u = ii()\n    let v = ii()\n\
    \    tree.link(u, v)\n\nvar answers: seq[string]\nfor i in 0..<q:\n    case ii()\n\
    \    of 0:\n        let u = ii()\n        let v = ii()\n        let w = ii()\n\
    \        let x = ii()\n        tree.cut(u, v)\n        tree.link(w, x)\n    of\
    \ 1:\n        let p = ii()\n        let c = int64(ii())\n        let d = int64(ii())\n\
    \        tree[p] = (a: c, b: d)\n    else:\n        let u = ii()\n        let\
    \ v = ii()\n        let x = int64(ii())\n        let f = tree.pathProd(u, v)\n\
    \        answers.add($((f.a * x + f.b) mod Mod))\necho answers.join(\"\\n\")\n"
  dependsOn:
  - cplib/tree/link_cut_tree.nim
  - cplib/tree/private/link_cut_tree_base.nim
  - cplib/tree/link_cut_tree.nim
  - cplib/tree/private/link_cut_tree_base.nim
  isVerificationFile: true
  path: verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
  requiredBy: []
  timestamp: '2026-09-10 04:41:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
layout: document
redirect_from:
- /verify/verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
- /verify/verify/tree/link_cut_tree/vertex_set_path_composite_test.nim.html
title: verify/tree/link_cut_tree/vertex_set_path_composite_test.nim
---
