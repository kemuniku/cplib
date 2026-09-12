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
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
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
    path: verify/AI/factoradic_signed_test.nim
    title: verify/AI/factoradic_signed_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/factoradic_signed_test.nim
    title: verify/AI/factoradic_signed_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/factoradic_test.nim
    title: verify/AI/factoradic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/factoradic_test.nim
    title: verify/AI/factoradic_test.nim
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
  code: "## \u7B26\u53F7\u4ED8\u304D\u968E\u4E57\u9032\u6570\u3002digits[i] \u306F\
    \u7D76\u5BFE\u5024\u306E i! \u306E\u4FC2\u6570\u3067\u30010 <= digits[i] <= i\u3002\
    \n## div\u30FBmod \u306F Nim \u3068\u540C\u3058 0 \u65B9\u5411\u3078\u306E\u9664\
    \u7B97\u3001//\u30FB%\u30FBdivmod \u306F Python \u3068\u540C\u3058\u5E8A\u9664\
    \u7B97\u3002\n## \u9806\u5217\u306F 0..<N \u306E\u4E26\u3079\u66FF\u3048\u3001\
    \u8F9E\u66F8\u9806\u306E\u9806\u4F4D\u306F 0 \u59CB\u307E\u308A\u3067\u6271\u3046\
    \u3002\n## \u4F7F\u7528\u4F8B: permutationRank(@[2, 0, 1]).toInt() == 4\u3001\n\
    ## initFactoradic(4).toPermutation(3) == @[2, 0, 1]\u3002\nwhen not declared CPLIB_MATH_FACTORADIC:\n\
    \    const CPLIB_MATH_FACTORADIC* = 1\n    import hashes\n    import cplib/math/bigint\n\
    \n    type Factoradic* = object\n        negative: bool\n        data: seq[int]\n\
    \n    proc normalize(self: var Factoradic) =\n        ## \u4E0A\u4F4D\u306E\u4E0D\
    \u8981\u306A 0 \u3092\u53D6\u308A\u9664\u304D\u30010 \u306E\u7B26\u53F7\u3092\u6B63\
    \u306B\u63C3\u3048\u308B\u3002O(\u6841\u6570)\u3002\n        while self.data.len\
    \ > 0 and self.data[^1] == 0:\n            self.data.setLen(self.data.len - 1)\n\
    \        if self.data.len == 0: self.negative = false\n\n    proc initFactoradic*(digits:\
    \ openArray[int], negative: bool = false): Factoradic =\n        ## \u7D76\u5BFE\
    \u5024\u306E\u4E0B\u4F4D\u6841\u304B\u3089\u4E26\u3079\u305F i! \u306E\u4FC2\u6570\
    \u3068\u7B26\u53F7\u3067\u69CB\u7BC9\u3059\u308B\u3002O(\u6841\u6570)\u3002\u7A7A\
    \u914D\u5217\u306F 0\u3002\n        for i, digit in digits:\n            doAssert\
    \ 0 <= digit and digit <= i, \"\u968E\u4E57\u9032\u6570\u306E\u6841\u304C\u7BC4\
    \u56F2\u5916\"\n        result.data = @digits\n        result.negative = negative\n\
    \        result.normalize()\n\n    proc initFactoradic*[T: SomeInteger](value:\
    \ T): Factoradic =\n        ## \u6574\u6570\u304B\u3089\u69CB\u7BC9\u3059\u308B\
    \u3002O(\u6841\u6570)\u3002\u7B26\u53F7\u4ED8\u304D\u6574\u6570\u306E\u6700\u5C0F\
    \u5024\u306B\u3082\u5BFE\u5FDC\u3059\u308B\u3002\n        var magnitude: uint64\n\
    \        when T is SomeSignedInt:\n            if value < 0:\n               \
    \ result.negative = true\n                magnitude = uint64(-(value + 1)) + 1'u64\n\
    \            else:\n                magnitude = uint64(value)\n        else:\n\
    \            magnitude = uint64(value)\n        var radix = 1'u64\n        while\
    \ magnitude > 0:\n            result.data.add(int(magnitude mod radix))\n    \
    \        magnitude = magnitude div radix\n            inc radix\n\n    proc abs*(self:\
    \ Factoradic): Factoradic =\n        ## \u7D76\u5BFE\u5024\u3092\u8FD4\u3059\u3002\
    \u6841\u914D\u5217\u306E\u30B3\u30D4\u30FC\u306B O(\u6841\u6570)\u3002\n     \
    \   result = self\n        result.negative = false\n\n    proc `-`*(self: Factoradic):\
    \ Factoradic =\n        ## \u7B26\u53F7\u3092\u53CD\u8EE2\u3059\u308B\u3002\u6841\
    \u914D\u5217\u306E\u30B3\u30D4\u30FC\u306B O(\u6841\u6570)\u30020 \u306F\u6B63\
    \u306E\u307E\u307E\u3002\n        result = self\n        if result.data.len >\
    \ 0: result.negative = not result.negative\n\n    proc `+`*(self: Factoradic):\
    \ Factoradic =\n        ## \u540C\u3058\u5024\u3092\u8FD4\u3059\u3002\u6841\u914D\
    \u5217\u306E\u30B3\u30D4\u30FC\u306B O(\u6841\u6570)\u3002\n        self\n\n \
    \   proc sgn*(self: Factoradic): int =\n        ## \u7B26\u53F7\u3092 -1\u3001\
    0\u30011 \u3067\u8FD4\u3059\u3002O(1)\u3002\n        if self.data.len == 0: 0\
    \ elif self.negative: -1 else: 1\n\n    const FactoradicConversionBlockSize =\
    \ 32\n\n    type FactoradicProductNode = object\n        first, last, left, right:\
    \ int\n        product: BigInt\n\n    proc buildFactoradicProducts(nodes: var\
    \ seq[FactoradicProductNode], first, last: int): int =\n        ## \u533A\u9593\
    \ [first, last) \u306E\u57FA\u6570 i+1 \u306E\u7A4D\u3092\u5206\u5272\u7D71\u6CBB\
    \u3067\u524D\u8A08\u7B97\u3059\u308B\u3002\n        var node = FactoradicProductNode(first:\
    \ first, last: last, left: -1, right: -1)\n        if last - first <= FactoradicConversionBlockSize:\n\
    \            node.product = initBigInt(1)\n            for i in first..<last:\
    \ node.product *= initBigInt(i + 1)\n        else:\n            let middle = first\
    \ + (last - first) div 2\n            node.left = buildFactoradicProducts(nodes,\
    \ first, middle)\n            node.right = buildFactoradicProducts(nodes, middle,\
    \ last)\n            node.product = nodes[node.left].product * nodes[node.right].product\n\
    \        result = nodes.len\n        nodes.add(node)\n\n    proc restoreFactoradicBlock(value:\
    \ BigInt, nodes: seq[FactoradicProductNode],\n            index: int, digits:\
    \ var seq[int]) =\n        ## \u533A\u9593\u306E\u7A4D\u3067\u5546\u3068\u4F59\
    \u308A\u306B\u5206\u3051\u3001\u6DF7\u5408\u57FA\u6570\u306E\u5404\u6841\u3092\
    \u5FA9\u5143\u3059\u308B\u3002\n        if value.isZero: return\n        let node\
    \ = nodes[index]\n        if node.left < 0:\n            var value = value\n \
    \           for i in node.first..<node.last:\n                if value.isZero:\
    \ break\n                let division = divmod(value, initBigInt(i + 1))\n   \
    \             digits[i] = division.remainder.toInt()\n                value =\
    \ division.quotient\n        else:\n            let division = divmod(value, nodes[node.left].product)\n\
    \            restoreFactoradicBlock(division.remainder, nodes, node.left, digits)\n\
    \            restoreFactoradicBlock(division.quotient, nodes, node.right, digits)\n\
    \n    proc initFactoradic*(value: BigInt): Factoradic =\n        ## \u591A\u500D\
    \u9577\u6574\u6570\u3092\u5909\u63DB\u3059\u308B\u3002\u9AD8\u901F\u4E57\u9664\
    \u7B97\u6642 O(M(B) log(N+1))\u3001B \u306F\u30D3\u30C3\u30C8\u9577\u3001N \u306F\
    \u6841\u6570\u3002\n        if initBigInt(low(int)) <= value and value <= initBigInt(high(int)):\n\
    \            return initFactoradic(value.toInt())\n        result.negative = value.sgn\
    \ < 0\n        let value = abs(value)\n        var nodes: seq[FactoradicProductNode]\n\
    \        var last = FactoradicConversionBlockSize + 1\n        var root = buildFactoradicProducts(nodes,\
    \ 1, last)\n        while nodes[root].product <= value:\n            let next\
    \ = 1 + 2 * (last - 1)\n            let right = buildFactoradicProducts(nodes,\
    \ last, next)\n            nodes.add(FactoradicProductNode(first: 1, last: next,\
    \ left: root, right: right,\n                product: nodes[root].product * nodes[right].product))\n\
    \            root = nodes.high\n            last = next\n        result.data =\
    \ newSeq[int](last)\n        restoreFactoradicBlock(value, nodes, root, result.data)\n\
    \        result.normalize()\n\n    proc factorialFactoradic*(n: int): Factoradic\
    \ =\n        ## N! \u3092\u968E\u4E57\u9032\u6570\u3067\u8FD4\u3059\u3002O(N+1)\
    \ \u6642\u9593\u30FB\u9818\u57DF\u30020! = 1\u3001\u8CA0\u306E N \u306F\u30A8\u30E9\
    \u30FC\u3002\n        doAssert n >= 0, \"\u968E\u4E57\u306E\u5F15\u6570\u306F\u975E\
    \u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308B\"\n        let index =\
    \ max(n, 1)\n        result.data = newSeq[int](index + 1)\n        result.data[index]\
    \ = 1\n\n    proc modFactorial*(self: Factoradic, k: int): Factoradic =\n    \
    \    ## k! \u3067\u5272\u3063\u305F\u975E\u8CA0\u306E\u4F59\u308A\u3092\u8FD4\u3059\
    \u3002\u975E\u8CA0\u306E\u5024\u306F O(min(\u6841\u6570,k)+1)\u3001\u8CA0\u306E\
    \u5024\u306F O(k+1)\u3002\u8CA0\u306E k \u306F\u30A8\u30E9\u30FC\u3002\n     \
    \   doAssert k >= 0, \"\u968E\u4E57\u306E\u5F15\u6570\u306F\u975E\u8CA0\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308B\"\n        let size = min(self.data.len,\
    \ k)\n        result.data = newSeq[int](size)\n        for i in 0..<size: result.data[i]\
    \ = self.data[i]\n        result.normalize()\n        if self.negative and result.data.len\
    \ > 0:\n            result.data.setLen(k)\n            var borrow = 0\n      \
    \      for i in 0..<k:\n                var digit = -result.data[i] - borrow\n\
    \                borrow = int(digit < 0)\n                if borrow > 0: digit\
    \ += i + 1\n                result.data[i] = digit\n            result.normalize()\n\
    \n    proc digits*(self: Factoradic): seq[int] =\n        ## \u7D76\u5BFE\u5024\
    \u306E\u4E0B\u4F4D\u6841\u304B\u3089\u4E26\u3079\u305F i! \u306E\u4FC2\u6570\u3092\
    \u8FD4\u3059\u30020 \u306F\u7A7A\u914D\u5217\u3002O(\u6841\u6570)\u3002\n    \
    \    result = newSeq[int](self.data.len)\n        for i, digit in self.data: result[i]\
    \ = digit\n\n    proc toInt*[T: SomeInteger](self: Factoradic, kind: typedesc[T]):\
    \ T =\n        ## \u6574\u6570\u578B T \u306B O(\u6841\u6570) \u3067\u5909\u63DB\
    \u3059\u308B\u3002T \u306E\u7BC4\u56F2\u5916\u3084\u8CA0\u6570\u306E\u7B26\u53F7\
    \u306A\u3057\u578B\u3078\u306E\u5909\u63DB\u306F\u30A8\u30E9\u30FC\u3002\n   \
    \     var value = 0'u64\n        var limit = uint64(high(T))\n        when T is\
    \ SomeSignedInt:\n            if self.negative: inc limit\n        else:\n   \
    \         doAssert not self.negative, \"\u8CA0\u6570\u306F\u7B26\u53F7\u306A\u3057\
    \u6574\u6570\u578B\u306B\u5909\u63DB\u3067\u304D\u306A\u3044\"\n        for i\
    \ in countdown(self.data.high, 1):\n            let digit = uint64(self.data[i])\n\
    \            doAssert digit <= limit, \"\u5909\u63DB\u5148\u306E\u6574\u6570\u578B\
    \u306E\u4E0A\u9650\u3092\u8D85\u3048\u3066\u3044\u308B\"\n            doAssert\
    \ value <= (limit - digit) div uint64(i + 1),\n                \"\u5909\u63DB\u5148\
    \u306E\u6574\u6570\u578B\u306E\u4E0A\u9650\u3092\u8D85\u3048\u3066\u3044\u308B\
    \"\n            value = value * uint64(i + 1) + digit\n        when T is SomeSignedInt:\n\
    \            if self.negative:\n                if value == limit: return low(T)\n\
    \                return -T(value)\n        result = T(value)\n\n    proc toInt*(self:\
    \ Factoradic): int =\n        ## int \u306B O(\u6841\u6570) \u3067\u5909\u63DB\
    \u3059\u308B\u3002int \u306E\u7BC4\u56F2\u5916\u306F\u30A8\u30E9\u30FC\u3002\n\
    \        self.toInt(int)\n\n    proc factoradicIntMagnitude(value: int): uint64\
    \ =\n        ## int \u306E\u7D76\u5BFE\u5024\u3092\u6700\u5C0F\u5024\u3082\u542B\
    \u3081\u3066 uint64 \u3067\u8FD4\u3059\u3002O(1)\u3002\n        if value < 0:\
    \ uint64(-(value + 1)) + 1'u64 else: uint64(value)\n\n    proc factoradicMulAddDivmod(a,\
    \ b, c, divisor: uint64): tuple[quotient, remainder: uint64] =\n        ## a*b+c\
    \ \u3092 128 \u30D3\u30C3\u30C8\u3067\u8A08\u7B97\u3057\u3066\u9664\u7B97\u3059\
    \u308B\u3002\u5546\u304C uint64 \u306B\u53CE\u307E\u308B\u5834\u5408\u306B\u4F7F\
    \u7528\u3059\u308B\u3002\n        var quotient, remainder: uint64\n        {.emit:\
    \ \"\"\"\n        {\n            unsigned __int128 value = (unsigned __int128)`a`\
    \ * `b` + `c`;\n            `quotient` = value / `divisor`;\n            `remainder`\
    \ = value % `divisor`;\n        }\n        \"\"\".}\n        (quotient, remainder)\n\
    \n    proc `mod`*(self: Factoradic, modulus: int): int =\n        ## Nim \u3068\
    \u540C\u3058\u88AB\u9664\u6570\u3068\u540C\u7B26\u53F7\u306E\u4F59\u308A\u3092\
    \ int \u3067\u8FD4\u3059\u3002O(\u6841\u6570+1) \u6642\u9593\u30FBO(1) \u9818\u57DF\
    \u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n        if modulus == 0:\n \
    \           raise newException(DivByZeroDefect, \"\u968E\u4E57\u9032\u6570\u306E\
    \ 0 \u9664\u7B97\")\n        let magnitude = factoradicIntMagnitude(modulus)\n\
    \        var remainder = 0'u64\n        for i in countdown(self.data.high, 1):\n\
    \            remainder = factoradicMulAddDivmod(remainder, uint64(i + 1),\n  \
    \              uint64(self.data[i]), magnitude).remainder\n        if self.negative:\
    \ -int(remainder) else: int(remainder)\n\n    proc `%`*(self: Factoradic, modulus:\
    \ int): int =\n        ## Python \u3068\u540C\u3058\u9664\u6570\u3068\u540C\u7B26\
    \u53F7\u306E\u4F59\u308A\u3092 int \u3067\u8FD4\u3059\u3002O(\u6841\u6570+1) \u6642\
    \u9593\u30FBO(1) \u9818\u57DF\u3002\n        let remainder = self mod modulus\n\
    \        if remainder != 0 and self.negative != (modulus < 0): remainder + modulus\
    \ else: remainder\n\n    proc factoradicBlockValue(digits: seq[int], first, last:\
    \ int): tuple[value, product: BigInt] =\n        ## \u5404\u533A\u9593\u306E\u5024\
    \u3068\u57FA\u6570\u306E\u7A4D\u3092\u8A08\u7B97\u3057\u3001\u4E0B\u4F4D\u306E\
    \u5024 + \u57FA\u6570\u306E\u7A4D * \u4E0A\u4F4D\u306E\u5024\u3067\u7D50\u5408\
    \u3059\u308B\u3002\n        if last - first <= FactoradicConversionBlockSize:\n\
    \            result.value = initBigInt(0)\n            result.product = initBigInt(1)\n\
    \            for i in countdown(last - 1, first):\n                result.value\
    \ = result.value * initBigInt(i + 1) + initBigInt(digits[i])\n               \
    \ result.product *= initBigInt(i + 1)\n        else:\n            let middle =\
    \ first + (last - first) div 2\n            let left = factoradicBlockValue(digits,\
    \ first, middle)\n            let right = factoradicBlockValue(digits, middle,\
    \ last)\n            result.value = left.value + left.product * right.value\n\
    \            result.product = left.product * right.product\n\n    proc toBigInt*(self:\
    \ Factoradic): BigInt =\n        ## \u591A\u500D\u9577\u6574\u6570\u306B\u5909\
    \u63DB\u3059\u308B\u3002\u9AD8\u901F\u4E57\u7B97\u6642 O(M(B) log(N+1))\u3001\
    B \u306F\u30D3\u30C3\u30C8\u9577\u3001N \u306F\u6841\u6570\u3002\n        if self.data.len\
    \ <= FactoradicConversionBlockSize + 1:\n            result = initBigInt(0)\n\
    \            for i in countdown(self.data.high, 1):\n                result =\
    \ result * initBigInt(i + 1) + initBigInt(self.data[i])\n        else:\n     \
    \       result = factoradicBlockValue(self.data, 1, self.data.len).value\n   \
    \     if self.negative: result = -result\n\n    proc `$`*(self: Factoradic): string\
    \ =\n        ## \u5024\u3092\u5341\u9032\u6574\u6570\u3068\u3057\u3066\u8868\u793A\
    \u3059\u308B\u3002\u7D44\u307F\u8FBC\u307F\u6574\u6570\u306E\u4E0A\u9650\u306B\
    \u5236\u9650\u3055\u308C\u306A\u3044\u3002\n        $self.toBigInt()\n\n    proc\
    \ factoradicCmpAbs(a, b: Factoradic): int =\n        ## \u7D76\u5BFE\u5024\u3092\
    \u6BD4\u8F03\u3059\u308B\u3002\u6841\u6570\u304C\u7570\u306A\u308C\u3070 O(1)\u3001\
    \u540C\u3058\u306A\u3089 O(\u6841\u6570)\u3002\n        result = cmp(a.data.len,\
    \ b.data.len)\n        if result != 0: return\n        for i in countdown(a.data.high,\
    \ 0):\n            result = cmp(a.data[i], b.data[i])\n            if result !=\
    \ 0: return\n\n    proc cmp*(a, b: Factoradic): int =\n        ## \u7B26\u53F7\
    \u4ED8\u304D\u306E\u5927\u5C0F\u3092\u6BD4\u8F03\u3059\u308B\u3002\u7B26\u53F7\
    \u3084\u6841\u6570\u304C\u7570\u306A\u308C\u3070 O(1)\u3001\u305D\u308C\u4EE5\u5916\
    \u306F O(\u6841\u6570)\u3002\n        if a.negative != b.negative:\n         \
    \   return if a.negative: -1 else: 1\n        result = factoradicCmpAbs(a, b)\n\
    \        if a.negative: result = -result\n\n    proc `<`*(a, b: Factoradic): bool\
    \ =\n        ## a \u304C b \u3088\u308A\u5C0F\u3055\u3044\u304B\u3092\u5224\u5B9A\
    \u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\n        cmp(a, b) < 0\n\n\
    \    proc `<=`*(a, b: Factoradic): bool =\n        ## a \u304C b \u4EE5\u4E0B\u304B\
    \u3092\u5224\u5B9A\u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\n      \
    \  cmp(a, b) <= 0\n\n    proc `>`*(a, b: Factoradic): bool =\n        ## a \u304C\
    \ b \u3088\u308A\u5927\u304D\u3044\u304B\u3092\u5224\u5B9A\u3059\u308B\u3002O(\u6700\
    \u5927\u6841\u6570)\u3002\n        cmp(a, b) > 0\n\n    proc `>=`*(a, b: Factoradic):\
    \ bool =\n        ## a \u304C b \u4EE5\u4E0A\u304B\u3092\u5224\u5B9A\u3059\u308B\
    \u3002O(\u6700\u5927\u6841\u6570)\u3002\n        cmp(a, b) >= 0\n\n    proc hash*(self:\
    \ Factoradic): Hash =\n        ## \u968E\u4E57\u9032\u6570\u306E\u30CF\u30C3\u30B7\
    \u30E5\u5024\u3092 O(\u6841\u6570) \u3067\u8FD4\u3059\u3002\n        !$ (hash(self.data)\
    \ !& hash(self.negative))\n\n    proc cmp*[T: SomeInteger](a: Factoradic, b: T):\
    \ int =\n        ## \u6574\u6570\u3068\u6BD4\u8F03\u3057\u3066 -1\u30010\u3001\
    1 \u3092\u8FD4\u3059\u3002O(\u6574\u6570 b \u306E\u968E\u4E57\u9032\u6570\u306E\
    \u6841\u6570+1)\u3002\n        cmp(a, initFactoradic(b))\n\n    proc cmp*[T: SomeInteger](a:\
    \ T, b: Factoradic): int =\n        ## \u6574\u6570\u304B\u3089\u898B\u305F\u5927\
    \u5C0F\u3092 -1\u30010\u30011 \u3067\u8FD4\u3059\u3002O(\u6574\u6570 a \u306E\u968E\
    \u4E57\u9032\u6570\u306E\u6841\u6570+1)\u3002\n        -cmp(b, a)\n\n    proc\
    \ `<`*[T: SomeInteger](a: Factoradic, b: T): bool =\n        ## \u968E\u4E57\u9032\
    \u6570\u3068\u6574\u6570\u3092\u6BD4\u8F03\u3059\u308B\u3002\u8CA0\u306E\u6574\
    \u6570\u306B\u3082\u5BFE\u5FDC\u3059\u308B\u3002\n        cmp(a, b) < 0\n\n  \
    \  proc `<`*[T: SomeInteger](a: T, b: Factoradic): bool =\n        ## \u968E\u4E57\
    \u9032\u6570\u3068\u6574\u6570\u3092\u6BD4\u8F03\u3059\u308B\u3002\u8CA0\u306E\
    \u6574\u6570\u306B\u3082\u5BFE\u5FDC\u3059\u308B\u3002\n        cmp(a, b) < 0\n\
    \n    proc `<=`*[T: SomeInteger](a: Factoradic, b: T): bool =\n        ## \u968E\
    \u4E57\u9032\u6570\u3068\u6574\u6570\u3092\u6BD4\u8F03\u3059\u308B\u3002\u8CA0\
    \u306E\u6574\u6570\u306B\u3082\u5BFE\u5FDC\u3059\u308B\u3002\n        cmp(a, b)\
    \ <= 0\n\n    proc `<=`*[T: SomeInteger](a: T, b: Factoradic): bool =\n      \
    \  ## \u968E\u4E57\u9032\u6570\u3068\u6574\u6570\u3092\u6BD4\u8F03\u3059\u308B\
    \u3002\u8CA0\u306E\u6574\u6570\u306B\u3082\u5BFE\u5FDC\u3059\u308B\u3002\n   \
    \     cmp(a, b) <= 0\n\n    proc `>`*[T: SomeInteger](a: Factoradic, b: T): bool\
    \ =\n        ## \u968E\u4E57\u9032\u6570\u3068\u6574\u6570\u3092\u6BD4\u8F03\u3059\
    \u308B\u3002\u8CA0\u306E\u6574\u6570\u306B\u3082\u5BFE\u5FDC\u3059\u308B\u3002\
    \n        cmp(a, b) > 0\n\n    proc `>`*[T: SomeInteger](a: T, b: Factoradic):\
    \ bool =\n        ## \u968E\u4E57\u9032\u6570\u3068\u6574\u6570\u3092\u6BD4\u8F03\
    \u3059\u308B\u3002\u8CA0\u306E\u6574\u6570\u306B\u3082\u5BFE\u5FDC\u3059\u308B\
    \u3002\n        cmp(a, b) > 0\n\n    proc `>=`*[T: SomeInteger](a: Factoradic,\
    \ b: T): bool =\n        ## \u968E\u4E57\u9032\u6570\u3068\u6574\u6570\u3092\u6BD4\
    \u8F03\u3059\u308B\u3002\u8CA0\u306E\u6574\u6570\u306B\u3082\u5BFE\u5FDC\u3059\
    \u308B\u3002\n        cmp(a, b) >= 0\n\n    proc `>=`*[T: SomeInteger](a: T, b:\
    \ Factoradic): bool =\n        ## \u968E\u4E57\u9032\u6570\u3068\u6574\u6570\u3092\
    \u6BD4\u8F03\u3059\u308B\u3002\u8CA0\u306E\u6574\u6570\u306B\u3082\u5BFE\u5FDC\
    \u3059\u308B\u3002\n        cmp(a, b) >= 0\n\n    proc `==`*[T: SomeInteger](a:\
    \ Factoradic, b: T): bool =\n        ## \u968E\u4E57\u9032\u6570\u3068\u6574\u6570\
    \u3092\u6BD4\u8F03\u3059\u308B\u3002\u8CA0\u306E\u6574\u6570\u306B\u3082\u5BFE\
    \u5FDC\u3059\u308B\u3002\n        cmp(a, b) == 0\n\n    proc `==`*[T: SomeInteger](a:\
    \ T, b: Factoradic): bool =\n        ## \u968E\u4E57\u9032\u6570\u3068\u6574\u6570\
    \u3092\u6BD4\u8F03\u3059\u308B\u3002\u8CA0\u306E\u6574\u6570\u306B\u3082\u5BFE\
    \u5FDC\u3059\u308B\u3002\n        cmp(a, b) == 0\n\n    proc factoradicAddAbs(a,\
    \ b: Factoradic): Factoradic =\n        ## \u7D76\u5BFE\u5024\u540C\u58EB\u3092\
    \u52A0\u7B97\u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\n        let size\
    \ = max(a.data.len, b.data.len)\n        result.data = newSeq[int](size)\n   \
    \     var carry = 0\n        for i in 0..<size:\n            var digit = carry\n\
    \            if i < a.data.len: digit += a.data[i]\n            if i < b.data.len:\
    \ digit += b.data[i]\n            result.data[i] = digit mod (i + 1)\n       \
    \     carry = digit div (i + 1)\n        if carry > 0: result.data.add(carry)\n\
    \n    proc factoradicSubAbs(a, b: Factoradic): Factoradic =\n        ## |a| >=\
    \ |b| \u306E\u7D76\u5BFE\u5024\u540C\u58EB\u3092\u6E1B\u7B97\u3059\u308B\u3002\
    O(\u6700\u5927\u6841\u6570)\u3002\n        let size = max(a.data.len, b.data.len)\n\
    \        result.data = newSeq[int](size)\n        var borrow = 0\n        for\
    \ i in 0..<size:\n            var digit = -borrow\n            if i < a.data.len:\
    \ digit += a.data[i]\n            if i < b.data.len: digit -= b.data[i]\n    \
    \        borrow = int(digit < 0)\n            if borrow > 0: digit += i + 1\n\
    \            result.data[i] = digit\n        doAssert borrow == 0, \"\u968E\u4E57\
    \u9032\u6570\u306E\u6E1B\u7B97\u7D50\u679C\u304C\u8CA0\u306B\u306A\u3063\u3066\
    \u3044\u308B\"\n        result.normalize()\n\n    proc `+`*(a, b: Factoradic):\
    \ Factoradic =\n        ## \u7B26\u53F7\u4ED8\u304D\u306E\u968E\u4E57\u9032\u6570\
    \u540C\u58EB\u3092\u52A0\u7B97\u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\
    \n        if a.negative == b.negative:\n            result = factoradicAddAbs(a,\
    \ b)\n            result.negative = a.negative and result.data.len > 0\n     \
    \   elif factoradicCmpAbs(a, b) >= 0:\n            result = factoradicSubAbs(a,\
    \ b)\n            result.negative = a.negative and result.data.len > 0\n     \
    \   else:\n            result = factoradicSubAbs(b, a)\n            result.negative\
    \ = b.negative and result.data.len > 0\n\n    proc `-`*(a, b: Factoradic): Factoradic\
    \ =\n        ## \u7B26\u53F7\u4ED8\u304D\u306E\u968E\u4E57\u9032\u6570\u540C\u58EB\
    \u3092\u6E1B\u7B97\u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\n      \
    \  a + (-b)\n\n    proc `+=`*(a: var Factoradic, b: Factoradic) =\n        ##\
    \ \u968E\u4E57\u9032\u6570\u3092\u52A0\u7B97\u3057\u3066\u4EE3\u5165\u3059\u308B\
    \u3002O(\u6700\u5927\u6841\u6570)\u3002\n        a = a + b\n\n    proc `-=`*(a:\
    \ var Factoradic, b: Factoradic) =\n        ## \u968E\u4E57\u9032\u6570\u3092\u6E1B\
    \u7B97\u3057\u3066\u4EE3\u5165\u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\
    \n        a = a - b\n\n    proc `+`*[T: SomeInteger](a: Factoradic, b: T): Factoradic\
    \ =\n        ## \u6574\u6570\u3092\u52A0\u7B97\u3059\u308B\u3002O(\u6700\u5927\
    \u6841\u6570)\u3002\n        a + initFactoradic(b)\n\n    proc `+`*[T: SomeInteger](a:\
    \ T, b: Factoradic): Factoradic =\n        ## \u6574\u6570\u306B\u968E\u4E57\u9032\
    \u6570\u3092\u52A0\u7B97\u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\n\
    \        b + a\n\n    proc `-`*[T: SomeInteger](a: Factoradic, b: T): Factoradic\
    \ =\n        ## \u6574\u6570\u3092\u6E1B\u7B97\u3059\u308B\u3002O(\u6700\u5927\
    \u6841\u6570)\u3002\n        a - initFactoradic(b)\n\n    proc `-`*[T: SomeInteger](a:\
    \ T, b: Factoradic): Factoradic =\n        ## \u6574\u6570\u304B\u3089\u968E\u4E57\
    \u9032\u6570\u3092\u6E1B\u7B97\u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\
    \n        initFactoradic(a) - b\n\n    proc `+=`*[T: SomeInteger](a: var Factoradic,\
    \ b: T) =\n        ## \u6574\u6570\u3092\u52A0\u7B97\u3057\u3066\u4EE3\u5165\u3059\
    \u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\n        a = a + b\n\n    proc `-=`*[T:\
    \ SomeInteger](a: var Factoradic, b: T) =\n        ## \u6574\u6570\u3092\u6E1B\
    \u7B97\u3057\u3066\u4EE3\u5165\u3059\u308B\u3002O(\u6700\u5927\u6841\u6570)\u3002\
    \n        a = a - b\n\n    proc `*`*(a: Factoradic, b: int): Factoradic\n    \
    \    ## \u6574\u6570\u3068\u306E\u7DDA\u5F62\u6642\u9593\u306E\u4E57\u7B97\u3092\
    \u524D\u65B9\u5BA3\u8A00\u3059\u308B\u3002\n\n    proc divmodTrunc(a: Factoradic,\
    \ b: int): tuple[quotient: Factoradic, remainder: int]\n        ## \u6574\u6570\
    \u3068\u306E 0 \u65B9\u5411\u3078\u306E\u9664\u7B97\u3092\u524D\u65B9\u5BA3\u8A00\
    \u3059\u308B\u3002\n\n    proc divmod*(a: Factoradic, b: int): tuple[quotient:\
    \ Factoradic, remainder: int]\n        ## \u6574\u6570\u3068\u306E\u7DDA\u5F62\
    \u6642\u9593\u306E\u9664\u7B97\u3092\u524D\u65B9\u5BA3\u8A00\u3059\u308B\u3002\
    \n\n    proc `*`*(a, b: Factoradic): Factoradic =\n        ## \u9AD8\u901F\u4E57\
    \u7B97\u6642\u306F\u5909\u63DB\u8FBC\u307F\u3067 O(M(B) log(N+1))\u3002\u7247\u65B9\
    \u304C int \u306B\u53CE\u307E\u308C\u3070\u7DDA\u5F62\u6642\u9593\u3002\n    \
    \    if a.data.len == 0 or b.data.len == 0: return\n        if low(int) <= a and\
    \ a <= high(int): return b * a.toInt()\n        if low(int) <= b and b <= high(int):\
    \ return a * b.toInt()\n        initFactoradic(a.toBigInt() * b.toBigInt())\n\n\
    \    proc divmod*(a, b: Factoradic): tuple[quotient, remainder: Factoradic] =\n\
    \        ## Python \u3068\u540C\u3058\u5E8A\u9664\u7B97\u306E\u5546\u3068\u4F59\
    \u308A\u3092\u8FD4\u3059\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n   \
    \     if b.data.len == 0:\n            raise newException(DivByZeroDefect, \"\u968E\
    \u4E57\u9032\u6570\u306E 0 \u9664\u7B97\")\n        if low(int) <= b and b <=\
    \ high(int):\n            let division = divmod(a, b.toInt())\n            return\
    \ (division.quotient, initFactoradic(division.remainder))\n        let order =\
    \ factoradicCmpAbs(a, b)\n        if order < 0:\n            if a.data.len > 0\
    \ and a.negative != b.negative:\n                return (initFactoradic(-1), a\
    \ + b)\n            return (default(Factoradic), a)\n        if order == 0:\n\
    \            return (initFactoradic(if a.negative != b.negative: -1 else: 1),\
    \ default(Factoradic))\n        let division = divmod(a.toBigInt(), b.toBigInt())\n\
    \        result.quotient = initFactoradic(division.quotient)\n        result.remainder\
    \ = initFactoradic(division.remainder)\n\n    proc `div`*(a, b: Factoradic): Factoradic\
    \ =\n        ## Nim \u3068\u540C\u3058 0 \u65B9\u5411\u306B\u4E38\u3081\u305F\u5546\
    \u3092\u8FD4\u3059\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n        if\
    \ b.data.len == 0:\n            raise newException(DivByZeroDefect, \"\u968E\u4E57\
    \u9032\u6570\u306E 0 \u9664\u7B97\")\n        if low(int) <= b and b <= high(int):\
    \ return divmodTrunc(a, b.toInt()).quotient\n        let order = factoradicCmpAbs(a,\
    \ b)\n        if order < 0:\n            return\n        if order == 0: return\
    \ initFactoradic(if a.negative != b.negative: -1 else: 1)\n        initFactoradic(a.toBigInt()\
    \ div b.toBigInt())\n\n    proc `mod`*(a, b: Factoradic): Factoradic =\n     \
    \   ## Nim \u3068\u540C\u3058\u88AB\u9664\u6570\u3068\u540C\u7B26\u53F7\u306E\u4F59\
    \u308A\u3092\u8FD4\u3059\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n   \
    \     if b.data.len == 0:\n            raise newException(DivByZeroDefect, \"\u968E\
    \u4E57\u9032\u6570\u306E 0 \u9664\u7B97\")\n        if low(int) <= b and b <=\
    \ high(int): return initFactoradic(a mod b.toInt())\n        let order = factoradicCmpAbs(a,\
    \ b)\n        if order < 0:\n            return a\n        if order == 0: return\n\
    \        initFactoradic(a.toBigInt() mod b.toBigInt())\n\n    proc `//`*(a, b:\
    \ Factoradic): Factoradic =\n        ## Python \u3068\u540C\u3058\u5E8A\u9664\u7B97\
    \u306E\u5546\u3092\u8FD4\u3059\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\
    \n        if b.data.len == 0:\n            raise newException(DivByZeroDefect,\
    \ \"\u968E\u4E57\u9032\u6570\u306E 0 \u9664\u7B97\")\n        if low(int) <= b\
    \ and b <= high(int): return divmod(a, b.toInt()).quotient\n        let order\
    \ = factoradicCmpAbs(a, b)\n        if order < 0:\n            return initFactoradic(if\
    \ a.data.len > 0 and a.negative != b.negative: -1 else: 0)\n        if order ==\
    \ 0: return initFactoradic(if a.negative != b.negative: -1 else: 1)\n        initFactoradic(a.toBigInt()\
    \ // b.toBigInt())\n\n    proc `%`*(a, b: Factoradic): Factoradic =\n        ##\
    \ Python \u3068\u540C\u3058\u9664\u6570\u3068\u540C\u7B26\u53F7\u306E\u4F59\u308A\
    \u3092\u8FD4\u3059\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n        if\
    \ b.data.len == 0:\n            raise newException(DivByZeroDefect, \"\u968E\u4E57\
    \u9032\u6570\u306E 0 \u9664\u7B97\")\n        if low(int) <= b and b <= high(int):\
    \ return initFactoradic(a % b.toInt())\n        let order = factoradicCmpAbs(a,\
    \ b)\n        if order < 0:\n            if a.data.len > 0 and a.negative != b.negative:\
    \ return a + b\n            return a\n        if order == 0: return\n        initFactoradic(a.toBigInt()\
    \ % b.toBigInt())\n\n    proc `*=`*(a: var Factoradic, b: Factoradic) =\n    \
    \    ## \u968E\u4E57\u9032\u6570\u3092\u639B\u3051\u3066\u4EE3\u5165\u3059\u308B\
    \u3002\n        a = a * b\n\n    proc `div=`*(a: var Factoradic, b: Factoradic)\
    \ =\n        ## \u968E\u4E57\u9032\u6570\u3067\u5272\u3063\u305F\u5546\u3092\u4EE3\
    \u5165\u3059\u308B\u30020 \u9664\u7B97\u306B\u306F DivByZeroDefect \u3092\u9001\
    \u51FA\u3059\u308B\u3002\n        a = a div b\n\n    proc `mod=`*(a: var Factoradic,\
    \ b: Factoradic) =\n        ## \u968E\u4E57\u9032\u6570\u3067\u5272\u3063\u305F\
    \u4F59\u308A\u3092\u4EE3\u5165\u3059\u308B\u30020 \u9664\u7B97\u306B\u306F DivByZeroDefect\
    \ \u3092\u9001\u51FA\u3059\u308B\u3002\n        a = a mod b\n\n    proc `*`*(a:\
    \ Factoradic, b: int): Factoradic =\n        ## \u7B26\u53F7\u4ED8\u304D\u6574\
    \u6570\u3092\u639B\u3051\u308B\u3002O(\u7D50\u679C\u306E\u6841\u6570+1) \u6642\
    \u9593\u30FB\u9818\u57DF\u3002\n        if b == 0 or a.data.len == 0: return\n\
    \        result.negative = a.negative != (b < 0)\n        let magnitude = factoradicIntMagnitude(b)\n\
    \        result.data = newSeq[int](a.data.len)\n        var carry = 0'u64\n  \
    \      for i, digit in a.data:\n            let division = factoradicMulAddDivmod(uint64(digit),\
    \ magnitude, carry, uint64(i + 1))\n            result.data[i] = int(division.remainder)\n\
    \            carry = division.quotient\n        while carry > 0:\n           \
    \ let radix = uint64(result.data.len + 1)\n            result.data.add(int(carry\
    \ mod radix))\n            carry = carry div radix\n\n    proc `*`*(a: int, b:\
    \ Factoradic): Factoradic =\n        ## \u7B26\u53F7\u4ED8\u304D\u6574\u6570\u306B\
    \u968E\u4E57\u9032\u6570\u3092\u639B\u3051\u308B\u3002O(\u7D50\u679C\u306E\u6841\
    \u6570+1)\u3002\n        b * a\n\n    proc divmodTrunc(a: Factoradic, b: int):\
    \ tuple[quotient: Factoradic, remainder: int] =\n        ## Nim \u3068\u540C\u3058\
    \u5546\u3068 int \u306E\u4F59\u308A\u3092 O(\u5165\u529B\u306E\u6841\u6570+1)\
    \ \u6642\u9593\u30FB\u9818\u57DF\u3067\u8FD4\u3059\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\
    \n        if b == 0:\n            raise newException(DivByZeroDefect, \"\u968E\
    \u4E57\u9032\u6570\u306E 0 \u9664\u7B97\")\n        result.quotient.data = newSeq[int](a.data.len)\n\
    \        let magnitude = factoradicIntMagnitude(b)\n        var remainder = 0'u64\n\
    \        for i in countdown(a.data.high, 1):\n            let division = factoradicMulAddDivmod(remainder,\
    \ uint64(i + 1), uint64(a.data[i]), magnitude)\n            result.quotient.data[i]\
    \ = int(division.quotient)\n            remainder = division.remainder\n     \
    \   result.quotient.normalize()\n        if a.negative != (b < 0):\n         \
    \   result.quotient = -result.quotient\n        result.remainder = if a.negative:\
    \ -int(remainder) else: int(remainder)\n\n    proc divmod*(a: Factoradic, b: int):\
    \ tuple[quotient: Factoradic, remainder: int] =\n        ## Python \u3068\u540C\
    \u3058\u5546\u3068 int \u306E\u4F59\u308A\u3092 O(\u5165\u529B\u306E\u6841\u6570\
    +1) \u6642\u9593\u30FB\u9818\u57DF\u3067\u8FD4\u3059\u30020 \u9664\u7B97\u306F\
    \ DivByZeroDefect\u3002\n        result = divmodTrunc(a, b)\n        if result.remainder\
    \ != 0 and a.negative != (b < 0):\n            result.quotient -= 1\n        \
    \    result.remainder += b\n\n    proc divmod*(a: int, b: Factoradic): tuple[quotient,\
    \ remainder: Factoradic] =\n        ## \u6574\u6570\u3092\u968E\u4E57\u9032\u6570\
    \u3067\u5E8A\u9664\u7B97\u3059\u308B\u3002\u7570\u7B26\u53F7\u306E\u4F59\u308A\
    \u306E\u69CB\u7BC9\u306B\u306F O(b \u306E\u6841\u6570) \u304C\u5FC5\u8981\u3002\
    0 \u9664\u7B97\u306F DivByZeroDefect\u3002\n        divmod(initFactoradic(a),\
    \ b)\n\n    proc `div`*(a: Factoradic, b: int): Factoradic =\n        ## \u6574\
    \u6570\u3067\u5272\u3063\u3066 0 \u65B9\u5411\u306B\u4E38\u3081\u305F\u5546\u3092\
    \ O(\u5165\u529B\u306E\u6841\u6570+1) \u6642\u9593\u30FB\u9818\u57DF\u3067\u8FD4\
    \u3059\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n        divmodTrunc(a,\
    \ b).quotient\n\n    proc `div`*(a: int, b: Factoradic): Factoradic =\n      \
    \  ## \u6574\u6570\u3092\u968E\u4E57\u9032\u6570\u3067\u5272\u3063\u3066 0 \u65B9\
    \u5411\u306B\u4E38\u3081\u305F\u5546\u3092\u8FD4\u3059\u3002O(a \u306E\u968E\u4E57\
    \u9032\u6570\u306E\u6841\u6570+1)\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\
    \n        initFactoradic(a) div b\n\n    proc `mod`*(a: int, b: Factoradic): Factoradic\
    \ =\n        ## \u6574\u6570\u3092\u968E\u4E57\u9032\u6570\u3067\u5272\u3063\u305F\
    \u4F59\u308A\u3092\u8FD4\u3059\u3002Nim \u3068\u540C\u3058\u88AB\u9664\u6570\u3068\
    \u540C\u7B26\u53F7\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n        initFactoradic(a)\
    \ mod b\n\n    proc `//`*(a: Factoradic, b: int): Factoradic =\n        ## \u6574\
    \u6570\u3067\u5E8A\u9664\u7B97\u3057\u305F\u5546\u3092 O(\u5165\u529B\u306E\u6841\
    \u6570+1) \u6642\u9593\u30FB\u9818\u57DF\u3067\u8FD4\u3059\u30020 \u9664\u7B97\
    \u306F DivByZeroDefect\u3002\n        divmod(a, b).quotient\n\n    proc `//`*(a:\
    \ int, b: Factoradic): Factoradic =\n        ## \u6574\u6570\u3092\u968E\u4E57\
    \u9032\u6570\u3067\u5E8A\u9664\u7B97\u3057\u305F\u5546\u3092\u8FD4\u3059\u3002\
    O(a \u306E\u968E\u4E57\u9032\u6570\u306E\u6841\u6570+1)\u30020 \u9664\u7B97\u306F\
    \ DivByZeroDefect\u3002\n        initFactoradic(a) // b\n\n    proc `%`*(a: int,\
    \ b: Factoradic): Factoradic =\n        ## \u6574\u6570\u3092\u968E\u4E57\u9032\
    \u6570\u3067\u5272\u3063\u305F\u4F59\u308A\u3092\u8FD4\u3059\u3002\u7570\u7B26\
    \u53F7\u306E\u5834\u5408\u306F O(b \u306E\u6841\u6570)\u30020 \u9664\u7B97\u306F\
    \ DivByZeroDefect\u3002\n        divmod(a, b).remainder\n\n    proc `*=`*(a: var\
    \ Factoradic, b: int) =\n        ## \u7B26\u53F7\u4ED8\u304D\u6574\u6570\u3092\
    \u639B\u3051\u3066\u4EE3\u5165\u3059\u308B\u3002\n        a = a * b\n\n    proc\
    \ `div=`*(a: var Factoradic, b: int) =\n        ## \u6574\u6570\u3067\u5272\u3063\
    \u3066 0 \u65B9\u5411\u306B\u4E38\u3081\u305F\u5546\u3092\u4EE3\u5165\u3059\u308B\
    \u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n        a = a div b\n\n    proc\
    \ `mod=`*(a: var Factoradic, b: int) =\n        ## \u6574\u6570\u3067\u5272\u3063\
    \u305F\u4F59\u308A\u3092\u968E\u4E57\u9032\u6570\u3068\u3057\u3066\u4EE3\u5165\
    \u3059\u308B\u30020 \u9664\u7B97\u306F DivByZeroDefect\u3002\n        a = initFactoradic(a\
    \ mod b)\n\n    proc initFactoradicCounts(n: int): seq[int] =\n        ## \u5404\
    \u8981\u7D20\u306E\u500B\u6570\u304C 1 \u306E Fenwick tree \u3092 O(N) \u3067\u69CB\
    \u7BC9\u3059\u308B\u3002\n        result = newSeq[int](n + 1)\n        for i in\
    \ 1..n: result[i] = i and -i\n\n    proc removeFactoradicValue(counts: var seq[int],\
    \ value: int) =\n        ## \u6307\u5B9A\u3057\u305F\u8981\u7D20\u3092 Fenwick\
    \ tree \u304B\u3089\u53D6\u308A\u9664\u304F\u3002O(log N)\u3002\n        var i\
    \ = value + 1\n        while i < counts.len:\n            dec counts[i]\n    \
    \        i += i and -i\n\n    proc permutationRank*(permutation: openArray[int]):\
    \ Factoradic =\n        ## 0..<N \u306E\u9806\u5217\u306E\u8F9E\u66F8\u9806\u9806\
    \u4F4D\u3092\u968E\u4E57\u9032\u6570\u3067\u8FD4\u3059\u3002O(N log N) \u6642\u9593\
    \u30FBO(N) \u9818\u57DF\u3002\n        let n = permutation.len\n        var counts\
    \ = initFactoradicCounts(n)\n        var used = newSeq[bool](n)\n        result.data\
    \ = newSeq[int](n)\n        for i, value in permutation:\n            doAssert\
    \ 0 <= value and value < n, \"\u9806\u5217\u306E\u8981\u7D20\u304C\u7BC4\u56F2\
    \u5916\"\n            doAssert not used[value], \"\u9806\u5217\u306E\u8981\u7D20\
    \u304C\u91CD\u8907\u3057\u3066\u3044\u308B\"\n            used[value] = true\n\
    \            var j = value\n            while j > 0:\n                result.data[n\
    \ - 1 - i] += counts[j]\n                j -= j and -j\n            counts.removeFactoradicValue(value)\n\
    \        result.normalize()\n\n    proc toPermutation*(self: Factoradic, n: int):\
    \ seq[int] =\n        ## \u8F9E\u66F8\u9806\u3067 self \u756A\u76EE\u306E 0..<N\
    \ \u306E\u9806\u5217\u3092\u5FA9\u5143\u3059\u308B\u3002O(N log N) \u6642\u9593\
    \u30FBO(N) \u9818\u57DF\u3002\n        ## N < 0 \u307E\u305F\u306F self >= N!\
    \ \u306F\u30A8\u30E9\u30FC\u3002N = 0 \u306E\u9806\u4F4D 0 \u306F\u7A7A\u9806\u5217\
    \u3002\n        doAssert n >= 0, \"\u9806\u5217\u306E\u9577\u3055\u306F\u975E\u8CA0\
    \u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308B\"\n        doAssert not self.negative,\
    \ \"\u9806\u5217\u306E\u9806\u4F4D\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308B\"\n        doAssert self.data.len <= n, \"\u9806\u4F4D\u304C\
    \u9806\u5217\u306E\u500B\u6570\u4EE5\u4E0A\u306B\u306A\u3063\u3066\u3044\u308B\
    \"\n        var counts = initFactoradicCounts(n)\n        result = newSeq[int](n)\n\
    \        var step = 1\n        while step <= n div 2: step *= 2\n        for i\
    \ in 0..<n:\n            let digitIndex = n - 1 - i\n            var rank = if\
    \ digitIndex < self.data.len: self.data[digitIndex] else: 0\n            var value\
    \ = 0\n            var width = step\n            while width > 0:\n          \
    \      let next = value + width\n                if next <= n and counts[next]\
    \ <= rank:\n                    rank -= counts[next]\n                    value\
    \ = next\n                width = width shr 1\n            result[i] = value\n\
    \            counts.removeFactoradicValue(value)\n"
  dependsOn:
  - cplib/convolution/convolution.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/bigint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/powmod.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/inner_math.nim
  - cplib/math/bigint.nim
  - cplib/math/isqrt.nim
  - cplib/math/inner_math.nim
  isVerificationFile: false
  path: cplib/math/factoradic.nim
  requiredBy: []
  timestamp: '2026-09-12 15:00:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/factoradic_test.nim
  - verify/AI/factoradic_test.nim
  - verify/AI/factoradic_signed_test.nim
  - verify/AI/factoradic_signed_test.nim
documentation_of: cplib/math/factoradic.nim
layout: document
redirect_from:
- /library/cplib/math/factoradic.nim
- /library/cplib/math/factoradic.nim.html
title: cplib/math/factoradic.nim
---
