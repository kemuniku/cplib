---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashset.nim
    title: cplib/collections/hashset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashset.nim
    title: cplib/collections/hashset.nim
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
    echo \"Hello World\"\n\nimport algorithm, sequtils\nimport cplib/collections/hashset\n\
    \nvar hs = initHashSet[int]()\nhs.incl(1)\nhs.incl(2)\nhs.incl(2)\nassert hs.contains(1)\n\
    assert hs.contains(2)\nhs.excl(1)\nassert not hs.contains(1)\nfor i in 3..20:\n\
    \  hs.incl(i)\nassert not hs.contains(1)\nassert hs.contains(20)\n\nvar items\
    \ = toSeq(hs.items)\nitems.sort()\nassert items[0] == 2\nassert items[^1] == 20\n\
    \nvar hs2 = toHashSet([5, 5, 6])\nassert hs2.contains(5)\nassert hs2.contains(6)\n\
    hs2.excl(5)\nassert not hs2.contains(5)\n"
  dependsOn:
  - cplib/collections/hashset.nim
  - cplib/collections/hashset.nim
  isVerificationFile: true
  path: verify/AI/hashset_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/hashset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/hashset_test.nim
- /verify/verify/AI/hashset_test.nim.html
title: verify/AI/hashset_test.nim
---
