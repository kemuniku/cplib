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
    path: cplib/utils/binary_search.nim
    title: cplib/utils/binary_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/binary_search.nim
    title: cplib/utils/binary_search.nim
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
    import cplib/str/can_reverse_hash_string\nimport cplib/utils/binary_search\nimport\
    \ strutils\n\nvar S = stdin.readLine().initRollingHash()\nvar L : seq[int]\n\n\
    for i in 0..<(2*len(S)-1):\n    if i mod 2 == 0:\n        var i = i div 2\n  \
    \      proc is_ok(arg:int):bool=\n            return S[(i-arg)..(i+arg)].isPalindrome()\n\
    \        L.add meguru_bisect(0,min(i,len(S)-i-1)+1,is_ok)*2 + 1\n    else:\n \
    \       var i = (i+1) div 2\n        proc is_ok(arg:int):bool=\n            return\
    \ S[(i-arg)..<(i+arg)].isPalindrome()\n        L.add meguru_bisect(0,min(i,len(S)-i)+1,is_ok)*2\n\
    \necho L.join(\" \")"
  dependsOn:
  - cplib/str/can_reverse_hash_string.nim
  - cplib/utils/binary_search.nim
  - cplib/str/can_reverse_hash_string.nim
  - cplib/utils/binary_search.nim
  isVerificationFile: true
  path: verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
  requiredBy: []
  timestamp: '2024-08-31 12:18:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
layout: document
redirect_from:
- /verify/verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
- /verify/verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim.html
title: verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
---
