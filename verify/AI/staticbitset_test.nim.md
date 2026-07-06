---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticbitset.nim
    title: cplib/collections/staticbitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticbitset.nim
    title: cplib/collections/staticbitset.nim
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


    import cplib/collections/staticbitset


    var a = initBitSet(@[true, false, true, false, true], 70)

    var b = initBitSet(@[2, 4, 65], 70)

    assert a[0]

    assert not a[1]

    assert a.popcount() == 3

    assert b.popcount() == 3

    assert (a & b).popcount() == 2

    assert (a | b).popcount() == 4

    assert (a ^ b).popcount() == 2

    assert a.andpopcount(b) == 2

    assert a.orpopcount(b) == 4

    assert a.xorpopcount(b) == 2

    a &= b

    assert a.popcount() == 2

    a |= b

    assert a.popcount() == 3

    a ^= b

    assert a.popcount() == 0

    a[69] = 1

    assert a[69]

    assert (a << 1).popcount() == 0

    a[69] = 0

    a[1] = true

    assert (a << 2)[3]

    assert (a >> 1)[0]

    assert (~initBitSet(5)).popcount() == 5

    assert $initBitSet(@[true, false, true], 3) == "101"

    '
  dependsOn:
  - cplib/collections/staticbitset.nim
  - cplib/collections/staticbitset.nim
  isVerificationFile: true
  path: verify/AI/staticbitset_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/staticbitset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/staticbitset_test.nim
- /verify/verify/AI/staticbitset_test.nim.html
title: verify/AI/staticbitset_test.nim
---
