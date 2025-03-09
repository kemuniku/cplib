---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/binary_trie.nim
    title: cplib/collections/binary_trie.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/binary_trie.nim
    title: cplib/collections/binary_trie.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/set_xor_min
    links:
    - https://judge.yosupo.jp/problem/set_xor_min
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/set_xor_min\n\
    import cplib/collections/binary_trie\nimport sequtils\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\nvar Q = ii()\nvar S = initBineryTrie(30)\nfor i in 0..<(Q):\n    var\
    \ t,x = ii()\n    if t == 0:\n        if x notin S:\n            S.incl(x)\n \
    \   elif t == 1:\n        if x in S:\n            S.excl(x)\n    else:\n     \
    \   stdout.writeLine S.get_kth(0,x) xor x\n"
  dependsOn:
  - cplib/collections/binary_trie.nim
  - cplib/collections/binary_trie.nim
  isVerificationFile: true
  path: verify/collections/binary_trie_test.nim
  requiredBy: []
  timestamp: '2025-03-09 17:40:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/binary_trie_test.nim
layout: document
redirect_from:
- /verify/verify/collections/binary_trie_test.nim
- /verify/verify/collections/binary_trie_test.nim.html
title: verify/collections/binary_trie_test.nim
---
