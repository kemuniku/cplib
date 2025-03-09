---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':question:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':question:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':question:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':x:'
    path: cplib/collections/rangeset.nim
    title: cplib/collections/rangeset.nim
  - icon: ':x:'
    path: cplib/collections/rangeset.nim
    title: cplib/collections/rangeset.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc380/tasks/abc380_e
    links:
    - https://atcoder.jp/contests/abc380/tasks/abc380_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc380/tasks/abc380_e\n\
    import sequtils\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    proc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\nimport cplib/collections/avlset\n\
    import cplib/collections/rangeset\n\nvar N,Q = ii()\nvar st = initRangeSet[int](-1)\n\
    for i in 0..<(N):\n    st.update(i,i+1,i)\nvar cnt = newseqwith(N,1)\nfor i in\
    \ 0..<(Q):\n    var t = ii()\n    if t == 1:\n        var x,c = ii()-1\n     \
    \   var (l,r,bef) = st.get_segment(x)\n        cnt[bef] -= r-l\n        cnt[c]\
    \ += r-l\n        st.update(l,r,c)\n    else:\n        var c = ii()-1\n      \
    \  stdout.writeLine cnt[c]"
  dependsOn:
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  - cplib/collections/rangeset.nim
  - cplib/collections/rangeset.nim
  isVerificationFile: true
  path: verify/collections/rangeset_test.nim
  requiredBy: []
  timestamp: '2024-11-28 13:30:55+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/collections/rangeset_test.nim
layout: document
redirect_from:
- /verify/verify/collections/rangeset_test.nim
- /verify/verify/collections/rangeset_test.nim.html
title: verify/collections/rangeset_test.nim
---
