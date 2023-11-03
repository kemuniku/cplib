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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_DATA_STRUCTURE_FENWICK_TREE:\n    const CPLIB_DATA_STRUCTURE_FENWICK_TREE\
    \ * = 1\n    import std/sequtils\n\n    type FenwickTree_Type*[T] = object\n \
    \       data*: seq[T]\n\n    proc initFenwickTree*[T](n: int): FenwickTree_Type[T]\
    \ =\n        return FenwickTree_Type()\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/data_structure/fenwick_tree.nim
  requiredBy: []
  timestamp: '2023-11-04 04:14:27+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/data_structure/fenwick_tree.nim
layout: document
redirect_from:
- /library/cplib/data_structure/fenwick_tree.nim
- /library/cplib/data_structure/fenwick_tree.nim.html
title: cplib/data_structure/fenwick_tree.nim
---
