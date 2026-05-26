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
  code: "when not declared CPLIB_UTILS_SEQIDX:\n    const CPLIB_UTILS_SEQIDX* = 1\n\
    \n    template allItidx*(s, pred: untyped): bool =\n        var result = true\n\
    \        for idx{.inject.},it {.inject.} in s:\n            if not pred:\n   \
    \             result = false\n                break\n        result\n\n    template\
    \ findItIdx*(s, predicate: untyped): int =\n        var\n            res = -1\n\
    \            i = 0\n\n        for idx{.inject.},it {.inject.} in s:\n        \
    \    if predicate:\n                res = i\n                break\n         \
    \   i += 1\n        res\n\n    template anyItIdx*(s, pred: untyped): bool =\n\
    \        findItIdx(s, pred) != -1\n\n    template mapItIdx*(s: typed, op: untyped):\
    \ untyped =\n        block:\n            type OutType = typeof((\n           \
    \     block:\n                    var it{.inject, used.}: typeof(items(s), typeOfIter);var\
    \ idx{.inject, used.} : int;\n                    op), typeOfProc)\n         \
    \   var result = newSeq[OutType](len(s))\n            var idx{.inject.} = 0\n\
    \            for it{.inject.} in s:\n                result[idx] = op\n      \
    \          idx += 1\n            move(result)\n\n    template newSeqWithIdx*(len:\
    \ int, init: untyped): untyped =\n        block:\n            var idx{.inject.}\
    \ : int = 0\n            type T = typeof(init)\n            let newLen = len\n\
    \            var result = newSeq[T](newLen)\n            for i in 0 ..< newLen:\n\
    \                result[i] = init\n                idx += 1\n            move(result)"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/seqidx.nim
  requiredBy: []
  timestamp: '2026-05-26 10:13:51+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/utils/seqidx.nim
layout: document
redirect_from:
- /library/cplib/utils/seqidx.nim
- /library/cplib/utils/seqidx.nim.html
title: cplib/utils/seqidx.nim
---
