---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_binary_trie.nim
    title: cplib/collections/persistent_binary_trie.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_binary_trie.nim
    title: cplib/collections/persistent_binary_trie.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/set_xor_min
    links:
    - https://judge.yosupo.jp/problem/set_xor_min
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/set_xor_min\n\
    import cplib/collections/persistent_binary_trie\nimport sequtils\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\nvar Q = ii()\nvar S = initPersistentBineryTrie(30)\n\
    for i in 0..<(Q):\n    var t,x = ii()\n    if t == 0:\n        if x notin S:\n\
    \            S = S.incl(x)\n    elif t == 1:\n        if x in S:\n           \
    \ S = S.excl(x)\n    else:\n        stdout.writeLine S.get_kth(0,x) xor x\n"
  dependsOn:
  - cplib/collections/persistent_binary_trie.nim
  - cplib/collections/persistent_binary_trie.nim
  isVerificationFile: true
  path: verify/collections/persistent_binary_trie_test.nim
  requiredBy: []
  timestamp: '2024-09-21 18:34:12+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/persistent_binary_trie_test.nim
layout: document
redirect_from:
- /verify/verify/collections/persistent_binary_trie_test.nim
- /verify/verify/collections/persistent_binary_trie_test.nim.html
title: verify/collections/persistent_binary_trie_test.nim
---
