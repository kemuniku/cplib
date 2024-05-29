---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/zalgorithm_test.nim
    title: verify/str/zalgorithm_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/zalgorithm_test.nim
    title: verify/str/zalgorithm_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_ZALGORITHM:\n    const CPLIB_STR_ZALGORITHM*\
    \ = 1\n    import sequtils\n    proc zalgorithm*(S:string):seq[int]=\n       \
    \ var N = len(S)\n        result = newseqwith(N,-1)\n        result[0] = S.len();\n\
    \        var i = 1\n        var j = 0\n        while (i < S.len()):\n        \
    \    while (i+j < S.len() and S[j] == S[i+j]):\n                j += 1\n     \
    \       result[i] = j\n            if j == 0:\n                i += 1\n      \
    \          continue\n            var k = 1\n            while (i+k < S.len() and\
    \ k+result[k] < j):\n                result[i+k] = result[k]\n               \
    \ k += 1\n            i += k\n            j -= k"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/zalgorithm.nim
  requiredBy: []
  timestamp: '2024-05-29 17:28:48+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/zalgorithm_test.nim
  - verify/str/zalgorithm_test.nim
documentation_of: cplib/str/zalgorithm.nim
layout: document
redirect_from:
- /library/cplib/str/zalgorithm.nim
- /library/cplib/str/zalgorithm.nim.html
title: cplib/str/zalgorithm.nim
---
