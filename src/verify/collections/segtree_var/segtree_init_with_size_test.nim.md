---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/segtree_var.nim
    title: cplib/collections/segtree_var.nim
  - icon: ':question:'
    path: cplib/collections/segtree_var.nim
    title: cplib/collections/segtree_var.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/point_add_range_sum
    links:
    - https://judge.yosupo.jp/problem/point_add_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum\n\
    import sequtils\nimport cplib/collections/segtree_var\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N, Q = ii()\nvar st = newSegWith(N, l+r, 0)\nfor\
    \ i in 0..<N:\n    st[i] = ii()\nfor i in 0..<Q:\n    var T = ii()\n    if T ==\
    \ 0:\n        var p, x = ii()\n        st[p] = st[p] + x\n    else:\n        var\
    \ l, r = ii()\n        echo st[l..<r]\n"
  dependsOn:
  - cplib/collections/segtree_var.nim
  - cplib/collections/segtree_var.nim
  isVerificationFile: true
  path: verify/collections/segtree_var/segtree_init_with_size_test.nim
  requiredBy: []
  timestamp: '2024-12-19 23:28:40+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree_var/segtree_init_with_size_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree_var/segtree_init_with_size_test.nim
- /verify/verify/collections/segtree_var/segtree_init_with_size_test.nim.html
title: verify/collections/segtree_var/segtree_init_with_size_test.nim
---
