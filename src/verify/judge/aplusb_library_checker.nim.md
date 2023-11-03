---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/aplusb
    links:
    - https://judge.yosupo.jp/problem/aplusb
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/aplusb

    import strscans


    var a, b: int

    discard stdin.readLine.scanf("$i $i", a, b)

    echo a + b

    '
  dependsOn: []
  isVerificationFile: false
  path: verify/judge/aplusb_library_checker.nim
  requiredBy: []
  timestamp: '2023-11-03 12:47:02+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/judge/aplusb_library_checker.nim
layout: document
redirect_from:
- /library/verify/judge/aplusb_library_checker.nim
- /library/verify/judge/aplusb_library_checker.nim.html
title: verify/judge/aplusb_library_checker.nim
---
