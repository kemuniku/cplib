---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_retroactive_priority_queue.nim
    title: cplib/collections/compressed_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_retroactive_priority_queue.nim
    title: cplib/collections/compressed_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
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
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc363/tasks/abc363_g
    links:
    - https://atcoder.jp/contests/abc363/tasks/abc363_g
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc363/tasks/abc363_g\n\
    import algorithm\ninclude cplib/tmpl/fastio\nimport cplib/collections/compressed_retroactive_priority_queue\n\
    \ntype\n    Time = tuple[day, id: int]\n    Query = tuple[c, x: int, y: int64]\n\
    \nlet n = input(int)\nlet q = input(int)\nvar d = newSeq[int](n)\nvar p = newSeq[int64](n)\n\
    for i in 0..<n: d[i] = input(int)\nfor i in 0..<n: p[i] = input(int64)\nvar times:\
    \ seq[Time]\nfor day in 1..n: times.add((n - day, n))\nfor i in 0..<n: times.add((n\
    \ - d[i], i))\nvar queries = newSeq[Query](q)\nfor query in queries.mitems:\n\
    \    query = (input(int) - 1, input(int), input(int64))\n    times.add((n - query.x,\
    \ query.c))\n\nvar pq = initCompressedRetroactivePriorityQueue[Time, int64](times,\
    \ Descending)\nfor day in 1..n: pq.setPop((n - day, n))\nvar total = 0'i64\nfor\
    \ i in 0..<n:\n    pq.setPush((n - d[i], i), p[i])\n    total += p[i]\nfor (c,\
    \ x, y) in queries:\n    pq.erase((n - d[c], c))\n    pq.setPush((n - x, c), y)\n\
    \    total += y - p[c]\n    d[c] = x\n    p[c] = y\n    echo total - pq.sum\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/tmpl/fastio.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/retroactive_priority_queue.nim
  isVerificationFile: false
  path: verify/collections/retroactive_priority_queue_abc363g_test_.nim
  requiredBy: []
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/retroactive_priority_queue_abc363g_test_.nim
layout: document
redirect_from:
- /library/verify/collections/retroactive_priority_queue_abc363g_test_.nim
- /library/verify/collections/retroactive_priority_queue_abc363g_test_.nim.html
title: verify/collections/retroactive_priority_queue_abc363g_test_.nim
---
