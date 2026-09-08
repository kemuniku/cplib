---
data:
  _extendedDependsOn:
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
    \ = 1\n\n    import bitops\n    import cplib/str/suffix_array\n\n    type EditDistanceRMQ\
    \ = object\n        values: seq[int]\n        masks: seq[uint]\n        table:\
    \ seq[seq[int]]\n        blockSize: int\n\n    proc initEditDistanceRMQ(values:\
    \ seq[int]): EditDistanceRMQ =\n        ## \u9577\u3055 N \u306E\u914D\u5217\u306E\
    \ RMQ \u3092\u6642\u9593\u30FB\u7A7A\u9593 O(N) \u3067\u69CB\u7BC9\u3057\u307E\
    \u3059\u3002\n        result.values = values\n        let n = values.len\n   \
    \     result.blockSize = max(1, fastLog2(n))\n        let size = result.blockSize\n\
    \        let blocks = (n + size - 1) div size\n        result.masks = newSeq[uint](n)\n\
    \        result.table = @[newSeq[int](blocks)]\n        for b in 0..<blocks:\n\
    \            let first = b * size\n            let last = min(first + size, n)\n\
    \            var mask = 0'u\n            for i in first..<last:\n            \
    \    while mask != 0:\n                    let top = fastLog2(mask)\n        \
    \            if values[first + top] < values[i]:\n                        break\n\
    \                    mask = mask xor (1'u shl top)\n                mask = mask\
    \ or (1'u shl (i - first))\n                result.masks[i] = mask\n         \
    \   result.table[0][b] = values[first + countTrailingZeroBits(mask)]\n       \
    \ # \u30D6\u30ED\u30C3\u30AF\u9577\u3092 \u0398(log N) \u306B\u3059\u308B\u305F\
    \u3081\u3001\u4E0A\u4F4D\u8868\u3082 O(N) \u306B\u53CE\u307E\u308A\u307E\u3059\
    \u3002\n        var k = 1\n        while (1 shl k) <= blocks:\n            let\
    \ distance = 1 shl (k - 1)\n            var row = newSeq[int](blocks - (1 shl\
    \ k) + 1)\n            for i in 0..<row.len:\n                row[i] = min(result.table[k\
    \ - 1][i], result.table[k - 1][i + distance])\n            result.table.add(move(row))\n\
    \            inc k\n\n    proc inBlock(rmq: EditDistanceRMQ, l, r: int): int {.inline.}\
    \ =\n        ## \u540C\u4E00\u30D6\u30ED\u30C3\u30AF\u5185\u306E\u534A\u958B\u533A\
    \u9593 [l, r) \u306E\u6700\u5C0F\u5024\u3092 O(1) \u3067\u8FD4\u3057\u307E\u3059\
    \u3002\n        let first = l div rmq.blockSize * rmq.blockSize\n        let mask\
    \ = rmq.masks[r - 1] and (high(uint) shl (l - first))\n        return rmq.values[first\
    \ + countTrailingZeroBits(mask)]\n\n    proc query(rmq: EditDistanceRMQ, l, r:\
    \ int): int {.inline.} =\n        ## \u7A7A\u3067\u306A\u3044\u534A\u958B\u533A\
    \u9593 [l, r) \u306E\u6700\u5C0F\u5024\u3092 O(1) \u3067\u8FD4\u3057\u307E\u3059\
    \u3002\n        let a = l div rmq.blockSize\n        let b = (r - 1) div rmq.blockSize\n\
    \        if a == b:\n            return rmq.inBlock(l, r)\n        result = min(rmq.inBlock(l,\
    \ (a + 1) * rmq.blockSize),\n            rmq.inBlock(b * rmq.blockSize, r))\n\
    \        if a + 1 < b:\n            let k = fastLog2(b - a - 1)\n            result\
    \ = min(result, min(rmq.table[k][a + 1], rmq.table[k][b - (1 shl k)]))\n\n   \
    \ proc editDistance*(s, t: string, k: int): int =\n        ## \u633F\u5165\u30FB\
    \u524A\u9664\u30FB\u7F6E\u63DB\u3092\u5404\u30B3\u30B9\u30C8 1 \u3068\u3059\u308B\
    \u7DE8\u96C6\u8DDD\u96E2\u3092\u8FD4\u3057\u307E\u3059\u3002k \u3092\u8D85\u3048\
    \u308B\u5834\u5408\u306F -1\u3002\n        ## k >= 0 \u304C\u5FC5\u8981\u3067\u3059\
    \u3002string \u306E\u5404\u30D0\u30A4\u30C8\u3092 1 \u6587\u5B57\u3068\u3057\u3066\
    \u6271\u3044\u307E\u3059\u3002\n        ## \u6642\u9593 O(|s| + |t| + k^2)\u3001\
    \u7A7A\u9593 O(|s| + |t| + k)\u3002\u30CF\u30C3\u30B7\u30E5\u306F\u4F7F\u3044\u307E\
    \u305B\u3093\u3002\n        doAssert k >= 0\n        let n = s.len\n        let\
    \ m = t.len\n        if abs(n - m) > k:\n            return -1\n        if n ==\
    \ 0 or m == 0:\n            return max(n, m)\n        if k == 0:\n           \
    \ return (if s == t: 0 else: -1)\n\n        let joined = s & t\n        let sa\
    \ = suffix_array(joined)\n        var rank = newSeq[int](joined.len)\n       \
    \ for i, p in sa:\n            rank[p] = i\n        let rmq = initEditDistanceRMQ(lcp_array(joined,\
    \ sa))\n\n        template extend(x, y: int): int =\n            ## \u4E21\u6587\
    \u5B57\u5217\u306E\u672B\u5C3E\u3092\u8D8A\u3048\u306A\u3044\u5171\u901A\u63A5\
    \u982D\u8F9E\u9577\u3092 O(1) \u3067\u6C42\u3081\u307E\u3059\u3002\n         \
    \   (if x == n or y == m: 0 else:\n                min(min(n - x, m - y),\n  \
    \                  rmq.query(min(rank[x], rank[n + y]), max(rank[x], rank[n +\
    \ y]))))\n\n        let limit = min(k, max(n, m))\n        let offset = limit\
    \ + 1\n        var previous = newSeq[int](2 * limit + 3)\n        var current\
    \ = newSeq[int](previous.len)\n        for i in 0..<previous.len:\n          \
    \  previous[i] = -1\n        previous[offset] = extend(0, 0)\n        if n ==\
    \ m and previous[offset] == n:\n            return 0\n\n        # \u5BFE\u89D2\
    \u7DDA d = y - x \u3054\u3068\u306B\u3001\u7DE8\u96C6\u56DE\u6570\u4EE5\u4E0B\u3067\
    \u5230\u9054\u3067\u304D\u308B\u6700\u5927\u306E x \u3092\u4FDD\u6301\u3057\u307E\
    \u3059\u3002\n        for edits in 1..limit:\n            for i in 0..<current.len:\n\
    \                current[i] = -1\n            for d in -min(edits, n)..min(edits,\
    \ m):\n                let idx = offset + d\n                var x = previous[idx]\n\
    \                if x >= 0 and x < n and x + d < m:\n                    inc x\n\
    \                let insertion = previous[idx - 1]\n                if insertion\
    \ >= 0 and insertion + d - 1 < m:\n                    x = max(x, insertion)\n\
    \                let deletion = previous[idx + 1]\n                if deletion\
    \ >= 0 and deletion < n:\n                    x = max(x, deletion + 1)\n     \
    \           if x < 0:\n                    continue\n                let y = x\
    \ + d\n                x += extend(x, y)\n                current[idx] = x\n \
    \               if d == m - n and x == n:\n                    return edits\n\
    \            swap(previous, current)\n        return -1\n"
  dependsOn:
  - cplib/str/suffix_array.nim
  - cplib/str/suffix_array.nim
  isVerificationFile: false
  path: cplib/str/edit_distance.nim
  requiredBy: []
  timestamp: '2026-09-08 16:17:28+09:00'
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
