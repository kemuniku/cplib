---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/itertools/itertools_combinations_test.nim
    title: verify/itertools/itertools_combinations_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/itertools/itertools_combinations_test.nim
    title: verify/itertools/itertools_combinations_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_ITERTOOLS_COMBINATIONS:\n    const CPLIB_ITERTOOLS_COMBINATIONS*\
    \ = 1\n    import std/sequtils, std/algorithm\n    iterator combinations*[T](v:\
    \ seq[T], r: int): seq[T] =\n        var x: seq[T]\n        var stack = @[not\
    \ 0, 0]\n        while len(stack) != 0:\n            var sindex = stack.pop()\n\
    \            if sindex >= 0:\n                if sindex != 0:\n              \
    \      x.add(v[sindex-1])\n                if len(x) == r:\n                 \
    \   yield x\n                else:\n                    for i in countdown(len(v)-(r-len(x)),\
    \ sindex, 1):\n                        stack.add(not(i+1))\n                 \
    \       stack.add(i+1)\n            else:\n                if sindex != -1:\n\
    \                    discard x.pop()\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/itertools/combinations.nim
  requiredBy: []
  timestamp: '2023-11-21 13:57:21+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/itertools/itertools_combinations_test.nim
  - verify/itertools/itertools_combinations_test.nim
documentation_of: cplib/itertools/combinations.nim
layout: document
redirect_from:
- /library/cplib/itertools/combinations.nim
- /library/cplib/itertools/combinations.nim.html
title: cplib/itertools/combinations.nim
---
