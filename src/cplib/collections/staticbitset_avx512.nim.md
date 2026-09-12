---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/collections/private/bitset_avx512_impl.nim
    title: cplib/collections/private/bitset_avx512_impl.nim
  - icon: ':warning:'
    path: cplib/collections/private/bitset_avx512_impl.nim
    title: cplib/collections/private/bitset_avx512_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "## AVX-512/AVX2\u3067\u8AD6\u7406\u6F14\u7B97\u30FB\u30B7\u30D5\u30C8\u30FB\
    \u30D3\u30C3\u30C8\u6570\u306E\u96C6\u8A08\u3092\u9AD8\u901F\u5316\u3057\u305F\
    \u56FA\u5B9A\u9577\u30D3\u30C3\u30C8\u96C6\u5408\u3067\u3059\u3002\n## amd64\u306E\
    AVX2\u5BFE\u5FDCCPU\u3068GCC/Clang\u304C\u5FC5\u8981\u3067\u3059\u3002C/C++\u30D0\
    \u30C3\u30AF\u30A8\u30F3\u30C9\u306B\u5BFE\u5FDC\u3057\u307E\u3059\u3002\n## AVX-512\u5BFE\
    \u5FDC\u74B0\u5883\u3067\u306F\u5BFE\u5FDC\u3059\u308B\u6F14\u7B97\u3092\u81EA\
    \u52D5\u3067\u5207\u308A\u66FF\u3048\u307E\u3059\u3002\u500B\u6570\u8A08\u7B97\
    \u306B\u306FVPOPCNTDQ\u304C\u5FC5\u8981\u3067\u3059\u3002\n## initBitSet(3000)\
    \ \u3084 BitSet[3000] \u3068\u3057\u3066\u4F7F\u3044\u307E\u3059\u3002-mavx2\u306E\
    \u6307\u5B9A\u306F\u4E0D\u8981\u3067\u3059\u3002\n## \u547D\u4EE4\u6570\u306F\
    AVX-512\u7D4C\u8DEF\u306E\u4E3B\u30EB\u30FC\u30D7\u306E\u6F14\u7B97\u90E8\u5206\
    \u306E\u76EE\u5B89\u3067\u3001\u95A2\u6570\u5168\u4F53\u306E\u547D\u4EE4\u6570\
    \u3084\u30B5\u30A4\u30AF\u30EB\u6570\u3067\u306F\u3042\u308A\u307E\u305B\u3093\
    \u3002\n## \u30ED\u30FC\u30C9\u30FB\u30B9\u30C8\u30A2\u3001\u30A2\u30C9\u30EC\u30B9\
    \u8A08\u7B97\u3001\u30EB\u30FC\u30D7\u5236\u5FA1\u3001CPU\u5224\u5B9A\u3001\u30C1\
    \u30A7\u30C3\u30AF\u3001\u9818\u57DF\u78BA\u4FDD\u30FB\u521D\u671F\u5316\u3001\
    \u5B9A\u6570\u6E96\u5099\u3001\u7AEF\u6570\u51E6\u7406\u306F\u542B\u3081\u307E\
    \u305B\u3093\u3002\n## \u30B3\u30F3\u30D1\u30A4\u30E9\u306B\u3088\u308B\u547D\u4EE4\
    \u306E\u878D\u5408\u30FB\u5C55\u958B\u3067\u5909\u308F\u308A\u307E\u3059\u3002\
    AVX2\u3078\u306E\u5207\u308A\u66FF\u3048\u6642\u306B\u306F\u5F53\u3066\u306F\u307E\
    \u308A\u307E\u305B\u3093\u3002\nwhen not declared CPLIB_COLLECTIONS_STATIC_BITSET_AVX512:\n\
    \    const CPLIB_COLLECTIONS_STATIC_BITSET_AVX512* = 1\n    when not (defined(amd64)\
    \ and (defined(gcc) or defined(clang))):\n        {.error: \"StaticBitSetAvx512\
    \ requires amd64 and GCC/Clang\".}\n    import bitops\n    include cplib/collections/private/bitset_avx512_impl\n\
    \n    func wordCount(size: int): int {.compileTime.} =\n        ## \u975E\u8CA0\
    \u306E\u30D3\u30C3\u30C8\u6570\u306B\u5FC5\u8981\u306A64\u30D3\u30C3\u30C8\u30EF\
    \u30FC\u30C9\u6570\u3092\u6C42\u3081\u307E\u3059\u3002\n        doAssert size\
    \ >= 0, \"BitSet size must be non-negative\"\n        (size shr 6) + ord((size\
    \ and 63) != 0)\n\n    type BitSet*[size: static int] {.byref.} = object\n   \
    \     bits: array[wordCount(size), uint64]\n\n    proc initBitSet*(size: static\
    \ int): BitSet[size] =\n        ## \u6307\u5B9A\u3057\u305F\u30D3\u30C3\u30C8\u6570\
    \u306E\u7A7A\u96C6\u5408\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        discard\n\
    \n    proc initBitSet*(v: openArray[bool], size: static int): BitSet[size] {.noinit.}\
    \ =\n        ## \u771F\u507D\u5024\u914D\u5217\u304B\u3089\u96C6\u5408\u3092\u69CB\
    \u7BC9\u3057\u3001\u6B8B\u308A\u30920\u3067\u57CB\u3081\u307E\u3059\u3002\n  \
    \      ## AVX-512BW\u7D4C\u8DEF\u306E\u76EE\u5B89: \u5165\u529B64\u500B\u306E\
    bool\u3042\u305F\u308A\u6BD4\u8F031\u547D\u4EE4\uFF0B\u30DE\u30B9\u30AF\u8EE2\u9001\
    1\u547D\u4EE4\u3002\u6B8B\u308A\u306E\u30BC\u30ED\u57CB\u3081\u306F\u5225\u9014\
    \u5FC5\u8981\u3067\u3059\u3002\n        when compileOption(\"boundChecks\"):\n\
    \            if v.len > size:\n                raise newException(ValueError,\
    \ \"initial value is longer than BitSet size\")\n        static:\n           \
    \ doAssert sizeof(bool) == 1\n        when size > 0:\n            let source =\
    \ if v.len == 0: nil else: cast[pointer](unsafeAddr v[0])\n            avxFromBools(addr\
    \ result.bits[0], source, v.len.csize_t, result.bits.len.csize_t)\n\n    proc\
    \ initBitSetFromString*(s: string, match: char, size: static int): BitSet[size]\
    \ {.noinit.} =\n        ## s[i] == match\u306E\u4F4D\u7F6E\u30921\u306B\u3057\u307E\
    \u3059\u3002\u6DFB\u5B57\u306F\u30D0\u30A4\u30C8\u5358\u4F4D\u3067\u3001\u6B8B\
    \u308A\u306F0\u3067\u3059\u3002O(s.len + size / 64)\u3002\n        ## UTF-8\u306E\
    \u6587\u5B57\u5358\u4F4D\u306E\u6BD4\u8F03\u3084\u90E8\u5206\u6587\u5B57\u5217\
    \u691C\u7D22\u3067\u306F\u3042\u308A\u307E\u305B\u3093\u3002NUL\u3092\u542B\u3080\
    \u6587\u5B57\u5217\u3082\u6BD4\u8F03\u3067\u304D\u307E\u3059\u3002\n        ##\
    \ AVX2\u7D4C\u8DEF\u306E\u76EE\u5B89: 32\u30D0\u30A4\u30C8\u3042\u305F\u308A\u6BD4\
    \u8F03\uFF0BMOVMSK\u306E2\u547D\u4EE4\u3002\u683C\u7D0D\u7528\u306E\u7D50\u5408\
    \u3068\u30BC\u30ED\u57CB\u3081\u306F\u5225\u3067\u3059\u3002\n        ## AVX-512BW\u7D4C\
    \u8DEF\u306E\u76EE\u5B89: 64\u30D0\u30A4\u30C8\u3042\u305F\u308A\u6BD4\u8F03\uFF0B\
    \u30DE\u30B9\u30AF\u8EE2\u9001\u306E2\u547D\u4EE4\u3002\n        when compileOption(\"\
    boundChecks\"):\n            if s.len > size:\n                raise newException(ValueError,\
    \ \"source string is longer than BitSet size\")\n        when size > 0:\n    \
    \        let source = if s.len == 0: nil else: cast[pointer](unsafeAddr s[0])\n\
    \            avxFromStringChar(addr result.bits[0], source, nil, ord(match).uint8,\
    \ s.len.csize_t, result.bits.len.csize_t)\n\n    proc initBitSetFromString*(s,\
    \ reference: string, size: static int): BitSet[size] {.noinit.} =\n        ##\
    \ \u540C\u3058\u9577\u3055\u306E\u6587\u5B57\u5217\u3092\u4F4D\u7F6E\u3054\u3068\
    \u306B\u6BD4\u8F03\u3057\u3001s[i] == reference[i]\u306E\u4F4D\u7F6E\u30921\u306B\
    \u3057\u307E\u3059\u3002\u6DFB\u5B57\u306F\u30D0\u30A4\u30C8\u5358\u4F4D\u3067\
    \u3001\u6B8B\u308A\u306F0\u3067\u3059\u3002O(s.len + size / 64)\u3002\n      \
    \  ## UTF-8\u306E\u6587\u5B57\u5358\u4F4D\u306E\u6BD4\u8F03\u3084\u90E8\u5206\u6587\
    \u5B57\u5217\u691C\u7D22\u3067\u306F\u3042\u308A\u307E\u305B\u3093\u3002NUL\u3092\
    \u542B\u3080\u6587\u5B57\u5217\u3082\u6BD4\u8F03\u3067\u304D\u307E\u3059\u3002\
    \n        ## AVX2\u7D4C\u8DEF\u306E\u76EE\u5B89: 32\u30D0\u30A4\u30C8\u3042\u305F\
    \u308A\u6BD4\u8F03\uFF0BMOVMSK\u306E2\u547D\u4EE4\u3002\u683C\u7D0D\u7528\u306E\
    \u7D50\u5408\u3068\u30BC\u30ED\u57CB\u3081\u306F\u5225\u3067\u3059\u3002\n   \
    \     ## AVX-512BW\u7D4C\u8DEF\u306E\u76EE\u5B89: 64\u30D0\u30A4\u30C8\u3042\u305F\
    \u308A\u6BD4\u8F03\uFF0B\u30DE\u30B9\u30AF\u8EE2\u9001\u306E2\u547D\u4EE4\u3002\
    \n        when compileOption(\"boundChecks\"):\n            if s.len > size:\n\
    \                raise newException(ValueError, \"source string is longer than\
    \ BitSet size\")\n            if s.len != reference.len:\n                raise\
    \ newException(ValueError, \"source and reference string lengths must match\"\
    )\n        when size > 0:\n            let source = if s.len == 0: nil else: cast[pointer](unsafeAddr\
    \ s[0])\n            let target = if reference.len == 0: nil else: cast[pointer](unsafeAddr\
    \ reference[0])\n            avxFromStringEqual(addr result.bits[0], source, target,\
    \ 0.uint8, s.len.csize_t, result.bits.len.csize_t)\n\n    proc initBitSetFromIndexes*(indexes:\
    \ openArray[int], size: static int): BitSet[size] =\n        ## \u6307\u5B9A\u3057\
    \u305F\u6DFB\u5B57\u306E\u30D3\u30C3\u30C8\u3092\u7ACB\u3066\u305F\u96C6\u5408\
    \u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        for i in indexes:\n      \
    \      when compileOption(\"boundChecks\"):\n                if i < 0 or i >=\
    \ size:\n                    raise newException(IndexDefect, \"BitSet index out\
    \ of bounds\")\n            result.bits[i shr 6] = result.bits[i shr 6] or (1'u64\
    \ shl (i and 63))\n\n    proc len*[size](bitset: BitSet[size]): int {.inline.}\
    \ =\n        ## \u96C6\u5408\u306E\u30D3\u30C3\u30C8\u6570\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\n        size\n\n    proc checkIndex[size](bitset: BitSet[size],\
    \ idx: Natural) {.inline.} =\n        ## \u6DFB\u5B57\u304C\u96C6\u5408\u306E\u7BC4\
    \u56F2\u5185\u3067\u3042\u308B\u3053\u3068\u3092\u78BA\u8A8D\u3057\u307E\u3059\
    \u3002\n        when compileOption(\"boundChecks\"):\n            if idx >= size:\n\
    \                raise newException(IndexDefect, \"BitSet index out of bounds\"\
    )\n\n    proc trim[size](bitset: var BitSet[size]) {.inline.} =\n        ## \u6700\
    \u5F8C\u306E\u30EF\u30FC\u30C9\u306E\u7BC4\u56F2\u5916\u306E\u30D3\u30C3\u30C8\
    \u30920\u306B\u3057\u307E\u3059\u3002\n        const remainder = size and 63\n\
    \        when remainder != 0:\n            bitset.bits[^1] = bitset.bits[^1] and\
    \ ((1'u64 shl remainder) - 1)\n\n    proc andInto*[size](dst: var BitSet[size],\
    \ x, y: BitSet[size]) =\n        ## \u78BA\u4FDD\u6E08\u307F\u306Edst\u3078x &\
    \ y\u3092\u66F8\u304D\u8FBC\u307F\u307E\u3059\u3002\u5168\u3066\u540C\u3058\u9577\
    \u3055\u304C\u5FC5\u8981\u3067\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\
    \n        ## \u9818\u57DF\u78BA\u4FDD\u30FB\u4E2D\u9593\u96C6\u5408\u306F\u4E0D\
    \u8981\u3067\u3001dst\u306Bx\u3084y\u81EA\u8EAB\u3092\u6307\u5B9A\u3059\u308B\u3053\
    \u3068\u3082\u3067\u304D\u307E\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\
    \u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u8AD6\u7406\u6F14\u7B97\
    1\u547D\u4EE4\u3002\u30ED\u30FC\u30C9\u30FB\u30B9\u30C8\u30A2\u3068\u672B\u5C3E\
    \u306E\u30DE\u30B9\u30AF\u306F\u5225\u3067\u3059\u3002\n        when size > 0:\n\
    \            avxAnd(addr dst.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0],\
    \ x.bits.len.csize_t)\n\n    proc orInto*[size](dst: var BitSet[size], x, y: BitSet[size])\
    \ =\n        ## \u78BA\u4FDD\u6E08\u307F\u306Edst\u3078x | y\u3092\u66F8\u304D\
    \u8FBC\u307F\u307E\u3059\u3002\u5168\u3066\u540C\u3058\u9577\u3055\u304C\u5FC5\
    \u8981\u3067\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        ## \u9818\
    \u57DF\u78BA\u4FDD\u30FB\u4E2D\u9593\u96C6\u5408\u306F\u4E0D\u8981\u3067\u3001\
    dst\u306Bx\u3084y\u81EA\u8EAB\u3092\u6307\u5B9A\u3059\u308B\u3053\u3068\u3082\u3067\
    \u304D\u307E\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308A\u8AD6\u7406\u6F14\u7B971\u547D\u4EE4\u3002\u30ED\
    \u30FC\u30C9\u30FB\u30B9\u30C8\u30A2\u3068\u672B\u5C3E\u306E\u30DE\u30B9\u30AF\
    \u306F\u5225\u3067\u3059\u3002\n        when size > 0:\n            avxOr(addr\
    \ dst.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\
    \n    proc xorInto*[size](dst: var BitSet[size], x, y: BitSet[size]) =\n     \
    \   ## \u78BA\u4FDD\u6E08\u307F\u306Edst\u3078x ^ y\u3092\u66F8\u304D\u8FBC\u307F\
    \u307E\u3059\u3002\u5168\u3066\u540C\u3058\u9577\u3055\u304C\u5FC5\u8981\u3067\
    \u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        ## \u9818\u57DF\u78BA\
    \u4FDD\u30FB\u4E2D\u9593\u96C6\u5408\u306F\u4E0D\u8981\u3067\u3001dst\u306Bx\u3084\
    y\u81EA\u8EAB\u3092\u6307\u5B9A\u3059\u308B\u3053\u3068\u3082\u3067\u304D\u307E\
    \u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\
    \u30C8\u3042\u305F\u308A\u8AD6\u7406\u6F14\u7B971\u547D\u4EE4\u3002\u30ED\u30FC\
    \u30C9\u30FB\u30B9\u30C8\u30A2\u3068\u672B\u5C3E\u306E\u30DE\u30B9\u30AF\u306F\
    \u5225\u3067\u3059\u3002\n        when size > 0:\n            avxXor(addr dst.bits[0],\
    \ unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n    proc\
    \ andNotInto*[size](dst: var BitSet[size], x, y: BitSet[size]) =\n        ## \u78BA\
    \u4FDD\u6E08\u307F\u306Edst\u3078x & ~y\u3092\u66F8\u304D\u8FBC\u307F\u307E\u3059\
    \u3002\u5168\u3066\u540C\u3058\u9577\u3055\u304C\u5FC5\u8981\u3067\u3059\u3002\
    O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        ## \u9818\u57DF\u78BA\u4FDD\u30FB\
    \u4E2D\u9593\u96C6\u5408\u306F\u4E0D\u8981\u3067\u3001dst\u306Bx\u3084y\u81EA\u8EAB\
    \u3092\u6307\u5B9A\u3059\u308B\u3053\u3068\u3082\u3067\u304D\u307E\u3059\u3002\
    \n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308A\u8AD6\u7406\u6F14\u7B971\u547D\u4EE4\u3002\u30ED\u30FC\u30C9\u30FB\
    \u30B9\u30C8\u30A2\u3068\u672B\u5C3E\u306E\u30DE\u30B9\u30AF\u306F\u5225\u3067\
    \u3059\u3002\n        when size > 0:\n            avxAndNot(addr dst.bits[0],\
    \ unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n    proc\
    \ xnorInto*[size](dst: var BitSet[size], x, y: BitSet[size]) =\n        ## \u78BA\
    \u4FDD\u6E08\u307F\u306Edst\u3078~(x ^ y)\u3092\u66F8\u304D\u8FBC\u307F\u307E\u3059\
    \u3002\u5168\u3066\u540C\u3058\u9577\u3055\u304C\u5FC5\u8981\u3067\u3059\u3002\
    O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        ## \u9818\u57DF\u78BA\u4FDD\u30FB\
    \u4E2D\u9593\u96C6\u5408\u306F\u4E0D\u8981\u3067\u3001dst\u306Bx\u3084y\u81EA\u8EAB\
    \u3092\u6307\u5B9A\u3059\u308B\u3053\u3068\u3082\u3067\u304D\u307E\u3059\u3002\
    \n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308A\u8AD6\u7406\u6F14\u7B971\u547D\u4EE4\u3002\u30ED\u30FC\u30C9\u30FB\
    \u30B9\u30C8\u30A2\u3068\u672B\u5C3E\u306E\u30DE\u30B9\u30AF\u306F\u5225\u3067\
    \u3059\u3002\n        when size > 0:\n            avxXnorAssign(addr dst.bits[0],\
    \ unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)\n\
    \            dst.trim()\n\n    proc `&`*[size](x, y: BitSet[size]): BitSet[size]\
    \ {.noinit.} =\n        ## \u5171\u901A\u90E8\u5206\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\
    \u3042\u305F\u308AAND 1\u547D\u4EE4\u3002\n        when size > 0:\n          \
    \  avxAnd(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\
    \n    proc `&=`*[size](x: var BitSet[size], y: BitSet[size]) =\n        ## \u81EA\
    \u8EAB\u3092\u5171\u901A\u90E8\u5206\u306B\u66F4\u65B0\u3057\u307E\u3059\u3002\
    \n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308AAND 1\u547D\u4EE4\u3002\n        when size > 0:\n            avxAnd(addr\
    \ x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n   \
    \ proc andNotAssign*[size](x: var BitSet[size], y: BitSet[size]) =\n        ##\
    \ x\u3092\u5DEE\u96C6\u5408x & ~y\u306B\u66F4\u65B0\u3057\u307E\u3059\u3002O(\u30D3\
    \u30C3\u30C8\u6570 / 64)\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89\
    : 512\u30D3\u30C3\u30C8\u3042\u305F\u308AANDNOT 1\u547D\u4EE4\u3002\n        when\
    \ size > 0:\n            avxAndNot(addr x.bits[0], addr x.bits[0], unsafeAddr\
    \ y.bits[0], x.bits.len.csize_t)\n\n    template `&=~`*[size](x: var BitSet[size],\
    \ y: BitSet[size]) =\n        ## x\u3092\u5DEE\u96C6\u5408x & ~y\u306B\u66F4\u65B0\
    \u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        ## AVX-512\u7D4C\
    \u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\u308AANDNOT 1\u547D\
    \u4EE4\u3002\u30C6\u30F3\u30D7\u30EC\u30FC\u30C8\u306E\u8FFD\u52A0\u547D\u4EE4\
    \u306F\u3042\u308A\u307E\u305B\u3093\u3002\n        andNotAssign(x, y)\n\n   \
    \ proc selectAssign*[size](x: var BitSet[size], y, mask: BitSet[size]) =\n   \
    \     ## mask\u304C1\u306E\u4F4D\u7F6E\u3060\u3051x\u3092y\u306E\u5024\u306B\u7F6E\
    \u304D\u63DB\u3048\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n \
    \       ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\
    \u308AVPTERNLOGQ 1\u547D\u4EE4\u3002AVX2\u7D4C\u8DEF\u306F256\u30D3\u30C3\u30C8\
    \u3042\u305F\u308A3\u547D\u4EE4\u3002\n        when size > 0:\n            avxSelectAssign(addr\
    \ x.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr mask.bits[0],\
    \ x.bits.len.csize_t)\n\n    proc orAndAssign*[size](x: var BitSet[size], y, z:\
    \ BitSet[size]) =\n        ## x\u3092x | (y & z)\u306B\u66F4\u65B0\u3057\u307E\
    \u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        ## AVX-512\u7D4C\u8DEF\
    \u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ 1\u547D\u4EE4\
    \u3002AVX2\u7D4C\u8DEF\u306F256\u30D3\u30C3\u30C8\u3042\u305F\u308A2\u547D\u4EE4\
    \u3002\n        when size > 0:\n            avxOrAndAssign(addr x.bits[0], unsafeAddr\
    \ x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.bits.len.csize_t)\n\
    \n    proc andOrAssign*[size](x: var BitSet[size], y, z: BitSet[size]) =\n   \
    \     ## x\u3092x & (y | z)\u306B\u66F4\u65B0\u3057\u307E\u3059\u3002O(\u30D3\u30C3\
    \u30C8\u6570 / 64)\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ 1\u547D\u4EE4\u3002AVX2\u7D4C\u8DEF\u306F\
    256\u30D3\u30C3\u30C8\u3042\u305F\u308A2\u547D\u4EE4\u3002\n        when size\
    \ > 0:\n            avxAndOrAssign(addr x.bits[0], unsafeAddr x.bits[0], unsafeAddr\
    \ y.bits[0], unsafeAddr z.bits[0], x.bits.len.csize_t)\n\n    proc xorAndAssign*[size](x:\
    \ var BitSet[size], y, z: BitSet[size]) =\n        ## x\u3092x ^ (y & z)\u306B\
    \u66F4\u65B0\u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n \
    \       ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\
    \u308AVPTERNLOGQ 1\u547D\u4EE4\u3002AVX2\u7D4C\u8DEF\u306F256\u30D3\u30C3\u30C8\
    \u3042\u305F\u308A2\u547D\u4EE4\u3002\n        when size > 0:\n            avxXorAndAssign(addr\
    \ x.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0],\
    \ x.bits.len.csize_t)\n\n    proc majority*[size](x, y, z: BitSet[size]): BitSet[size]\
    \ {.noinit.} =\n        ## 3\u96C6\u5408\u306E\u3046\u30612\u96C6\u5408\u4EE5\u4E0A\
    \u306B\u542B\u307E\u308C\u308B\u4F4D\u7F6E\u306E\u96C6\u5408\u3092\u8FD4\u3057\
    \u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        ## AVX-512\u7D4C\
    \u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ 1\u547D\
    \u4EE4\u3002AVX2\u7D4C\u8DEF\u306F256\u30D3\u30C3\u30C8\u3042\u305F\u308A4\u547D\
    \u4EE4\u3002\n        when size > 0:\n            avxMajority(addr result.bits[0],\
    \ unsafeAddr x.bits[0], unsafeAddr y.bits[0], unsafeAddr z.bits[0], x.bits.len.csize_t)\n\
    \n    proc xnor*[size](x, y: BitSet[size]): BitSet[size] {.noinit.} =\n      \
    \  ## \u5165\u529B\u3092\u5909\u66F4\u305B\u305A~(x ^ y)\u3092\u8FD4\u3057\u3001\
    \u7BC4\u56F2\u5916\u306E\u30D3\u30C3\u30C8\u30920\u306B\u3057\u307E\u3059\u3002\
    O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\u4E2D\u9593\u96C6\u5408\u306F\u4F5C\u308A\
    \u307E\u305B\u3093\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ 1\u547D\u4EE4\u3002AVX2\u7D4C\u8DEF\u306F\
    256\u30D3\u30C3\u30C8\u3042\u305F\u308A2\u547D\u4EE4\u3002\n        when size\
    \ > 0:\n            avxXnorAssign(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr\
    \ y.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)\n            result.trim()\n\
    \n    proc xnorAssign*[size](x: var BitSet[size], y: BitSet[size]) =\n       \
    \ ## x\u3092~(x ^ y)\u306B\u66F4\u65B0\u3057\u3001\u7BC4\u56F2\u5916\u306E\u30D3\
    \u30C3\u30C8\u30920\u306B\u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 /\
    \ 64)\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\
    \u30C8\u3042\u305F\u308AVPTERNLOGQ 1\u547D\u4EE4\u3002AVX2\u7D4C\u8DEF\u306F256\u30D3\
    \u30C3\u30C8\u3042\u305F\u308A2\u547D\u4EE4\u3002\n        when size > 0:\n  \
    \          avxXnorAssign(addr x.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0],\
    \ unsafeAddr x.bits[0], x.bits.len.csize_t)\n            x.trim()\n\n    proc\
    \ `|`*[size](x, y: BitSet[size]): BitSet[size] {.noinit.} =\n        ## \u548C\
    \u96C6\u5408\u3092\u8FD4\u3057\u307E\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\
    \u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\u308AOR 1\u547D\u4EE4\u3002\
    \n        when size > 0:\n            avxOr(addr result.bits[0], unsafeAddr x.bits[0],\
    \ unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n    proc `|=`*[size](x: var BitSet[size],\
    \ y: BitSet[size]) =\n        ## \u81EA\u8EAB\u3092\u548C\u96C6\u5408\u306B\u66F4\
    \u65B0\u3057\u307E\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89\
    : 512\u30D3\u30C3\u30C8\u3042\u305F\u308AOR 1\u547D\u4EE4\u3002\n        when\
    \ size > 0:\n            avxOr(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0],\
    \ x.bits.len.csize_t)\n\n    proc `^`*[size](x, y: BitSet[size]): BitSet[size]\
    \ {.noinit.} =\n        ## \u5BFE\u79F0\u5DEE\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308AXOR 1\u547D\u4EE4\u3002\n        when size > 0:\n            avxXor(addr\
    \ result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\
    \n    proc `^=`*[size](x: var BitSet[size], y: BitSet[size]) =\n        ## \u81EA\
    \u8EAB\u3092\u5BFE\u79F0\u5DEE\u306B\u66F4\u65B0\u3057\u307E\u3059\u3002\n   \
    \     ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\
    \u308AXOR 1\u547D\u4EE4\u3002\n        when size > 0:\n            avxXor(addr\
    \ x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n   \
    \ proc `<<`*[size](bitset: BitSet[size], x: int): BitSet[size] =\n        ## \u6DFB\
    \u5B57\u304C\u5927\u304D\u3044\u65B9\u5411\u3078x\u30D3\u30C3\u30C8\u305A\u3089\
    \u3057\u3001\u7BC4\u56F2\u5916\u3092\u5207\u308A\u6368\u3066\u307E\u3059\u3002\
    \n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: \u51FA\u529B512\u30D3\u30C3\
    \u30C8\u3042\u305F\u308A\u30B7\u30D5\u30C82\u547D\u4EE4\uFF0BOR 1\u547D\u4EE4\u3002\
    64\u306E\u500D\u6570\u306E\u30B7\u30D5\u30C8\u306F\u30B3\u30D4\u30FC\u306E\u307F\
    \u3002\n        when compileOption(\"boundChecks\"):\n            if x < 0:\n\
    \                raise newException(ValueError, \"shift count must be non-negative\"\
    )\n        when size > 0:\n            if x < size:\n                avxShl(addr\
    \ result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)\n\
    \                result.trim()\n\n    proc `>>`*[size](bitset: BitSet[size], x:\
    \ int): BitSet[size] =\n        ## \u6DFB\u5B57\u304C\u5C0F\u3055\u3044\u65B9\u5411\
    \u3078x\u30D3\u30C3\u30C8\u305A\u3089\u3057\u3001\u7BC4\u56F2\u5916\u3092\u5207\
    \u308A\u6368\u3066\u307E\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\
    \u5B89: \u51FA\u529B512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u30B7\u30D5\u30C8\
    2\u547D\u4EE4\uFF0BOR 1\u547D\u4EE4\u300264\u306E\u500D\u6570\u306E\u30B7\u30D5\
    \u30C8\u306F\u30B3\u30D4\u30FC\u306E\u307F\u3002\n        when compileOption(\"\
    boundChecks\"):\n            if x < 0:\n                raise newException(ValueError,\
    \ \"shift count must be non-negative\")\n        when size > 0:\n            if\
    \ x < size:\n                avxShr(addr result.bits[0], unsafeAddr bitset.bits[0],\
    \ bitset.bits.len.csize_t, x.csize_t)\n\n    proc `~`*[size](x: BitSet[size]):\
    \ BitSet[size] {.noinit.} =\n        ## \u96C6\u5408\u306E\u30D3\u30C3\u30C8\u6570\
    \u3092\u4FDD\u3063\u305F\u307E\u307E\u5404\u30D3\u30C3\u30C8\u3092\u53CD\u8EE2\
    \u3057\u307E\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308A\u53CD\u8EE2 1\u547D\u4EE4\uFF08\u5168\u30D3\u30C3\
    \u30C81\u3068\u306EXOR\u306A\u3069\uFF09\u3002\n        when size > 0:\n     \
    \       avxNot(addr result.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)\n\
    \            result.trim()\n\n    proc andAssignPopcount*[size](x: var BitSet[size],\
    \ y: BitSet[size]): int =\n        ## x\u3092x & y\u306B\u66F4\u65B0\u3057\u3001\
    \u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\
    O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\u67FB\u3067\u3059\u3002\
    \n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\u7B97\u306E\u8A08\
    3\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\u30FB\u7AEF\u6570\
    \u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size > 0:\n         \
    \   result = avxAndAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr\
    \ x.bits[0], size.csize_t).int\n\n    proc orAssignPopcount*[size](x: var BitSet[size],\
    \ y: BitSet[size]): int =\n        ## x\u3092x | y\u306B\u66F4\u65B0\u3057\u3001\
    \u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\
    O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\u67FB\u3067\u3059\u3002\
    \n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\u7B97\u306E\u8A08\
    3\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\u30FB\u7AEF\u6570\
    \u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size > 0:\n         \
    \   result = avxOrAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr\
    \ x.bits[0], size.csize_t).int\n\n    proc xorAssignPopcount*[size](x: var BitSet[size],\
    \ y: BitSet[size]): int =\n        ## x\u3092x ^ y\u306B\u66F4\u65B0\u3057\u3001\
    \u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\
    O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\u67FB\u3067\u3059\u3002\
    \n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\u7B97\u306E\u8A08\
    3\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\u30FB\u7AEF\u6570\
    \u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size > 0:\n         \
    \   result = avxXorAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0], unsafeAddr\
    \ x.bits[0], size.csize_t).int\n\n    proc andNotAssignPopcount*[size](x: var\
    \ BitSet[size], y: BitSet[size]): int =\n        ## x\u3092x & ~y\u306B\u66F4\u65B0\
    \u3057\u3001\u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\
    \u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\u67FB\u3067\
    \u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\
    \u30C8\u3042\u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\u7B97\
    \u306E\u8A083\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\u30FB\
    \u7AEF\u6570\u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size > 0:\n\
    \            result = avxAndNotAssignPopcount(addr x.bits[0], unsafeAddr y.bits[0],\
    \ unsafeAddr x.bits[0], size.csize_t).int\n\n    proc selectAssignPopcount*[size](x:\
    \ var BitSet[size], y, mask: BitSet[size]): int =\n        ## x\u3092mask\u304C\
    1\u306E\u4F4D\u7F6E\u3060\u3051y\u3092\u63A1\u7528\u3057\u305F\u96C6\u5408\u306B\
    \u66F4\u65B0\u3057\u3001\u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\
    \u67FB\u3067\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\
    \u7B97\u306E\u8A083\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\
    \u30FB\u7AEF\u6570\u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size\
    \ > 0:\n            result = avxSelectAssignPopcount(addr x.bits[0], unsafeAddr\
    \ y.bits[0], unsafeAddr mask.bits[0], size.csize_t).int\n\n    proc orAndAssignPopcount*[size](x:\
    \ var BitSet[size], y, z: BitSet[size]): int =\n        ## x\u3092x | (y & z)\u306B\
    \u66F4\u65B0\u3057\u3001\u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\
    \u67FB\u3067\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\
    \u7B97\u306E\u8A083\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\
    \u30FB\u7AEF\u6570\u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size\
    \ > 0:\n            result = avxOrAndAssignPopcount(addr x.bits[0], unsafeAddr\
    \ y.bits[0], unsafeAddr z.bits[0], size.csize_t).int\n\n    proc andOrAssignPopcount*[size](x:\
    \ var BitSet[size], y, z: BitSet[size]): int =\n        ## x\u3092x & (y | z)\u306B\
    \u66F4\u65B0\u3057\u3001\u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\
    \u67FB\u3067\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\
    \u7B97\u306E\u8A083\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\
    \u30FB\u7AEF\u6570\u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size\
    \ > 0:\n            result = avxAndOrAssignPopcount(addr x.bits[0], unsafeAddr\
    \ y.bits[0], unsafeAddr z.bits[0], size.csize_t).int\n\n    proc xorAndAssignPopcount*[size](x:\
    \ var BitSet[size], y, z: BitSet[size]): int =\n        ## x\u3092x ^ (y & z)\u306B\
    \u66F4\u65B0\u3057\u3001\u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\
    \u67FB\u3067\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\
    \u7B97\u306E\u8A083\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\
    \u30FB\u7AEF\u6570\u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size\
    \ > 0:\n            result = avxXorAndAssignPopcount(addr x.bits[0], unsafeAddr\
    \ y.bits[0], unsafeAddr z.bits[0], size.csize_t).int\n\n    proc xnorAssignPopcount*[size](x:\
    \ var BitSet[size], y: BitSet[size]): int =\n        ## x\u3092~(x ^ y)\u306B\u66F4\
    \u65B0\u3057\u3001\u66F4\u65B0\u5F8C\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\
    \u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u30011\u56DE\u306E\u8D70\u67FB\
    \u3067\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\
    \u30C3\u30C8\u3042\u305F\u308AVPTERNLOGQ\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\
    \u7B97\u306E\u8A083\u547D\u4EE4\u3002\u4FDD\u5B58\u30FB\u6700\u7D42\u96C6\u7D04\
    \u30FB\u7AEF\u6570\u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n        when size\
    \ > 0:\n            result = avxXnorAssignPopcount(addr x.bits[0], unsafeAddr\
    \ y.bits[0], unsafeAddr x.bits[0], size.csize_t).int\n\n    proc popcount*[size](x:\
    \ BitSet[size]): int =\n        ## \u7ACB\u3063\u3066\u3044\u308B\u30D3\u30C3\u30C8\
    \u306E\u500B\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\n        ## AVX-512\u7D4C\
    \u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\u308AVPOPCNTQ 1\u547D\
    \u4EE4\uFF0B\u7D2F\u7A4D\u52A0\u7B971\u547D\u4EE4\u3002\u6700\u5F8C\u306E8\u30EC\
    \u30FC\u30F3\u306E\u96C6\u7D04\u306F\u5225\u9014\u5FC5\u8981\u3067\u3059\u3002\
    \n        when size > 0:\n            result = avxPopcount(unsafeAddr x.bits[0],\
    \ unsafeAddr x.bits[0], x.bits.len.csize_t).int\n\n    proc andpopcount*[size](x,\
    \ y: BitSet[size]): int =\n        ## \u5171\u901A\u90E8\u5206\u306E\u8981\u7D20\
    \u6570\u3092\u3001\u4E00\u6642\u7684\u306A\u96C6\u5408\u3092\u4F5C\u3089\u305A\
    \u306B\u8FD4\u3057\u307E\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\
    \u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\u308AAND\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\
    \u52A0\u7B97\u306E\u8A083\u547D\u4EE4\u3002\u6700\u5F8C\u306E8\u30EC\u30FC\u30F3\
    \u306E\u96C6\u7D04\u306F\u5225\u9014\u5FC5\u8981\u3067\u3059\u3002\n        when\
    \ size > 0:\n            result = avxAndPopcount(unsafeAddr x.bits[0], unsafeAddr\
    \ y.bits[0], x.bits.len.csize_t).int\n\n    proc orpopcount*[size](x, y: BitSet[size]):\
    \ int =\n        ## \u548C\u96C6\u5408\u306E\u8981\u7D20\u6570\u3092\u3001\u4E00\
    \u6642\u7684\u306A\u96C6\u5408\u3092\u4F5C\u3089\u305A\u306B\u8FD4\u3057\u307E\
    \u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\
    \u30C8\u3042\u305F\u308AOR\uFF0BVPOPCNTQ\uFF0B\u7D2F\u7A4D\u52A0\u7B97\u306E\u8A08\
    3\u547D\u4EE4\u3002\u6700\u5F8C\u306E8\u30EC\u30FC\u30F3\u306E\u96C6\u7D04\u306F\
    \u5225\u9014\u5FC5\u8981\u3067\u3059\u3002\n        when size > 0:\n         \
    \   result = avxOrPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int\n\
    \n    proc xorpopcount*[size](x, y: BitSet[size]): int =\n        ## \u5BFE\u79F0\
    \u5DEE\u306E\u8981\u7D20\u6570\u3092\u3001\u4E00\u6642\u7684\u306A\u96C6\u5408\
    \u3092\u4F5C\u3089\u305A\u306B\u8FD4\u3057\u307E\u3059\u3002\n        ## AVX-512\u7D4C\
    \u8DEF\u306E\u76EE\u5B89: 512\u30D3\u30C3\u30C8\u3042\u305F\u308AXOR\uFF0BVPOPCNTQ\uFF0B\
    \u7D2F\u7A4D\u52A0\u7B97\u306E\u8A083\u547D\u4EE4\u3002\u6700\u5F8C\u306E8\u30EC\
    \u30FC\u30F3\u306E\u96C6\u7D04\u306F\u5225\u9014\u5FC5\u8981\u3067\u3059\u3002\
    \n        when size > 0:\n            result = avxXorPopcount(unsafeAddr x.bits[0],\
    \ unsafeAddr y.bits[0], x.bits.len.csize_t).int\n\n    proc popcountrange*[size](x:\
    \ BitSet[size], l, r: int): int =\n        ## x\u306E\u534A\u958B\u533A\u9593\
    [l, r)\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u30020 <= l <= r\
    \ <= len(x)\u3002O(1 + (r-l) / 64)\u3002\n        ## \u4E00\u6642\u96C6\u5408\u306F\
    \u4F5C\u3089\u305A\u3001\u4E21\u7AEF\u306E\u6700\u59272\u30EF\u30FC\u30C9\u3060\
    \u3051\u3092\u30DE\u30B9\u30AF\u3057\u307E\u3059\u3002\u7A7A\u533A\u9593\u306F\
    0\u3067\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\u306E\u76EE\u5B89: \u4E2D\u592E\
    \u306E\u5B8C\u5168\u306A512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u7D042\u6F14\u7B97\
    \u547D\u4EE4\u3002\u4E21\u7AEF\u306E\u30DE\u30B9\u30AF\u30FB\u500B\u6570\u8A08\
    \u7B97\u3068\u6700\u7D42\u96C6\u7D04\u306F\u5225\u3067\u3059\u3002\n        when\
    \ compileOption(\"boundChecks\"):\n            if l < 0 or l > r or r > size:\n\
    \                raise newException(IndexDefect, \"BitSet range out of bounds\"\
    )\n        when size > 0:\n            if l < r:\n                result = avxPopcountRange(unsafeAddr\
    \ x.bits[0], unsafeAddr x.bits[0], l.csize_t, r.csize_t).int\n\n    proc andpopcountrange*[size](x,\
    \ y: BitSet[size], l, r: int): int =\n        ## x\u3068y\u306E\u5171\u901A\u90E8\
    \u5206\u306E\u534A\u958B\u533A\u9593[l, r)\u306E\u8981\u7D20\u6570\u3092\u8FD4\
    \u3057\u307E\u3059\u30020 <= l <= r <= len(x)\u3002O(1 + (r-l) / 64)\u3002\n \
    \       ## \u4E00\u6642\u96C6\u5408\u306F\u4F5C\u3089\u305A\u3001\u4E21\u7AEF\u306E\
    \u6700\u59272\u30EF\u30FC\u30C9\u3060\u3051\u3092\u30DE\u30B9\u30AF\u3057\u307E\
    \u3059\u3002\u7A7A\u533A\u9593\u306F0\u3067\u3059\u3002\n        ## AVX-512\u7D4C\
    \u8DEF\u306E\u76EE\u5B89: \u4E2D\u592E\u306E\u5B8C\u5168\u306A512\u30D3\u30C3\u30C8\
    \u3042\u305F\u308A\u7D043\u6F14\u7B97\u547D\u4EE4\u3002\u4E21\u7AEF\u306E\u30DE\
    \u30B9\u30AF\u30FB\u500B\u6570\u8A08\u7B97\u3068\u6700\u7D42\u96C6\u7D04\u306F\
    \u5225\u3067\u3059\u3002\n        when compileOption(\"boundChecks\"):\n     \
    \       if l < 0 or l > r or r > size:\n                raise newException(IndexDefect,\
    \ \"BitSet range out of bounds\")\n        when size > 0:\n            if l <\
    \ r:\n                result = avxAndpopcountRange(unsafeAddr x.bits[0], unsafeAddr\
    \ y.bits[0], l.csize_t, r.csize_t).int\n\n    proc orpopcountrange*[size](x, y:\
    \ BitSet[size], l, r: int): int =\n        ## x\u3068y\u306E\u548C\u96C6\u5408\
    \u306E\u534A\u958B\u533A\u9593[l, r)\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\
    \u307E\u3059\u30020 <= l <= r <= len(x)\u3002O(1 + (r-l) / 64)\u3002\n       \
    \ ## \u4E00\u6642\u96C6\u5408\u306F\u4F5C\u3089\u305A\u3001\u4E21\u7AEF\u306E\u6700\
    \u59272\u30EF\u30FC\u30C9\u3060\u3051\u3092\u30DE\u30B9\u30AF\u3057\u307E\u3059\
    \u3002\u7A7A\u533A\u9593\u306F0\u3067\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\
    \u306E\u76EE\u5B89: \u4E2D\u592E\u306E\u5B8C\u5168\u306A512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308A\u7D043\u6F14\u7B97\u547D\u4EE4\u3002\u4E21\u7AEF\u306E\u30DE\u30B9\
    \u30AF\u30FB\u500B\u6570\u8A08\u7B97\u3068\u6700\u7D42\u96C6\u7D04\u306F\u5225\
    \u3067\u3059\u3002\n        when compileOption(\"boundChecks\"):\n           \
    \ if l < 0 or l > r or r > size:\n                raise newException(IndexDefect,\
    \ \"BitSet range out of bounds\")\n        when size > 0:\n            if l <\
    \ r:\n                result = avxOrpopcountRange(unsafeAddr x.bits[0], unsafeAddr\
    \ y.bits[0], l.csize_t, r.csize_t).int\n\n    proc xorpopcountrange*[size](x,\
    \ y: BitSet[size], l, r: int): int =\n        ## x\u3068y\u306E\u5BFE\u79F0\u5DEE\
    \u306E\u534A\u958B\u533A\u9593[l, r)\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\
    \u307E\u3059\u30020 <= l <= r <= len(x)\u3002O(1 + (r-l) / 64)\u3002\n       \
    \ ## \u4E00\u6642\u96C6\u5408\u306F\u4F5C\u3089\u305A\u3001\u4E21\u7AEF\u306E\u6700\
    \u59272\u30EF\u30FC\u30C9\u3060\u3051\u3092\u30DE\u30B9\u30AF\u3057\u307E\u3059\
    \u3002\u7A7A\u533A\u9593\u306F0\u3067\u3059\u3002\n        ## AVX-512\u7D4C\u8DEF\
    \u306E\u76EE\u5B89: \u4E2D\u592E\u306E\u5B8C\u5168\u306A512\u30D3\u30C3\u30C8\u3042\
    \u305F\u308A\u7D043\u6F14\u7B97\u547D\u4EE4\u3002\u4E21\u7AEF\u306E\u30DE\u30B9\
    \u30AF\u30FB\u500B\u6570\u8A08\u7B97\u3068\u6700\u7D42\u96C6\u7D04\u306F\u5225\
    \u3067\u3059\u3002\n        when compileOption(\"boundChecks\"):\n           \
    \ if l < 0 or l > r or r > size:\n                raise newException(IndexDefect,\
    \ \"BitSet range out of bounds\")\n        when size > 0:\n            if l <\
    \ r:\n                result = avxXorpopcountRange(unsafeAddr x.bits[0], unsafeAddr\
    \ y.bits[0], l.csize_t, r.csize_t).int\n\n    proc intersects*[size](x, y: BitSet[size]):\
    \ bool =\n        ## \u5171\u901A\u8981\u7D20\u304C\u3042\u308B\u304B\u3092\u5224\
    \u5B9A\u3057\u307E\u3059\u3002\u6700\u60AAO(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\
    \u7D50\u679C\u304C\u78BA\u5B9A\u3059\u308B\u3068\u7D42\u4E86\u3057\u307E\u3059\
    \u3002\n        ## AVX-512\u7D4C\u8DEF\u306F512\u30D3\u30C3\u30C8\u3042\u305F\u308A\
    \u30C6\u30B9\u30C81\u547D\u4EE4\u3001AVX2\u7D4C\u8DEF\u306F256\u30D3\u30C3\u30C8\
    \u3042\u305F\u308AVPTEST 1\u547D\u4EE4\u304C\u76EE\u5B89\u3067\u3059\u3002\u6761\
    \u4EF6\u5224\u5B9A\u306F\u5225\u3067\u3059\u3002\n        when size > 0:\n   \
    \         result = avxIntersects(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\
    \ != 0\n\n    proc isSubsetOf*[size](x, y: BitSet[size]): bool =\n        ## x\u304C\
    y\u306E\u90E8\u5206\u96C6\u5408\u304B\u3092\u5224\u5B9A\u3057\u307E\u3059\u3002\
    \u6700\u60AAO(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\u7D50\u679C\u304C\u78BA\u5B9A\
    \u3059\u308B\u3068\u7D42\u4E86\u3057\u307E\u3059\u3002\n        ## AVX-512\u7D4C\
    \u8DEF\u306F512\u30D3\u30C3\u30C8\u3042\u305F\u308AANDNOT\uFF0B\u30C6\u30B9\u30C8\
    \u306E2\u547D\u4EE4\u3001AVX2\u7D4C\u8DEF\u306F256\u30D3\u30C3\u30C8\u3042\u305F\
    \u308AVPTEST 1\u547D\u4EE4\u304C\u76EE\u5B89\u3067\u3059\u3002\u6761\u4EF6\u5224\
    \u5B9A\u306F\u5225\u3067\u3059\u3002\n        result = true\n        when size\
    \ > 0:\n            result = avxSubset(unsafeAddr x.bits[0], unsafeAddr y.bits[0],\
    \ x.bits.len.csize_t) != 0\n\n    proc nextSetBit*[size](x: BitSet[size], start:\
    \ int): int =\n        ## start\u4EE5\u4E0A\u3067\u6700\u521D\u306E1\u306E\u6DFB\
    \u5B57\u3092\u8FD4\u3057\u3001\u306A\u3051\u308C\u3070-1\u3092\u8FD4\u3057\u307E\
    \u3059\u30020 <= start <= len(x)\u3002\u6700\u60AAO(\u30D3\u30C3\u30C8\u6570 /\
    \ 64)\u3002\n        ## SIMD\u547D\u4EE4\u306F\u4F7F\u308F\u305A\u300164\u30D3\
    \u30C3\u30C8\u30EF\u30FC\u30C9\u3092\u8D70\u67FB\u3057\u3066\u672B\u5C3E\u306E\
    0\u306E\u500B\u6570\u304B\u3089\u4F4D\u7F6E\u3092\u6C42\u3081\u307E\u3059\u3002\
    \n        when compileOption(\"boundChecks\"):\n            if start < 0 or start\
    \ > size:\n                raise newException(IndexDefect, \"BitSet index out\
    \ of bounds\")\n        result = -1\n        when size > 0:\n            if start\
    \ < size:\n                var wordIndex = start shr 6\n                var word\
    \ = x.bits[wordIndex] and ((not 0'u64) shl (start and 63))\n                while\
    \ true:\n                    if word != 0:\n                        return wordIndex\
    \ * 64 + word.countTrailingZeroBits()\n                    inc wordIndex\n   \
    \                 if wordIndex >= x.bits.len: break\n                    word\
    \ = x.bits[wordIndex]\n\n    proc xnorpopcount*[size](x, y: BitSet[size]): int\
    \ =\n        ## \u30D3\u30C3\u30C8\u304C\u4E00\u81F4\u3059\u308B\u4F4D\u7F6E\u306E\
    \u500B\u6570\u3092\u3001\u4E00\u6642\u96C6\u5408\u3092\u4F5C\u3089\u305A\u306B\
    \u8FD4\u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n       \
    \ ## xorpopcount\u3068\u540C\u3058SIMD\u51E6\u7406\u306B\u3001\u30B9\u30AB\u30E9\
    \u30FC\u6E1B\u7B971\u547D\u4EE4\u3092\u52A0\u3048\u307E\u3059\u3002\n        size\
    \ - xorpopcount(x, y)\n\n    proc setRange*[size](x: var BitSet[size], l, r: int)\
    \ =\n        ## \u534A\u958B\u533A\u9593[l, r)\u306E\u30D3\u30C3\u30C8\u30921\u306B\
    \u66F4\u65B0\u3057\u307E\u3059\u3002\u7BC4\u56F2\u5916\u306F\u7DAD\u6301\u3057\
    \u307E\u3059\u3002O(1 + (r-l) / 64)\u3002\n        ## \u4E2D\u592E\u306E\u5B8C\
    \u5168\u306A\u30D6\u30ED\u30C3\u30AF\u306F\u5168\u30D3\u30C3\u30C81\u306E\u30B9\
    \u30C8\u30A2\u3067\u66F4\u65B0\u3057\u3001\u8AD6\u7406\u6F14\u7B97\u306F\u4E0D\
    \u8981\u3067\u3059\u3002\u4E21\u7AEF\u306E\u30DE\u30B9\u30AF\u51E6\u7406\u306F\
    \u5225\u3067\u3059\u3002\n        when compileOption(\"boundChecks\"):\n     \
    \       if l < 0 or l > r or r > size:\n                raise newException(IndexDefect,\
    \ \"BitSet range out of bounds\")\n        when size > 0:\n            if l <\
    \ r:\n                avxSetRange(addr x.bits[0], l.csize_t, r.csize_t)\n\n  \
    \  proc clearRange*[size](x: var BitSet[size], l, r: int) =\n        ## \u534A\
    \u958B\u533A\u9593[l, r)\u306E\u30D3\u30C3\u30C8\u30920\u306B\u66F4\u65B0\u3057\
    \u307E\u3059\u3002\u7BC4\u56F2\u5916\u306F\u7DAD\u6301\u3057\u307E\u3059\u3002\
    O(1 + (r-l) / 64)\u3002\n        ## \u4E2D\u592E\u306E\u5B8C\u5168\u306A\u30D6\
    \u30ED\u30C3\u30AF\u306F\u30BC\u30ED\u306E\u30B9\u30C8\u30A2\u3067\u66F4\u65B0\
    \u3057\u3001\u8AD6\u7406\u6F14\u7B97\u306F\u4E0D\u8981\u3067\u3059\u3002\u4E21\
    \u7AEF\u306E\u30DE\u30B9\u30AF\u51E6\u7406\u306F\u5225\u3067\u3059\u3002\n   \
    \     when compileOption(\"boundChecks\"):\n            if l < 0 or l > r or r\
    \ > size:\n                raise newException(IndexDefect, \"BitSet range out\
    \ of bounds\")\n        when size > 0:\n            if l < r:\n              \
    \  avxClearRange(addr x.bits[0], l.csize_t, r.csize_t)\n\n    proc flipRange*[size](x:\
    \ var BitSet[size], l, r: int) =\n        ## \u534A\u958B\u533A\u9593[l, r)\u306E\
    \u30D3\u30C3\u30C8\u3092\u53CD\u8EE2\u66F4\u65B0\u3057\u307E\u3059\u3002\u7BC4\
    \u56F2\u5916\u306F\u7DAD\u6301\u3057\u307E\u3059\u3002O(1 + (r-l) / 64)\u3002\n\
    \        ## 512\u30D3\u30C3\u30C8\u3042\u305F\u308A\u53CD\u8EE21\u547D\u4EE4\u304C\
    \u76EE\u5B89\u3067\u3059\u3002\u30ED\u30FC\u30C9\u30FB\u30B9\u30C8\u30A2\u3068\
    \u4E21\u7AEF\u306E\u30DE\u30B9\u30AF\u51E6\u7406\u306F\u5225\u3067\u3059\u3002\
    \n        when compileOption(\"boundChecks\"):\n            if l < 0 or l > r\
    \ or r > size:\n                raise newException(IndexDefect, \"BitSet range\
    \ out of bounds\")\n        when size > 0:\n            if l < r:\n          \
    \      avxFlipRange(addr x.bits[0], l.csize_t, r.csize_t)\n\n    proc clear*[size](x:\
    \ var BitSet[size]) =\n        ## \u5168\u30D3\u30C3\u30C8\u30920\u306B\u3057\u307E\
    \u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        x.clearRange(0, size)\n\
    \n    proc fill*[size](x: var BitSet[size]) =\n        ## \u6709\u52B9\u306A\u5168\
    \u30D3\u30C3\u30C8\u30921\u306B\u3057\u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570\
    \ / 64)\u3002\n        x.setRange(0, size)\n\n    proc flipAll*[size](x: var BitSet[size])\
    \ =\n        ## \u6709\u52B9\u306A\u5168\u30D3\u30C3\u30C8\u3092\u53CD\u8EE2\u3057\
    \u307E\u3059\u3002O(\u30D3\u30C3\u30C8\u6570 / 64)\u3002\n        x.flipRange(0,\
    \ size)\n\n    iterator items*[size](bitset: BitSet[size]): int =\n        ##\
    \ \u7ACB\u3063\u3066\u3044\u308B\u30D3\u30C3\u30C8\u306E\u6DFB\u5B57\u3092\u6607\
    \u9806\u306B\u5217\u6319\u3057\u307E\u3059\u3002\n        for wordIndex in 0..<bitset.bits.len:\n\
    \            var word = bitset.bits[wordIndex]\n            while word != 0:\n\
    \                yield wordIndex * 64 + word.countTrailingZeroBits()\n       \
    \         word = word and (word - 1)\n\n    proc lowestBit*[size](bitset: BitSet[size]):\
    \ int =\n        ## \u6700\u5C0F\u306E\u8981\u7D20\u3092\u8FD4\u3057\u3001\u7A7A\
    \u96C6\u5408\u306A\u3089-1\u3092\u8FD4\u3057\u307E\u3059\u3002\n        for wordIndex\
    \ in 0..<bitset.bits.len:\n            if bitset.bits[wordIndex] != 0:\n     \
    \           return wordIndex * 64 + bitset.bits[wordIndex].countTrailingZeroBits()\n\
    \        -1\n\n    proc `[]`*[size](bitset: BitSet[size], idx: Natural): bool\
    \ =\n        ## \u6307\u5B9A\u3057\u305F\u6DFB\u5B57\u306E\u30D3\u30C3\u30C8\u304C\
    \u7ACB\u3063\u3066\u3044\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\n   \
    \     ## AVX-512\u547D\u4EE4\u306F\u4F7F\u3044\u307E\u305B\u3093\u30021\u30EF\u30FC\
    \u30C9\u3092\u30B9\u30AB\u30E9\u30FC\u547D\u4EE4\u3067\u8AAD\u307F\u51FA\u3057\
    \u3066\u30D3\u30C3\u30C8\u3092\u5224\u5B9A\u3057\u307E\u3059\u3002\n        when\
    \ compileOption(\"boundChecks\"):\n            bitset.checkIndex(idx)\n      \
    \  bitset.bits[idx shr 6].testBit(idx and 63)\n\n    proc flip*[size](bitset:\
    \ var BitSet[size], idx: Natural) {.inline.} =\n        ## \u6307\u5B9A\u3057\u305F\
    \u6DFB\u5B57\u306E\u30D3\u30C3\u30C8\u3092\u53CD\u8EE2\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        ## AVX-512\u547D\u4EE4\u306F\u4F7F\u3044\u307E\u305B\u3093\
    \u30021\u30EF\u30FC\u30C9\u3092\u30B9\u30AB\u30E9\u30FC\u547D\u4EE4\u3067\u66F4\
    \u65B0\u3057\u307E\u3059\u3002\n        when compileOption(\"boundChecks\"):\n\
    \            bitset.checkIndex(idx)\n        bitset.bits[idx shr 6] = bitset.bits[idx\
    \ shr 6] xor (1'u64 shl (idx and 63))\n\n    proc `[]=`*[size](bitset: var BitSet[size],\
    \ idx: Natural, x: bool) =\n        ## \u6307\u5B9A\u3057\u305F\u6DFB\u5B57\u306E\
    \u30D3\u30C3\u30C8\u3092\u771F\u507D\u5024\u3067\u66F4\u65B0\u3057\u307E\u3059\
    \u3002\n        ## AVX-512\u547D\u4EE4\u306F\u4F7F\u3044\u307E\u305B\u3093\u3002\
    1\u30EF\u30FC\u30C9\u3092\u30B9\u30AB\u30E9\u30FC\u547D\u4EE4\u3067\u66F4\u65B0\
    \u3057\u307E\u3059\u3002\n        when compileOption(\"boundChecks\"):\n     \
    \       bitset.checkIndex(idx)\n        if x:\n            bitset.bits[idx shr\
    \ 6].setBit(idx and 63)\n        else:\n            bitset.bits[idx shr 6].clearBit(idx\
    \ and 63)\n\n    proc `[]=`*[size](bitset: var BitSet[size], idx: Natural, x:\
    \ int) =\n        ## 0\u306A\u3089\u30D3\u30C3\u30C8\u3092\u843D\u3068\u3057\u3001\
    1\u306A\u3089\u7ACB\u3066\u307E\u3059\u3002\u305D\u308C\u4EE5\u5916\u306F\u4F55\
    \u3082\u3057\u307E\u305B\u3093\u3002\n        ## AVX-512\u547D\u4EE4\u306F\u4F7F\
    \u3044\u307E\u305B\u3093\u30021\u30EF\u30FC\u30C9\u3092\u30B9\u30AB\u30E9\u30FC\
    \u547D\u4EE4\u3067\u66F4\u65B0\u3057\u307E\u3059\u3002\n        if x == 1:\n \
    \           bitset[idx] = true\n        elif x == 0:\n            bitset[idx]\
    \ = false\n\n    const ByteStrings = block:\n        var table: array[256, array[8,\
    \ char]]\n        for value in 0..<256:\n            for bit in 0..<8:\n     \
    \           table[value][bit] = char(ord('0') + ((value shr (7 - bit)) and 1))\n\
    \        table\n\n    proc `$`*[size](bitset: BitSet[size]): string =\n      \
    \  ## \u6DFB\u5B57\u306E\u5927\u304D\u3044\u9806\u306B\u30D3\u30C3\u30C8\u3092\
    \u4E26\u3079\u305F\u6587\u5B57\u5217\u3092\u8FD4\u3057\u307E\u3059\u3002\n   \
    \     result = newString(size)\n        var finish = size\n        for wordIndex\
    \ in 0..<bitset.bits.len:\n            var word = bitset.bits[wordIndex]\n   \
    \         var remaining = min(64, size - wordIndex * 64)\n            while remaining\
    \ >= 8:\n                finish -= 8\n                copyMem(addr result[finish],\
    \ unsafeAddr ByteStrings[int(word and 255)][0], 8)\n                word = word\
    \ shr 8\n                remaining -= 8\n            while remaining > 0:\n  \
    \              dec finish\n                result[finish] = char(ord('0') + int(word\
    \ and 1))\n                word = word shr 1\n                dec remaining\n\n\
    \    proc cmp*[size](x, y: BitSet[size]): int =\n        ## \u540C\u3058\u9577\
    \u3055\u306E\u30D3\u30C3\u30C8\u5217\u3092\u6DFB\u5B570\u304B\u3089false < true\u3067\
    \u6BD4\u8F03\u3057\u3001-1\u30FB0\u30FB1\u3092\u8FD4\u3057\u307E\u3059\u3002\n\
    \        ## \u6642\u9593O(1 + N / 64)\u3001\u8FFD\u52A0\u30E1\u30E2\u30EAO(1)\u3002\
    \u6700\u521D\u306E\u76F8\u9055\u3067\u7D42\u4E86\u3057\u307E\u3059\u3002\n   \
    \     ## 512\u30D3\u30C3\u30C8\u305A\u3064\u6BD4\u8F03\u3057\u307E\u3059\u3002\
    AVX512F\u975E\u5BFE\u5FDC\u6642\u306FAVX2\u3092\u4F7F\u3044\u307E\u3059\u3002\n\
    \        when size > 0:\n            result = avxCmp(unsafeAddr x.bits[0], unsafeAddr\
    \ y.bits[0], x.bits.len.csize_t).int\n\n    proc lexLess*[size](x, y: BitSet[size]):\
    \ bool {.inline.} =\n        ## \u6DFB\u5B570\u304B\u3089false < true\u306E\u8F9E\
    \u66F8\u9806\u3067\u5C0F\u3055\u3044\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \u6642\u9593O(1 + N / 64)\u3001\u8FFD\u52A0\u30E1\u30E2\u30EAO(1)\u3002\n    \
    \    cmp(x, y) < 0\n\n    proc `<`*[size](x, y: BitSet[size]): bool {.inline.}\
    \ =\n        ## \u6DFB\u5B570\u304B\u3089false < true\u306E\u8F9E\u66F8\u9806\u3067\
    \u5C0F\u3055\u3044\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\u6642\u9593O(1 +\
    \ N / 64)\u3001\u8FFD\u52A0\u30E1\u30E2\u30EAO(1)\u3002\n        cmp(x, y) < 0\n\
    \n    proc `<=`*[size](x, y: BitSet[size]): bool {.inline.} =\n        ## \u6DFB\
    \u5B570\u304B\u3089false < true\u306E\u8F9E\u66F8\u9806\u3067\u4EE5\u4E0B\u304B\
    \u3092\u8FD4\u3057\u307E\u3059\u3002\u6642\u9593O(1 + N / 64)\u3001\u8FFD\u52A0\
    \u30E1\u30E2\u30EAO(1)\u3002\n        cmp(x, y) <= 0\n\n    proc all*[size](x:\
    \ BitSet[size]): bool =\n        ## \u6709\u52B9\u306A\u5168\u30D3\u30C3\u30C8\
    \u304C1\u304B\u3092\u8FD4\u3057\u307E\u3059\u30020\u3092\u898B\u3064\u3051\u305F\
    \u3089\u7D42\u4E86\u3057\u3001\u9577\u30550\u3067\u306Ftrue\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\n        ## \u6700\u60AA\u6642\u9593O(1 + N / 64)\u3001\u8FFD\u52A0\
    \u30E1\u30E2\u30EAO(1)\u3002\n        ## 512\u30D3\u30C3\u30C8\u305A\u3064\u5224\
    \u5B9A\u3057\u3001AVX512F\u975E\u5BFE\u5FDC\u6642\u306FAVX2\u3092\u4F7F\u3044\u307E\
    \u3059\u3002\n        when size > 0:\n            result = avxAll(unsafeAddr x.bits[0],\
    \ size.csize_t) != 0\n        else:\n            result = true\n\n    proc any*[size](x:\
    \ BitSet[size]): bool =\n        ## \u6709\u52B9\u306A\u30D3\u30C3\u30C8\u306B\
    1\u304C\u3042\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\u30021\u3092\u898B\u3064\
    \u3051\u305F\u3089\u7D42\u4E86\u3057\u3001\u9577\u30550\u3067\u306Ffalse\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\n        ## \u6700\u60AA\u6642\u9593O(1 + N / 64)\u3001\
    \u8FFD\u52A0\u30E1\u30E2\u30EAO(1)\u3002\n        ## 512\u30D3\u30C3\u30C8\u305A\
    \u3064\u5224\u5B9A\u3057\u3001AVX512F\u975E\u5BFE\u5FDC\u6642\u306FAVX2\u3092\u4F7F\
    \u3044\u307E\u3059\u3002\n        when size > 0:\n            result = avxAny(unsafeAddr\
    \ x.bits[0], size.csize_t) != 0\n"
  dependsOn:
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  isVerificationFile: false
  path: cplib/collections/staticbitset_avx512.nim
  requiredBy: []
  timestamp: '2026-09-13 04:30:30+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/staticbitset_avx512.nim
layout: document
redirect_from:
- /library/cplib/collections/staticbitset_avx512.nim
- /library/cplib/collections/staticbitset_avx512.nim.html
title: cplib/collections/staticbitset_avx512.nim
---
