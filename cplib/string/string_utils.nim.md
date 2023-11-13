---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/string/run_length_encoding_test.nim
    title: verify/string/run_length_encoding_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/string/run_length_encoding_test.nim
    title: verify/string/run_length_encoding_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STRING_UTILS:\n    const CPLIB_STRING_UTILS* = 1\n\
    \    import sequtils\n    proc run_length_encode*[T](a: seq[T]): seq[(T, int)]\
    \ =\n        for i in 0..<len(a):\n            if result.len == 0:\n         \
    \       result.add((a[i], 1))\n                continue\n            if result[^1][0]\
    \ == a[i]: result[^1][1] += 1\n            else: result.add((a[i], 1))\n\n   \
    \ proc run_length_encode*(s: string): seq[(char, int)] =\n        var a = s.items.toSeq\n\
    \        return run_length_encode(a)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/string/string_utils.nim
  requiredBy: []
  timestamp: '2023-11-02 03:46:07+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/string/run_length_encoding_test.nim
  - verify/string/run_length_encoding_test.nim
documentation_of: cplib/string/string_utils.nim
layout: document
redirect_from:
- /library/cplib/string/string_utils.nim
- /library/cplib/string/string_utils.nim.html
title: cplib/string/string_utils.nim
---
