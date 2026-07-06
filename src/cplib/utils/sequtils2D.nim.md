---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/sequtils2D_test.nim
    title: verify/AI/sequtils2D_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/sequtils2D_test.nim
    title: verify/AI/sequtils2D_test.nim
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
  code: "proc maxIndex*[T](V : openArray[seq[T]]):(int,int)=\n    result = (-1,-1)\n\
    \    for i in 0..<len(V):\n        for j in 0..<len(V[i]):\n            if result\
    \ == (-1,-1) or V[i][j] > V[result[0]][result[1]]:\n                result = (i,j)\n\
    \nproc minIndex*[T](V : openArray[seq[T]]):(int,int)=\n    result = (-1,-1)\n\
    \    for i in 0..<len(V):\n        for j in 0..<len(V[i]):\n            if result\
    \ == (-1,-1) or V[i][j] < V[result[0]][result[1]]:\n                result = (i,j)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/sequtils2D.nim
  requiredBy: []
  timestamp: '2026-07-06 04:42:52+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/sequtils2D_test.nim
  - verify/AI/sequtils2D_test.nim
documentation_of: cplib/utils/sequtils2D.nim
layout: document
redirect_from:
- /library/cplib/utils/sequtils2D.nim
- /library/cplib/utils/sequtils2D.nim.html
title: cplib/utils/sequtils2D.nim
---
