---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/rolling_hash.nim
    title: cplib/str/rolling_hash.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/rolling_hash.nim
    title: cplib/str/rolling_hash.nim
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
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/enumerate_palindromes
    links:
    - https://judge.yosupo.jp/problem/enumerate_palindromes
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_palindromes\n\
    import sequtils, strutils, algorithm\nimport cplib/str/rolling_hash\nimport cplib/utils/binary_search\n\
    \nvar s = stdin.readLine\nvar n = s.len\nvar rh = initRollingHash(s)\nvar rhr\
    \ = initRollingHash(s.reversed.join(\"\"))\nvar ans = newSeqWith(n*2-1, 0)\nfor\
    \ i in 0..<n*2-1:\n    var l = i div 2\n    var r = n - 1 - (i div 2)\n    if\
    \ i mod 2 == 0:\n        proc isok(x: int): bool = return x == 0 or rh.query(l-x..l+x)\
    \ == rhr.query(r-x..r+x)\n        var mx = min(i div 2, n - 1 - (i div 2))\n \
    \       var x = meguru_bisect(0, mx+1, isok)\n        ans[i] = x * 2 + 1\n   \
    \ else:\n        proc isok(x: int): bool = return x == 0 or rh.query(l-x+1..l+x)\
    \ == rhr.query(r-x..r+x-1)\n        var mx = min((i div 2) + 1, n - 1 - (i div\
    \ 2))\n        var x = meguru_bisect(0, mx+1, isok)\n        ans[i] = x * 2\n\
    echo ans.join(\" \")\n"
  dependsOn:
  - cplib/str/rolling_hash.nim
  - cplib/str/rolling_hash.nim
  - cplib/utils/binary_search.nim
  - cplib/utils/binary_search.nim
  isVerificationFile: false
  path: verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
  requiredBy: []
  timestamp: '2024-01-20 09:29:29+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
layout: document
redirect_from:
- /library/verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
- /library/verify/str/rolling_hash_yosupo_enumerate_palindromes.nim.html
title: verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
---
