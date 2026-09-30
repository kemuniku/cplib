---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
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
    import sequtils, algorithm\nimport cplib/utils/bititers\n\nfor bits in 0..<256:\n\
    \    var expected: seq[int] = @[]\n    for mask in 0..bits:\n        if (mask\
    \ and bits) == mask:\n            expected.add(mask)\n    doAssert toSeq(bitsubseteq(bits))\
    \ == expected\n    var proper = expected\n    proper.setLen(proper.len - 1)\n\
    \    doAssert toSeq(bitsubset(bits)) == proper\n    expected.reverse()\n    proper.reverse()\n\
    \    doAssert toSeq(bitsubseteq_descending(bits)) == expected\n    doAssert toSeq(bitsubset_descending(bits))\
    \ == proper\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/bititers.nim
  - cplib/utils/bititers.nim
  isVerificationFile: true
  path: verify/AI/bititers_empty_subset_test.nim
  requiredBy: []
  timestamp: '2026-10-01 00:30:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bititers_empty_subset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bititers_empty_subset_test.nim
- /verify/verify/AI/bititers_empty_subset_test.nim.html
title: verify/AI/bititers_empty_subset_test.nim
---
