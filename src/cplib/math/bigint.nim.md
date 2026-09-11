---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/bigint_unit_test.nim
    title: verify/math/bigint_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/bigint_unit_test.nim
    title: verify/math/bigint_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/division_of_big_integers_test.nim
    title: verify/math/division_of_big_integers_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/division_of_big_integers_test.nim
    title: verify/math/division_of_big_integers_test.nim
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
  code: "when not declared CPLIB_MATH_BIGINT:\n    const CPLIB_MATH_BIGINT* = 1\n\
    \    import hashes\n    import cplib/convolution/convolution\n\n    type BigInt*\
    \ = object\n        sign: int\n        digits: seq[uint32]\n\n    const BigIntBase\
    \ = 1_000_000_000'u64\n\n    proc normalize(x: var BigInt) =\n        ## \u4E0A\
    \u4F4D\u306E\u4E0D\u8981\u306A 0 \u3092\u9664\u304D\u30010 \u306E\u7B26\u53F7\u3092\
    \u7D71\u4E00\u3059\u308B\u3002\n        while x.digits.len > 0 and x.digits[^1]\
    \ == 0:\n            x.digits.setLen(x.digits.len - 1)\n        if x.digits.len\
    \ == 0:\n            x.sign = 0\n\n    proc initBigInt*[T: SomeInteger](x: T):\
    \ BigInt =\n        ## \u7D44\u307F\u8FBC\u307F\u6574\u6570\u304B\u3089\u591A\u500D\
    \u9577\u6574\u6570\u3092\u4F5C\u308B\u3002\n        var magnitude: uint64\n  \
    \      when T is SomeSignedInt:\n            if x < 0:\n                result.sign\
    \ = -1\n                magnitude = uint64(-(x + 1)) + 1'u64\n            else:\n\
    \                magnitude = uint64(x)\n        else:\n            magnitude =\
    \ uint64(x)\n        if magnitude != 0 and result.sign == 0:\n            result.sign\
    \ = 1\n        if magnitude != 0:\n            let size = if magnitude < BigIntBase:\
    \ 1\n                elif magnitude < BigIntBase * BigIntBase: 2 else: 3\n   \
    \         result.digits = newSeq[uint32](size)\n            for i in 0..<size:\n\
    \                result.digits[i] = uint32(magnitude mod BigIntBase)\n       \
    \         magnitude = magnitude div BigIntBase\n\n    proc parseBigInt*(s: string):\
    \ BigInt =\n        ## \u7B26\u53F7\u4ED8\u304D 10 \u9032\u6587\u5B57\u5217\u3092\
    \u5909\u63DB\u3057\u3001\u7A7A\u6587\u5B57\u5217\u3084\u4E0D\u6B63\u306A\u6587\
    \u5B57\u306B\u306F ValueError \u3092\u9001\u51FA\u3059\u308B\u3002\n        if\
    \ s.len == 0:\n            raise newException(ValueError, \"\u591A\u500D\u9577\
    \u6574\u6570\u306E\u6587\u5B57\u5217\u304C\u7A7A\u3067\u3059\")\n        var first\
    \ = 0\n        result.sign = 1\n        if s[0] == '+' or s[0] == '-':\n     \
    \       if s[0] == '-':\n                result.sign = -1\n            first =\
    \ 1\n        if first == s.len:\n            raise newException(ValueError, \"\
    \u591A\u500D\u9577\u6574\u6570\u306E\u6570\u5B57\u304C\u3042\u308A\u307E\u305B\
    \u3093\")\n        result.digits = newSeq[uint32]((s.len - first + 8) div 9)\n\
    \        var last = s.len\n        var index = 0\n        while last > first:\n\
    \            let start = max(first, last - 9)\n            var digit = 0'u32\n\
    \            for i in start..<last:\n                if s[i] < '0' or s[i] > '9':\n\
    \                    raise newException(ValueError, \"\u591A\u500D\u9577\u6574\
    \u6570\u306B\u4E0D\u6B63\u306A\u6587\u5B57\u304C\u542B\u307E\u308C\u3066\u3044\
    \u307E\u3059\")\n                digit = digit * 10 + uint32(ord(s[i]) - ord('0'))\n\
    \            result.digits[index] = digit\n            inc index\n           \
    \ last = start\n        result.normalize()\n\n    proc initBigInt*(s: string):\
    \ BigInt =\n        ## \u7B26\u53F7\u4ED8\u304D 10 \u9032\u6587\u5B57\u5217\u304B\
    \u3089\u591A\u500D\u9577\u6574\u6570\u3092\u4F5C\u308B\u3002\n        parseBigInt(s)\n\
    \n    converter toBigInt*(x: SomeInteger): BigInt =\n        ## \u7D44\u307F\u8FBC\
    \u307F\u6574\u6570\u3092\u591A\u500D\u9577\u6574\u6570\u306B\u6697\u9ED9\u5909\
    \u63DB\u3059\u308B\u3002\n        initBigInt(x)\n\n    proc `$`*(x: BigInt): string\
    \ =\n        ## \u7B26\u53F7\u4ED8\u304D 10 \u9032\u6587\u5B57\u5217\u3092\u8FD4\
    \u3059\u3002\n        if x.sign == 0:\n            return \"0\"\n        if x.digits.len\
    \ <= 2:\n            var value = uint64(x.digits[0])\n            if x.digits.len\
    \ == 2:\n                value += uint64(x.digits[1]) * BigIntBase\n         \
    \   if x.sign < 0:\n                return system.`$`(-int64(value))\n       \
    \     return system.`$`(value)\n        const pairs = \"00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899\"\
    \n        let top = system.`$`(uint64(x.digits[^1]))\n        let signLen = ord(x.sign\
    \ < 0)\n        result = newString((x.digits.len - 1) * 9 + top.len + signLen)\n\
    \        if x.sign < 0:\n            result[0] = '-'\n        for i in 0..<top.len:\n\
    \            result[signLen + i] = top[i]\n        var position = result.len\n\
    \        for i in 0..<x.digits.len - 1:\n            var digit = x.digits[i]\n\
    \            for _ in 0..<4:\n                let pair = int(digit mod 100) *\
    \ 2\n                result[position - 1] = pairs[pair + 1]\n                result[position\
    \ - 2] = pairs[pair]\n                position -= 2\n                digit = digit\
    \ div 100\n            result[position - 1] = char(ord('0') + int(digit))\n  \
    \          dec position\n\n    proc isZero*(x: BigInt): bool =\n        ## 0 \u304B\
    \u3069\u3046\u304B\u3092\u8FD4\u3059\u3002\n        x.sign == 0\n\n    proc sgn*(x:\
    \ BigInt): int =\n        ## \u7B26\u53F7\u3092 -1, 0, 1 \u306E\u3044\u305A\u308C\
    \u304B\u3067\u8FD4\u3059\u3002\n        x.sign\n\n    proc abs*(x: BigInt): BigInt\
    \ =\n        ## \u7D76\u5BFE\u5024\u3092\u8FD4\u3059\u3002\n        result = x\n\
    \        if result.sign < 0:\n            result.sign = 1\n\n    proc `-`*(x:\
    \ BigInt): BigInt =\n        ## \u7B26\u53F7\u3092\u53CD\u8EE2\u3059\u308B\u3002\
    \n        result = x\n        result.sign = -result.sign\n\n    proc `+`*(x: BigInt):\
    \ BigInt =\n        ## \u5143\u306E\u5024\u3092\u8FD4\u3059\u3002\n        x\n\
    \n    proc cmpAbs(x, y: BigInt): int =\n        ## \u7D76\u5BFE\u5024\u3092\u6BD4\
    \u8F03\u3057\u3066 -1, 0, 1 \u306E\u3044\u305A\u308C\u304B\u3092\u8FD4\u3059\u3002\
    \n        if x.digits.len != y.digits.len:\n            return system.cmp(x.digits.len,\
    \ y.digits.len)\n        for i in countdown(x.digits.len - 1, 0):\n          \
    \  if x.digits[i] != y.digits[i]:\n                return system.cmp(x.digits[i],\
    \ y.digits[i])\n\n    proc cmp*(x, y: BigInt): int =\n        ## \u5927\u5C0F\u95A2\
    \u4FC2\u3092 -1, 0, 1 \u306E\u3044\u305A\u308C\u304B\u3067\u8FD4\u3059\u3002\n\
    \        if x.sign != y.sign:\n            return system.cmp(x.sign, y.sign)\n\
    \        x.sign * cmpAbs(x, y)\n\n    proc `==`*(x, y: BigInt): bool =\n     \
    \   ## \u7B49\u3057\u3044\u304B\u3069\u3046\u304B\u3092\u8FD4\u3059\u3002\n  \
    \      x.sign == y.sign and x.digits == y.digits\n\n    proc `<`*(x, y: BigInt):\
    \ bool =\n        ## \u5DE6\u8FBA\u304C\u53F3\u8FBA\u3088\u308A\u5C0F\u3055\u3044\
    \u304B\u3092\u8FD4\u3059\u3002\n        cmp(x, y) < 0\n\n    proc `<=`*(x, y:\
    \ BigInt): bool =\n        ## \u5DE6\u8FBA\u304C\u53F3\u8FBA\u4EE5\u4E0B\u304B\
    \u3092\u8FD4\u3059\u3002\n        cmp(x, y) <= 0\n\n    proc `>`*(x, y: BigInt):\
    \ bool =\n        ## \u5DE6\u8FBA\u304C\u53F3\u8FBA\u3088\u308A\u5927\u304D\u3044\
    \u304B\u3092\u8FD4\u3059\u3002\n        cmp(x, y) > 0\n\n    proc `>=`*(x, y:\
    \ BigInt): bool =\n        ## \u5DE6\u8FBA\u304C\u53F3\u8FBA\u4EE5\u4E0A\u304B\
    \u3092\u8FD4\u3059\u3002\n        cmp(x, y) >= 0\n\n    proc addAbs(x, y: BigInt):\
    \ BigInt =\n        ## \u7D76\u5BFE\u5024\u306E\u548C\u3092\u8FD4\u3059\u3002\n\
    \        result.sign = 1\n        let n = max(x.digits.len, y.digits.len)\n  \
    \      result.digits = newSeq[uint32](n + 1)\n        var carry = 0'u64\n    \
    \    for i in 0..<n:\n            if i < x.digits.len:\n                carry\
    \ += uint64(x.digits[i])\n            if i < y.digits.len:\n                carry\
    \ += uint64(y.digits[i])\n            result.digits[i] = uint32(carry mod BigIntBase)\n\
    \            carry = carry div BigIntBase\n        result.digits[n] = uint32(carry)\n\
    \        result.normalize()\n\n    proc subAbs(x, y: BigInt): BigInt =\n     \
    \   ## |x| >= |y| \u3092\u524D\u63D0\u3068\u3057\u3066\u7D76\u5BFE\u5024\u306E\
    \u5DEE\u3092\u8FD4\u3059\u3002\n        result.sign = 1\n        result.digits\
    \ = newSeq[uint32](x.digits.len)\n        var borrow = 0'i64\n        for i in\
    \ 0..<x.digits.len:\n            var digit = int64(x.digits[i]) - borrow\n   \
    \         if i < y.digits.len:\n                digit -= int64(y.digits[i])\n\
    \            borrow = 0\n            if digit < 0:\n                digit += int64(BigIntBase)\n\
    \                borrow = 1\n            result.digits[i] = uint32(digit)\n  \
    \      result.normalize()\n\n    proc `+`*(x, y: BigInt): BigInt =\n        ##\
    \ \u548C\u3092\u8FD4\u3059\u3002\n        if x.sign == 0:\n            return\
    \ y\n        if y.sign == 0:\n            return x\n        if x.sign == y.sign:\n\
    \            result = addAbs(x, y)\n            result.sign = x.sign\n       \
    \ elif cmpAbs(x, y) >= 0:\n            result = subAbs(x, y)\n            result.sign\
    \ *= x.sign\n        else:\n            result = subAbs(y, x)\n            result.sign\
    \ *= y.sign\n\n    proc `-`*(x, y: BigInt): BigInt =\n        ## \u5DEE\u3092\u8FD4\
    \u3059\u3002\n        x + (-y)\n\n    proc mulSchoolbook(x, y: BigInt): BigInt\
    \ =\n        ## 0 \u3067\u306A\u3044\u6574\u6570\u540C\u58EB\u306E\u7A4D\u3092\
    \u7B46\u7B97\u3067\u8FD4\u3059\u3002\n        result.sign = x.sign * y.sign\n\
    \        result.digits = newSeq[uint32](x.digits.len + y.digits.len)\n       \
    \ for i in 0..<x.digits.len:\n            var carry = 0'u64\n            for j\
    \ in 0..<y.digits.len:\n                let digit = uint64(result.digits[i + j])\
    \ +\n                    uint64(x.digits[i]) * uint64(y.digits[j]) + carry\n \
    \               result.digits[i + j] = uint32(digit mod BigIntBase)\n        \
    \        carry = digit div BigIntBase\n            result.digits[i + y.digits.len]\
    \ = uint32(carry)\n        result.normalize()\n\n    when defined(cpp) and defined(amd64):\n\
    \        const\n            BigIntNttThreshold = 64\n            BigIntNttMaxLength\
    \ = 1 shl 24\n            BigIntNttMod1 = 754974721'u64\n            BigIntNttMod2\
    \ = 469762049'u64\n            BigIntNttInvMod1 = 221064492'u64\n            BigIntNttLargeBaseMaxDigits\
    \ = int(\n                (BigIntNttMod1 * BigIntNttMod2 - 1) div (999999'u64\
    \ * 999999'u64))\n\n        proc bigIntConvolutionAvx2(\n                output,\
    \ left: ptr uint32, leftLen: csize_t,\n                right: ptr uint32, rightLen,\
    \ nttLen: csize_t,\n                modulus, primitiveRoot: uint32, montgomeryRepresentation:\
    \ bool\n                ) {.importc: \"cplib_convolution_ntt_friendly\".}\n  \
    \          ## \u65E2\u5B58\u306E AVX2 \u7573\u307F\u8FBC\u307F\u3092\u901A\u5E38\
    \u8868\u73FE\u306E 32 bit \u914D\u5217\u304B\u3089\u547C\u3073\u51FA\u3059\u3002\
    \n\n        proc convolutionNttDigits(left, right: seq[uint32],\n            \
    \    modulus, primitiveRoot: uint32): seq[uint32] =\n            ## \u6307\u5B9A\
    \u3057\u305F NTT \u7D20\u6570\u3092\u6CD5\u3068\u3059\u308B\u7573\u307F\u8FBC\u307F\
    \u3092\u8FD4\u3059\u3002\n            let length = left.len + right.len - 1\n\
    \            var nttLength = 1\n            while nttLength < length:\n      \
    \          nttLength *= 2\n            result = newSeq[uint32](nttLength)\n  \
    \          bigIntConvolutionAvx2(addr result[0], unsafeAddr left[0], left.len.csize_t,\n\
    \                unsafeAddr right[0], right.len.csize_t, nttLength.csize_t,\n\
    \                modulus, primitiveRoot, false)\n            result.setLen(length)\n\
    \n        proc splitNttDigits[decimalDigits: static[int]](x: BigInt): seq[uint32]\
    \ =\n            ## 10^9 \u9032\u306E\u6841\u3092 NTT \u7528\u306E 10^6 \u9032\
    \u307E\u305F\u306F 10^5 \u9032\u306B\u5909\u63DB\u3059\u308B\u3002\n         \
    \   const base = if decimalDigits == 6: 1_000_000'u64 else: 100_000'u64\n    \
    \        result = newSeq[uint32]((x.digits.len * 9 + decimalDigits - 1) div decimalDigits)\n\
    \            var value = 0'u64\n            var scale = 1'u64\n            var\
    \ position = 0\n            for digit in x.digits:\n                value += uint64(digit)\
    \ * scale\n                scale *= BigIntBase\n                while scale >=\
    \ base:\n                    result[position] = uint32(value mod base)\n     \
    \               value = value div base\n                    scale = scale div\
    \ base\n                    inc position\n            if scale > 1:\n        \
    \        result[position] = uint32(value)\n\n        proc restoreNttProduct[decimalDigits:\
    \ static[int]](\n                c1, c2: seq[uint32], length, sign: int): BigInt\
    \ =\n            ## 2 \u7D20\u6570\u306E\u7573\u307F\u8FBC\u307F\u3092 CRT \u3067\
    \u5FA9\u5143\u3057\u3001\u7E70\u308A\u4E0A\u304C\u308A\u3092\u51E6\u7406\u3059\
    \u308B\u3002\n            const base = if decimalDigits == 6: 1_000_000'u64 else:\
    \ 100_000'u64\n            result.sign = sign\n            result.digits = newSeq[uint32](length)\n\
    \            # \u547C\u3073\u51FA\u3057\u5074\u3067\u5404\u4FC2\u6570\u304C 2\
    \ \u7D20\u6570\u306E\u7A4D\u672A\u6E80\u3067\u3042\u308B\u3053\u3068\u3092\u4FDD\
    \u8A3C\u3059\u308B\u3002\n            var carry = 0'u64\n            var value\
    \ = 0'u64\n            var scale = 1'u64\n            var position = 0\n     \
    \       for i in 0..<c1.len:\n                let r1 = uint64(c1[i])\n       \
    \         let t2 = ((uint64(c2[i]) + 2 * BigIntNttMod2 - r1) *\n             \
    \       BigIntNttInvMod1) mod BigIntNttMod2\n                carry += r1 + BigIntNttMod1\
    \ * t2\n                value += (carry mod base) * scale\n                carry\
    \ = carry div base\n                scale *= base\n                if scale >=\
    \ BigIntBase:\n                    result.digits[position] = uint32(value mod\
    \ BigIntBase)\n                    value = value div BigIntBase\n            \
    \        scale = scale div BigIntBase\n                    inc position\n    \
    \        while carry != 0:\n                value += (carry mod base) * scale\n\
    \                carry = carry div base\n                scale *= base\n     \
    \           if scale >= BigIntBase:\n                    result.digits[position]\
    \ = uint32(value mod BigIntBase)\n                    value = value div BigIntBase\n\
    \                    scale = scale div BigIntBase\n                    inc position\n\
    \            if value != 0:\n                result.digits[position] = uint32(value)\n\
    \            result.normalize()\n\n        proc mulNtt[decimalDigits: static[int]](x,\
    \ y: BigInt): BigInt =\n            ## \u4FC2\u6570\u4E0A\u9650\u306B\u5408\u308F\
    \u305B\u305F 2 \u7D20\u6570\u306E NTT \u3068 CRT \u3067\u53B3\u5BC6\u306A\u7A4D\
    \u3092\u8FD4\u3059\u3002\n            let left = splitNttDigits[decimalDigits](x)\n\
    \            let right = splitNttDigits[decimalDigits](y)\n            let c1\
    \ = convolutionNttDigits(left, right, BigIntNttMod1.uint32, 11'u32)\n        \
    \    let c2 = convolutionNttDigits(left, right, BigIntNttMod2.uint32, 3'u32)\n\
    \            restoreNttProduct[decimalDigits](c1, c2,\n                x.digits.len\
    \ + y.digits.len, x.sign * y.sign)\n\n    proc `*`*(x, y: BigInt): BigInt =\n\
    \        ## \u5927\u304D\u306A\u6570\u306F NTT\u3001\u5C0F\u3055\u306A\u6570\u3084\
    \ NTT \u306E\u5BFE\u5FDC\u7BC4\u56F2\u5916\u3067\u306F\u7B46\u7B97\u3067\u7A4D\
    \u3092\u8FD4\u3059\u3002\n        if x.sign == 0 or y.sign == 0:\n           \
    \ return\n        when nimvm:\n            result = mulSchoolbook(x, y)\n    \
    \    else:\n            when defined(cpp) and defined(amd64):\n              \
    \  let smaller = min(x.digits.len, y.digits.len)\n                let total =\
    \ x.digits.len + y.digits.len\n                if smaller > BigIntNttThreshold:\n\
    \                    if smaller <= (BigIntNttLargeBaseMaxDigits * 2) div 3 and\n\
    \                            total <= (BigIntNttMaxLength * 2) div 3:\n      \
    \                  return mulNtt[6](x, y)\n                    if total <= (BigIntNttMaxLength\
    \ * 5) div 9:\n                        return mulNtt[5](x, y)\n            result\
    \ = mulSchoolbook(x, y)\n\n    proc mulAbsSmall(x: BigInt, y: uint32): BigInt\
    \ =\n        ## \u7D76\u5BFE\u5024\u3068 1 \u6841\u306E\u975E\u8CA0\u6574\u6570\
    \u3068\u306E\u7A4D\u3092\u8FD4\u3059\u3002\n        result.sign = 1\n        result.digits\
    \ = newSeq[uint32](x.digits.len + 1)\n        var carry = 0'u64\n        for i\
    \ in 0..<x.digits.len:\n            let digit = uint64(x.digits[i]) * uint64(y)\
    \ + carry\n            result.digits[i] = uint32(digit mod BigIntBase)\n     \
    \       carry = digit div BigIntBase\n        result.digits[x.digits.len] = uint32(carry)\n\
    \        result.normalize()\n\n    proc divAbsSmall(x: BigInt, y: uint32): tuple[quotient:\
    \ BigInt, remainder: uint32] =\n        ## \u7D76\u5BFE\u5024\u3092 1 \u6841\u306E\
    \u6B63\u6574\u6570\u3067\u5272\u3063\u305F\u5546\u3068\u4F59\u308A\u3092\u8FD4\
    \u3059\u3002\n        result.quotient.sign = 1\n        result.quotient.digits\
    \ = newSeq[uint32](x.digits.len)\n        var remainder = 0'u64\n        for i\
    \ in countdown(x.digits.len - 1, 0):\n            let digit = remainder * BigIntBase\
    \ + uint64(x.digits[i])\n            result.quotient.digits[i] = uint32(digit\
    \ div uint64(y))\n            remainder = digit mod uint64(y)\n        result.quotient.normalize()\n\
    \        result.remainder = uint32(remainder)\n\n    proc divmodSchoolbook(x,\
    \ y: BigInt): tuple[quotient, remainder: BigInt] =\n        ## \u7B46\u7B97\u3067\
    \ 0 \u65B9\u5411\u306B\u4E38\u3081\u305F\u5546\u3068\u4F59\u308A\u3092\u8FD4\u3057\
    \u30010 \u9664\u7B97\u306B\u306F DivByZeroDefect \u3092\u9001\u51FA\u3059\u308B\
    \u3002\n        if y.sign == 0:\n            raise newException(DivByZeroDefect,\
    \ \"\u591A\u500D\u9577\u6574\u6570\u3092 0 \u3067\u5272\u308B\u3053\u3068\u306F\
    \u3067\u304D\u307E\u305B\u3093\")\n        if cmpAbs(x, y) < 0:\n            result.remainder\
    \ = x\n            return\n        if x.digits.len <= 2:\n            var numerator\
    \ = uint64(x.digits[0])\n            var denominator = uint64(y.digits[0])\n \
    \           if x.digits.len == 2:\n                numerator += uint64(x.digits[1])\
    \ * BigIntBase\n            if y.digits.len == 2:\n                denominator\
    \ += uint64(y.digits[1]) * BigIntBase\n            result.quotient = initBigInt(numerator\
    \ div denominator)\n            result.remainder = initBigInt(numerator mod denominator)\n\
    \            result.quotient.sign *= x.sign * y.sign\n            result.remainder.sign\
    \ *= x.sign\n            return\n        if y.digits.len == 1:\n            if\
    \ y.digits[0] == 1:\n                result.quotient = x\n                result.quotient.sign\
    \ *= y.sign\n                return\n            let division = divAbsSmall(x,\
    \ y.digits[0])\n            result.quotient = division.quotient\n            result.quotient.sign\
    \ *= x.sign * y.sign\n            result.remainder = initBigInt(division.remainder)\n\
    \            result.remainder.sign *= x.sign\n            return\n\n        let\
    \ factor = uint32(BigIntBase div (uint64(y.digits[^1]) + 1))\n        var dividend\
    \ = mulAbsSmall(x, factor)\n        let divisor = mulAbsSmall(y, factor)\n   \
    \     let n = divisor.digits.len\n        let quotientLen = x.digits.len - n +\
    \ 1\n        dividend.digits.setLen(x.digits.len + 1)\n        result.quotient.sign\
    \ = x.sign * y.sign\n        result.quotient.digits = newSeq[uint32](quotientLen)\n\
    \        for j in countdown(quotientLen - 1, 0):\n            let top = uint64(dividend.digits[j\
    \ + n]) * BigIntBase +\n                uint64(dividend.digits[j + n - 1])\n \
    \           var estimate = min(BigIntBase - 1, top div uint64(divisor.digits[n\
    \ - 1]))\n            var remainder = top - estimate * uint64(divisor.digits[n\
    \ - 1])\n            while remainder < BigIntBase and\n                    estimate\
    \ * uint64(divisor.digits[n - 2]) >\n                    remainder * BigIntBase\
    \ + uint64(dividend.digits[j + n - 2]):\n                dec estimate\n      \
    \          remainder += uint64(divisor.digits[n - 1])\n\n            var borrow\
    \ = 0'i64\n            for i in 0..<n:\n                let product = estimate\
    \ * uint64(divisor.digits[i]) + uint64(borrow)\n                var digit = int64(dividend.digits[j\
    \ + i]) - int64(product mod BigIntBase)\n                borrow = int64(product\
    \ div BigIntBase)\n                if digit < 0:\n                    digit +=\
    \ int64(BigIntBase)\n                    inc borrow\n                dividend.digits[j\
    \ + i] = uint32(digit)\n            var last = int64(dividend.digits[j + n]) -\
    \ borrow\n            if last < 0:\n                dec estimate\n           \
    \     var carry = 0'u64\n                for i in 0..<n:\n                   \
    \ let digit = uint64(dividend.digits[j + i]) +\n                        uint64(divisor.digits[i])\
    \ + carry\n                    dividend.digits[j + i] = uint32(digit mod BigIntBase)\n\
    \                    carry = digit div BigIntBase\n                last += int64(carry)\n\
    \            dividend.digits[j + n] = uint32(last)\n            result.quotient.digits[j]\
    \ = uint32(estimate)\n\n        result.quotient.normalize()\n        dividend.digits.setLen(n)\n\
    \        dividend.normalize()\n        result.remainder = divAbsSmall(dividend,\
    \ factor).quotient\n        result.remainder.sign *= x.sign\n\n    when defined(cpp)\
    \ and defined(amd64):\n        const BigIntNewtonThreshold = 256\n\n        proc\
    \ fixedConvolutionCreate(data: ptr uint32, length, size: csize_t,\n          \
    \      modulus, root: uint32): pointer {.importc: \"cplib_fixed_convolution_create\"\
    .}\n            ## \u56FA\u5B9A\u5074\u306E NTT \u3092\u4FDD\u6301\u3059\u308B\
    \u30B3\u30F3\u30C6\u30AD\u30B9\u30C8\u3092\u4F5C\u308B\u3002\n\n        proc fixedConvolutionRun(context:\
    \ pointer, output, data: ptr uint32,\n                length: csize_t) {.importc:\
    \ \"cplib_fixed_convolution_run\".}\n            ## \u56FA\u5B9A\u5074\u306E NTT\
    \ \u3092\u518D\u5229\u7528\u3057\u3066\u7573\u307F\u8FBC\u307F\u3092\u8A08\u7B97\
    \u3059\u308B\u3002\n\n        proc fixedConvolutionDestroy(context: pointer) {.importc:\
    \ \"cplib_fixed_convolution_destroy\".}\n            ## \u56FA\u5B9A\u5074\u306E\
    \ NTT \u3068\u5909\u63DB\u8A08\u753B\u3092\u89E3\u653E\u3059\u308B\u3002\n\n \
    \       type FixedBigIntMultiplier = object\n            first, second: pointer\n\
    \            length, fixedLength: int\n            c1, c2: seq[uint32]\n\n   \
    \     proc initFixedMultiplier(y: BigInt, maxLeftLength: int): FixedBigIntMultiplier\
    \ =\n            ## \u4FC2\u6570\u4E0A\u9650\u3092\u6E80\u305F\u3059\u5834\u5408\
    \u306B\u9650\u308A\u3001\u7E70\u308A\u8FD4\u3057\u4E57\u7B97\u306E\u56FA\u5B9A\
    \u5074\u3092\u6E96\u5099\u3059\u308B\u3002\n            let fixedLength = (y.digits.len\
    \ * 3 + 1) div 2\n            let leftLength = (maxLeftLength * 3 + 1) div 2\n\
    \            if min(fixedLength, leftLength) > BigIntNttLargeBaseMaxDigits or\n\
    \                    fixedLength + leftLength - 1 > BigIntNttMaxLength:\n    \
    \            return\n            result.length = 1\n            while result.length\
    \ < fixedLength + leftLength - 1:\n                result.length *= 2\n      \
    \      result.fixedLength = fixedLength\n            let digits = splitNttDigits[6](y)\n\
    \            result.first = fixedConvolutionCreate(unsafeAddr digits[0], digits.len.csize_t,\n\
    \                result.length.csize_t, BigIntNttMod1.uint32, 11'u32)\n      \
    \      result.second = fixedConvolutionCreate(unsafeAddr digits[0], digits.len.csize_t,\n\
    \                result.length.csize_t, BigIntNttMod2.uint32, 3'u32)\n       \
    \     result.c1 = newSeq[uint32](result.length)\n            result.c2 = newSeq[uint32](result.length)\n\
    \n        proc close(context: var FixedBigIntMultiplier) =\n            ## \u9664\
    \u7B97\u304C\u7D42\u308F\u3063\u305F\u6642\u70B9\u3067\u56FA\u5B9A\u5074\u306E\
    \ NTT \u3092\u89E3\u653E\u3059\u308B\u3002\n            fixedConvolutionDestroy(context.first)\n\
    \            fixedConvolutionDestroy(context.second)\n            context.first\
    \ = nil\n            context.second = nil\n\n        proc mulFixed(x, y: BigInt,\
    \ context: var FixedBigIntMultiplier): BigInt =\n            ## \u56FA\u5B9A\u5074\
    \u306E\u5909\u63DB\u3068\u4F5C\u696D\u9818\u57DF\u3092\u518D\u5229\u7528\u3057\
    \u3066\u7A4D\u3092\u8FD4\u3059\u3002\n            if context.first == nil or x.digits.len\
    \ <= BigIntNttThreshold:\n                return x * y\n            let left =\
    \ splitNttDigits[6](x)\n            context.c1.setLen(context.length)\n      \
    \      context.c2.setLen(context.length)\n            fixedConvolutionRun(context.first,\
    \ addr context.c1[0], unsafeAddr left[0], left.len.csize_t)\n            fixedConvolutionRun(context.second,\
    \ addr context.c2[0], unsafeAddr left[0], left.len.csize_t)\n            context.c1.setLen(left.len\
    \ + context.fixedLength - 1)\n            context.c2.setLen(left.len + context.fixedLength\
    \ - 1)\n            restoreNttProduct[6](context.c1, context.c2,\n           \
    \     x.digits.len + y.digits.len, x.sign * y.sign)\n\n        proc shiftDigitsLeft(x:\
    \ BigInt, count: int): BigInt =\n            ## \u57FA\u6570\u306E count \u4E57\
    \u3092\u639B\u3051\u308B\u3002\n            if x.isZero:\n                return\n\
    \            result.sign = x.sign\n            result.digits = newSeq[uint32](x.digits.len\
    \ + count)\n            for i in 0..<x.digits.len:\n                result.digits[i\
    \ + count] = x.digits[i]\n\n        proc shiftDigitsRight(x: BigInt, count: int):\
    \ BigInt =\n            ## \u4E0B\u4F4D count \u6841\u3092\u5207\u308A\u6368\u3066\
    \u3001\u7B26\u53F7\u3092\u7DAD\u6301\u3059\u308B\u3002\n            if x.digits.len\
    \ <= count:\n                return\n            result.sign = x.sign\n      \
    \      result.digits = newSeq[uint32](x.digits.len - count)\n            for i\
    \ in 0..<result.digits.len:\n                result.digits[i] = x.digits[i + count]\n\
    \n        proc basePower(exponent: int): BigInt =\n            ## \u57FA\u6570\
    \u306E exponent \u4E57\u3092\u8FD4\u3059\u3002\n            result.sign = 1\n\
    \            result.digits = newSeq[uint32](exponent + 1)\n            result.digits[exponent]\
    \ = 1\n\n        proc reciprocalAbs(x: BigInt): BigInt =\n            ## \u6B63\
    \u306E m \u6841\u306E x \u306B\u5BFE\u3057\u3001B^(2m)/x \u4EE5\u4E0B\u3067\u8AA4\
    \u5DEE 2 \u672A\u6E80\u306E\u6574\u6570\u8FD1\u4F3C\u3092\u6C42\u3081\u308B\u3002\
    \n            let m = x.digits.len\n            if m <= 32:\n                return\
    \ divmodSchoolbook(basePower(2 * m), x).quotient\n            let half = (m +\
    \ 1) div 2 + 2\n            let low = m - half\n            let inverse = reciprocalAbs(shiftDigitsRight(x,\
    \ low))\n            let product = x * (inverse * inverse)\n            var correction\
    \ = shiftDigitsRight(product, 2 * half)\n            for i in 0..<min(2 * half,\
    \ product.digits.len):\n                if product.digits[i] != 0:\n         \
    \           correction = correction + initBigInt(1)\n                    break\n\
    \            # \u4E0A\u4F4D\u534A\u5206\u306B\u30AC\u30FC\u30C9 2 \u6841\u3092\
    \u52A0\u3048\u308B\u3053\u3068\u3067\u3001Newton \u66F4\u65B0\u306E\u8AA4\u5DEE\
    \u3092 1 \u672A\u6E80\u306B\u3059\u308B\u3002\n            # \u5207\u308A\u6368\
    \u3066\u5F8C\u306E\u8AA4\u5DEE\u306F 2 \u672A\u6E80\u3067\u4FDD\u3061\u3001\u53B3\
    \u5BC6\u5316\u306F\u6700\u5F8C\u306E\u5546\u306E\u88DC\u6B63\u306B\u307E\u3068\
    \u3081\u308B\u3002\n            result = shiftDigitsLeft(mulAbsSmall(inverse,\
    \ 2), low) - correction\n\n        proc quotientFromReciprocal(x, inverse: BigInt,\
    \ divisorLen, precision: int): BigInt =\n            ## \u4E0D\u8981\u306A\u88AB\
    \u9664\u6570\u306E\u4E0B\u4F4D\u6841\u3092\u843D\u3068\u3057\u3066\u5546\u3092\
    \u63A8\u5B9A\u3057\u3001\u4E0D\u8DB3\u3092\u9AD8\u3005 3 \u306B\u6291\u3048\u308B\
    \u3002\n            let cut = max(0, divisorLen - 1)\n            shiftDigitsRight(shiftDigitsRight(x,\
    \ cut) * inverse, divisorLen + precision - cut)\n\n        proc correctDivisionProduct(x,\
    \ y, quotient, product: BigInt): tuple[quotient, remainder: BigInt] =\n      \
    \      ## \u6B63\u306E\u6574\u6570\u306E\u63A8\u5B9A\u5546\u3092\u4E0B\u65B9 1\
    \ \u56DE\u30FB\u4E0A\u65B9 3 \u56DE\u307E\u3067\u88DC\u6B63\u3057\u3066\u5546\u3068\
    \u4F59\u308A\u3092\u78BA\u5B9A\u3059\u308B\u3002\n            result.quotient\
    \ = quotient\n            result.remainder = x - product\n            if result.remainder.sign\
    \ < 0:\n                result.quotient = result.quotient - initBigInt(1)\n  \
    \              result.remainder = result.remainder + y\n            for _ in 0..<3:\n\
    \                if cmpAbs(result.remainder, y) < 0:\n                    break\n\
    \                result.quotient = result.quotient + initBigInt(1)\n         \
    \       result.remainder = result.remainder - y\n\n        proc correctDivision(x,\
    \ y, quotient: BigInt): tuple[quotient, remainder: BigInt] =\n            ## \u63A8\
    \u5B9A\u5546\u3068\u9664\u6570\u306E\u7A4D\u304B\u3089\u5546\u3068\u4F59\u308A\
    \u3092\u78BA\u5B9A\u3059\u308B\u3002\n            correctDivisionProduct(x, y,\
    \ quotient, quotient * y)\n\n        proc divmodBlocks(x, y: BigInt): tuple[quotient,\
    \ remainder: BigInt] =\n            ## \u6B63\u306E\u6574\u6570\u306E\u88AB\u9664\
    \u6570\u3092\u9664\u6570\u3068\u540C\u3058\u6841\u6570\u306E\u30D6\u30ED\u30C3\
    \u30AF\u306B\u5206\u3051\u3001\u9006\u6570\u3092\u5171\u6709\u3057\u3066\u5272\
    \u308B\u3002\n            let n = x.digits.len\n            let m = y.digits.len\n\
    \            let inverse = reciprocalAbs(y)\n            var inverseMultiplier:\
    \ FixedBigIntMultiplier\n            defer: inverseMultiplier.close()\n      \
    \      var divisorMultiplier: FixedBigIntMultiplier\n            defer: divisorMultiplier.close()\n\
    \            if n >= 4 * m:\n                inverseMultiplier = initFixedMultiplier(inverse,\
    \ m + 1)\n                divisorMultiplier = initFixedMultiplier(y, m)\n    \
    \        result.quotient.sign = 1\n            result.quotient.digits = newSeq[uint32](n\
    \ - m + 1)\n            for blockIndex in countdown((n - 1) div m, 0):\n     \
    \           let offset = blockIndex * m\n                let width = min(m, n\
    \ - offset)\n                var dividend: BigInt\n                dividend.sign\
    \ = 1\n                dividend.digits = newSeq[uint32](width + result.remainder.digits.len)\n\
    \                for i in 0..<width:\n                    dividend.digits[i] =\
    \ x.digits[offset + i]\n                for i in 0..<result.remainder.digits.len:\n\
    \                    dividend.digits[width + i] = result.remainder.digits[i]\n\
    \                dividend.normalize()\n                if cmpAbs(dividend, y)\
    \ < 0:\n                    result.remainder = dividend\n                    continue\n\
    \                let quotient = shiftDigitsRight(mulFixed(\n                 \
    \   shiftDigitsRight(dividend, m - 1), inverse, inverseMultiplier), m + 1)\n \
    \               let division = correctDivisionProduct(dividend, y, quotient,\n\
    \                    mulFixed(quotient, y, divisorMultiplier))\n             \
    \   for i in 0..<division.quotient.digits.len:\n                    result.quotient.digits[offset\
    \ + i] = division.quotient.digits[i]\n                result.remainder = division.remainder\n\
    \            result.quotient.normalize()\n\n        proc divmodNewton(x, y: BigInt):\
    \ tuple[quotient, remainder: BigInt] =\n            ## \u6B63\u8CA0\u306E\u6574\
    \u6570\u306E\u5546\u3092\u5FC5\u8981\u306A\u7CBE\u5EA6\u306E\u9006\u6570\u304B\
    \u3089\u6C42\u3081\u3001\u5546\u3068\u4F59\u308A\u3092\u53B3\u5BC6\u306B\u88DC\
    \u6B63\u3059\u308B\u3002\n            let dividend = abs(x)\n            let divisor\
    \ = abs(y)\n            let n = dividend.digits.len\n            let m = divisor.digits.len\n\
    \            if n > 2 * m:\n                result = divmodBlocks(dividend, divisor)\n\
    \            else:\n                let cut = max(0, m - (n - m + 2))\n      \
    \          let divisorHigh = shiftDigitsRight(divisor, cut)\n                let\
    \ precision = max(m - cut, n - m)\n                let inverse = reciprocalAbs(shiftDigitsLeft(divisorHigh,\
    \ precision - (m - cut)))\n                let quotient = quotientFromReciprocal(shiftDigitsRight(dividend,\
    \ cut),\n                    inverse, m - cut, precision)\n                result\
    \ = correctDivision(dividend, divisor, quotient)\n            result.quotient.sign\
    \ *= x.sign * y.sign\n            result.remainder.sign *= x.sign\n\n    proc\
    \ divmod*(x, y: BigInt): tuple[quotient, remainder: BigInt] =\n        ## 0 \u65B9\
    \u5411\u306B\u4E38\u3081\u305F\u5546\u3068\u88AB\u9664\u6570\u3068\u540C\u7B26\
    \u53F7\u306E\u4F59\u308A\u3092\u8FD4\u3057\u30010 \u9664\u7B97\u306B\u306F DivByZeroDefect\
    \ \u3092\u9001\u51FA\u3059\u308B\u3002\n        when nimvm:\n            result\
    \ = divmodSchoolbook(x, y)\n        else:\n            when defined(cpp) and defined(amd64):\n\
    \                let n = x.digits.len\n                let m = y.digits.len\n\
    \                if min(m, n - m) > BigIntNewtonThreshold:\n                 \
    \   # \u30D6\u30ED\u30C3\u30AF\u9664\u7B97\u3067\u306F\u3001\u88AB\u9664\u6570\
    \u306E\u5168\u9577\u306B\u3088\u3089\u305A\u9664\u6570\u306E\u6841\u6570\u3067\
    \u5909\u63DB\u9577\u3092\u6291\u3048\u3089\u308C\u308B\u3002\n               \
    \     let productSize = if n > 2 * m: 2 * m + 8\n                        else:\
    \ max(n + 1, 2 * min(m, n - m + 2) + 8)\n                    if productSize <=\
    \ (BigIntNttMaxLength * 5) div 9:\n                        return divmodNewton(x,\
    \ y)\n            result = divmodSchoolbook(x, y)\n\n    proc `div`*(x, y: BigInt):\
    \ BigInt =\n        ## 0 \u65B9\u5411\u306B\u4E38\u3081\u305F\u5546\u3092\u8FD4\
    \u3059\u3002\n        divmod(x, y).quotient\n\n    proc `mod`*(x, y: BigInt):\
    \ BigInt =\n        ## \u88AB\u9664\u6570\u3068\u540C\u7B26\u53F7\u306E\u4F59\u308A\
    \u3092\u8FD4\u3059\u3002\n        divmod(x, y).remainder\n\n    proc `+=`*(x:\
    \ var BigInt, y: BigInt) =\n        ## \u53F3\u8FBA\u3092\u52A0\u3048\u308B\u3002\
    \n        x = x + y\n\n    proc `-=`*(x: var BigInt, y: BigInt) =\n        ##\
    \ \u53F3\u8FBA\u3092\u5F15\u304F\u3002\n        x = x - y\n\n    proc `*=`*(x:\
    \ var BigInt, y: BigInt) =\n        ## \u53F3\u8FBA\u3092\u639B\u3051\u308B\u3002\
    \n        x = x * y\n\n    proc `div=`*(x: var BigInt, y: BigInt) =\n        ##\
    \ \u53F3\u8FBA\u3067\u5272\u3063\u305F\u5546\u3092\u4EE3\u5165\u3059\u308B\u3002\
    \n        x = x div y\n\n    proc `mod=`*(x: var BigInt, y: BigInt) =\n      \
    \  ## \u53F3\u8FBA\u3067\u5272\u3063\u305F\u4F59\u308A\u3092\u4EE3\u5165\u3059\
    \u308B\u3002\n        x = x mod y\n\n    proc pow*(x: BigInt, exponent: int):\
    \ BigInt =\n        ## \u975E\u8CA0\u6574\u6570\u4E57\u3092\u7E70\u308A\u8FD4\u3057\
    \u4E8C\u4E57\u6CD5\u3067\u6C42\u3081\u3001\u8CA0\u306E\u6307\u6570\u306B\u306F\
    \ ValueError \u3092\u9001\u51FA\u3059\u308B\u30020^0 \u306F 1\u3002\n        if\
    \ exponent < 0:\n            raise newException(ValueError, \"\u591A\u500D\u9577\
    \u6574\u6570\u306E\u6307\u6570\u306F\u975E\u8CA0\u6574\u6570\u3067\u6307\u5B9A\
    \u3057\u3066\u304F\u3060\u3055\u3044\")\n        result = initBigInt(1)\n    \
    \    var base = x\n        var n = exponent\n        while n > 0:\n          \
    \  if (n and 1) != 0:\n                result *= base\n            n = n shr 1\n\
    \            if n > 0:\n                base *= base\n\n    proc gcd*(x, y: BigInt):\
    \ BigInt =\n        ## \u975E\u8CA0\u306E\u6700\u5927\u516C\u7D04\u6570\u3092\u8FD4\
    \u3059\u3002gcd(0, 0) \u306F 0\u3002\n        result = abs(x)\n        var y =\
    \ abs(y)\n        while not y.isZero:\n            let remainder = result mod\
    \ y\n            result = y\n            y = remainder\n\n    proc lcm*(x, y:\
    \ BigInt): BigInt =\n        ## \u975E\u8CA0\u306E\u6700\u5C0F\u516C\u500D\u6570\
    \u3092\u8FD4\u3059\u3002\u3044\u305A\u308C\u304B\u304C 0 \u306A\u3089 0\u3002\n\
    \        if x.isZero or y.isZero:\n            return\n        abs((x div gcd(x,\
    \ y)) * y)\n\n    proc toInt*(x: BigInt): int =\n        ## int \u306B\u5909\u63DB\
    \u3057\u3001\u7BC4\u56F2\u5916\u306A\u3089 OverflowDefect \u3092\u9001\u51FA\u3059\
    \u308B\u3002\n        let limit = uint64(high(int)) + uint64(ord(x.sign < 0))\n\
    \        var magnitude = 0'u64\n        for i in countdown(x.digits.len - 1, 0):\n\
    \            let digit = uint64(x.digits[i])\n            if magnitude > limit\
    \ div BigIntBase or\n                    (magnitude == limit div BigIntBase and\
    \ digit > limit mod BigIntBase):\n                raise newException(OverflowDefect,\
    \ \"\u591A\u500D\u9577\u6574\u6570\u304C int \u306E\u7BC4\u56F2\u5916\u3067\u3059\
    \")\n            magnitude = magnitude * BigIntBase + digit\n        if x.sign\
    \ < 0:\n            if magnitude == uint64(high(int)) + 1'u64:\n             \
    \   return low(int)\n            return -int(magnitude)\n        int(magnitude)\n\
    \n    proc hash*(x: BigInt): Hash =\n        ## \u591A\u500D\u9577\u6574\u6570\
    \u306E\u30CF\u30C3\u30B7\u30E5\u5024\u3092\u8FD4\u3059\u3002\n        result =\
    \ hashes.hash(x.sign)\n        for digit in x.digits:\n            result = result\
    \ !& hashes.hash(digit)\n        result = !$result\n"
  dependsOn:
  - cplib/math/inner_math.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/powmod.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/powmod.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inner_math.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  isVerificationFile: false
  path: cplib/math/bigint.nim
  requiredBy: []
  timestamp: '2026-09-08 11:13:22+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/bigint_unit_test.nim
  - verify/math/bigint_unit_test.nim
  - verify/math/division_of_big_integers_test.nim
  - verify/math/division_of_big_integers_test.nim
documentation_of: cplib/math/bigint.nim
layout: document
redirect_from:
- /library/cplib/math/bigint.nim
- /library/cplib/math/bigint.nim.html
title: cplib/math/bigint.nim
---
