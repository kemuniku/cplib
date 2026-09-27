---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_rectangle_add_rectangle_sum_test.nim
    title: verify/AI/static_rectangle_add_rectangle_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_rectangle_add_rectangle_sum_test.nim
    title: verify/AI/static_rectangle_add_rectangle_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/static_rectangle_add_rectangle_sum_test.nim
    title: verify/utils/static_rectangle_add_rectangle_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/static_rectangle_add_rectangle_sum_test.nim
    title: verify/utils/static_rectangle_add_rectangle_sum_test.nim
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
  code: "## \u9577\u65B9\u5F62\u3078\u306E\u52A0\u7B97\u5F8C\u3001\u9577\u65B9\u5F62\
    \u5185\u306E\u7DCF\u548C\u3092\u30AA\u30D5\u30E9\u30A4\u30F3\u3067\u6C42\u3081\
    \u307E\u3059\u3002\nwhen not declared CPLIB_UTILS_STATIC_RECTANGLE_ADD_RECTANGLE_SUM:\n\
    \    const CPLIB_UTILS_STATIC_RECTANGLE_ADD_RECTANGLE_SUM* = 1\n    import algorithm\n\
    \    # \u6DFB\u5B57\u306F\u5185\u90E8\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\
    -d:debug\u3067\u306F\u5883\u754C\u30FB\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\
    \u691C\u67FB\u3082\u884C\u3044\u307E\u3059\u3002\n    when not defined(debug):\n\
    \        {.push boundChecks:off, overflowChecks:off, rangeChecks:off.}\n\n   \
    \ type RectangleSumEvent[K] = tuple[coordinate: K, index: int]\n\n    proc sortRectangleSumEvents[K](events:\
    \ var seq[RectangleSumEvent[K]]) =\n        ## \u6574\u6570\u5EA7\u6A19\u306F\u57FA\
    \u6570\u30BD\u30FC\u30C8\u3001\u305D\u306E\u4ED6\u306E\u5EA7\u6A19\u306F\u6BD4\
    \u8F03\u30BD\u30FC\u30C8\u3067\u4E26\u3079\u307E\u3059\u3002O(N)\u307E\u305F\u306F\
    O(N log N)\u3002\n        mixin `<`\n        when K is SomeInteger:\n        \
    \    if events.len < 2: return\n            template key(coordinate: K): uint64\
    \ =\n                ## \u7B26\u53F7\u4ED8\u304D\u6574\u6570\u306F\u7B26\u53F7\
    \u30D3\u30C3\u30C8\u3092\u53CD\u8EE2\u3057\u3001\u5927\u5C0F\u95A2\u4FC2\u3092\
    \u4FDD\u3061\u307E\u3059\u3002\n                when K is SomeSignedInt:\n   \
    \                 cast[uint64](int64(coordinate)) xor (1'u64 shl 63)\n       \
    \         else:\n                    uint64(coordinate)\n            let first\
    \ = key(events[0].coordinate)\n            var varying = 0'u64\n            for\
    \ event in events: varying = varying or (key(event.coordinate) xor first)\n  \
    \          var scratch = newSeq[RectangleSumEvent[K]](events.len)\n          \
    \  var shift = 0\n            while shift < 64 and (varying shr shift) != 0:\n\
    \                if ((varying shr shift) and 2047'u64) != 0:\n               \
    \     var offsets: array[2048, int]\n                    for event in events:\n\
    \                        inc offsets[int((key(event.coordinate) shr shift) and\
    \ 2047'u64)]\n                    var total = 0\n                    for i in\
    \ 0..<offsets.len:\n                        let count = offsets[i]\n         \
    \               offsets[i] = total\n                        total += count\n \
    \                   for event in events:\n                        let digit =\
    \ int((key(event.coordinate) shr shift) and 2047'u64)\n                      \
    \  scratch[offsets[digit]] = event\n                        inc offsets[digit]\n\
    \                    swap(events, scratch)\n                shift += 11\n    \
    \    else:\n            events.sort(proc(a, b: RectangleSumEvent[K]): int =\n\
    \                if a.coordinate < b.coordinate: -1\n                elif b.coordinate\
    \ < a.coordinate: 1\n                else: 0)\n\n    template rectangleSumSlot(i:\
    \ int): int =\n        ## \u4E0A\u4F4D\u30CE\u30FC\u30C9\u540C\u58EB\u306E\u30AD\
    \u30E3\u30C3\u30B7\u30E5\u7AF6\u5408\u3092\u907F\u3051\u308B\u305F\u3081\u3001\
    \u4F59\u767D\u3092\u633F\u5165\u3057\u307E\u3059\u3002\n        i + (i shr 10)\n\
    \n    type RectangleSumCoefficients[T] = object\n        w, wx, wy, wxy: T\n\n\
    \    proc `+=`[T](a: var RectangleSumCoefficients[T], b: RectangleSumCoefficients[T])\
    \ {.inline.} =\n        ## \u7D2F\u7A4D\u548C\u3092\u8868\u3059\u5F0F\u306E\u4FC2\
    \u6570\u3092\u6210\u5206\u3054\u3068\u306B\u52A0\u7B97\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        mixin `+=`\n        a.w += b.w\n        a.wx += b.wx\n   \
    \     a.wy += b.wy\n        a.wxy += b.wxy\n\n    proc addRectangleCoefficients[T](bit:\
    \ var seq[RectangleSumCoefficients[T]], l, r, size: int,\n        bottom, top:\
    \ RectangleSumCoefficients[T]) {.inline.} =\n        ## \u533A\u9593\u306E\u4E21\
    \u7AEF\u3092\u66F4\u65B0\u3057\u3001\u5171\u901A\u306E\u7956\u5148\u3067\u306F\
    \u76F8\u6BBA\u3057\u306A\u3044\u4E8C\u3064\u306E\u4FC2\u6570\u3060\u3051\u3092\
    \u52A0\u7B97\u3057\u307E\u3059\u3002O(log N)\u3002\n        mixin `+=`\n     \
    \   var l = l + 1\n        var r = r + 1\n        while l < r:\n            bit[rectangleSumSlot(l)]\
    \ += bottom\n            l += l and -l\n        while r < l and r <= size:\n \
    \           bit[rectangleSumSlot(r)] += top\n            r += r and -r\n     \
    \   var wy = bottom.wy\n        var wxy = bottom.wxy\n        wy += top.wy\n \
    \       wxy += top.wxy\n        while l <= size:\n            bit[rectangleSumSlot(l)].wy\
    \ += wy\n            bit[rectangleSumSlot(l)].wxy += wxy\n            l += l and\
    \ -l\n\n    proc prefixRectangleCoefficients[T](bit: seq[RectangleSumCoefficients[T]],\
    \ r: int): RectangleSumCoefficients[T] {.inline.} =\n        ## \u5727\u7E2E\u5F8C\
    \u306E\u6DFB\u5B57\u533A\u9593[0,r)\u306E\u4FC2\u6570\u306E\u548C\u3092\u8FD4\u3057\
    \u307E\u3059\u3002O(log N)\u3002\n        var i = r\n        while i > 0:\n  \
    \          result += bit[rectangleSumSlot(i)]\n            i = i and (i - 1)\n\
    \n    proc rectanglePrefixValue[K, T](a: RectangleSumCoefficients[T], x, y: K):\
    \ T {.inline.} =\n        ## \u4FC2\u6570\u304B\u3089\u5883\u754C(x,y)\u307E\u3067\
    \u306E\u7D2F\u7A4D\u548C\u3092\u8A55\u4FA1\u3057\u307E\u3059\u3002O(1)\u3002\n\
    \        mixin `*`, `-`, `+=`\n        result = (a.w * x - a.wx) * y - a.wy *\
    \ x\n        result += a.wxy\n\n    proc static_rectangle_add_rectangle_sum*[K,\
    \ T](\n        rectangles: openArray[(K, K, K, K, T)],\n        queries: openArray[(K,\
    \ K, K, K)]\n    ): seq[T] =\n        ## \u5168\u52A0\u7B97\u5F8C\u306E\u5404\u30AF\
    \u30A8\u30EA\u306E\u7DCF\u548C\u3092\u5165\u529B\u9806\u306B\u8FD4\u3057\u307E\
    \u3059\u3002\u6642\u9593O((N+Q) log(N+Q))\u3001\u8FFD\u52A0\u7A7A\u9593O(N+Q)\u3002\
    \n        ## \u52A0\u7B97\u306F(l,d,r,u,w)\u3001\u53D6\u5F97\u306F(l,d,r,u)\u3067\
    \u3001\u7BC4\u56F2\u306F[l,r)\xD7[d,u)\u3067\u3059\u3002\n        ## l<=r, d<=u\u304C\
    \u5FC5\u8981\u3067\u3059\u3002\u7A7A\u5165\u529B\u30FB\u7A7A\u9577\u65B9\u5F62\
    \u30FB\u8CA0\u306E\u5EA7\u6A19\u306B\u3082\u5BFE\u5FDC\u3057\u307E\u3059\u3002\
    \n        ## K\u306F\u4E00\u8CAB\u3057\u305F < \u3092\u6301\u3064\u5EA7\u6A19\u578B\
    \u3067\u3059\u3002\u5727\u7E2E\u524D\u306E\u5EA7\u6A19\u3092\u7528\u3044\u3066\
    \u9762\u7A4D\u3092\u8A08\u7B97\u3057\u307E\u3059\u3002\n        ## \u6574\u6570\
    \u5EA7\u6A19\u306F\u57FA\u6570\u30BD\u30FC\u30C8\u3067\u9AD8\u901F\u5316\u3057\
    \u3001\u305D\u306E\u4ED6\u306E\u5EA7\u6A19\u306F\u6BD4\u8F03\u30BD\u30FC\u30C8\
    \u3067\u51E6\u7406\u3057\u307E\u3059\u3002\n        ## T\u306E\u521D\u671F\u5024\
    \u3092\u96F6\u3068\u3057\u3001\u53EF\u63DB\u306A ``+=``\u3001\u4E8C\u9805 ``-``\u3001\
    \u5EA7\u6A19\u500D ``*(T,K):T`` \u304C\u5FC5\u8981\u3067\u3059\u3002\n       \
    \ ## \u5EA7\u6A19\u500D\u306F\u52A0\u6E1B\u7B97\u306B\u5206\u914D\u53EF\u80FD\u3067\
    \u3042\u308B\u3053\u3068\u3002T\u540C\u58EB\u306E\u4E57\u7B97\u3084\u9664\u7B97\
    \u306F\u4E0D\u8981\u3067\u3059\u3002\n        ## \u6574\u6570\u3067\u306F\u7B54\
    \u3048\u3060\u3051\u3067\u306A\u304F\u4FC2\u6570\u30FB\u9014\u4E2D\u306E\u7D2F\
    \u7A4D\u548C\u3082T\u306B\u53CE\u307E\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\u3002\n        ## \u5B9F\u6570\u5EA7\u6A19\u3067\u306F\u91CD\u307F\u4ED8\
    \u304D\u9762\u7A4D\u3092\u8FD4\u3057\u3001\u6D6E\u52D5\u5C0F\u6570\u70B9\u6570\
    \u3067\u306F\u4E38\u3081\u8AA4\u5DEE\u3092\u542B\u307F\u307E\u3059\u3002\n   \
    \     runnableExamples:\n            let rectangles = @[(-2, -1, 3, 4, 2'i64)]\n\
    \            let queries = @[(-1, 0, 2, 2), (3, 0, 5, 2)]\n            assert\
    \ static_rectangle_add_rectangle_sum(rectangles, queries) == @[12'i64, 0]\n  \
    \      mixin `<`, `*`, `-`, `+=`\n        let n = rectangles.len\n        result\
    \ = newSeq[T](queries.len)\n        var events = newSeqOfCap[RectangleSumEvent[K]](2\
    \ * (n + queries.len))\n        var updateCount = 0\n        for i, rectangle\
    \ in rectangles:\n            let (l, d, r, u, _) = rectangle\n            assert\
    \ not (r < l) and not (u < d), \"\u533A\u9593\u306E\u5DE6\u7AEF\u306F\u53F3\u7AEF\
    \u4EE5\u4E0B\u306B\u3057\u3066\u304F\u3060\u3055\u3044\"\n            if not (l\
    \ < r) or not (d < u): continue\n            events.add((d, 2 * i))\n        \
    \    events.add((u, 2 * i + 1))\n            inc updateCount\n        for i, query\
    \ in queries:\n            let (l, d, r, u) = query\n            assert not (r\
    \ < l) and not (u < d), \"\u533A\u9593\u306E\u5DE6\u7AEF\u306F\u53F3\u7AEF\u4EE5\
    \u4E0B\u306B\u3057\u3066\u304F\u3060\u3055\u3044\"\n            if not (l < r)\
    \ or not (d < u): continue\n            events.add((d, 2 * (n + i)))\n       \
    \     events.add((u, 2 * (n + i) + 1))\n        if updateCount == 0 or events.len\
    \ == 2 * updateCount: return\n\n        sortRectangleSumEvents(events)\n     \
    \   var indices = newSeq[int](2 * (n + queries.len))\n        var size = 0\n \
    \       var previous: K\n        # \u30AF\u30A8\u30EA\u306E\u5883\u754C\u3082\u540C\
    \u6642\u306B\u8D70\u67FB\u3057\u3001\u66F4\u65B0\u70B9\u3060\u3051\u3067\u5727\
    \u7E2E\u3057\u305F\u6DFB\u5B57\u3092\u6C42\u3081\u307E\u3059\u3002\n        for\
    \ event in events:\n            if event.index < 2 * n:\n                if size\
    \ == 0 or previous < event.coordinate:\n                    previous = event.coordinate\n\
    \                    inc size\n                indices[event.index] = size - 1\n\
    \            else:\n                var rank = size\n                if size >\
    \ 0 and not (previous < event.coordinate): dec rank\n                indices[event.index]\
    \ = rank\n        for event in events.mitems:\n            let i = event.index\
    \ shr 1\n            let right = (event.index and 1) != 0\n            if i <\
    \ n:\n                event.coordinate = if right: rectangles[i][2] else: rectangles[i][0]\n\
    \            else:\n                event.coordinate = if right: queries[i - n][2]\
    \ else: queries[i - n][0]\n        sortRectangleSumEvents(events)\n\n        #\
    \ \u540C\u3058x\u306E\u52A0\u7B97\u306F\u7D2F\u7A4D\u548C\u3078\u306E\u5BC4\u4E0E\
    \u304C\u96F6\u306A\u306E\u3067\u3001\u540C\u5EA7\u6A19\u5185\u306E\u51E6\u7406\
    \u9806\u306F\u554F\u3044\u307E\u305B\u3093\u3002\n        var bit = newSeq[RectangleSumCoefficients[T]](rectangleSumSlot(size)\
    \ + 1)\n        let zero = default(T)\n        for event in events:\n        \
    \    let i = event.index shr 1\n            let right = (event.index and 1) !=\
    \ 0\n            if i < n:\n                let rectangle = rectangles[i]\n  \
    \              let w = if right: zero - rectangle[4] else: rectangle[4]\n    \
    \            let wx = w * event.coordinate\n                # \u5404\u9802\u70B9\
    (a,b)\u306E\u5BC4\u4E0Ew(x-a)(y-b)\u3092\u56DB\u3064\u306E\u4FC2\u6570\u3067\u4FDD\
    \u6301\u3057\u307E\u3059\u3002\n                let bottom = RectangleSumCoefficients[T](\n\
    \                    w: w, wx: wx, wy: w * rectangle[1], wxy: wx * rectangle[1])\n\
    \                let top = RectangleSumCoefficients[T](\n                    w:\
    \ zero - w, wx: zero - wx,\n                    wy: zero - w * rectangle[3], wxy:\
    \ zero - wx * rectangle[3])\n                bit.addRectangleCoefficients(indices[2\
    \ * i], indices[2 * i + 1], size, bottom, top)\n            else:\n          \
    \      let q = i - n\n                let query = queries[q]\n               \
    \ let bottom = bit.prefixRectangleCoefficients(indices[2 * i])\n             \
    \   let top = bit.prefixRectangleCoefficients(indices[2 * i + 1])\n          \
    \      let value = rectanglePrefixValue(top, event.coordinate, query[3]) -\n \
    \                   rectanglePrefixValue(bottom, event.coordinate, query[1])\n\
    \                if right:\n                    result[q] += value\n         \
    \       else:\n                    result[q] = result[q] - value\n\n    when not\
    \ defined(debug):\n        {.pop.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/static_rectangle_add_rectangle_sum.nim
  requiredBy: []
  timestamp: '2026-09-27 22:49:59+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/static_rectangle_add_rectangle_sum_test.nim
  - verify/utils/static_rectangle_add_rectangle_sum_test.nim
  - verify/AI/static_rectangle_add_rectangle_sum_test.nim
  - verify/AI/static_rectangle_add_rectangle_sum_test.nim
documentation_of: cplib/utils/static_rectangle_add_rectangle_sum.nim
layout: document
redirect_from:
- /library/cplib/utils/static_rectangle_add_rectangle_sum.nim
- /library/cplib/utils/static_rectangle_add_rectangle_sum.nim.html
title: cplib/utils/static_rectangle_add_rectangle_sum.nim
---
