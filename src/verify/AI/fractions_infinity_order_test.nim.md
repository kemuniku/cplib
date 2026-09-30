---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
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
    import cplib/math/fractions\n\nlet positive = initFraction(1, 0)\nlet negative\
    \ = initFraction(-1, 0)\nfor magnitude in 1..3:\n    let positives = [initFraction(magnitude,\
    \ 0, false), positive * magnitude]\n    let negatives = [initFraction(-magnitude,\
    \ 0, false), negative * magnitude]\n    for value in positives:\n        doAssert\
    \ value == positive\n        doAssert not (value < positive)\n        doAssert\
    \ not (value > positive)\n        doAssert not (positive < value)\n        doAssert\
    \ not (positive > value)\n        doAssert value <= positive and value >= positive\n\
    \        doAssert cmp(value, positive) == 0\n        doAssert cmp(positive, value)\
    \ == 0\n    for value in negatives:\n        doAssert value == negative\n    \
    \    doAssert not (value < negative)\n        doAssert not (value > negative)\n\
    \        doAssert not (negative < value)\n        doAssert not (negative > value)\n\
    \        doAssert value <= negative and value >= negative\n        doAssert cmp(value,\
    \ negative) == 0\n        doAssert cmp(negative, value) == 0\n    for pos in positives:\n\
    \        for neg in negatives:\n            doAssert pos > neg and neg < pos\n\
    \            doAssert not (pos < neg) and not (neg > pos)\n            doAssert\
    \ cmp(pos, neg) == 1 and cmp(neg, pos) == -1\n        for finite in [initFraction(-5,\
    \ 2), initFraction(0), initFraction(7, 3)]:\n            doAssert pos > finite\
    \ and finite < pos\n            for neg in negatives:\n                doAssert\
    \ neg < finite and finite > neg\n\nlet nan = initFraction(0, 0)\ndoAssert not\
    \ (nan < positive) and not (nan > positive)\ndoAssert not (positive < nan) and\
    \ not (positive > nan)\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/AI/fractions_infinity_order_test.nim
  requiredBy: []
  timestamp: '2026-10-01 02:25:40+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fractions_infinity_order_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fractions_infinity_order_test.nim
- /verify/verify/AI/fractions_infinity_order_test.nim.html
title: verify/AI/fractions_infinity_order_test.nim
---
