---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_segtree.nim
    title: cplib/collections/dynamic_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_segtree.nim
    title: cplib/collections/dynamic_segtree.nim
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
    import cplib/collections/dynamic_segtree\n\nproc scanf(formatstr: cstring) {.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int = scanf(\"%lld\", addr result)\n\n\
    let n = ii()\nlet q = ii()\nlet st = newDynamicSegWith(n, l + r, 0)\nfor i in\
    \ 0..<n:\n    st[i] = ii()\nfor i in 0..<q:\n    let t = ii()\n    let a = ii()\n\
    \    let b = ii()\n    if t == 0:\n        st[a] = st[a] + b\n    else:\n    \
    \    echo st.get(a, b)\n"
  dependsOn:
  - cplib/collections/dynamic_segtree.nim
  - cplib/collections/dynamic_segtree.nim
  isVerificationFile: true
  path: verify/collections/segtree/dynamic_segtree_PARS_test.nim
  requiredBy: []
  timestamp: '2026-09-12 20:28:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree/dynamic_segtree_PARS_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree/dynamic_segtree_PARS_test.nim
- /verify/verify/collections/segtree/dynamic_segtree_PARS_test.nim.html
title: verify/collections/segtree/dynamic_segtree_PARS_test.nim
---
