---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lcp_naive_test.nim
    title: verify/AI/lcp_naive_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lcp_naive_test.nim
    title: verify/AI/lcp_naive_test.nim
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
  code: "when not declared CPLIB_STR_LCP_NAIVE:\n    const CPLIB_STR_LCP_NAIVE* =\
    \ 1\n    proc lcp_naive*[U](S,T:openArray[U]):int=\n        for i in 0..<(min(len(S),len(T))):\n\
    \            if S[i] != T[i]:\n                return i\n        return min(len(S),len(T))\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/lcp_naive.nim
  requiredBy: []
  timestamp: '2026-07-05 23:03:18+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/lcp_naive_test.nim
  - verify/AI/lcp_naive_test.nim
documentation_of: cplib/str/lcp_naive.nim
layout: document
redirect_from:
- /library/cplib/str/lcp_naive.nim
- /library/cplib/str/lcp_naive.nim.html
title: cplib/str/lcp_naive.nim
---
