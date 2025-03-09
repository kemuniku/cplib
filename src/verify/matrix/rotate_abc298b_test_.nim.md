---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matops.nim
    title: cplib/matrix/matops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matops.nim
    title: cplib/matrix/matops.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc298/tasks/abc298_b
    links:
    - https://atcoder.jp/contests/abc298/tasks/abc298_b
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc298/tasks/abc298_b\n\
    import cplib/matrix/matops\nimport strutils, sequtils, sugar\nvar n = stdin.readLine.parseInt\n\
    var a, b = collect(newSeq): (for i in 0..<n: stdin.readLine.split.map(parseInt))\n\
    for i in 0..<4:\n    proc check(a, b: seq[seq[int]]): bool =\n        for i in\
    \ 0..<n:\n            for j in 0..<n:\n                if a[i][j] == 1 and b[i][j]\
    \ == 0: return false\n        return true\n    if check(a.rotated(i), b):\n  \
    \      echo \"Yes\"\n        quit()\necho \"No\"\n"
  dependsOn:
  - cplib/matrix/matops.nim
  - cplib/matrix/matops.nim
  isVerificationFile: false
  path: verify/matrix/rotate_abc298b_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/matrix/rotate_abc298b_test_.nim
layout: document
redirect_from:
- /library/verify/matrix/rotate_abc298b_test_.nim
- /library/verify/matrix/rotate_abc298b_test_.nim.html
title: verify/matrix/rotate_abc298b_test_.nim
---
