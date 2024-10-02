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
    PROBLEM: https://atcoder.jp/contests/abc258/tasks/abc258_g
    links:
    - https://atcoder.jp/contests/abc258/tasks/abc258_g
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc258/tasks/abc258_g\n\
    import cplib/collections/staticbitset\nimport sequtils\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N = ii()\nvar A = newSeqWith(N,(stdin.readline.mapit(it\
    \ == '1')).initBitSet(3000))\nvar ans = 0\nfor i in 0..<(N-1):\n    for j in (i+1)..<N:\n\
    \        if A[i][j]:\n            ans += (A[i]&A[j]).popcount()\necho (ans div\
    \ 3)"
  dependsOn:
  - cplib/collections/staticbitset.nim
  - cplib/collections/staticbitset.nim
  isVerificationFile: true
  path: verify/collections/static_bitset_test.nim
  requiredBy: []
  timestamp: '2024-10-02 16:59:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/static_bitset_test.nim
layout: document
redirect_from:
- /verify/verify/collections/static_bitset_test.nim
- /verify/verify/collections/static_bitset_test.nim.html
title: verify/collections/static_bitset_test.nim
---
