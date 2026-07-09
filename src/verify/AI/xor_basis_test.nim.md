---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/xor_basis.nim
    title: cplib/math/xor_basis.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/xor_basis.nim
    title: cplib/math/xor_basis.nim
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


    import cplib/math/xor_basis


    var xb = initXorBasis(@[1, 2, 3])

    assert xb.len_basis == 2

    assert xb.can_make(3)

    assert not xb.can_make(4)

    xb.incl(4)

    assert xb.len_basis == 3

    assert xb.kth_smallest(0) == 0

    assert xb.kth_smallest(5) == 5

    assert xb.kth_smallest(8) == -1

    assert xb.lt(4) == 3

    assert xb.le(4) == 4

    assert xb.index(6) == 6

    assert xb.xor_min(5) == 5

    assert xb.xor_kth(2, 0) == 2

    assert xb.xor_kth(2, 3) == 1

    assert xb.xor_kth(2, 8) == -1

    '
  dependsOn:
  - cplib/math/xor_basis.nim
  - cplib/math/xor_basis.nim
  isVerificationFile: true
  path: verify/AI/xor_basis_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:24:29+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/xor_basis_test.nim
layout: document
redirect_from:
- /verify/verify/AI/xor_basis_test.nim
- /verify/verify/AI/xor_basis_test.nim.html
title: verify/AI/xor_basis_test.nim
---
