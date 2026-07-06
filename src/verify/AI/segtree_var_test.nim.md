---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_var.nim
    title: cplib/collections/segtree_var.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_var.nim
    title: cplib/collections/segtree_var.nim
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


    import cplib/collections/segtree_var


    let merge = proc(x, y: int): int = x + y

    var st = initSegmentTree(@[1, 2, 3, 4], merge, 0)

    assert st.len == 4

    assert st.get(0, 4) == 10

    assert st[1..2] == 5

    st[2] += 7

    assert int(st[2]) == 10

    assert st.get_all() == 17

    st[0] = 5

    assert st.get(0, 2) == 7

    assert $st == "5 2 10 4"

    assert st.max_right(0, proc(x: int): bool = x <= 7) == 2

    assert st.min_left(4, proc(x: int): bool = x <= 14) == 2


    let st2 = newSegWith(@[2, 3], l * r, 1)

    assert st2.get_all() == 6

    '
  dependsOn:
  - cplib/collections/segtree_var.nim
  - cplib/collections/segtree_var.nim
  isVerificationFile: true
  path: verify/AI/segtree_var_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/segtree_var_test.nim
layout: document
redirect_from:
- /verify/verify/AI/segtree_var_test.nim
- /verify/verify/AI/segtree_var_test.nim.html
title: verify/AI/segtree_var_test.nim
---
