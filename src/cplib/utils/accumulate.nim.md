---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulate_test.nim
    title: verify/utils/accumulate/accumulate_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulate_test.nim
    title: verify/utils/accumulate/accumulate_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulated_2_test.nim
    title: verify/utils/accumulate/accumulated_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulated_2_test.nim
    title: verify/utils/accumulate/accumulated_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulated_test.nim
    title: verify/utils/accumulate/accumulated_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulated_test.nim
    title: verify/utils/accumulate/accumulated_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulatedr_2_test.nim
    title: verify/utils/accumulate/accumulatedr_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulatedr_2_test.nim
    title: verify/utils/accumulate/accumulatedr_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulatedr_test.nim
    title: verify/utils/accumulate/accumulatedr_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulatedr_test.nim
    title: verify/utils/accumulate/accumulatedr_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulater_test.nim
    title: verify/utils/accumulate/accumulater_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/accumulate/accumulater_test.nim
    title: verify/utils/accumulate/accumulater_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_ACCUMULATE:\n    const CPLIB_UTILS_ACCUMULATE*\
    \ = 1\n    template accumulated*[T](sequence:seq[T],operation:untyped,first:T):seq[T]=\n\
    \        let inner_seq = sequence\n        var result = newseq[T](len(inner_seq)+1)\n\
    \        result[0] = first\n        for i in 0..<len(inner_seq):\n           \
    \ let\n                a {.inject.} = result[i]\n                b {.inject.}\
    \ = inner_seq[i]\n            result[i+1] = operation\n        result\n\n    template\
    \ accumulated*[T](sequence:seq[T],operation:untyped):seq[T]=\n        let inner_seq\
    \ = sequence\n        var result = newseq[T](len(inner_seq))\n        if len(inner_seq)\
    \ >= 1:\n            result[0] = inner_seq[0]\n        for i in 1..<len(inner_seq):\n\
    \            let\n                a {.inject.} = result[i-1]\n               \
    \ b {.inject.} = inner_seq[i]\n            result[i] = operation\n        result\n\
    \n    template accumulate*[T](sequence:var seq[T],operation:untyped)=\n      \
    \  for i in 1..<len(sequence):\n            let\n                a {.inject.}\
    \ = sequence[i-1]\n                b {.inject.} = sequence[i]\n            sequence[i]\
    \ = operation\n\n    template accumulatedr*[T](sequence:seq[T],operation:untyped,first:T):seq[T]=\n\
    \        let inner_seq = sequence\n        var result = newseq[T](len(inner_seq)+1)\n\
    \        result[^1] = first\n        for i in countdown(len(inner_seq),1,1):\n\
    \            let\n                a {.inject.} = inner_seq[i-1]\n            \
    \    b {.inject.} = result[i]\n            result[i-1] = operation\n        result\n\
    \n    template accumulatedr*[T](sequence:seq[T],operation:untyped):seq[T]=\n \
    \       let inner_seq = sequence\n        var result = newseq[T](len(inner_seq))\n\
    \        if len(inner_seq) >= 1:\n            result[^1] = inner_seq[^1]\n   \
    \     for i in countdown(len(inner_seq)-2,0,1):\n            let\n           \
    \     a {.inject.} = inner_seq[i]\n                b {.inject.} = result[i+1]\n\
    \            result[i] = operation\n        result\n\n    template accumulater*[T](sequence:var\
    \ seq[T],operation:untyped)=\n        for i in countdown(len(sequence)-2,0,1):\n\
    \            let\n                a {.inject.} = sequence[i]\n               \
    \ b {.inject.} = sequence[i+1]\n            sequence[i] = operation\n\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/accumulate.nim
  requiredBy: []
  timestamp: '2024-08-17 01:24:43+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/accumulate/accumulate_test.nim
  - verify/utils/accumulate/accumulate_test.nim
  - verify/utils/accumulate/accumulated_test.nim
  - verify/utils/accumulate/accumulated_test.nim
  - verify/utils/accumulate/accumulatedr_2_test.nim
  - verify/utils/accumulate/accumulatedr_2_test.nim
  - verify/utils/accumulate/accumulatedr_test.nim
  - verify/utils/accumulate/accumulatedr_test.nim
  - verify/utils/accumulate/accumulater_test.nim
  - verify/utils/accumulate/accumulater_test.nim
  - verify/utils/accumulate/accumulated_2_test.nim
  - verify/utils/accumulate/accumulated_2_test.nim
documentation_of: cplib/utils/accumulate.nim
layout: document
redirect_from:
- /library/cplib/utils/accumulate.nim
- /library/cplib/utils/accumulate.nim.html
title: cplib/utils/accumulate.nim
---
