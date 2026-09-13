---
data:
  _extendedDependsOn:
  - icon: ':x:'
    path: cplib/tree/link_cut_tree.nim
    title: cplib/tree/link_cut_tree.nim
  - icon: ':x:'
    path: cplib/tree/link_cut_tree.nim
    title: cplib/tree/link_cut_tree.nim
  - icon: ':x:'
    path: cplib/tree/private/link_cut_tree_base.nim
    title: cplib/tree/private/link_cut_tree_base.nim
  - icon: ':x:'
    path: cplib/tree/private/link_cut_tree_base.nim
    title: cplib/tree/private/link_cut_tree_base.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/dynamic_tree_vertex_add_path_sum
    links:
    - https://judge.yosupo.jp/problem/dynamic_tree_vertex_add_path_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dynamic_tree_vertex_add_path_sum\n\
    import sequtils, strutils\nimport cplib/tree/link_cut_tree\n\nproc scanf(formatstr:\
    \ cstring): cint {.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.}\
    \ = discard scanf(\"%lld\", addr result)\n\nlet n = ii()\nlet q = ii()\nlet values\
    \ = newSeqWith(n, int64(ii()))\nlet tree = newLinkCutTreeWith(values, l + r, 0'i64)\n\
    for i in 0..<n - 1:\n    let u = ii()\n    let v = ii()\n    tree.link(u, v)\n\
    \nvar answers: seq[string]\nfor i in 0..<q:\n    case ii()\n    of 0:\n      \
    \  let u = ii()\n        let v = ii()\n        let w = ii()\n        let x = ii()\n\
    \        tree.cut(u, v)\n        tree.link(w, x)\n    of 1:\n        let p = ii()\n\
    \        let x = int64(ii())\n        tree[p] = tree[p] + x\n    else:\n     \
    \   let u = ii()\n        let v = ii()\n        answers.add($tree.pathProd(u,\
    \ v))\necho answers.join(\"\\n\")\n"
  dependsOn:
  - cplib/tree/private/link_cut_tree_base.nim
  - cplib/tree/link_cut_tree.nim
  - cplib/tree/link_cut_tree.nim
  - cplib/tree/private/link_cut_tree_base.nim
  isVerificationFile: true
  path: verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
layout: document
redirect_from:
- /verify/verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
- /verify/verify/tree/link_cut_tree/vertex_add_path_sum_test.nim.html
title: verify/tree/link_cut_tree/vertex_add_path_sum_test.nim
---
