---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':question:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/number_of_substrings
    links:
    - https://judge.yosupo.jp/problem/number_of_substrings
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings\n\
    import cplib/str/suffix_array\n\nlet S = stdin.readLine()\nlet SA = suffix_array(S)\n\
    let LCP = lcp_array(S, SA)\nvar sm = 0\nfor value in LCP:\n    sm += value\necho\
    \ len(S) * (len(S) + 1) div 2 - sm\n"
  dependsOn:
  - cplib/str/suffix_array.nim
  - cplib/str/suffix_array.nim
  isVerificationFile: true
  path: verify/str/static_string/static_string_lcp_test.nim
  requiredBy: []
  timestamp: '2026-09-08 13:45:31+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/static_string/static_string_lcp_test.nim
layout: document
redirect_from:
- /verify/verify/str/static_string/static_string_lcp_test.nim
- /verify/verify/str/static_string/static_string_lcp_test.nim.html
title: verify/str/static_string/static_string_lcp_test.nim
---
