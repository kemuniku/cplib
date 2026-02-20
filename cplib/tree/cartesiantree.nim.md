---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/tree/cartesiantree_test.nim
    title: verify/tree/cartesiantree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/cartesiantree_test.nim
    title: verify/tree/cartesiantree_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TREE_CARTESIAN_TREE:\n    const CPLIB_TREE_CARTESIAN_TREE*\
    \ = 1\n    import sequtils\n\n    proc cartesian_tree_tuple*(A:seq[int]):seq[tuple[p:int,l:int,r:int]]=\n\
    \        result = newseqwith(len(A),(-1,-1,-1))\n        var stack : seq[int]\n\
    \n        for i in 0..<(len(A)):\n            var s = -1\n            while len(stack)\
    \ > 0 and A[stack[^1]] > A[i]:\n                s = stack.pop()\n            if\
    \ s != -1:\n                if result[i].l != -1:\n                    swap(result[i].l\
    \ , result[s].l)\n                else:\n                    result[i].l = s\n\
    \                result[s].p = i\n            if len(stack) > 0:\n           \
    \     result[i].p = stack[^1]\n                result[stack[^1]].r = i\n     \
    \       stack.add(i)\n\n            #echo stack.mapit(A[it])"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tree/cartesiantree.nim
  requiredBy: []
  timestamp: '2026-02-11 05:05:44+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/cartesiantree_test.nim
  - verify/tree/cartesiantree_test.nim
documentation_of: cplib/tree/cartesiantree.nim
layout: document
redirect_from:
- /library/cplib/tree/cartesiantree.nim
- /library/cplib/tree/cartesiantree.nim.html
title: cplib/tree/cartesiantree.nim
---
