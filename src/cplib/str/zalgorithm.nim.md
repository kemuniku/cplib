---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_enumerate.nim
    title: cplib/str/run_enumerate.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_enumerate.nim
    title: cplib/str/run_enumerate.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/run_enumerate_test.nim
    title: verify/AI/run_enumerate_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/run_enumerate_test.nim
    title: verify/AI/run_enumerate_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/zalgorithm_test.nim
    title: verify/AI/zalgorithm_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/zalgorithm_test.nim
    title: verify/AI/zalgorithm_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/run_enumerate_yosupo_test.nim
    title: verify/str/run_enumerate_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/run_enumerate_yosupo_test.nim
    title: verify/str/run_enumerate_yosupo_test.nim
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_ZALGORITHM:\n    const CPLIB_STR_ZALGORITHM*\
    \ = 1\n    import sequtils\n    proc zalgorithm*[T](S: openArray[T]): seq[int]\
    \ =\n        var N = len(S)\n        result = newseqwith(N, -1)\n        if N\
    \ == 0:\n            return\n        result[0] = N\n        var i = 1\n      \
    \  var j = 0\n        while (i < N):\n            while (i+j < N and S[j] == S[i+j]):\n\
    \                j += 1\n            result[i] = j\n            if j == 0:\n \
    \               i += 1\n                continue\n            var k = 1\n    \
    \        while (i+k < N and k+result[k] < j):\n                result[i+k] = result[k]\n\
    \                k += 1\n            i += k\n            j -= k\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/zalgorithm.nim
  requiredBy:
  - cplib/str/run_enumerate.nim
  - cplib/str/run_enumerate.nim
  timestamp: '2026-07-09 09:03:36+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/zalgorithm_test.nim
  - verify/str/zalgorithm_test.nim
  - verify/str/run_enumerate_yosupo_test.nim
  - verify/str/run_enumerate_yosupo_test.nim
  - verify/AI/zalgorithm_test.nim
  - verify/AI/zalgorithm_test.nim
  - verify/AI/run_enumerate_test.nim
  - verify/AI/run_enumerate_test.nim
documentation_of: cplib/str/zalgorithm.nim
layout: document
redirect_from:
- /library/cplib/str/zalgorithm.nim
- /library/cplib/str/zalgorithm.nim.html
title: cplib/str/zalgorithm.nim
---
