---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/collections/staticbitset.nim
    title: cplib/collections/staticbitset.nim
  - icon: ':warning:'
    path: cplib/collections/staticbitset.nim
    title: cplib/collections/staticbitset.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc258/tasks/abc258_g
    links:
    - https://atcoder.jp/contests/abc258/tasks/abc258_g
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc258/tasks/abc258_g\n\
    import cplib/collections/staticbitset\nimport sequtils\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N = ii()\nvar A : seq[BitSet[3000]]\nfor i in 0..<(N):\n\
    \    var S = stdin.readline()\n    var tmp : seq[int]\n    for j in 0..<(N):\n\
    \        if S[j] == '1':\n            tmp.add(j)\n    A.add(tmp.initBitSet(3000))\n\
    \nvar ans = 0\nfor i in 0..<(N-1):\n    for j in (i+1)..<N:\n        if A[i][j]:\n\
    \            ans += (A[i]&A[j]).popcount()\necho (ans div 3)"
  dependsOn:
  - cplib/collections/staticbitset.nim
  - cplib/collections/staticbitset.nim
  isVerificationFile: false
  path: verify/collections/static_bitset_seqint_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/static_bitset_seqint_test_.nim
layout: document
redirect_from:
- /library/verify/collections/static_bitset_seqint_test_.nim
- /library/verify/collections/static_bitset_seqint_test_.nim.html
title: verify/collections/static_bitset_seqint_test_.nim
---
