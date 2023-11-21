---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/run_length_encode_test.nim
    title: verify/str/run_length_encode_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/run_length_encode_test.nim
    title: verify/str/run_length_encode_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_RUN_LENGTH_ENCODE_UTILS:\n    const CPLIB_STR_RUN_LENGTH_ENCODE_UTILS*\
    \ = 1\n    import sequtils\n    proc run_length_encode*[T](a: seq[T]): seq[(T,\
    \ int)] =\n        for i in 0..<len(a):\n            if result.len == 0:\n   \
    \             result.add((a[i], 1))\n                continue\n            if\
    \ result[^1][0] == a[i]: result[^1][1] += 1\n            else: result.add((a[i],\
    \ 1))\n\n    proc run_length_encode*(s: string): seq[(char, int)] =\n        var\
    \ a = s.items.toSeq\n        return run_length_encode(a)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/run_length_encode.nim
  requiredBy: []
  timestamp: '2023-11-19 18:26:38+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/run_length_encode_test.nim
  - verify/str/run_length_encode_test.nim
documentation_of: cplib/str/run_length_encode.nim
layout: document
redirect_from:
- /library/cplib/str/run_length_encode.nim
- /library/cplib/str/run_length_encode.nim.html
title: cplib/str/run_length_encode.nim
---
