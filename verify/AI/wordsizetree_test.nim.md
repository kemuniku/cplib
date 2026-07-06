---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/wordsizetree.nim
    title: cplib/collections/wordsizetree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/wordsizetree.nim
    title: cplib/collections/wordsizetree.nim
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


    import cplib/collections/wordsizetree


    var wt = initWordsizeTree()

    assert wt.ge(0) == -1

    wt.incl(5)

    wt.incl(70)

    wt.incl(4097)

    assert wt[5]

    assert wt[70]

    assert wt.ge(0) == 5

    assert wt.ge(6) == 70

    assert wt.ge(4097) == 4097

    assert wt.le(4096) == 70

    assert wt.le(70) == 70

    wt.excl(70)

    assert not wt[70]

    assert wt.ge(6) == 4097

    assert wt.le(4096) == 5


    var wt2 = initWordsizeTree(@[false, true, false, true])

    assert wt2.ge(0) == 1

    assert wt2.le(10) == 3

    '
  dependsOn:
  - cplib/collections/wordsizetree.nim
  - cplib/collections/wordsizetree.nim
  isVerificationFile: true
  path: verify/AI/wordsizetree_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/wordsizetree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/wordsizetree_test.nim
- /verify/verify/AI/wordsizetree_test.nim.html
title: verify/AI/wordsizetree_test.nim
---
