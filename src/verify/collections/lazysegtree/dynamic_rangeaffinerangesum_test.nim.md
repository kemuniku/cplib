---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_lazysegtree.nim
    title: cplib/collections/dynamic_lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_lazysegtree.nim
    title: cplib/collections/dynamic_lazysegtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/range_affine_range_sum
    links:
    - https://judge.yosupo.jp/problem/range_affine_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_range_sum\n\
    import cplib/collections/dynamic_lazysegtree\n\nconst modulus = 998244353\ntype\n\
    \    S = tuple[sum, size: int]\n    F = tuple[a, b: int]\n\nproc scanf(formatstr:\
    \ cstring) {.header: \"<stdio.h>\", varargs.}\nproc ii(): int = scanf(\"%lld\"\
    , addr result)\nproc op(l, r: S): S = ((l.sum + r.sum) mod modulus, l.size + r.size)\n\
    proc mapping(f: F, x: S): S = ((f.a * x.sum + f.b * x.size) mod modulus, x.size)\n\
    proc composition(f, g: F): F = (f.a * g.a mod modulus, (f.a * g.b + f.b) mod modulus)\n\
    proc initial(l, r: int): S = (0, r - l)\n\nlet n = ii()\nlet q = ii()\nlet st\
    \ = initDynamicLazySegmentTree[S, F](n, op, (0, 0), mapping, composition, (1,\
    \ 0), initial)\nfor i in 0..<n: st[i] = (ii(), 1)\nfor i in 0..<q:\n    let t\
    \ = ii()\n    let l = ii()\n    let r = ii()\n    if t == 0:\n        let a =\
    \ ii()\n        let b = ii()\n        st.apply(l, r, (a, b))\n    else:\n    \
    \    echo st.get(l, r).sum\n"
  dependsOn:
  - cplib/collections/dynamic_lazysegtree.nim
  - cplib/collections/dynamic_lazysegtree.nim
  isVerificationFile: true
  path: verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
  requiredBy: []
  timestamp: '2026-09-12 20:28:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
layout: document
redirect_from:
- /verify/verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
- /verify/verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim.html
title: verify/collections/lazysegtree/dynamic_rangeaffinerangesum_test.nim
---
