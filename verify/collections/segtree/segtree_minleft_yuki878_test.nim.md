---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/878
    links:
    - https://yukicoder.me/problems/no/878
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/878\nimport\
    \ cplib/collections/segtree\nimport sequtils, strutils, algorithm\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar n, q = ii()\nvar a = newSeqWith(n, ii())\nvar seg\
    \ = newSegWith(a, max(l, r), 0)\nvar mn = newSeq[int](n)\nfor i in 0..<n:\n  \
    \  mn[i] = seg.min_left(i, proc(x: int): bool = x <= a[i])\nvar ad = newseqwith(n,\
    \ newseq[int]())\nfor i in 0..<n:\n    ad[mn[i]].add(i)\na.reverse\nvar query\
    \ = newSeq[(int, int, int)](q)\nfor i in 0..<q:\n    var _, l, r = ii()\n    query[i]\
    \ = (l-1, r, i)\nquery.sort\n\nvar ans = newseq[int](q)\nvar seg_add = newsegwith(newseqwith(n,\
    \ 0), l+r, 0)\nvar li = 0\nfor (l, r, id) in query:\n    while li <= l:\n    \
    \    for x in ad[li]:\n            seg_add[x] = seg_add[x] + 1\n        li +=\
    \ 1\n    ans[id] = seg_add[l..<r]\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/collections/segtree/segtree_minleft_yuki878_test.nim
  requiredBy: []
  timestamp: '2024-12-19 23:19:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree/segtree_minleft_yuki878_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree/segtree_minleft_yuki878_test.nim
- /verify/verify/collections/segtree/segtree_minleft_yuki878_test.nim.html
title: verify/collections/segtree/segtree_minleft_yuki878_test.nim
---
