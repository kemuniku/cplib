---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/deletable_heapqueue.nim
    title: cplib/collections/deletable_heapqueue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/deletable_heapqueue.nim
    title: cplib/collections/deletable_heapqueue.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc170/tasks/abc170_e
    links:
    - https://atcoder.jp/contests/abc170/tasks/abc170_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc170/tasks/abc170_e\n\
    import cplib/collections/deletable_heapqueue\nimport sequtils\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\nvar N,Q = ii()\nvar A:seq[int]\nvar B:seq[int]\nvar hqs\
    \ = newseqwith(200001,initDeletableHeapQueue[int]())\nvar now = initDeletableHeapQueue[int]()\n\
    for i in 0..<N:\n    var a = ii()\n    var b = ii()\n    A.add(a)\n    B.add(b)\n\
    \    hqs[b].push(-a)\n\n\nfor i in 1..200000:\n    if len(hqs[i]) > 0:\n     \
    \   now.push(-hqs[i][0])\n\nfor i in 0..<Q:\n    var C = ii()-1\n    var D = ii()\n\
    \    now.delete(-hqs[B[C]][0])\n    if len(hqs[D]) >= 1:\n        now.delete(-hqs[D][0])\n\
    \    hqs[B[C]].delete(-A[C])\n    hqs[D].push(-A[C])\n    if len(hqs[B[C]]) >=\
    \ 1:\n        now.push(-hqs[B[C]][0])\n    now.push(-hqs[D][0])\n    B[C] = D\n\
    \    echo now[0]\n\n\n"
  dependsOn:
  - cplib/collections/deletable_heapqueue.nim
  - cplib/collections/deletable_heapqueue.nim
  isVerificationFile: true
  path: verify/collections/deletable_heapqueue_test.nim
  requiredBy: []
  timestamp: '2024-09-04 03:52:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/deletable_heapqueue_test.nim
layout: document
redirect_from:
- /verify/verify/collections/deletable_heapqueue_test.nim
- /verify/verify/collections/deletable_heapqueue_test.nim.html
title: verify/collections/deletable_heapqueue_test.nim
---
