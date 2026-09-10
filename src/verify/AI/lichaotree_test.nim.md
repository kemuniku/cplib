---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lichaotree.nim
    title: cplib/collections/lichaotree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lichaotree.nim
    title: cplib/collections/lichaotree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
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


    import cplib/collections/lichaotree

    import cplib/utils/constants


    let lct = initLiChaoTree(@[-2, -1, 0, 1, 2, 3])

    assert lct.get_min(0) == INF64

    lct.add_line(2, 3)

    lct.add_line(-1, 4)

    assert lct.get_min(-2) == -1

    assert lct.get_min(2) == 2

    lct.add_segment(0, -5, -1, 2)

    assert lct.get_min(0) == -5

    assert lct.get_min(2) == 2

    '
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/collections/lichaotree.nim
  - cplib/collections/lichaotree.nim
  isVerificationFile: true
  path: verify/AI/lichaotree_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:12:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lichaotree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lichaotree_test.nim
- /verify/verify/AI/lichaotree_test.nim.html
title: verify/AI/lichaotree_test.nim
---
