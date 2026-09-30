---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/double_ended_priority_queue.nim
    title: cplib/collections/double_ended_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/double_ended_priority_queue.nim
    title: cplib/collections/double_ended_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/double_ended_priority_queue
    links:
    - https://judge.yosupo.jp/problem/double_ended_priority_queue
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/double_ended_priority_queue\n\
    include cplib/tmpl/fastio\nimport cplib/collections/double_ended_priority_queue\n\
    \nlet n = input(int)\nlet q = input(int)\nvar heap = input(n, int).toDoubleEndedPriorityQueue()\n\
    for _ in 0..<q:\n    case input(int)\n    of 0: heap.push(input(int))\n    of\
    \ 1: print(heap.popMin())\n    else: print(heap.popMax())\n"
  dependsOn:
  - cplib/collections/double_ended_priority_queue.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/collections/double_ended_priority_queue.nim
  isVerificationFile: true
  path: verify/collections/double_ended_priority_queue_test.nim
  requiredBy: []
  timestamp: '2026-09-30 06:04:26+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/double_ended_priority_queue_test.nim
layout: document
redirect_from:
- /verify/verify/collections/double_ended_priority_queue_test.nim
- /verify/verify/collections/double_ended_priority_queue_test.nim.html
title: verify/collections/double_ended_priority_queue_test.nim
---
