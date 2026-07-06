---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':question:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':question:'
    path: cplib/utils/inversion_number.nim
    title: cplib/utils/inversion_number.nim
  - icon: ':question:'
    path: cplib/utils/inversion_number.nim
    title: cplib/utils/inversion_number.nim
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


    import cplib/utils/inversion_number


    assert inversion_number(@[2, 1, 5, 3, 4]) == 3

    assert inversion_number(@[1, 1, 1]) == 0

    assert inversion_number(@[3, 2, 1]) == 3

    '
  dependsOn:
  - cplib/utils/inversion_number.nim
  - cplib/collections/segtree.nim
  - cplib/utils/inversion_number.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/AI/inversion_number_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/inversion_number_test.nim
layout: document
redirect_from:
- /verify/verify/AI/inversion_number_test.nim
- /verify/verify/AI/inversion_number_test.nim.html
title: verify/AI/inversion_number_test.nim
---
