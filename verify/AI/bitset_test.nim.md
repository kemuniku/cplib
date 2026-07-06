---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset.nim
    title: cplib/collections/bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset.nim
    title: cplib/collections/bitset.nim
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


    import cplib/collections/bitset


    var a = initBitSet(@[true, false, true, false, true])

    var b = initBitSet(0)

    b[1] = true

    b[2] = true

    b[64] = true

    assert a[0]

    assert not a[1]

    assert a.popcount() == 3

    assert b.popcount() == 3

    assert (a & b).popcount() == 1

    assert (a | b).popcount() == 5

    assert a.andpopcount(b) == 1

    a &= b

    assert a.popcount() == 1

    a |= b

    assert a.popcount() == 3

    a ^= b

    assert a.popcount() == 0

    a[70] = true

    assert a[70]

    a[70] = false

    assert not a[70]

    '
  dependsOn:
  - cplib/collections/bitset.nim
  - cplib/collections/bitset.nim
  isVerificationFile: true
  path: verify/AI/bitset_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_test.nim
- /verify/verify/AI/bitset_test.nim.html
title: verify/AI/bitset_test.nim
---
