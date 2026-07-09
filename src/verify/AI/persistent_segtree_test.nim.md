---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_segtree.nim
    title: cplib/collections/persistent_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_segtree.nim
    title: cplib/collections/persistent_segtree.nim
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


    import cplib/collections/persistent_segtree


    let st = initSegmentTree(@[1, 2, 3, 4], proc(l, r: int): int = l + r, 0)

    assert st.query(0, 4) == 10

    assert st.query(1, 3) == 5

    let st2 = st.update(2, 10)

    assert st.query(0, 4) == 10

    assert st2.query(0, 4) == 17

    assert st2.query(2, 3) == 10

    '
  dependsOn:
  - cplib/collections/persistent_segtree.nim
  - cplib/collections/persistent_segtree.nim
  isVerificationFile: true
  path: verify/AI/persistent_segtree_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:12:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/persistent_segtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/persistent_segtree_test.nim
- /verify/verify/AI/persistent_segtree_test.nim.html
title: verify/AI/persistent_segtree_test.nim
---
