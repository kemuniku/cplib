---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/edit_distance_test.nim
    title: verify/AI/edit_distance_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/edit_distance_test.nim
    title: verify/AI/edit_distance_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/edit_distance_test.nim
    title: verify/str/edit_distance_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/edit_distance_test.nim
    title: verify/str/edit_distance_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_EDIT_DISTANCE:\n    const CPLIB_STR_EDIT_DISTANCE*\
    \ = 1\n\n    import cplib/collections/staticRMQ\n    import cplib/str/suffix_array\n\
    \n    proc editDistance*(s, t: string, k: int): int =\n        ## \u633F\u5165\
    \u30FB\u524A\u9664\u30FB\u7F6E\u63DB\u3092\u5404\u30B3\u30B9\u30C8 1 \u3068\u3059\
    \u308B\u7DE8\u96C6\u8DDD\u96E2\u3092\u8FD4\u3057\u307E\u3059\u3002k \u3092\u8D85\
    \u3048\u308B\u5834\u5408\u306F -1\u3002\n        ## k >= 0 \u304C\u5FC5\u8981\u3067\
    \u3059\u3002string \u306E\u5404\u30D0\u30A4\u30C8\u3092 1 \u6587\u5B57\u3068\u3057\
    \u3066\u6271\u3044\u307E\u3059\u3002\n        ## N = |s| + |t| \u3068\u3057\u3066\
    \u3001\u6642\u9593 O(N log N + k^2)\u3001\u7A7A\u9593 O(N log N + k)\u3002\u30CF\
    \u30C3\u30B7\u30E5\u306F\u4F7F\u3044\u307E\u305B\u3093\u3002\n        assert k\
    \ >= 0, \"k\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n        let n = s.len\n        let m = t.len\n        if abs(n - m)\
    \ > k:\n            return -1\n        if n == 0 or m == 0:\n            return\
    \ max(n, m)\n        if k == 0:\n            return (if s == t: 0 else: -1)\n\n\
    \        let joined = s & t\n        let sa = suffix_array(joined)\n        var\
    \ rank = newSeq[int](joined.len)\n        for i, p in sa:\n            rank[p]\
    \ = i\n        let rmq = initRMQ(lcp_array(joined, sa))\n\n        template extend(x,\
    \ y: int): int =\n            ## \u4E21\u6587\u5B57\u5217\u306E\u672B\u5C3E\u3092\
    \u8D8A\u3048\u306A\u3044\u5171\u901A\u63A5\u982D\u8F9E\u9577\u3092 O(1) \u3067\
    \u6C42\u3081\u307E\u3059\u3002\n            (if x == n or y == m: 0 else:\n  \
    \              min(min(n - x, m - y),\n                    rmq.query(min(rank[x],\
    \ rank[n + y]), max(rank[x], rank[n + y]))))\n\n        let limit = min(k, max(n,\
    \ m))\n        let offset = limit + 1\n        var previous = newSeq[int](2 *\
    \ limit + 3)\n        var current = newSeq[int](previous.len)\n        for i in\
    \ 0..<previous.len:\n            previous[i] = -1\n        previous[offset] =\
    \ extend(0, 0)\n        if n == m and previous[offset] == n:\n            return\
    \ 0\n\n        # \u5BFE\u89D2\u7DDA d = y - x \u3054\u3068\u306B\u3001\u7DE8\u96C6\
    \u56DE\u6570\u4EE5\u4E0B\u3067\u5230\u9054\u3067\u304D\u308B\u6700\u5927\u306E\
    \ x \u3092\u4FDD\u6301\u3057\u307E\u3059\u3002\n        for edits in 1..limit:\n\
    \            for i in 0..<current.len:\n                current[i] = -1\n    \
    \        for d in -min(edits, n)..min(edits, m):\n                let idx = offset\
    \ + d\n                var x = previous[idx]\n                if x >= 0 and x\
    \ < n and x + d < m:\n                    inc x\n                let insertion\
    \ = previous[idx - 1]\n                if insertion >= 0 and insertion + d - 1\
    \ < m:\n                    x = max(x, insertion)\n                let deletion\
    \ = previous[idx + 1]\n                if deletion >= 0 and deletion < n:\n  \
    \                  x = max(x, deletion + 1)\n                if x < 0:\n     \
    \               continue\n                let y = x + d\n                x +=\
    \ extend(x, y)\n                current[idx] = x\n                if d == m -\
    \ n and x == n:\n                    return edits\n            swap(previous,\
    \ current)\n        return -1\n"
  dependsOn:
  - cplib/str/suffix_array.nim
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/suffix_array.nim
  isVerificationFile: false
  path: cplib/str/edit_distance.nim
  requiredBy: []
  timestamp: '2026-09-17 22:28:31+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/edit_distance_test.nim
  - verify/str/edit_distance_test.nim
  - verify/AI/edit_distance_test.nim
  - verify/AI/edit_distance_test.nim
documentation_of: cplib/str/edit_distance.nim
layout: document
redirect_from:
- /library/cplib/str/edit_distance.nim
- /library/cplib/str/edit_distance.nim.html
title: cplib/str/edit_distance.nim
---
