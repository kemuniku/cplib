---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/3677
    links:
    - https://yukicoder.me/problems/no/3677
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/3677\n\n\
    include cplib/tmpl/fastio\n\nlet height = input(int)\nlet width = input(int)\n\
    var sums = newSeq[uint32](height)\nvar total = 0'u32\nfor row in 0 ..< height:\n\
    \    var rowSum = 0'u32\n    for column in 0 ..< width:\n        rowSum += input(uint32)\n\
    \    sums[row] = rowSum\n    total += rowSum\nfor row in 0 ..< height:\n    sums[row]\
    \ += total\nprint(*sums, sep = \"\\n\")\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/tmpl/fastio_global_checksum_test.nim
  requiredBy: []
  timestamp: '2026-09-05 05:19:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tmpl/fastio_global_checksum_test.nim
layout: document
redirect_from:
- /verify/verify/tmpl/fastio_global_checksum_test.nim
- /verify/verify/tmpl/fastio_global_checksum_test.nim.html
title: verify/tmpl/fastio_global_checksum_test.nim
---
