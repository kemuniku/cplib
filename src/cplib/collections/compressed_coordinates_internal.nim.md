---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_lazysegtree.nim
    title: cplib/collections/compressed_lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_lazysegtree.nim
    title: cplib/collections/compressed_lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_segtree.nim
    title: cplib/collections/compressed_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_segtree.nim
    title: cplib/collections/compressed_segtree.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_lazysegtree_test.nim
    title: verify/AI/compressed_lazysegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_lazysegtree_test.nim
    title: verify/AI/compressed_lazysegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_segtree_test.nim
    title: verify/AI/compressed_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_segtree_test.nim
    title: verify/AI/compressed_segtree_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_COMPRESSED_COORDINATES_INTERNAL:\n  \
    \  const CPLIB_COLLECTIONS_COMPRESSED_COORDINATES_INTERNAL = 1\n    import algorithm\n\
    \n    proc compressedCoordinateKey[K: SomeInteger](x: K): uint64 {.inline.} =\n\
    \        ## \u6574\u6570\u306E\u5927\u5C0F\u95A2\u4FC2\u3092\u4FDD\u3064\u7B26\
    \u53F7\u306A\u3057\u30AD\u30FC\u306B\u5909\u63DB\u3057\u307E\u3059\u3002\n   \
    \     when K is SomeSignedInt:\n            cast[uint64](int64(x)) xor (1u64 shl\
    \ 63)\n        else:\n            uint64(x)\n\n    proc sortCompressedCoordinates[K](xs:\
    \ var seq[K]) =\n        ## \u5927\u304D\u306A\u6574\u6570\u914D\u5217\u306F\u57FA\
    \u6570\u30BD\u30FC\u30C8\u3001\u305D\u308C\u4EE5\u5916\u306F\u6BD4\u8F03\u30BD\
    \u30FC\u30C8\u3067\u6574\u5217\u3057\u307E\u3059\u3002\n        when K is SomeInteger:\n\
    \            if xs.len >= 2048:\n                let first = compressedCoordinateKey(xs[0])\n\
    \                var differing = 0u64\n                var ordered = true\n  \
    \              for i in 1..<xs.len:\n                    differing = differing\
    \ or (first xor compressedCoordinateKey(xs[i]))\n                    if xs[i]\
    \ < xs[i - 1]: ordered = false\n                if ordered: return\n         \
    \       var tmp = newSeq[K](xs.len)\n                var counts: array[2048, int]\n\
    \                for shift in countup(0, 55, 11):\n                    if ((differing\
    \ shr shift) and 2047u64) == 0: continue\n                    counts.fill(0)\n\
    \                    for x in xs:\n                        inc counts[int((compressedCoordinateKey(x)\
    \ shr shift) and 2047u64)]\n                    var total = 0\n              \
    \      for i in 0..<counts.len:\n                        let size = counts[i]\n\
    \                        counts[i] = total\n                        total += size\n\
    \                    for x in xs:\n                        let bucket = int((compressedCoordinateKey(x)\
    \ shr shift) and 2047u64)\n                        tmp[counts[bucket]] = x\n \
    \                       inc counts[bucket]\n                    swap(xs, tmp)\n\
    \                return\n        xs.sort()\n\n    proc compressedCoordinateHash[K:\
    \ SomeInteger](x: K): int {.inline.} =\n        ## \u6574\u6570\u306E\u5404\u30D3\
    \u30C3\u30C8\u3092\u6DF7\u305C\u3001\u6DFB\u5B57\u691C\u7D22\u7528\u306E\u30CF\
    \u30C3\u30B7\u30E5\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n        var h =\
    \ compressedCoordinateKey(x)\n        h = (h xor (h shr 30)) * 0xbf58476d1ce4e5b9u64\n\
    \        h = (h xor (h shr 27)) * 0x94d049bb133111ebu64\n        cast[int](h xor\
    \ (h shr 31))\n\n    proc initCompressedCoordinateIndex[K](coords: openArray[K]):\
    \ seq[int] =\n        ## \u6574\u6570\u5EA7\u6A19\u306BO(N)\u7A7A\u9593\u306E\u6DFB\
    \u5B57\u7D22\u5F15\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\u885D\u7A81\u306E\
    \u63A2\u7D22\u306F8\u56DE\u307E\u3067\u3067\u3059\u3002\n        when K is SomeInteger:\n\
    \            if coords.len >= 64:\n                var capacity = 1\n        \
    \        while capacity < coords.len * 2: capacity *= 2\n                result\
    \ = newSeq[int](capacity)\n                for i, x in coords:\n             \
    \       var slot = compressedCoordinateHash(x) and (capacity - 1)\n          \
    \          for probe in 0..<8:\n                        if result[slot] == 0:\n\
    \                            result[slot] = i + 1\n                          \
    \  break\n                        slot = (slot + 1) and (capacity - 1)\n\n   \
    \ proc findCompressedCoordinate[K](coords: openArray[K], slots: openArray[int],\
    \ x: K): int =\n        ## \u767B\u9332\u6E08\u307F\u306E\u6DFB\u5B57\u304B-1\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\u885D\u7A81\u304C\u591A\u3051\u308C\u3070\u4E8C\
    \u5206\u63A2\u7D22\u3057\u3001\u6700\u60AAO(log N)\u3067\u3059\u3002\n       \
    \ when K is SomeInteger:\n            if slots.len > 0:\n                let mask\
    \ = slots.len - 1\n                var slot = compressedCoordinateHash(x) and\
    \ mask\n                for probe in 0..<8:\n                    let entry = slots[slot]\n\
    \                    if entry == 0: return -1\n                    if coords[entry\
    \ - 1] == x: return entry - 1\n                    slot = (slot + 1) and mask\n\
    \        let i = coords.lowerBound(x)\n        if i < coords.len and coords[i]\
    \ == x: i\n        else: -1\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/compressed_coordinates_internal.nim
  requiredBy:
  - cplib/collections/compressed_lazysegtree.nim
  - cplib/collections/compressed_lazysegtree.nim
  - cplib/collections/compressed_segtree.nim
  - cplib/collections/compressed_segtree.nim
  timestamp: '2026-09-17 19:00:20+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/compressed_segtree_test.nim
  - verify/AI/compressed_segtree_test.nim
  - verify/AI/compressed_lazysegtree_test.nim
  - verify/AI/compressed_lazysegtree_test.nim
documentation_of: cplib/collections/compressed_coordinates_internal.nim
layout: document
redirect_from:
- /library/cplib/collections/compressed_coordinates_internal.nim
- /library/cplib/collections/compressed_coordinates_internal.nim.html
title: cplib/collections/compressed_coordinates_internal.nim
---
