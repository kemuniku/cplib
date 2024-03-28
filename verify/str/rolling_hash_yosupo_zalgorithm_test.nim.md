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
    PROBLEM: https://judge.yosupo.jp/problem/zalgorithm
    links:
    - https://judge.yosupo.jp/problem/zalgorithm
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/zalgorithm\n\
    import sequtils, strutils\nimport cplib/str/rolling_hash\nimport cplib/utils/binary_search\n\
    \nvar s = stdin.readLine\nvar rh = initRollingHash(s)\nvar ans = newSeqWith(s.len,\
    \ 0)\nfor i in 0..<s.len:\n    proc isok(x: int): bool = x == 0 or rh.query(i..<i+x)\
    \ == rh.query(0..<x)\n    ans[i] = meguru_bisect(0, s.len - i + 1, isok)\necho\
    \ ans.join(\" \")\n"
  dependsOn:
  - cplib/utils/binary_search.nim
  - cplib/utils/binary_search.nim
  - cplib/str/rolling_hash.nim
  - cplib/str/rolling_hash.nim
  isVerificationFile: true
  path: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  requiredBy: []
  timestamp: '2024-01-20 09:29:29+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
layout: document
redirect_from:
- /verify/verify/str/rolling_hash_yosupo_zalgorithm_test.nim
- /verify/verify/str/rolling_hash_yosupo_zalgorithm_test.nim.html
title: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
---
