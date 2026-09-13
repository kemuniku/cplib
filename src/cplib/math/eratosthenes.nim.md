---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/eratosthenes_test.nim
    title: verify/AI/eratosthenes_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/eratosthenes_test.nim
    title: verify/AI/eratosthenes_test.nim
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
  code: "when not declared CPLIB_MATH_ERATOSTHENES:\n    const CPLIB_MATH_ERATOSTHENES*\
    \ = 1\n    import bitops\n\n    const\n        WheelResidues = [1, 7, 11, 13,\
    \ 17, 19, 23, 29]\n        WheelIndex = [ -1, 0, -1, -1, -1, -1, -1, 1, -1, -1,\n\
    \                       -1, 2, -1, 3, -1, -1, -1, 4, -1, 5,\n                \
    \       -1, -1, -1, 6, -1, -1, -1, -1, -1, 7 ]\n        SieveBlockBytes = 32 *\
    \ 1024\n        PreSieveGroups = [[7, 11, 13], [17, 19, 1], [23, 29, 1],\n   \
    \                       [31, 37, 1], [41, 43, 1]]\n        PreSievePrimes = [7,\
    \ 11, 13, 17, 19, 23, 29, 31, 37, 41, 43]\n\n    func makePreSieve(): seq[seq[uint8]]\
    \ =\n        ## \u5C0F\u7D20\u6570\u306E\u500D\u6570\u3092\u9664\u304F\u5468\u671F\
    \u30D1\u30BF\u30FC\u30F3\u3092\u30B3\u30F3\u30D1\u30A4\u30EB\u6642\u306B\u751F\
    \u6210\u3059\u308B\u3002\n        for group in PreSieveGroups:\n            let\
    \ period = group[0] * group[1] * group[2]\n            var pattern = newSeq[uint8](period)\n\
    \            for q in 0..<period:\n                var bits = 255'u8\n       \
    \         for i, r in WheelResidues:\n                    for p in group:\n  \
    \                      if p > 1 and (30 * q + r) mod p == 0:\n               \
    \             bits = bits and not (1'u8 shl i)\n                pattern[q] = bits\n\
    \            result.add(pattern)\n\n    const PreSieve = makePreSieve()\n\n  \
    \  type\n        EratosthenesSieve* = object\n            first, last, firstByte:\
    \ int\n            bits: seq[uint8]\n        SieveStrike = object\n          \
    \  prime: int\n            next: array[8, int]\n            masks: array[8, uint8]\n\
    \n    proc basePrimes(limit: int): seq[int] =\n        ## limit \u4EE5\u4E0B\u306E\
    \u57FA\u5E95\u7D20\u6570\u3092\u5947\u6570\u7BE9\u3067\u5217\u6319\u3059\u308B\
    \u3002O(limit log log limit) \u6642\u9593\u3002\n        var composite = newSeq[bool](limit\
    \ div 2 + 1)\n        var p = 3\n        while p <= limit div p:\n           \
    \ if not composite[p div 2]:\n                var j = p * p div 2\n          \
    \      while j < composite.len:\n                    composite[j] = true\n   \
    \                 j += p\n            p += 2\n        for i in 1..<composite.len:\n\
    \            let p = 2 * i + 1\n            if p <= limit and not composite[i]:\n\
    \                result.add(p)\n\n    # \u5185\u90E8\u3067\u4FDD\u8A3C\u3057\u305F\
    \u30D6\u30ED\u30C3\u30AF\u7BC4\u56F2\u3060\u3051\u3092\u64CD\u4F5C\u3057\u3001\
    AND \u30EB\u30FC\u30D7\u306E\u81EA\u52D5\u30D9\u30AF\u30C8\u30EB\u5316\u3092\u8A31\
    \u3059\u3002\n    {.push checks: off.}\n    proc fillBlock(dst: ptr UncheckedArray[uint8],\
    \ firstByte, size: int) =\n        ## \u5468\u671F\u30D1\u30BF\u30FC\u30F3\u3092\
    \u9023\u7D9A\u9818\u57DF\u3054\u3068\u306B AND \u5408\u6210\u3059\u308B\u3002\
    O(size) \u6642\u9593\u3002\n        for g in 0..<PreSieve.len:\n            let\
    \ period = PreSieve[g].len\n            var phase = firstByte mod period\n   \
    \         var pos = 0\n            while pos < size:\n                let n =\
    \ min(period - phase, size - pos)\n                if g == 0:\n              \
    \      copyMem(addr dst[pos], unsafeAddr PreSieve[g][phase], n)\n            \
    \    else:\n                    let source = cast[ptr UncheckedArray[uint8]](unsafeAddr\
    \ PreSieve[g][phase])\n                    let target = cast[ptr UncheckedArray[uint8]](addr\
    \ dst[pos])\n                    for i in 0..<n:\n                        target[i]\
    \ = target[i] and source[i]\n                pos += n\n                phase =\
    \ 0\n\n    proc strikeBlock(dst: ptr UncheckedArray[uint8], size: int, state:\
    \ var SieveStrike) =\n        ## \u5404\u5270\u4F59\u306E\u500D\u6570\u3092\u5B9A\
    \u9593\u9694\u3067\u6D88\u3057\u3001\u6B21\u30D6\u30ED\u30C3\u30AF\u3078\u306E\
    \u4F4D\u7F6E\u3092\u4FDD\u5B58\u3059\u308B\u3002\n        let p = state.prime\n\
    \        for r in 0..<8:\n            var j = state.next[r]\n            let mask\
    \ = state.masks[r]\n            while j + 3 * p < size:\n                dst[j]\
    \ = dst[j] and mask\n                dst[j + p] = dst[j + p] and mask\n      \
    \          dst[j + 2 * p] = dst[j + 2 * p] and mask\n                dst[j + 3\
    \ * p] = dst[j + 3 * p] and mask\n                j += 4 * p\n            while\
    \ j < size:\n                dst[j] = dst[j] and mask\n                j += p\n\
    \            state.next[r] = j - size\n    {.pop.}\n\n    proc initSegmentedEratosthenes*(low,\
    \ high: int): EratosthenesSieve =\n        ## \u9589\u533A\u9593 [low, high] \u3092\
    \u7BE9\u3046\u30020 <= low <= high\u3002\u4FDD\u6301\u9818\u57DF\u306F\u7D04 (high-low)/30\
    \ byte\u3002\n        doAssert low >= 0 and low <= high\n        result.first\
    \ = low\n        result.last = high\n        result.firstByte = low div 30\n \
    \       let endByte = high div 30\n        when declared(newSeqUninit):\n    \
    \        result.bits = newSeqUninit[uint8](endByte - result.firstByte + 1)\n \
    \       else:\n            result.bits = newSeqUninitialized[uint8](endByte -\
    \ result.firstByte + 1)\n        var root = 0\n        var step = 1 shl ((sizeof(int)\
    \ * 8 - 2) div 2)\n        while step > 0:\n            let candidate = root +\
    \ step\n            if candidate <= high div candidate:\n                root\
    \ = candidate\n            step = step shr 1\n        var states: seq[SieveStrike]\n\
    \        for p in basePrimes(root):\n            if p <= PreSievePrimes[^1]:\n\
    \                continue\n            var state = SieveStrike(prime: p)\n   \
    \         for i, r in WheelResidues:\n                let multiplier = uint64(p)\
    \ + uint64((r - p mod 30 + 30) mod 30)\n                let product = uint64(p)\
    \ * multiplier\n                var q = product div 30\n                if q <\
    \ uint64(result.firstByte):\n                    let gap = uint64(result.firstByte)\
    \ - q\n                    q += ((gap + uint64(p) - 1) div uint64(p)) * uint64(p)\n\
    \                state.next[i] = int(q) - result.firstByte\n                state.masks[i]\
    \ = not (1'u8 shl WheelIndex[int(product mod 30)])\n            states.add(state)\n\
    \        var pos = 0\n        while pos < result.bits.len:\n            let size\
    \ = min(SieveBlockBytes, result.bits.len - pos)\n            let dst = cast[ptr\
    \ UncheckedArray[uint8]](addr result.bits[pos])\n            fillBlock(dst, result.firstByte\
    \ + pos, size)\n            for state in states.mitems:\n                strikeBlock(dst,\
    \ size, state)\n            pos += size\n        for p in PreSievePrimes:\n  \
    \          if low <= p and p <= high:\n                let q = p div 30 - result.firstByte\n\
    \                result.bits[q] = result.bits[q] or (1'u8 shl WheelIndex[p mod\
    \ 30])\n        for i, r in WheelResidues:\n            if r < low mod 30:\n \
    \               result.bits[0] = result.bits[0] and not (1'u8 shl i)\n       \
    \     if r > high mod 30:\n                result.bits[^1] = result.bits[^1] and\
    \ not (1'u8 shl i)\n        if low <= 1 and 1 <= high:\n            result.bits[0]\
    \ = result.bits[0] and not 1'u8\n\n    proc initEratosthenes*(limit: int): EratosthenesSieve\
    \ =\n        ## \u9589\u533A\u9593 [0, limit] \u306E\u7BE9\u3092\u69CB\u7BC9\u3059\
    \u308B\u3002\u4FDD\u6301\u9818\u57DF\u306F floor(limit/30)+1 byte\u3002\n    \
    \    initSegmentedEratosthenes(0, limit)\n\n    proc is_prime*(sieve: EratosthenesSieve,\
    \ n: int): bool {.inline.} =\n        ## \u69CB\u7BC9\u3057\u305F\u9589\u533A\u9593\
    \u5185\u306E\u7D20\u6570\u5224\u5B9A\u3092 O(1) \u6642\u9593\u3067\u884C\u3046\
    \u3002\u7BC4\u56F2\u5916\u306F false\u3002\n        if n < sieve.first or n >\
    \ sieve.last or n < 2:\n            return false\n        if n == 2 or n == 3\
    \ or n == 5:\n            return true\n        let bit = WheelIndex[n mod 30]\n\
    \        bit >= 0 and (sieve.bits[n div 30 - sieve.firstByte] and (1'u8 shl bit))\
    \ != 0\n\n    proc byte_size*(sieve: EratosthenesSieve): int {.inline.} =\n  \
    \      ## \u7D20\u6570\u5224\u5B9A\u7528\u306E\u5727\u7E2E\u914D\u5217\u306E byte\
    \ \u6570\u3092 O(1) \u6642\u9593\u3067\u8FD4\u3059\u3002\n        sieve.bits.len\n\
    \n    proc count_primes*(sieve: EratosthenesSieve): int =\n        ## \u533A\u9593\
    \u5185\u306E\u7D20\u6570\u306E\u500B\u6570\u3092 O(\u533A\u9593\u9577 / 30) \u6642\
    \u9593\u3067\u8FD4\u3059\u3002\n        for p in [2, 3, 5]:\n            if sieve.first\
    \ <= p and p <= sieve.last:\n                inc result\n        for bits in sieve.bits:\n\
    \            result += countSetBits(bits)\n\n    iterator items*(sieve: EratosthenesSieve):\
    \ int =\n        ## \u533A\u9593\u5185\u306E\u7D20\u6570\u3092\u6607\u9806\u306B\
    \ O(\u533A\u9593\u9577 / 30 + \u7D20\u6570\u306E\u500B\u6570) \u6642\u9593\u3067\
    \u5217\u6319\u3059\u308B\u3002\n        for p in [2, 3, 5]:\n            if sieve.first\
    \ <= p and p <= sieve.last:\n                yield p\n        for q, byte in sieve.bits:\n\
    \            var bits = byte\n            while bits != 0:\n                let\
    \ i = countTrailingZeroBits(bits)\n                yield (sieve.firstByte + q)\
    \ * 30 + WheelResidues[i]\n                bits = bits and (bits - 1)\n\n    proc\
    \ collectPrimes(sieve: EratosthenesSieve): seq[int] =\n        ## \u7BE9\u5185\
    \u306E\u7D20\u6570\u3092 O(\u5727\u7E2E\u914D\u5217\u9577 + \u7D20\u6570\u306E\
    \u500B\u6570) \u6642\u9593\u3067\u6607\u9806\u306E seq \u306B\u3059\u308B\u3002\
    \n        let count = sieve.count_primes()\n        when declared(newSeqUninit):\n\
    \            result = newSeqUninit[int](count)\n        else:\n            result\
    \ = newSeqUninitialized[int](count)\n        var i = 0\n        for p in sieve:\n\
    \            result[i] = p\n            inc i\n\n    proc get_primes*(limit: int):\
    \ seq[int] =\n        ## limit \u4EE5\u4E0B\u306E\u7D20\u6570\u3092\u6607\u9806\
    \u306E seq \u3067\u8FD4\u3059\u3002limit < 2 \u306A\u3089\u7A7A\u5217\u3002\n\
    \        if limit < 2:\n            return @[]\n        collectPrimes(initEratosthenes(limit))\n\
    \n    proc get_primes*(l, r: int): seq[int] =\n        ## \u534A\u958B\u533A\u9593\
    \ [l, r) \u306E\u7D20\u6570\u3092\u533A\u9593\u7BE9\u3067\u6607\u9806\u306E seq\
    \ \u306B\u3059\u308B\u3002l >= r \u306A\u3089\u7A7A\u5217\u3002\n        if l\
    \ >= r or r <= 2:\n            return @[]\n        collectPrimes(initSegmentedEratosthenes(max(l,\
    \ 2), r - 1))\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/eratosthenes.nim
  requiredBy: []
  timestamp: '2026-09-13 12:34:02+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/eratosthenes_test.nim
  - verify/AI/eratosthenes_test.nim
documentation_of: cplib/math/eratosthenes.nim
layout: document
redirect_from:
- /library/cplib/math/eratosthenes.nim
- /library/cplib/math/eratosthenes.nim.html
title: cplib/math/eratosthenes.nim
---
