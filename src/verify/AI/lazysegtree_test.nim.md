---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree.nim
    title: cplib/collections/lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree.nim
    title: cplib/collections/lazysegtree.nim
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/collections/lazysegtree


    proc merge(x, y: int): int = min(x, y)

    proc mapping(f, x: int): int = f + x

    proc composition(f, g: int): int = f + g


    var st = initLazySegmentTree(@[1, 2, 3, 4, 5], merge, int.high, mapping, composition,
    0)

    assert st.len == 5

    assert st.get(0, 5) == 1

    st.apply(1, 4, 10)

    assert st[1] == 12

    assert st.get(1, 4) == 12

    st[0] = 20

    assert st.get(0, 5) == 5

    st.apply(2..4, -3)

    assert st[2] == 10

    assert st[4] == 2

    assert $st == "20 12 10 11 2"


    var st2 = newLazySegWith(@[1, 2, 3], min(l, r), int.high, f + x, f + g, 0)

    st2.apply(0, 3, 4)

    assert st2.get(0, 3) == 5

    '
  dependsOn:
  - cplib/collections/lazysegtree.nim
  - cplib/collections/lazysegtree.nim
  isVerificationFile: true
  path: verify/AI/lazysegtree_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lazysegtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lazysegtree_test.nim
- /verify/verify/AI/lazysegtree_test.nim.html
title: verify/AI/lazysegtree_test.nim
---
