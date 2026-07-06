---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/graph/restore_shortest_path_from_prev


    assert restore_shortest_path_from_prev(@[-1, 0, 1, 2], 3) == @[0, 1, 2, 3]

    assert restore_shortest_path_from_prev(@[-1, 0, 0], 2) == @[0, 2]

    '
  dependsOn:
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  isVerificationFile: true
  path: verify/AI/restore_shortest_path_from_prev_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/restore_shortest_path_from_prev_test.nim
layout: document
redirect_from:
- /verify/verify/AI/restore_shortest_path_from_prev_test.nim
- /verify/verify/AI/restore_shortest_path_from_prev_test.nim.html
title: verify/AI/restore_shortest_path_from_prev_test.nim
---
