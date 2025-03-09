---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/lis.nim
    title: cplib/utils/lis.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/lis.nim
    title: cplib/utils/lis.nim
  - icon: ':warning:'
    path: cplib/utils/list_procs.nim
    title: cplib/utils/list_procs.nim
  - icon: ':warning:'
    path: cplib/utils/list_procs.nim
    title: cplib/utils/list_procs.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc237/tasks/abc237_d
    links:
    - https://atcoder.jp/contests/abc237/tasks/abc237_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc237/tasks/abc237_d\n\
    import sequtils, algorithm\nimport cplib/utils/lis\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nimport lists\nimport cplib/utils/list_procs\nimport strutils\n\n\
    var N = ii()\nvar S = stdin.readLine()\nvar list = initDoublyLinkedList[int]()\n\
    var bef = newDoublyLinkedNode[int](0)\nlist.add(bef)\nfor i in 0..<N:\n    var\
    \ tmp = newDoublyLinkedNode[int](i+1)\n    if S[i] == 'R':\n        list.insert(bef,tmp)\n\
    \    else:\n        list.insertPrev(bef,tmp)\n    bef = tmp\necho list.toseq().join(\"\
    \ \")"
  dependsOn:
  - cplib/utils/lis.nim
  - cplib/utils/list_procs.nim
  - cplib/utils/lis.nim
  - cplib/utils/list_procs.nim
  isVerificationFile: false
  path: verify/utils/list_procs_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/utils/list_procs_test_.nim
layout: document
redirect_from:
- /library/verify/utils/list_procs_test_.nim
- /library/verify/utils/list_procs_test_.nim.html
title: verify/utils/list_procs_test_.nim
---
