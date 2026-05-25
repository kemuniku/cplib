---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/manacher.nim
    title: cplib/str/manacher.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/manacher.nim
    title: cplib/str/manacher.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/enumerate_palindromes
    links:
    - https://judge.yosupo.jp/problem/enumerate_palindromes
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_palindromes\n\
    \ninclude cplib/tmpl/sheep\nimport cplib/str/manacher\nimport cplib/str/can_reverse_hash_string\n\
    \nvar S = si()\n\nvar HS = S.initRollingHash()\n\nvar palindromes = get_palindromes(S)\n\
    \nfor i in range(len(palindromes)):\n    var (l,r) = palindromes[i]\n    assert\
    \ HS[l..<r].isPalindrome()\n    if l != 0 and r != len(S) and l != -1:\n     \
    \   assert not HS[(l-1)..<(r+1)].isPalindrome()\n\necho palindromes.mapit(it[1]-it[0]).join(\"\
    \ \")"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep.nim
  - cplib/str/can_reverse_hash_string.nim
  - cplib/str/manacher.nim
  - cplib/str/manacher.nim
  - cplib/str/can_reverse_hash_string.nim
  isVerificationFile: true
  path: verify/str/get_palindromes_test.nim
  requiredBy: []
  timestamp: '2026-05-24 07:19:32+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/get_palindromes_test.nim
layout: document
redirect_from:
- /verify/verify/str/get_palindromes_test.nim
- /verify/verify/str/get_palindromes_test.nim.html
title: verify/str/get_palindromes_test.nim
---
