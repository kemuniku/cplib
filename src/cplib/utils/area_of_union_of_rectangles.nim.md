---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/area_of_union_of_rectangles_test.nim
    title: verify/utils/area_of_union_of_rectangles_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/area_of_union_of_rectangles_test.nim
    title: verify/utils/area_of_union_of_rectangles_test.nim
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
  code: "when not declared CPLIB_UTILS_AREA_OF_UNION_OF_RECTANGLES:\n    const CPLIB_UTILS_AREA_OF_UNION_OF_RECTANGLES*\
    \ = 1\n    # \u5185\u90E8\u306E\u6DFB\u5B57\u3068\u578B\u306E\u7BC4\u56F2\u306F\
    \u69CB\u7BC9\u6642\u306B\u4FDD\u8A3C\u3059\u308B\u3002-d:debug\u3067\u306F\u691C\
    \u67FB\u3092\u6709\u52B9\u306B\u3059\u308B\u3002\n    when not defined(debug):\n\
    \        {.push boundChecks:off, overflowChecks:off, rangeChecks:off.}\n\n   \
    \ proc rectangleRadixSort[T](a:var seq[T])=\n        ## \u5EA7\u6A19\u3092\u57FA\
    \u6570\u30BD\u30FC\u30C8\u3059\u308B\u3002\u56FA\u5B9A\u5E45\u6574\u6570\u3067\
    \u306F\u6642\u9593O(N)\u3001\u8FFD\u52A0\u7A7A\u9593O(N)\u3002\n        # \u7B26\
    \u53F7\u30D3\u30C3\u30C8\u3092\u53CD\u8EE2\u3059\u308B\u3068\u3001\u8CA0\u306E\
    \u5EA7\u6A19\u3082\u7B26\u53F7\u306A\u3057\u6574\u6570\u306E\u9806\u5E8F\u3067\
    \u30BD\u30FC\u30C8\u3067\u304D\u308B\u3002\n        if a.len < 2: return\n   \
    \     const signBit = 1'u shl (sizeof(int)*8-1)\n        const mask = 2047'u\n\
    \        let first = cast[uint](a[0].coordinate)\n        var varying = 0'u\n\
    \        for e in a:\n            varying = varying or (cast[uint](e.coordinate)\
    \ xor first)\n        var scratch = newSeq[T](a.len)\n        var shift = 0\n\
    \        while shift < sizeof(int)*8 and (varying shr shift) != 0:\n         \
    \   if ((varying shr shift) and mask) != 0:\n                var offsets:array[2048,int]\n\
    \                for e in a:\n                    let digit = int(((cast[uint](e.coordinate)\
    \ xor signBit) shr shift) and mask)\n                    offsets[digit].inc\n\
    \                var total = 0\n                for i in 0..<offsets.len:\n  \
    \                  let count = offsets[i]\n                    offsets[i] = total\n\
    \                    total += count\n                for e in a:\n           \
    \         let digit = int(((cast[uint](e.coordinate) xor signBit) shr shift) and\
    \ mask)\n                    scratch[offsets[digit]] = e\n                   \
    \ offsets[digit].inc\n                swap(a,scratch)\n            shift += 11\n\
    \n    proc rectangleSweep[Length,Index](\n        rectangles:seq[(int,int,int,int)],\
    \ positions,seps:seq[int]\n    ):int=\n        ## \u8D70\u67FB\u7DDA\u3068\u5C02\
    \u7528\u30BB\u30B0\u6728\u3067\u9762\u7A4D\u3092\u6C42\u3081\u308B\u3002\u6642\
    \u9593O(N log N)\u3001\u8FFD\u52A0\u7A7A\u9593O(N)\u3002\n        type\n     \
    \       Event = tuple[coordinate:int,left,right:Index]\n            Node = object\n\
    \                cover:Index\n                length,width:Length\n        var\
    \ events = newSeqOfCap[Event](2*rectangles.len)\n        for i,rectangle in rectangles:\n\
    \            let (l,d,r,u) = rectangle\n            if l == r or d == u: continue\n\
    \            let x = Index(positions[2*i])\n            let z = Index(positions[2*i+1])\n\
    \            # \u524A\u9664\u30A4\u30D9\u30F3\u30C8\u306Fleft\u306E\u30D3\u30C3\
    \u30C8\u53CD\u8EE2\u3067\u8868\u3057\u3001\u30A4\u30D9\u30F3\u30C8\u3092\u5C0F\
    \u3055\u304F\u4FDD\u3064\u3002\n            events.add((d,x,z))\n            events.add((u,not\
    \ x,z))\n        rectangleRadixSort(events)\n\n        let n = seps.len-1\n  \
    \      var size = 1\n        while size < n: size *= 2\n        var nodes = newSeq[Node](2*size)\n\
    \        for i in 0..<n:\n            nodes[size+i].width = Length(seps[i+1]-seps[i])\n\
    \        for i in countdown(size-1,1):\n            nodes[i].width = nodes[2*i].width+nodes[2*i+1].width\n\
    \n        template change(node,delta:int):Length =\n            block:\n     \
    \           var difference:Length\n                let oldCover = nodes[node].cover\n\
    \                nodes[node].cover += Index(delta)\n                # \u88AB\u8986\
    \u56DE\u6570\u304C\u6B63\u306E\u307E\u307E\u306A\u3089\u3001\u88AB\u8986\u9577\
    \u306F\u5909\u308F\u3089\u306A\u3044\u3002\n                if nodes[node].cover\
    \ == 0 or oldCover == 0:\n                    let old = nodes[node].length\n \
    \                   if nodes[node].cover > 0:\n                        nodes[node].length\
    \ = nodes[node].width\n                    elif node < size:\n               \
    \         nodes[node].length = nodes[node*2].length+nodes[node*2+1].length\n \
    \                   else:\n                        nodes[node].length = 0\n  \
    \                  difference = nodes[node].length-old\n                difference\n\
    \n        var previousY = events[0].coordinate\n        for event in events:\n\
    \            result += int(nodes[1].length)*(event.coordinate-previousY)\n   \
    \         previousY = event.coordinate\n            let delta = if event.left\
    \ < 0: -1 else: 1\n            var l = (if event.left < 0: not int(event.left)\
    \ else: int(event.left))+size\n            var r = int(event.right)+size\n   \
    \         var leftNode = l\n            var rightNode = r-1\n            var leftDiff,rightDiff:Length\n\
    \            # \u5404\u6BB5\u306E\u4E21\u7AEF\u3092\u4E0B\u304B\u3089\u51E6\u7406\
    \u3059\u308B\u3002\u5B50\u306E\u88AB\u8986\u9577\u306E\u5DEE\u5206\u3060\u3051\
    \u3092\u89AA\u3078\u6E21\u3059\u3002\n            while leftNode > 0:\n      \
    \          if leftNode == rightNode:\n                    leftDiff += rightDiff\n\
    \                    rightDiff = 0\n                if leftDiff != 0:\n      \
    \              if nodes[leftNode].cover == 0:\n                        nodes[leftNode].length\
    \ += leftDiff\n                    else:\n                        leftDiff = 0\n\
    \                if rightDiff != 0:\n                    if nodes[rightNode].cover\
    \ == 0:\n                        nodes[rightNode].length += rightDiff\n      \
    \              else:\n                        rightDiff = 0\n                if\
    \ l < r:\n                    if (l and 1) != 0:\n                        leftDiff\
    \ += change(l,delta)\n                        l.inc\n                    if (r\
    \ and 1) != 0:\n                        r.dec\n                        rightDiff\
    \ += change(r,delta)\n                # \u533A\u9593\u3078\u306E\u66F4\u65B0\u304C\
    \u5B8C\u4E86\u3057\u3001\u5DEE\u5206\u3082\u6D88\u3048\u305F\u3089\u7956\u5148\
    \u306E\u66F4\u65B0\u306F\u4E0D\u8981\u3002\n                if l == r and leftDiff\
    \ == 0 and rightDiff == 0: break\n                l = l shr 1\n              \
    \  r = r shr 1\n                leftNode = leftNode shr 1\n                rightNode\
    \ = rightNode shr 1\n\n    proc area_of_union_of_rectangles*(rectangles:seq[(int,int,int,int)]):int=\n\
    \        ## \u8EF8\u306B\u5E73\u884C\u306A\u9577\u65B9\u5F62\u306E\u548C\u96C6\
    \u5408\u306E\u9762\u7A4D\u3092\u8FD4\u3059\u3002N\u500B\u306B\u5BFE\u3057\u3066\
    \u6642\u9593O(N log N)\u3001\u8FFD\u52A0\u7A7A\u9593O(N)\u3002\n        ## \u5404\
    \u8981\u7D20\u306F(l,d,r,u) = (\u5DE6\u7AEF,\u4E0B\u7AEF,\u53F3\u7AEF,\u4E0A\u7AEF\
    )\u3002l <= r, d <= u\u3092\u6E80\u305F\u3059\u3053\u3068\u3002\n        ## \u7A7A\
    \u306E\u5165\u529B\u3084\u9762\u7A4D0\u306E\u9577\u65B9\u5F62\u306B\u3082\u5BFE\
    \u5FDC\u3059\u308B\u3002\u8CA0\u306E\u5EA7\u6A19\u3082\u4F7F\u7528\u3067\u304D\
    \u308B\u3002\n        ## \u5168\u4F53\u306Ex\u5EA7\u6A19\u5E45\u3001y\u5EA7\u6A19\
    \u306E\u5DEE\u3001\u9762\u7A4D\u306Fint\u306B\u53CE\u307E\u308B\u3053\u3068\uFF08\
    \u901A\u5E38\u306F64bit\u74B0\u5883\u3067\u4F7F\u7528\uFF09\u3002\n        var\
    \ endpoints = newSeqOfCap[tuple[coordinate,index:int]](2*rectangles.len)\n   \
    \     for i,rectangle in rectangles:\n            let (l,d,r,u) = rectangle\n\
    \            if l == r or d == u: continue\n            endpoints.add((l,2*i))\n\
    \            endpoints.add((r,2*i+1))\n        if endpoints.len == 0: return 0\n\
    \        rectangleRadixSort(endpoints)\n        var positions = newSeq[int](2*rectangles.len)\n\
    \        var seps = newSeqOfCap[int](endpoints.len)\n        for e in endpoints:\n\
    \            if seps.len == 0 or seps[^1] != e.coordinate:\n                seps.add(e.coordinate)\n\
    \            positions[e.index] = seps.len-1\n        reset(endpoints)\n     \
    \   # \u901A\u5E38\u306E\u5236\u7D04\u3067\u306F\u30CE\u30FC\u30C9\u309212\u30D0\
    \u30A4\u30C8\u306B\u3059\u308B\u3002\u5927\u304D\u3044\u5EA7\u6A19\u5E45\u306A\
    \u3069\u306B\u306Fint\u7248\u3092\u4F7F\u3046\u3002\n        if rectangles.len\
    \ <= int32.high.int div 2:\n            if seps[^1]-seps[0] <= int32.high.int:\n\
    \                return rectangleSweep[int32,int32](rectangles,positions,seps)\n\
    \            return rectangleSweep[int,int32](rectangles,positions,seps)\n   \
    \     return rectangleSweep[int,int](rectangles,positions,seps)\n\n    when not\
    \ defined(debug):\n        {.pop.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/area_of_union_of_rectangles.nim
  requiredBy: []
  timestamp: '2026-09-12 10:21:16+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/area_of_union_of_rectangles_test.nim
  - verify/utils/area_of_union_of_rectangles_test.nim
documentation_of: cplib/utils/area_of_union_of_rectangles.nim
layout: document
redirect_from:
- /library/cplib/utils/area_of_union_of_rectangles.nim
- /library/cplib/utils/area_of_union_of_rectangles.nim.html
title: cplib/utils/area_of_union_of_rectangles.nim
---
