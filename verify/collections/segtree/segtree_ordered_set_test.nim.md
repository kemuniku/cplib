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
    PROBLEM: https://judge.yosupo.jp/problem/ordered_set
    links:
    - https://judge.yosupo.jp/problem/ordered_set
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/ordered_set\n\
    import sequtils,algorithm,sugar\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nimport\
    \ cplib/collections/segtree\nvar N,Q = ii()\nvar A = newseqwith(N,ii())\nvar querys\
    \ : seq[(int,int)]\nvar C = A\nfor i in 0..<Q:\n    var t,x = ii()\n    querys.add((t,x))\n\
    \    C.add(x)\nC = C.sorted().deduplicate(true)\n\nvar tmp = newseqwith(len(C),0)\n\
    \nfor i in 0..<(N):\n    tmp[C.lowerbound(A[i])] = 1\n\nvar st = newsegwith(tmp,l+r,0)\n\
    \n\nfor i in 0..<Q:\n    var (t,x) = querys[i]\n    if t == 0:\n        st[C.lowerBound(x)]\
    \ = 1\n    elif t == 1:\n        st[C.lowerBound(x)] = 0\n    elif t == 2:\n \
    \       if st.get_all() < x:\n            stdout.writeLine -1\n        else:\n\
    \            stdout.writeLine C[st.max_right(0,(y:int) => (y<x))]\n    elif t\
    \ == 3:\n        stdout.writeLine st[0..C.lowerBound(x)]\n    elif t == 4:\n \
    \       var tmp = st.min_left(C.lowerBound(x)+1,(y:int) => (y == 0))-1\n     \
    \   if tmp == -1:\n            stdout.writeLine -1\n        else:\n          \
    \  stdout.writeLine C[tmp]\n    else:\n        var tmp = st.max_right(C.lowerBound(x),(y:int)\
    \ => (y == 0))\n        if tmp == len(st):\n            stdout.writeLine -1\n\
    \        else:\n            stdout.writeLine C[tmp]"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/collections/segtree/segtree_ordered_set_test.nim
  requiredBy: []
  timestamp: '2024-12-19 23:19:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree/segtree_ordered_set_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree/segtree_ordered_set_test.nim
- /verify/verify/collections/segtree/segtree_ordered_set_test.nim.html
title: verify/collections/segtree/segtree_ordered_set_test.nim
---
