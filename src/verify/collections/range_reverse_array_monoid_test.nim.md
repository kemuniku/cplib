---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_array_monoid.nim
    title: cplib/collections/range_reverse_array_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_array_monoid.nim
    title: cplib/collections/range_reverse_array_monoid.nim
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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\nimport sequtils\nimport cplib/collections/range_reverse_array_monoid\n\
    \nproc addInt(a, b: int): int = a + b\n\nvar emptyMonoid = initRangeReverseArrayMonoid(newSeq[int](),\
    \ addInt, 0)\nemptyMonoid.reverse(0, 0)\nassert emptyMonoid.len == 0\nassert emptyMonoid.get_all\
    \ == 0\nassert emptyMonoid.get(0, 0) == 0\n\nvar d = initRangeReverseArrayMonoid((0..<8).toSeq,\
    \ addInt, 0)\nassert d.len == 8\nassert d.get_all == 28\nassert d.get(2, 6) ==\
    \ 14\nassert d[2..5] == 14\nd.reverse(1, 7)\nassert d.toSeq == @[0, 6, 5, 4, 3,\
    \ 2, 1, 7]\nassert d.get_all == 28\nassert d.get(1, 4) == 15\nd[3] = 100\nassert\
    \ d.toSeq == @[0, 6, 5, 100, 3, 2, 1, 7]\nassert d.get(2, 6) == 110\nassert d[^1]\
    \ == 7\n\nvar e = newRangeReverseArrayMonoidWith((1..5).toSeq, l + r, 0)\nassert\
    \ e.fold == 15\ne.reverse(1..<4)\nassert e.toSeq == @[1, 4, 3, 2, 5]\nassert e.fold(1,\
    \ 4) == 9\n\nproc concat(a, b: string): string = a & b\n\nvar f = initRangeReverseArrayMonoid([\"\
    a\", \"b\", \"c\", \"d\", \"e\"], concat, \"\")\nassert f.get_all == \"abcde\"\
    \nassert f.get(1, 4) == \"bcd\"\nf.reverse(1, 5)\nassert f.toSeq == @[\"a\", \"\
    e\", \"d\", \"c\", \"b\"]\nassert f.get_all == \"aedcb\"\nassert f[1..3] == \"\
    edc\"\nf[2] = \"X\"\nassert f.toSeq == @[\"a\", \"e\", \"X\", \"c\", \"b\"]\n\
    assert f.fold == \"aeXcb\"\nassert $f == \"a e X c b\"\n\nimport std/[random,\
    \ strutils, algorithm]\n\nblock:\n    var rng = initRand(91842)\n    var seg =\
    \ newRangeReverseArrayMonoidWith(newSeq[int](), l + r, 0)\n    var values: seq[int]\n\
    \    for step in 0..<12000:\n        let n = values.len\n        let i = rng.rand(n)\n\
    \        case rng.rand(0..6)\n        of 0, 1:\n            let x = rng.rand(20)\n\
    \            seg.insert(i, x)\n            values.insert(x, i)\n        of 2:\n\
    \            if i < n:\n                seg.erase(i)\n                values.delete(i)\n\
    \        of 3:\n            if i < n:\n                let x = rng.rand(20)\n\
    \                seg[i] = x\n                values[i] = x\n        of 4:\n  \
    \          if step mod 17 == 0:\n                let r = rng.rand(i..n)\n    \
    \            seg.erase(i..<r)\n                values = values[0..<i] & values[r..<n]\n\
    \        of 5:\n            let r = rng.rand(i..n)\n            seg.reverse(i,\
    \ r)\n            if i < r: values.reverse(i, r - 1)\n        else:\n        \
    \    if i < n: doAssert seg[i] == values[i]\n        doAssert seg.len == values.len\n\
    \        var total = 0\n        for x in values: total += x\n        doAssert\
    \ seg.fold == total\n        let l = rng.rand(values.len)\n        let r = rng.rand(l..values.len)\n\
    \        var expected = 0\n        for j in l..<r: expected += values[j]\n   \
    \     doAssert seg[l..<r] == expected\n        let limit = rng.rand(100)\n   \
    \     var right = l\n        var sum = 0\n        while right < values.len and\
    \ sum + values[right] <= limit:\n            sum += values[right]\n          \
    \  inc right\n        doAssert seg.max_right(l, proc(x: int): bool = x <= limit)\
    \ == right\n        var left = r\n        sum = 0\n        while left > 0 and\
    \ sum + values[left - 1] <= limit:\n            dec left\n            sum += values[left]\n\
    \        doAssert seg.min_left(r, proc(x: int): bool = x <= limit) == left\n \
    \       if step mod 101 == 0: doAssert seg.toSeq == values\n    seg.erase(0, seg.len)\n\
    \    doAssert seg.fold == 0\n    doAssert seg.toSeq == newSeq[int]()\n    seg.insert(0,\
    \ 7)\n    doAssert seg[^1] == 7\n    doAssert $seg == \"7\"\n\n# \u975E\u53EF\u63DB\
    \u306A\u96C6\u7D04\u3068\u5883\u754C\u63A2\u7D22\u306E\u9806\u5E8F\u3092\u691C\
    \u8A3C\u3059\u308B\u3002\nblock:\n    var seg = newRangeReverseArrayMonoidWith(@[\"\
    a\", \"bc\", \"d\", \"ef\", \"g\"], l & r, \"\")\n    seg.insert(2, \"xy\")\n\
    \    seg.erase(0)\n    seg[3] = \"z\"\n    let values = @[\"bc\", \"xy\", \"d\"\
    , \"z\", \"g\"]\n    doAssert seg.toSeq == values\n    for l in 0..seg.len:\n\
    \        for r in l..seg.len:\n            let target = values[l..<r].join(\"\"\
    )\n            doAssert seg.fold(l, r) == target\n            doAssert seg.max_right(l,\
    \ proc(x: string): bool = target.startsWith(x)) == r\n            doAssert seg.min_left(r,\
    \ proc(x: string): bool = target.endsWith(x)) == l\n    doAssert seg.fold == values.join(\"\
    \")\n    seg.erase(1..3)\n    doAssert seg.toSeq == @[\"bc\", \"g\"]\n\n# \u69CB\
    \u7BC9\u3068\u3001\u4E00\u70B9\u66F4\u65B0\u30FB\u53D6\u5F97\u304C\u96C6\u7D04\
    \u3092\u4E0D\u5FC5\u8981\u306B\u518D\u8A08\u7B97\u3057\u306A\u3044\u3053\u3068\
    \u3092\u78BA\u8A8D\u3059\u308B\u3002\nblock:\n    var calls = 0\n    proc op(a,\
    \ b: int): int =\n        inc calls\n        a + b\n    var seg = initRangeReverseArrayMonoid(newSeqWith(10000,\
    \ 1), op, 0)\n    doAssert seg.get_all == 10000\n    calls = 0\n    doAssert seg.get(0,\
    \ 10000) == 10000\n    doAssert seg[5000] == 1\n    doAssert calls == 0\n    seg.update(5000,\
    \ 20)\n    doAssert seg.get_all == 10019\n    doAssert seg.get(4999..5001) ==\
    \ 22\n    doAssert seg.fold(0..<0) == 0\n\n# \u975E\u53EF\u63DB\u306A\u96C6\u7D04\
    \u3067\u3001\u672A\u4F1D\u64AD\u306E\u53CD\u8EE2\u3068\u633F\u5165\u30FB\u524A\
    \u9664\u30FB\u63A2\u7D22\u3092\u6DF7\u5728\u3055\u305B\u308B\u3002\nblock:\n \
    \   var rng = initRand(37283)\n    var values = @[\"a\", \"b\", \"c\", \"d\"]\n\
    \    var seg = newRangeReverseArrayMonoidWith(values, l & r, \"\")\n    for step\
    \ in 0..<2000:\n        let n = values.len\n        let l = rng.rand(n)\n    \
    \    let r = rng.rand(l..n)\n        case step mod 4\n        of 0:\n        \
    \    seg.reverse(l, r)\n            if l < r: values.reverse(l, r - 1)\n     \
    \   of 1:\n            seg.insert(l, \"x\")\n            values.insert(\"x\",\
    \ l)\n        of 2:\n            seg.erase(l, r)\n            values = values[0..<l]\
    \ & values[r..<n]\n        else:\n            if l < n:\n                seg[l]\
    \ = \"yz\"\n                values[l] = \"yz\"\n        doAssert seg.fold == values.join(\"\
    \")\n        let a = rng.rand(values.len)\n        let b = rng.rand(a..values.len)\n\
    \        let target = values[a..<b].join(\"\")\n        doAssert seg.get(a, b)\
    \ == target\n        doAssert seg.max_right(a, proc(x: string): bool = target.startsWith(x))\
    \ == b\n        doAssert seg.min_left(b, proc(x: string): bool = target.endsWith(x))\
    \ == a\n    doAssert seg.toSeq == values\n"
  dependsOn:
  - cplib/collections/range_reverse_array_monoid.nim
  - cplib/collections/range_reverse_array_monoid.nim
  isVerificationFile: true
  path: verify/collections/range_reverse_array_monoid_test.nim
  requiredBy: []
  timestamp: '2026-09-06 11:23:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_reverse_array_monoid_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_reverse_array_monoid_test.nim
- /verify/verify/collections/range_reverse_array_monoid_test.nim.html
title: verify/collections/range_reverse_array_monoid_test.nim
---
