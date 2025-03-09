---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "proc maxIndex*[T](V : seq[seq[T]]):(int,int)=\n    result = (-1,-1)\n   \
    \ for i in 0..<len(V):\n        for j in 0..<len(V[i]):\n            if result\
    \ == (-1,-1) or V[i][j] > V[result[0]][result[1]]:\n                result = (i,j)\n\
    \nproc minIndex*[T](V : seq[seq[T]]):(int,int)=\n    result = (-1,-1)\n    for\
    \ i in 0..<len(V):\n        for j in 0..<len(V[i]):\n            if result ==\
    \ (-1,-1) or V[i][j] < V[result[0]][result[1]]:\n                result = (i,j)\n\
    \n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/sequtils2D.nim
  requiredBy: []
  timestamp: '2025-02-07 19:23:00+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/utils/sequtils2D.nim
layout: document
redirect_from:
- /library/cplib/utils/sequtils2D.nim
- /library/cplib/utils/sequtils2D.nim.html
title: cplib/utils/sequtils2D.nim
---
