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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport cplib/collections/staticbitset\n\nvar a = initBitSet(@[true,\
    \ false, true, false, true], 70)\nvar b = initBitSetFromIndexes(@[2, 4, 65], 70)\n\
    var bItems: seq[int]\nfor i in b:\n    bItems.add(i)\nassert bItems == @[2, 4,\
    \ 65]\nassert b.lowestBit == 2\nassert initBitSet(70).lowestBit == -1\nassert\
    \ a[0]\nassert not a[1]\nassert a.popcount() == 3\nassert b.popcount() == 3\n\
    assert (a & b).popcount() == 2\nassert (a | b).popcount() == 4\nassert (a ^ b).popcount()\
    \ == 2\nassert a.andpopcount(b) == 2\nassert a.orpopcount(b) == 4\nassert a.xorpopcount(b)\
    \ == 2\na &= b\nassert a.popcount() == 2\na |= b\nassert a.popcount() == 3\na\
    \ ^= b\nassert a.popcount() == 0\na[69] = 1\nassert a[69]\nassert (a << 1).popcount()\
    \ == 0\na[69] = 0\na[1] = true\nassert (a << 2)[3]\nassert (a >> 1)[0]\nassert\
    \ (~initBitSet(5)).popcount() == 5\nassert $initBitSet(@[true, false, true], 3)\
    \ == \"101\"\n"
  dependsOn:
  - cplib/collections/staticbitset.nim
  - cplib/collections/staticbitset.nim
  isVerificationFile: true
  path: verify/AI/staticbitset_test.nim
  requiredBy: []
  timestamp: '2026-08-28 03:07:19+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/staticbitset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/staticbitset_test.nim
- /verify/verify/AI/staticbitset_test.nim.html
title: verify/AI/staticbitset_test.nim
---
