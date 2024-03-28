---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/manachar.nim
    title: cplib/str/manachar.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/manachar.nim
    title: cplib/str/manachar.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/enumerate_palindromes
    links:
    - https://judge.yosupo.jp/problem/enumerate_palindromes
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_palindromes\n\
    import strutils, sequtils\nimport cplib/str/manachar\n\nvar s = stdin.readLine\n\
    s = s.mapIt(it & \"$\").join(\"\")[0..<(^1)]\nvar ans = manachar(s)\nfor i in\
    \ 0..<ans.len:\n    if i mod 2 != 0: ans[i] = ans[i] div 2 * 2\n    else: ans[i]\
    \ = (ans[i] + 1) div 2 * 2 - 1\necho ans.join(\" \")\n"
  dependsOn:
  - cplib/str/manachar.nim
  - cplib/str/manachar.nim
  isVerificationFile: true
  path: verify/str/manachar_test.nim
  requiredBy: []
  timestamp: '2024-01-07 15:19:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/manachar_test.nim
layout: document
redirect_from:
- /verify/verify/str/manachar_test.nim
- /verify/verify/str/manachar_test.nim.html
title: verify/str/manachar_test.nim
---