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
    PROBLEM: https://atcoder.jp/contests/arc161/tasks/arc161_b
    links:
    - https://atcoder.jp/contests/arc161/tasks/arc161_b
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/arc161/tasks/arc161_b\n\
    import cplib/utils/bititers\nimport sequtils, algorithm\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nconst arr = bitcomb(60, 3).toseq().sorted()\nvar T\
    \ = ii()\nfor i in 0..<T:\n    var N = ii()\n    var x = arr.upperBound(N)-1\n\
    \    if x == -1:\n        echo -1\n    else:\n        echo arr[x]\n"
  dependsOn:
  - cplib/utils/bititers.nim
  - cplib/utils/bititers.nim
  isVerificationFile: true
  path: verify/utils/bititers_bitcomb_test.nim
  requiredBy: []
  timestamp: '2023-12-13 00:30:20+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/bititers_bitcomb_test.nim
layout: document
redirect_from:
- /verify/verify/utils/bititers_bitcomb_test.nim
- /verify/verify/utils/bititers_bitcomb_test.nim.html
title: verify/utils/bititers_bitcomb_test.nim
---