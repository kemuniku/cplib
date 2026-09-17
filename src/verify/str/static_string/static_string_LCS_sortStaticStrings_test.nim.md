---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/longest_common_substring
    links:
    - https://judge.yosupo.jp/problem/longest_common_substring
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/longest_common_substring\n\
    import cplib/str/static_string\n\nlet RS = stdin.readLine()\nlet RT = stdin.readLine()\n\
    let tmp = @[RS, RT].toStaticStrings()\nlet S = tmp[0]\nlet T = tmp[1]\n\nvar X:\
    \ seq[StaticString[char]]\nfor i in 0..<len(S):\n    X.add(S[i..<len(S)])\nfor\
    \ i in 0..<len(T):\n    X.add(T[i..<len(T)])\n\nX.sortStaticStrings()\n\nvar a,\
    \ b, c, d: int\nvar l = 0\nfor i in 0..<(len(X)-1):\n    if X[i].r != X[i+1].r:\n\
    \        let common = lcp(X[i], X[i+1])\n        if l < common:\n            l\
    \ = common\n            a = X[i].l\n            b = a + l\n            c = X[i+1].l\n\
    \            d = c + l\n            if X[i].r == T.r:\n                swap(a,\
    \ c)\n                swap(b, d)\n            c -= T.l\n            d -= T.l\n\
    \necho a, \" \", b, \" \", c, \" \", d\n"
  dependsOn:
  - cplib/str/suffix_array.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/suffix_array.nim
  - cplib/str/static_string.nim
  isVerificationFile: true
  path: verify/str/static_string/static_string_LCS_sortStaticStrings_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:22:04+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/static_string/static_string_LCS_sortStaticStrings_test.nim
layout: document
redirect_from:
- /verify/verify/str/static_string/static_string_LCS_sortStaticStrings_test.nim
- /verify/verify/str/static_string/static_string_LCS_sortStaticStrings_test.nim.html
title: verify/str/static_string/static_string_LCS_sortStaticStrings_test.nim
---
