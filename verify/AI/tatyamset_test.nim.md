---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/tatyamset.nim
    title: cplib/collections/tatyamset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/tatyamset.nim
    title: cplib/collections/tatyamset.nim
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


    import options, sequtils

    import cplib/collections/tatyamset


    var st = initSortedMultiset(@[3, 1, 2, 2])

    assert st.len == 4

    assert st.toSeq == @[1, 2, 2, 3]

    assert st.contains(2)

    assert st.count(2) == 2

    assert st.lt(2).get == 1

    assert st.le(2).get == 2

    assert st.gt(2).get == 3

    assert st.ge(2).get == 2

    assert st[0] == 1

    assert st[-1] == 3

    assert st.index(2) == 1

    assert st.index_right(2) == 3

    st.incl(4)

    assert st.pop(-1) == 4

    assert st.pop(1) == 2

    assert st.excl(2)

    assert not st.excl(9)

    assert st.toSeq == @[1, 3]

    '
  dependsOn:
  - cplib/collections/tatyamset.nim
  - cplib/collections/tatyamset.nim
  isVerificationFile: true
  path: verify/AI/tatyamset_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/tatyamset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/tatyamset_test.nim
- /verify/verify/AI/tatyamset_test.nim.html
title: verify/AI/tatyamset_test.nim
---
