---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':question:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
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


    import cplib/collections/segtree


    let merge = proc(x, y: int): int = x + y

    var st = initSegmentTree(@[1, 2, 3, 4, 5], merge, 0)

    assert st.len == 5

    assert st.get(0, 5) == 15

    assert st.get(1, 4) == 9

    assert st[1..3] == 9

    assert st[2] == 3

    st.update(2, 10)

    assert st[2] == 10

    st[0] = 7

    assert st.get_all() == 28

    assert $st == "7 2 10 4 5"

    assert st.max_right(0, proc(x: int): bool = x <= 19) == 3

    assert st.min_left(5, proc(x: int): bool = x <= 11) == 3


    let st2 = initSegmentTree[int](3, merge, 0)

    assert st2.get_all() == 0


    let st3 = newSegWith(@[1, 2, 3], l + r, 0)

    assert st3.get_all() == 6

    '
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/AI/segtree_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/segtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/segtree_test.nim
- /verify/verify/AI/segtree_test.nim.html
title: verify/AI/segtree_test.nim
---
