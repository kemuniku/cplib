---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashtable.nim
    title: cplib/collections/hashtable.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashtable.nim
    title: cplib/collections/hashtable.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/2686
    links:
    - https://yukicoder.me/problems/no/2686
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/2686\nproc\
    \ scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\ninclude sequtils, strutils, algorithm,\
    \ sugar\nimport cplib/collections/segtree\nimport cplib/collections/hashtable\n\
    \nvar n, m, q = ii()\nvar a, b = newSeq[int](n)\nfor i in 0..<n:\n    a[i] = ii()\n\
    \    b[i] = ii()\n\nproc dp(a, b: seq[int]): HashTable[(int, int), int] =\n  \
    \  var n = a.len\n    var dp = initHashTable[(int, int), int]()\n    dp[(0, 0)]\
    \ = 0\n    for i in 0..<n:\n        var dpn = dp\n        for t, v in dp:\n  \
    \          var (x, y) = t\n            if (x+a[i], y) in dpn: dpn[(x+a[i], y)]\
    \ = max(dpn[(x+a[i], y)], v + b[i])\n            else: dpn[(x+a[i], y)] = v +\
    \ b[i]\n            if (x, y+a[i]) in dpn: dpn[(x, y+a[i])] = max(dpn[(x, y+a[i])],\
    \ v + b[i])\n            else: dpn[(x, y+a[i])] = v + b[i]\n        swap(dp, dpn)\n\
    \    return dp\nvar dp1 = dp(a[0..<(n div 2)], b[0..<(n div 2)])\nvar dp2 = dp(a[(n\
    \ div 2)..<n], b[(n div 2)..<n])\n\nvar c = dp2.keys.toSeq.mapIt(it[0]).sorted.deduplicate(true)\n\
    var add = newSeqWith(c.len, newSeq[(int, int)](0))\nfor k, v in dp2:\n    var\
    \ (x, y) = k\n    add[c.lowerBound(x)].add((y, v))\nvar seg = newSegWith(newSeqWith(c.len,\
    \ int(-3e18)), max(l, r), int(-3e18))\n\nvar qi = dp1.pairs.toseq.mapIt((it[0][0],\
    \ it[0][1], it[1])).sortedByIt(-it[0])\nvar ans = 0\nvar pos = 0\nfor (x, y, v)\
    \ in qi:\n    while pos < c.len and m - x >= c[pos]:\n        for (yn, vn) in\
    \ add[pos]:\n            seg[c.lowerBound(yn)] = max(seg[c.lowerBound(yn)], vn)\n\
    \        pos += 1\n    var r = c.upperBound(q - y)\n    ans = max(ans, seg.get(0..<r)\
    \ + v)\necho ans\n"
  dependsOn:
  - cplib/collections/hashtable.nim
  - cplib/collections/hashtable.nim
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/collections/hashtable_yuki2686_test.nim
  requiredBy: []
  timestamp: '2024-12-19 23:19:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/hashtable_yuki2686_test.nim
layout: document
redirect_from:
- /verify/verify/collections/hashtable_yuki2686_test.nim
- /verify/verify/collections/hashtable_yuki2686_test.nim.html
title: verify/collections/hashtable_yuki2686_test.nim
---
