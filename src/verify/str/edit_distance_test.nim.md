---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/str/edit_distance.nim
    title: cplib/str/edit_distance.nim
  - icon: ':question:'
    path: cplib/str/edit_distance.nim
    title: cplib/str/edit_distance.nim
  - icon: ':question:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':question:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_E
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_E
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_E


    import cplib/str/edit_distance


    let s = stdin.readLine()

    let t = stdin.readLine()

    echo editDistance(s, t, max(s.len, t.len))

    '
  dependsOn:
  - cplib/str/edit_distance.nim
  - cplib/str/suffix_array.nim
  - cplib/str/edit_distance.nim
  - cplib/str/suffix_array.nim
  isVerificationFile: true
  path: verify/str/edit_distance_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/str/edit_distance_test.nim
layout: document
redirect_from:
- /verify/verify/str/edit_distance_test.nim
- /verify/verify/str/edit_distance_test.nim.html
title: verify/str/edit_distance_test.nim
---
