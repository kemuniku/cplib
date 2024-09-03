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
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc141/tasks/abc141_e
    links:
    - https://atcoder.jp/contests/abc141/tasks/abc141_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc141/tasks/abc141_e\n\
    import strutils, tables\nimport cplib/str/rolling_hash\nimport cplib/utils/binary_search\n\
    \nvar n = stdin.readLine.parseInt\nvar s = stdin.readLine\nvar rh = initRollingHash(s)\n\
    \nproc is_ok(x: int): bool =\n    var seen = initTable[uint, int]()\n    for i\
    \ in 0..<n-x+1:\n        var sh = rh.query(i..<i+x)\n        if sh in seen:\n\
    \            if seen[sh] + x <= i:\n                return true\n        else:\n\
    \            seen[sh] = i\n    return false\nif not is_ok(1):\n    echo 0\n  \
    \  quit()\necho meguru_bisect(1, n div 2 + 1, is_ok)\n"
  dependsOn:
  - cplib/utils/binary_search.nim
  - cplib/str/rolling_hash.nim
  - cplib/utils/binary_search.nim
  - cplib/str/rolling_hash.nim
  isVerificationFile: true
  path: verify/str/rolling_hash_pun_test.nim
  requiredBy: []
  timestamp: '2024-06-07 22:14:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/rolling_hash_pun_test.nim
layout: document
redirect_from:
- /verify/verify/str/rolling_hash_pun_test.nim
- /verify/verify/str/rolling_hash_pun_test.nim.html
title: verify/str/rolling_hash_pun_test.nim
---
