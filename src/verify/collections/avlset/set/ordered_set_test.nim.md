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
    import sequtils,options\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nimport\
    \ cplib/collections/avlset\nvar N,Q = ii()\nvar A = newseqwith(N,ii())\nvar st\
    \ = initAvlSortedSet[int](A)\n\nfor i in 0..<Q:\n    var t,x = ii()\n    if t\
    \ == 0:\n        st.incl(x)\n    elif t == 1:\n        st.excl(x)\n    elif t\
    \ == 2:\n        if len(st) < x:\n            echo -1\n        else:\n       \
    \     echo st[x-1]\n    elif t == 3:\n        echo st.upperBound(x)\n    elif\
    \ t == 4:\n        var tmp = st.le(x)\n        if tmp.issome():\n            echo\
    \ tmp.get()\n        else:\n            echo -1\n    else:\n        var tmp =\
    \ st.ge(x)\n        if tmp.issome():\n            echo tmp.get()\n        else:\n\
    \            echo -1"
  dependsOn:
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/collections/avlset/set/ordered_set_test.nim
  requiredBy: []
  timestamp: '2024-11-19 18:37:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avlset/set/ordered_set_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avlset/set/ordered_set_test.nim
- /verify/verify/collections/avlset/set/ordered_set_test.nim.html
title: verify/collections/avlset/set/ordered_set_test.nim
---
