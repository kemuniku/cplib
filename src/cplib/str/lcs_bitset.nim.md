---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse.nim
    title: cplib/collections/private/bitset_avx512_fuse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse.nim
    title: cplib/collections/private/bitset_avx512_fuse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
    title: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
    title: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_block.nim
    title: cplib/collections/private/bitset_avx512_fuse_block.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_block.nim
    title: cplib/collections/private/bitset_avx512_fuse_block.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_shift.nim
    title: cplib/collections/private/bitset_avx512_fuse_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_shift.nim
    title: cplib/collections/private/bitset_avx512_fuse_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_impl.nim
    title: cplib/collections/private/bitset_avx512_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_impl.nim
    title: cplib/collections/private/bitset_avx512_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_shift_assign.nim
    title: cplib/collections/private/bitset_avx512_shift_assign.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_shift_assign.nim
    title: cplib/collections/private/bitset_avx512_shift_assign.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_search_impl.nim
    title: cplib/collections/private/bitset_search_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_search_impl.nim
    title: cplib/collections/private/bitset_search_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/lcs_bitset_test.nim
    title: verify/str/lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/lcs_bitset_test.nim
    title: verify/str/lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/restore_lcs_bitset_test.nim
    title: verify/str/restore_lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/restore_lcs_bitset_test.nim
    title: verify/str/restore_lcs_bitset_test.nim
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
  code: "when not declared CPLIB_STR_LCS_BITSET:\n    const CPLIB_STR_LCS_BITSET*\
    \ = 1\n\n    import tables\n    import cplib/collections/bitset_avx512\n\n   \
    \ proc lcsBitsetDP[T](A, B: openArray[T], backwards: static bool = false): BitSetAvx512\
    \ =\n        ## B\u65B9\u5411\u306EDP\u5DEE\u5206\u3092\u8A08\u7B97\u3057\u307E\
    \u3059\u3002backwards\u3067\u306F\u4E21\u5165\u529B\u3092\u30B3\u30D4\u30FC\u305B\
    \u305A\u9006\u9806\u306B\u8D70\u67FB\u3057\u307E\u3059\u3002\n        let m =\
    \ B.len\n        let words = (m shr 6) + ord((m and 63) != 0)\n        var state\
    \ = initBitSet(m)\n        var matched = initBitSet(m)\n\n        template advance(mask:\
    \ BitSetAvx512) =\n            ## DP\u306E\u96A3\u63A5\u5DEE\u5206\u3092\u66F4\
    \u65B0\u3057\u307E\u3059\u3002x - ((state << 1) | 1) = x + ~(state << 1)\u3092\
    \u4F7F\u3044\u307E\u3059\u3002\n            template equal: untyped = mask\n \
    \           fuse:\n                let combined = state or equal\n           \
    \     let difference = combined + not (state shl 1)\n                state = combined\
    \ and not difference\n\n        template aValue(i: int): untyped =\n         \
    \   ## \u8D70\u67FB\u65B9\u5411\u306B\u5FDC\u3058\u305FA\u306E\u8981\u7D20\u3092\
    \u53C2\u7167\u3057\u307E\u3059\u3002\n            when backwards: A[A.len - 1\
    \ - i]\n            else: A[i]\n\n        template bValue(i: int): untyped =\n\
    \            ## \u8D70\u67FB\u65B9\u5411\u306B\u5FDC\u3058\u305FB\u306E\u8981\u7D20\
    \u3092\u53C2\u7167\u3057\u307E\u3059\u3002\n            when backwards: B[m -\
    \ 1 - i]\n            else: B[i]\n\n        when T is SomeInteger or T is char\
    \ or T is bool or T is enum or T is string:\n            var ids = initTable[T,\
    \ int]()\n            var positions: seq[seq[int]]\n            for i in 0..<m:\n\
    \                template value: untyped = bValue(i)\n                let id =\
    \ ids.getOrDefault(value, -1)\n                if id < 0:\n                  \
    \  ids[value] = positions.len\n                    positions.add(@[i])\n     \
    \           else:\n                    positions[id].add(i)\n            var masks\
    \ = newSeq[BitSetAvx512](positions.len)\n            for id, indexes in positions:\n\
    \                # \u983B\u51FA\u8981\u7D20\u3060\u3051\u3092\u30D3\u30C3\u30C8\
    \u5217\u306B\u3057\u3001\u8981\u7D20\u306E\u7A2E\u985E\u304C\u591A\u3044\u5834\
    \u5408\u3082\u8FFD\u52A0\u7A7A\u9593\u3092O(m)\u306B\u6291\u3048\u307E\u3059\u3002\
    \n                if indexes.len > words:\n                    masks[id] = initBitSetFromIndexes(indexes,\
    \ m)\n            for k in 0..<A.len:\n                template value: untyped\
    \ = aValue(k)\n                let id = ids.getOrDefault(value, -1)\n        \
    \        if id >= 0:\n                    if masks[id].len != 0:\n           \
    \             advance(masks[id])\n                    else:\n                \
    \        matched.clear()\n                        for i in positions[id]:\n  \
    \                          matched[i] = true\n                        advance(matched)\n\
    \        else:\n            # \u72EC\u81EA\u306E == \u3092\u6301\u3064\u578B\u306B\
    \u3082\u3001\u30CF\u30C3\u30B7\u30E5\u3084\u9806\u5E8F\u6BD4\u8F03\u3092\u8981\
    \u6C42\u305B\u305A\u5BFE\u5FDC\u3057\u307E\u3059\u3002\n            for k in 0..<A.len:\n\
    \                template value: untyped = aValue(k)\n                matched.clear()\n\
    \                for i in 0..<m:\n                    if bValue(i) == value:\n\
    \                        matched[i] = true\n                advance(matched)\n\
    \        move(state)\n\n    proc LCS*[T](A, B: openArray[T]): int =\n        ##\
    \ \u65E2\u5B58\u306ELCS\u3068\u540C\u3058\u304F\u3001\u6700\u9577\u5171\u901A\u90E8\
    \u5206\u5217\u306E\u9577\u3055\u3092\u8FD4\u3057\u307E\u3059\u3002string\u306F\
    \u30D0\u30A4\u30C8\u5358\u4F4D\u3067\u6BD4\u8F03\u3057\u307E\u3059\u3002\n   \
    \     ## n = max(A.len, B.len), m = min(A.len, B.len), w = ceil(m / 64)\u3002\u8FFD\
    \u52A0\u7A7A\u9593O(m)\u3002\n        ## \u6574\u6570\u30FBchar\u30FBbool\u30FB\
    enum\u30FBstring\u306F\u671F\u5F85\u6642\u9593O(m + n*w)\u3002\u8981\u7D20\u306E\
    \u30CF\u30C3\u30B7\u30E5\u30FB\u6BD4\u8F03\u306FO(1)\u3068\u3057\u307E\u3059\u3002\
    \n        ## \u305D\u306E\u4ED6\u306E\u578B\u306F == \u306E\u307F\u3092\u4F7F\u3063\
    \u3066\u4E00\u81F4\u4F4D\u7F6E\u3092\u6C42\u3081\u3001\u6642\u9593O(n*m)\u3002\
    \u7A7A\u5165\u529B\u306FO(1)\u3067\u3059\u3002\n        ## amd64\u306EAVX2\u5BFE\
    \u5FDCCPU\u3068GCC/Clang\u304C\u5FC5\u8981\u3067\u3059\u3002\u5BFE\u5FDC\u74B0\
    \u5883\u3067\u306F\u30D3\u30C3\u30C8\u6F14\u7B97\u306BAVX-512\u3082\u4F7F\u3044\
    \u307E\u3059\u3002\n        if A.len < B.len:\n            return LCS(B, A)\n\
    \        if B.len == 0:\n            return 0\n        lcsBitsetDP(A, B).popcount()\n\
    \n    proc lcsBitsetSplit[T](A, B: openArray[T], middle: int): int =\n       \
    \ ## \u524D\u534A\u30FB\u5F8C\u534A\u306ELCS\u9577\u306E\u548C\u3092\u6700\u5927\
    \u306B\u3059\u308BB\u306E\u5206\u5272\u4F4D\u7F6E\u3092\u6C42\u3081\u3001\u4F5C\
    \u696D\u9818\u57DF\u3092\u547C\u3073\u51FA\u3057\u5143\u3078\u6301\u3061\u8D8A\
    \u3057\u307E\u305B\u3093\u3002\n        let forward = lcsBitsetDP(A.toOpenArray(0,\
    \ middle - 1), B)\n        let backward = lcsBitsetDP(A.toOpenArray(middle, A.high),\
    \ B, true)\n        var left = 0\n        var right = backward.popcount()\n  \
    \      var best = right\n        for j in 0..<B.len:\n            left += ord(forward[j])\n\
    \            right -= ord(backward[B.len - 1 - j])\n            if left + right\
    \ > best:\n                best = left + right\n                result = j + 1\n\
    \n    proc restoreLCSInto[T](A, B: openArray[T], output: var seq[T]) =\n     \
    \   ## Hirschberg\u6CD5\u3067\u5DE6\u53F3\u306E\u90E8\u5206\u5217\u3092\u9806\u306B\
    \u8FFD\u8A18\u3057\u307E\u3059\u3002\u5165\u529B\u306E\u533A\u9593\u306F\u30B3\
    \u30D4\u30FC\u305B\u305A\u53C2\u7167\u3057\u307E\u3059\u3002\n        if A.len\
    \ < B.len:\n            restoreLCSInto(B, A, output)\n            return\n   \
    \     if B.len == 0:\n            return\n        if B.len == 1:\n           \
    \ for value in A:\n                if value == B[0]:\n                    output.add(B[0])\n\
    \                    break\n            return\n        let middle = A.len div\
    \ 2\n        let split = lcsBitsetSplit(A, B, middle)\n        if split > 0:\n\
    \            restoreLCSInto(A.toOpenArray(0, middle - 1), B.toOpenArray(0, split\
    \ - 1), output)\n        if split < B.len:\n            restoreLCSInto(A.toOpenArray(middle,\
    \ A.high), B.toOpenArray(split, B.high), output)\n\n    proc restoreLCS*[T](A,\
    \ B: openArray[T]): seq[T] =\n        ## \u6700\u9577\u5171\u901A\u90E8\u5206\u5217\
    \u3092\u4E00\u3064\u5FA9\u5143\u3057\u307E\u3059\u3002\u8907\u6570\u89E3\u304C\
    \u3042\u308B\u5834\u5408\u306E\u9078\u3073\u65B9\u306F\u65E2\u5B58\u7248\u3068\
    \u7570\u306A\u308B\u3053\u3068\u304C\u3042\u308A\u307E\u3059\u3002\n        ##\
    \ n = max(A.len, B.len), m = min(A.len, B.len)\u3002\u51FA\u529B\u3092\u542B\u3080\
    \u8FFD\u52A0\u7A7A\u9593O(n + m)\u3002\n        ## \u6574\u6570\u30FBchar\u30FB\
    bool\u30FBenum\u30FBstring\u306F\u671F\u5F85\u6642\u9593O(n*m/64 + (n+m)*log(n+m))\u3001\
    \u305D\u306E\u4ED6\u306E\u578B\u306FO(n*m)\u3002\n        ## \u30CF\u30C3\u30B7\
    \u30E5\u30FB\u6BD4\u8F03\u306FO(1)\u3068\u3057\u307E\u3059\u3002\u7A7A\u5165\u529B\
    \u306FO(1)\u3067\u3059\u3002\n        restoreLCSInto(A, B, result)\n"
  dependsOn:
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  isVerificationFile: false
  path: cplib/str/lcs_bitset.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/restore_lcs_bitset_test.nim
  - verify/str/restore_lcs_bitset_test.nim
  - verify/str/lcs_bitset_test.nim
  - verify/str/lcs_bitset_test.nim
documentation_of: cplib/str/lcs_bitset.nim
layout: document
redirect_from:
- /library/cplib/str/lcs_bitset.nim
- /library/cplib/str/lcs_bitset.nim.html
title: cplib/str/lcs_bitset.nim
---
