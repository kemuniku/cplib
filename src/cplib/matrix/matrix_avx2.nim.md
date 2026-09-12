---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/field_matrix_ops.nim
    title: cplib/matrix/field_matrix_ops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_field_impl.nim
    title: cplib/matrix/matrix_avx2_field_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_field_impl.nim
    title: cplib/matrix/matrix_avx2_field_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_kernel.nim
    title: cplib/matrix/matrix_avx2_kernel.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_kernel.nim
    title: cplib/matrix/matrix_avx2_kernel.nim
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
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/field_algorithms_unit.nim
    title: verify/matrix/linear_algebra/field_algorithms_unit.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/field_algorithms_unit.nim
    title: verify/matrix/linear_algebra/field_algorithms_unit.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/judge_driver.nim
    title: verify/matrix/linear_algebra/judge_driver.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/judge_driver.nim
    title: verify/matrix/linear_algebra/judge_driver.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_gc_test.nim
    title: verify/matrix/matrix_avx2_gc_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_gc_test.nim
    title: verify/matrix/matrix_avx2_gc_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_test.nim
    title: verify/matrix/matrix_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_test.nim
    title: verify/matrix/matrix_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_unit_test.nim
    title: verify/matrix/matrix_avx2_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_unit_test.nim
    title: verify/matrix/matrix_avx2_unit_test.nim
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
  code: "import hashes\nimport cplib/modint/modint\n\nwhen not declared CPLIB_MATRIX_MATRIX_AVX2:\n\
    \    const CPLIB_MATRIX_MATRIX_AVX2* = 1\n    import cplib/matrix/matrix_avx2_kernel\n\
    \    export matrixProductKernel, matrixProductMontgomeryKernel, matrixJoinValues,\
    \ matrixConvertValues, matrixWriteRow\n\n    proc matrixProduct*(a, b: openArray[uint32],\
    \ n, m, k: int,\n            modulus: uint32 = 998244353u32): seq[uint32] =\n\
    \        ## \u884C\u512A\u5148\u306E\u4E00\u6B21\u5143\u914D\u5217\u306E\u884C\
    \u5217\u7A4D\u3092AVX2\u3067\u8A08\u7B97\u3059\u308B\u3002\n        doAssert modulus\
    \ > 0 and modulus < (1u32 shl 30) and\n            (modulus and 1u32) == 1, \"\
    modulus must be odd and in [1, 2^30)\"\n        doAssert n >= 0 and m >= 0 and\
    \ k >= 0, \"negative matrix dimension\"\n        doAssert n <= high(cint).int\
    \ and m <= high(cint).int and\n            k <= high(cint).int, \"matrix dimension\
    \ exceeds int32\"\n        doAssert n == 0 or m <= high(int) div n, \"matrix size\
    \ overflow\"\n        doAssert m == 0 or k <= high(int) div m, \"matrix size overflow\"\
    \n        doAssert n == 0 or k <= high(int) div n, \"matrix size overflow\"\n\
    \        doAssert a.len == n * m and b.len == m * k, \"matrix size mismatch\"\n\
    \        for value in a:\n            assert value < modulus, \"matrix entries\
    \ must be less than modulus\"\n        for value in b:\n            assert value\
    \ < modulus, \"matrix entries must be less than modulus\"\n        result = newSeq[uint32](n\
    \ * k)\n        if n == 0 or m == 0 or k == 0 or modulus == 1:\n            return\n\
    \        matrixProductKernel(unsafeAddr a[0], unsafeAddr b[0], addr result[0],\n\
    \            n.cint, m.cint, k.cint, modulus)\n\n    proc matrixProduct*(a, b:\
    \ openArray[seq[uint32]],\n            modulus: uint32 = 998244353u32): seq[seq[uint32]]\
    \ =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\u306E\u884C\u5217\u7A4D\u3092AVX2\u3067\
    \u8A08\u7B97\u3059\u308B\u3002\n        let n = a.len\n        let m = if n ==\
    \ 0: 0 else: a[0].len\n        let k = if b.len == 0: 0 else: b[0].len\n     \
    \   doAssert m == b.len, \"matrix size mismatch\"\n        for row in a:\n   \
    \         doAssert row.len == m, \"ragged matrix\"\n        for row in b:\n  \
    \          doAssert row.len == k, \"ragged matrix\"\n        doAssert n == 0 or\
    \ m <= high(int) div n, \"matrix size overflow\"\n        doAssert m == 0 or k\
    \ <= high(int) div m, \"matrix size overflow\"\n        var flatA = newSeq[uint32](n\
    \ * m)\n        var flatB = newSeq[uint32](m * k)\n        for i in 0 ..< n:\n\
    \            if m > 0:\n                copyMem(addr flatA[i * m], unsafeAddr\
    \ a[i][0], m * sizeof(uint32))\n        for i in 0 ..< m:\n            if k >\
    \ 0:\n                copyMem(addr flatB[i * k], unsafeAddr b[i][0], k * sizeof(uint32))\n\
    \        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)\n        result\
    \ = newSeq[seq[uint32]](n)\n        for i in 0 ..< n:\n            result[i] =\
    \ newSeq[uint32](k)\n            if k > 0:\n                copyMem(addr result[i][0],\
    \ unsafeAddr flatC[i * k], k * sizeof(uint32))\n\n\n    type MatrixRowStorage[T]\
    \ = ref object\n        values: seq[T]\n\n    when defined(gcDestructors):\n \
    \       type MatrixStorage[T] = MatrixRowStorage[T]\n    else:\n        # refc\u3067\
    \u306F\u6A19\u6E96\u306Eseq\u30B3\u30D4\u30FC\u3092\u4F7F\u3044\u3001\u72EC\u81EA\
    =copy\u306B\u3088\u308BGC\u30EB\u30FC\u30C8\u767B\u9332\u6B20\u843D\u3092\u907F\
    \u3051\u308B\u3002\n        type MatrixStorage[T] = object\n            values:\
    \ seq[T]\n\n    type\n        Matrix*[T] = object\n            ## refc\u306E\u4EE3\
    \u5165\u306F\u6A19\u6E96seq\u3068\u540C\u3058\u3002\u884C\u30D3\u30E5\u30FC\u304B\
    \u3089\u3082\u72EC\u7ACB\u3055\u305B\u308B\u5834\u5408\u306Fclone\u3092\u4F7F\u3046\
    \u3002\n            storage: MatrixStorage[T]\n            height, width: int\n\
    \            modulus: uint32\n        MatrixRow*[T] = object\n            storage:\
    \ MatrixRowStorage[T]\n            offset, length: int\n        MutableMatrixRow*[T]\
    \ = object\n            storage: MatrixRowStorage[T]\n            offset, length:\
    \ int\n\n    when defined(gcDestructors):\n        proc `=copy`[T](destination:\
    \ var Matrix[T], source: Matrix[T]) =\n            ## \u884C\u30D3\u30E5\u30FC\
    \u306F\u8A18\u61B6\u57DF\u3092\u5171\u6709\u3057\u3001\u884C\u5217\u305D\u306E\
    \u3082\u306E\u306E\u4EE3\u5165\u306F\u5024\u3092\u30B3\u30D4\u30FC\u3059\u308B\
    \u3002\n            destination.height = source.height\n            destination.width\
    \ = source.width\n            destination.modulus = source.modulus\n         \
    \   if destination.storage == source.storage:\n                return\n      \
    \      if source.storage.isNil:\n                destination.storage = nil\n \
    \           else:\n                var storage = MatrixStorage[T](values: newSeq[T](source.storage.values.len))\n\
    \                for i, value in source.storage.values:\n                    storage.values[i]\
    \ = value\n                destination.storage = storage\n\n    proc rowStorage[T](a:\
    \ Matrix[T]): MatrixRowStorage[T] {.inline.} =\n        ## \u884C\u30D3\u30E5\u30FC\
    \u306E\u5BFF\u547D\u4E2D\u3001\u5143\u306E\u9023\u7D9A\u914D\u5217\u3092\u5171\
    \u6709\u3057\u3066\u4FDD\u6301\u3059\u308B\u3002O(1)\u3002\n        when defined(gcDestructors):\n\
    \            result = a.storage\n        else:\n            new(result)\n    \
    \        shallowCopy(result.values, a.storage.values)\n\n    proc matrixModulus[T]():\
    \ uint32 {.inline.} =\n        ## \u5229\u7528\u53EF\u80FD\u306Amodint\u578B\u3068\
    \u6CD5\u3092\u691C\u67FB\u3059\u308B\u3002\n        when T isnot MontgomeryModint\
    \ and T isnot BarrettModint:\n            {.error: \"matrix_avx2.Matrix requires\
    \ MontgomeryModint or BarrettModint\".}\n        static:\n            doAssert\
    \ sizeof(T) == sizeof(uint32)\n            doAssert alignof(T) == alignof(uint32)\n\
    \        result = T.umod.uint32\n        doAssert result > 0 and result < (1u32\
    \ shl 30) and (result and 1) == 1,\n            \"modulus must be odd and in [1,\
    \ 2^30)\"\n\n    proc matrixSize(h, w: int): int {.inline.} =\n        ## \u5BF8\
    \u6CD5\u3068\u9023\u7D9A\u914D\u5217\u306E\u8981\u7D20\u6570\u3092\u691C\u67FB\
    \u3059\u308B\u3002\n        doAssert h >= 0 and w >= 0 and h <= high(cint).int\
    \ and w <= high(cint).int,\n            \"invalid matrix dimensions\"\n      \
    \  doAssert h == 0 or w <= (high(int) div sizeof(uint32)) div h,\n           \
    \ \"matrix size overflow\"\n        h * w\n\n    proc checkModulus[T](a: Matrix[T])\
    \ {.inline.} =\n        ## dynamic modint\u306E\u6CD5\u304C\u884C\u5217\u4F5C\u6210\
    \u5F8C\u306B\u5909\u66F4\u3055\u308C\u3066\u3044\u306A\u3044\u3053\u3068\u3092\
    \u78BA\u8A8D\u3059\u308B\u3002\n        let modulus = matrixModulus[T]()\n   \
    \     doAssert a.modulus == 0 or a.modulus == modulus, \"matrix modulus has changed\"\
    \n\n    proc scalar[T](value: T or SomeInteger): T {.inline.} =\n        ## \u6574\
    \u6570\u3092\u6B63\u898F\u5316\u3057\u3066\u304B\u3089modint\u3078\u5909\u63DB\
    \u3059\u308B\u3002\n        when value is T:\n            value\n        elif\
    \ value is SomeUnsignedInt:\n            T.init((value.uint64 mod T.umod.uint64).int)\n\
    \        else:\n            T.init((value.int64 mod T.umod.int64).int)\n\n   \
    \ proc initMatrix*[T](h, w: int, value: T): Matrix[T] =\n        ## h\u884Cw\u5217\
    \u306E\u9023\u7D9A\u914D\u5217\u3092\u78BA\u4FDD\u3057\u3001\u5168\u8981\u7D20\
    \u3092\u6307\u5B9A\u3057\u305F\u5024\u3067\u521D\u671F\u5316\u3059\u308B\u3002\
    \n        let modulus = matrixModulus[T]()\n        let size = matrixSize(h, w)\n\
    \        result = Matrix[T](height: h, width: w, modulus: modulus,\n         \
    \   storage: MatrixStorage[T](values: newSeq[T](size)))\n        let v = scalar[T](value)\n\
    \        for x in result.storage.values.mitems:\n            x = v\n\n    proc\
    \ initMatrix*[T](h, w: int, value: SomeInteger): Matrix[T] =\n        ## \u6574\
    \u6570\u3092\u6CD5\u3067\u6B63\u898F\u5316\u3057\u3066\u5168\u8981\u7D20\u3092\
    \u521D\u671F\u5316\u3059\u308B\u3002\n        bind initMatrix\n        discard\
    \ matrixModulus[T]()\n        initMatrix[T](h, w, scalar[T](value))\n\n    proc\
    \ initMatrix*[T](h, w: int): Matrix[T] =\n        ## h\u884Cw\u5217\u306E\u96F6\
    \u884C\u5217\u3092\u4F5C\u308B\u3002\n        let modulus = matrixModulus[T]()\n\
    \        let size = matrixSize(h, w)\n        Matrix[T](height: h, width: w, modulus:\
    \ modulus,\n            storage: MatrixStorage[T](values: newSeq[T](size)))\n\n\
    \    proc initMatrix*[T](h, w: int, values: sink seq[T]): Matrix[T] =\n      \
    \  ## \u884C\u512A\u5148\u306E\u914D\u5217\u3092\u884C\u5217\u3078\u79FB\u3057\
    \u3001\u4E0D\u8981\u306A\u8981\u7D20\u30B3\u30D4\u30FC\u3092\u907F\u3051\u308B\
    \u3002\n        let modulus = matrixModulus[T]()\n        doAssert values.len\
    \ == matrixSize(h, w), \"matrix size mismatch\"\n        result = Matrix[T](height:\
    \ h, width: w, modulus: modulus,\n            storage: MatrixStorage[T](values:\
    \ values))\n\n    proc initMatrix*[T](h, w: int, values: openArray[uint32]): Matrix[T]\
    \ =\n        ## \u6B63\u898F\u5316\u6E08\u307F\u306E\u516C\u958B\u5024\u304B\u3089\
    modint\u306E\u9023\u7D9A\u884C\u5217\u3092\u4F5C\u308B\u3002\n        result =\
    \ initMatrix[T](h, w)\n        doAssert values.len == result.storage.values.len,\
    \ \"matrix size mismatch\"\n        for value in values:\n            assert value\
    \ < result.modulus, \"matrix entries must be less than modulus\"\n        if values.len\
    \ > 0:\n            matrixConvertValues(unsafeAddr values[0],\n              \
    \  cast[ptr uint32](addr result.storage.values[0]), values.len,\n            \
    \    result.modulus, T is MontgomeryModint)\n\n    proc initMatrixOwned[T](h,\
    \ w: int, values: var seq[uint32]): Matrix[T] =\n        ## \u6240\u6709\u6A29\
    \u3092\u6301\u3064\u516C\u958B\u5024\u914D\u5217\u3092\u6D88\u8CBB\u3057\u3001\
    \u540C\u3058\u9818\u57DF\u3092modint\u914D\u5217\u3068\u3057\u3066\u4F7F\u3046\
    \u3002\n        let modulus = matrixModulus[T]()\n        doAssert values.len\
    \ == matrixSize(h, w), \"matrix size mismatch\"\n        for value in values:\n\
    \            assert value < modulus, \"matrix entries must be less than modulus\"\
    \n        result = Matrix[T](height: h, width: w, modulus: modulus,\n        \
    \    storage: MatrixStorage[T]())\n        # \u4E21modint\u306F\u53C2\u7167\u3092\
    \u542B\u307E\u306A\u3044uint32\u30D5\u30A3\u30FC\u30EB\u30C91\u500B\u3002\u578B\
    \u3092\u5408\u308F\u305B\u3066\u304B\u3089move\u3059\u308B\u3002\n        result.storage.values\
    \ = move(cast[ptr seq[T]](addr values)[])\n        when T is MontgomeryModint:\n\
    \            if result.storage.values.len > 0:\n                let data = cast[ptr\
    \ uint32](addr result.storage.values[0])\n                matrixConvertValues(data,\
    \ data, result.storage.values.len, modulus, true)\n\n    template initMatrix*[T](h,\
    \ w: int, values: seq[uint32]): untyped =\n        ## \u4E00\u6642\u914D\u5217\
    \u306F\u30B3\u30D4\u30FC\u305B\u305A\u53D6\u308A\u8FBC\u307F\u3001\u518D\u5229\
    \u7528\u3059\u308B\u914D\u5217\u306F\u901A\u5E38\u306E\u5024\u30B3\u30D4\u30FC\
    \u3067\u4FDD\u8B77\u3059\u308B\u3002\n        block:\n            let rows = h\n\
    \            let columns = w\n            var owned: seq[uint32] = values\n  \
    \          initMatrixOwned[T](rows, columns, owned)\n\n    proc initMatrix*[T](values:\
    \ openArray[seq[T]]): Matrix[T] =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\u3092\
    \u9023\u7D9A\u914D\u7F6E\u306E\u884C\u5217\u3078\u30B3\u30D4\u30FC\u3059\u308B\
    \u3002\n        let h = values.len\n        let w = if h == 0: 0 else: values[0].len\n\
    \        result = initMatrix[T](h, w)\n        for i, row in values:\n       \
    \     doAssert row.len == w, \"ragged matrix\"\n            for j, value in row:\n\
    \                result.storage.values[i * w + j] = value\n\n    proc clone*[T](a:\
    \ Matrix[T]): Matrix[T] =\n        ## \u884C\u30D3\u30E5\u30FC\u3084let\u4EE3\u5165\
    \u306E\u5171\u6709\u306B\u3088\u3089\u306A\u3044\u72EC\u7ACB\u3057\u305F\u884C\
    \u5217\u3092\u4F5C\u308B\u3002O(h*w)\u3002\n        checkModulus(a)\n        result\
    \ = initMatrix[T](a.height, a.width)\n        for i in 0 ..< a.height * a.width:\n\
    \            result.storage.values[i] = a.storage.values[i]\n\n    proc toMatrix*[T](values:\
    \ openArray[seq[T]]): Matrix[T] =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\u3092\
    \u884C\u5217\u3078\u5909\u63DB\u3059\u308B\u3002\n        bind initMatrix\n  \
    \      initMatrix(values)\n\n    proc initMatrix*[T](values: openArray[T], vertical:\
    \ bool = false): Matrix[T] =\n        ## \u4E00\u6B21\u5143\u914D\u5217\u3092\
    1\u884C\u307E\u305F\u306F1\u5217\u306E\u884C\u5217\u3078\u5909\u63DB\u3059\u308B\
    \u3002\n        bind initMatrix\n        let h = if vertical: values.len else:\
    \ 1\n        let w = if vertical: 1 else: values.len\n        initMatrix[T](h,\
    \ w, @values)\n\n    proc h*[T](a: Matrix[T]): int {.inline.} =\n        ## \u884C\
    \u6570\u3092\u8FD4\u3059\u3002\n        a.height\n    proc w*[T](a: Matrix[T]):\
    \ int {.inline.} =\n        ## \u5217\u6570\u3092\u8FD4\u3059\u3002\u884C\u6570\
    0\u306E\u5834\u5408\u3082\u5217\u6570\u3092\u4FDD\u6301\u3059\u308B\u3002\n  \
    \      a.width\n\n    template checkIndex(index, size: int) =\n        ## \u901A\
    \u5E38\u306E\u914D\u5217\u3068\u540C\u3058\u30B3\u30F3\u30D1\u30A4\u30EB\u8A2D\
    \u5B9A\u3067\u6DFB\u5B57\u3092\u691C\u67FB\u3059\u308B\u3002\n        when compileOption(\"\
    boundChecks\"):\n            if index < 0 or index >= size:\n                raise\
    \ newException(IndexDefect, \"matrix index out of bounds\")\n\n    proc `[]`*[T](a:\
    \ Matrix[T], r, c: int): T {.inline.} =\n        ## \u6307\u5B9A\u3057\u305F\u8981\
    \u7D20\u3092\u8AAD\u307F\u53D6\u308B\u3002\n        checkIndex(r, a.height)\n\
    \        checkIndex(c, a.width)\n        a.storage.values[r * a.width + c]\n \
    \   proc `[]`*[T](a: var Matrix[T], r, c: int): var T {.inline.} =\n        ##\
    \ \u6307\u5B9A\u3057\u305F\u8981\u7D20\u3078\u306E\u5909\u66F4\u53EF\u80FD\u306A\
    \u53C2\u7167\u3092\u8FD4\u3059\u3002\n        checkIndex(r, a.height)\n      \
    \  checkIndex(c, a.width)\n        a.storage.values[r * a.width + c]\n    proc\
    \ `[]=`*[T](a: var Matrix[T], r, c: int, value: T or SomeInteger) {.inline.} =\n\
    \        ## \u6307\u5B9A\u3057\u305F\u8981\u7D20\u3078\u4EE3\u5165\u3059\u308B\
    \u3002\n        checkIndex(r, a.height)\n        checkIndex(c, a.width)\n    \
    \    a.storage.values[r * a.width + c] = scalar[T](value)\n\n    proc `[]`*[T](a:\
    \ Matrix[T], r: int): MatrixRow[T] {.inline.} =\n        ## \u884C\u3092\u30B3\
    \u30D4\u30FC\u305B\u305A\u8AAD\u307F\u53D6\u308A\u5C02\u7528\u30D3\u30E5\u30FC\
    \u3068\u3057\u3066\u8FD4\u3059\u3002\n        checkIndex(r, a.height)\n      \
    \  MatrixRow[T](storage: rowStorage(a), offset: r * a.width, length: a.width)\n\
    \    proc `[]`*[T](a: var Matrix[T], r: int): MutableMatrixRow[T] {.inline.} =\n\
    \        ## \u5143\u306E\u884C\u5217\u3092\u66F8\u304D\u63DB\u3048\u3089\u308C\
    \u308B\u884C\u30D3\u30E5\u30FC\u3092\u8FD4\u3059\u3002\n        checkIndex(r,\
    \ a.height)\n        MutableMatrixRow[T](storage: rowStorage(a), offset: r * a.width,\
    \ length: a.width)\n    proc `[]`*[T](row: MatrixRow[T], column: int): T {.inline.}\
    \ =\n        ## \u884C\u30D3\u30E5\u30FC\u306E\u8981\u7D20\u3092\u8AAD\u307F\u53D6\
    \u308B\u3002\n        checkIndex(column, row.length)\n        row.storage.values[row.offset\
    \ + column]\n    proc `[]`*[T](row: MutableMatrixRow[T], column: int): var T {.inline.}\
    \ =\n        ## \u884C\u30D3\u30E5\u30FC\u304B\u3089\u5143\u306E\u8981\u7D20\u3078\
    \u306E\u53C2\u7167\u3092\u8FD4\u3059\u3002\n        checkIndex(column, row.length)\n\
    \        row.storage.values[row.offset + column]\n    proc `[]=`*[T](row: MutableMatrixRow[T],\
    \ column: int, value: T or SomeInteger) {.inline.} =\n        ## \u884C\u30D3\u30E5\
    \u30FC\u3092\u901A\u3057\u3066\u5143\u306E\u884C\u5217\u3078\u4EE3\u5165\u3059\
    \u308B\u3002\n        checkIndex(column, row.length)\n        row.storage.values[row.offset\
    \ + column] = scalar[T](value)\n    proc len*[T](row: MatrixRow[T] or MutableMatrixRow[T]):\
    \ int {.inline.} =\n        ## \u884C\u30D3\u30E5\u30FC\u306E\u5217\u6570\u3092\
    \u8FD4\u3059\u3002\n        row.length\n    iterator items*[T](row: MatrixRow[T]\
    \ or MutableMatrixRow[T]): T =\n        ## \u884C\u306E\u8981\u7D20\u3092\u5DE6\
    \u304B\u3089\u9806\u306B\u5217\u6319\u3059\u308B\u3002\n        for i in 0 ..<\
    \ row.length:\n            yield row.storage.values[row.offset + i]\n    iterator\
    \ pairs*[T](row: MatrixRow[T] or MutableMatrixRow[T]): (int, T) =\n        ##\
    \ \u884C\u306E\u5217\u756A\u53F7\u3068\u8981\u7D20\u3092\u5217\u6319\u3059\u308B\
    \u3002\n        for i in 0 ..< row.length:\n            yield (i, row.storage.values[row.offset\
    \ + i])\n    iterator mitems*[T](row: MutableMatrixRow[T]): var T =\n        ##\
    \ \u884C\u306E\u5404\u8981\u7D20\u3092\u5909\u66F4\u53EF\u80FD\u306A\u53C2\u7167\
    \u3068\u3057\u3066\u5217\u6319\u3059\u308B\u3002\n        for i in 0 ..< row.length:\n\
    \            yield row.storage.values[row.offset + i]\n    proc toSeq*[T](row:\
    \ MatrixRow[T] or MutableMatrixRow[T]): seq[T] =\n        ## \u884C\u30D3\u30E5\
    \u30FC\u3092\u72EC\u7ACB\u3057\u305F\u914D\u5217\u3078\u30B3\u30D4\u30FC\u3059\
    \u308B\u3002\n        result = newSeq[T](row.length)\n        for i in 0 ..< row.length:\n\
    \            result[i] = row.storage.values[row.offset + i]\n    proc join*[T](row:\
    \ MatrixRow[T] or MutableMatrixRow[T], sep: string = \"\"): string =\n       \
    \ ## \u884C\u306E\u5024\u3092\u6307\u5B9A\u3057\u305F\u533A\u5207\u308A\u6587\u5B57\
    \u3067\u9023\u7D50\u3059\u308B\u3002\n        if row.length == 0: return \"\"\n\
    \        let modulus = matrixModulus[T]()\n        let values = cast[ptr uint32](unsafeAddr\
    \ row.storage.values[row.offset])\n        matrixJoinValues(values, row.length,\
    \ modulus, T is MontgomeryModint, sep)\n    proc writeRow*[T](row: MatrixRow[T]\
    \ or MutableMatrixRow[T], output: File = stdout) =\n        ## \u884C\u3092\u7A7A\
    \u767D\u533A\u5207\u308A\u3068\u6539\u884C\u3067\u51FA\u529B\u3057\u3001\u4E00\
    \u6642\u6587\u5B57\u5217\u306E\u78BA\u4FDD\u3092\u907F\u3051\u308B\u3002\n   \
    \     let modulus = matrixModulus[T]()\n        let values = if row.length ==\
    \ 0: nil else:\n            cast[ptr uint32](unsafeAddr row.storage.values[row.offset])\n\
    \        matrixWriteRow(values, row.length, modulus, T is MontgomeryModint, output)\n\
    \    proc `[]=`*[T](a: var Matrix[T], r: int, row: openArray[T]) =\n        ##\
    \ \u5217\u6570\u3092\u4FDD\u3063\u305F\u307E\u307E\u884C\u306E\u5168\u8981\u7D20\
    \u3092\u7F6E\u304D\u63DB\u3048\u308B\u3002\n        checkIndex(r, a.height)\n\
    \        doAssert row.len == a.width, \"matrix row size mismatch\"\n        for\
    \ j, value in row:\n            a.storage.values[r * a.width + j] = value\n  \
    \  proc `[]=`*[T](a: var Matrix[T], r: int, row: MatrixRow[T] or MutableMatrixRow[T])\
    \ =\n        ## \u5225\u306E\u884C\u30D3\u30E5\u30FC\u306E\u5185\u5BB9\u3092\u6307\
    \u5B9A\u3057\u305F\u884C\u3078\u30B3\u30D4\u30FC\u3059\u308B\u3002\n        checkIndex(r,\
    \ a.height)\n        doAssert row.len == a.width, \"matrix row size mismatch\"\
    \n        for j in 0 ..< row.len:\n            a.storage.values[r * a.width +\
    \ j] = row[j]\n\n    proc `*`*[T](a, b: Matrix[T]): Matrix[T] =\n        ## \u9023\
    \u7D9A\u914D\u7F6E\u3055\u308C\u305Fmodint\u3092\u76F4\u63A5AVX2\u30AB\u30FC\u30CD\
    \u30EB\u3078\u6E21\u3057\u3066\u4E57\u7B97\u3059\u308B\u3002\n        checkModulus(a)\n\
    \        checkModulus(b)\n        doAssert a.width == b.height, \"matrix size\
    \ mismatch\"\n        result = initMatrix[T](a.height, b.width)\n        if a.height\
    \ == 0 or a.width == 0 or b.width == 0 or result.modulus == 1:\n            return\n\
    \        let ap = cast[ptr uint32](unsafeAddr a.storage.values[0])\n        let\
    \ bp = cast[ptr uint32](unsafeAddr b.storage.values[0])\n        let cp = cast[ptr\
    \ uint32](addr result.storage.values[0])\n        when T is MontgomeryModint:\n\
    \            matrixProductMontgomeryKernel(ap, bp, cp, a.height.cint,\n      \
    \          a.width.cint, b.width.cint, result.modulus)\n        else:\n      \
    \      matrixProductKernel(ap, bp, cp, a.height.cint,\n                a.width.cint,\
    \ b.width.cint, result.modulus)\n    proc `*=`*[T](a: var Matrix[T], b: Matrix[T])\
    \ =\n        ## \u4F59\u5206\u306A\u5DE6\u884C\u5217\u306E\u30B3\u30D4\u30FC\u3092\
    \u4F5C\u3089\u305A\u306B\u7A4D\u3067\u7F6E\u304D\u63DB\u3048\u308B\u3002\n   \
    \     var product = a * b\n        swap(a, product)\n    proc matrixProduct*[T](a,\
    \ b: Matrix[T]): Matrix[T] =\n        ## \u95A2\u6570\u5F62\u5F0F\u3067\u9AD8\u901F\
    \u884C\u5217\u306E\u7A4D\u3092\u6C42\u3081\u308B\u3002\n        a * b\n\n    template\
    \ defineAssignment(assign, op: untyped) =\n        ## \u52A0\u6E1B\u7B97\u3068\
    \u5BFE\u5FDC\u3059\u308B\u4EE3\u5165\u6F14\u7B97\u5B50\u3092\u307E\u3068\u3081\
    \u3066\u5B9A\u7FA9\u3059\u308B\u3002\n        proc assign*[T](a: var Matrix[T],\
    \ b: Matrix[T]) =\n            ## \u540C\u3058\u5F62\u72B6\u306E\u884C\u5217\u3069\
    \u3046\u3057\u3092\u6210\u5206\u3054\u3068\u306B\u6F14\u7B97\u3059\u308B\u3002\
    \n            checkModulus(a)\n            checkModulus(b)\n            doAssert\
    \ a.h == b.h and a.w == b.w, \"matrix size mismatch\"\n            for i in 0\
    \ ..< a.h * a.w:\n                assign(a.storage.values[i], b.storage.values[i])\n\
    \        proc assign*[T](a: var Matrix[T], value: T or SomeInteger) =\n      \
    \      ## \u5168\u8981\u7D20\u3068\u30B9\u30AB\u30E9\u30FC\u3092\u6210\u5206\u3054\
    \u3068\u306B\u6F14\u7B97\u3059\u308B\u3002\n            checkModulus(a)\n    \
    \        let v = scalar[T](value)\n            for i in 0 ..< a.h * a.w:\n   \
    \             assign(a.storage.values[i], v)\n        proc op*[T](a, b: Matrix[T]):\
    \ Matrix[T] =\n            ## \u540C\u3058\u5F62\u72B6\u306E\u884C\u5217\u306E\
    \u6F14\u7B97\u7D50\u679C\u3092\u65B0\u3057\u3044\u884C\u5217\u306B\u8FD4\u3059\
    \u3002\n            result = a\n            assign(result, b)\n        proc op*[T](a:\
    \ Matrix[T], value: T or SomeInteger): Matrix[T] =\n            ## \u5404\u8981\
    \u7D20\u3068\u30B9\u30AB\u30E9\u30FC\u306E\u6F14\u7B97\u7D50\u679C\u3092\u65B0\
    \u3057\u3044\u884C\u5217\u306B\u8FD4\u3059\u3002\n            result = a\n   \
    \         assign(result, value)\n    defineAssignment(`+=`, `+`)\n    defineAssignment(`-=`,\
    \ `-`)\n\n    proc `-`*[T](a: Matrix[T]): Matrix[T] =\n        ## \u5404\u8981\
    \u7D20\u306E\u52A0\u6CD5\u9006\u5143\u3092\u6C42\u3081\u308B\u3002\n        result\
    \ = initMatrix[T](a.h, a.w)\n        result -= a\n    proc `+`*[T](value: T, a:\
    \ Matrix[T]): Matrix[T] =\n        ## \u30B9\u30AB\u30E9\u30FC\u3068\u884C\u5217\
    \u306E\u5404\u8981\u7D20\u3092\u52A0\u7B97\u3059\u308B\u3002\n        a + value\n\
    \    proc `-`*[T](value: T, a: Matrix[T]): Matrix[T] =\n        ## \u30B9\u30AB\
    \u30E9\u30FC\u304B\u3089\u884C\u5217\u306E\u5404\u8981\u7D20\u3092\u5F15\u304F\
    \u3002\n        bind initMatrix\n        result = initMatrix[T](a.h, a.w, value)\n\
    \        result -= a\n    proc `*=`*[T](a: var Matrix[T], value: T or SomeInteger)\
    \ =\n        ## \u884C\u5217\u306E\u5168\u8981\u7D20\u3092\u30B9\u30AB\u30E9\u30FC\
    \u500D\u3059\u308B\u3002\n        checkModulus(a)\n        let v = scalar[T](value)\n\
    \        for i in 0 ..< a.h * a.w:\n            a.storage.values[i] *= v\n   \
    \ proc `*`*[T](a: Matrix[T], value: T or SomeInteger): Matrix[T] =\n        ##\
    \ \u30B9\u30AB\u30E9\u30FC\u500D\u3057\u305F\u884C\u5217\u3092\u65B0\u3057\u304F\
    \u8FD4\u3059\u3002\n        result = a\n        result *= value\n    proc `*`*[T](value:\
    \ T, a: Matrix[T]): Matrix[T] =\n        ## \u30B9\u30AB\u30E9\u30FC\u500D\u3057\
    \u305F\u884C\u5217\u3092\u65B0\u3057\u304F\u8FD4\u3059\u3002\n        a * value\n\
    \n    proc `+`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =\n        ##\
    \ \u6574\u6570\u3068\u884C\u5217\u306E\u5404\u8981\u7D20\u3092\u52A0\u7B97\u3059\
    \u308B\u3002\n        a + scalar[T](value)\n    proc `-`*[T](value: SomeInteger,\
    \ a: Matrix[T]): Matrix[T] =\n        ## \u6574\u6570\u304B\u3089\u884C\u5217\u306E\
    \u5404\u8981\u7D20\u3092\u5F15\u304F\u3002\n        scalar[T](value) - a\n   \
    \ proc `*`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =\n        ## \u6574\
    \u6570\u3067\u884C\u5217\u3092\u30B9\u30AB\u30E9\u30FC\u500D\u3059\u308B\u3002\
    \n        a * scalar[T](value)\n\n    proc identity_matrix*[T](n: int, one, zero:\
    \ T): Matrix[T] =\n        ## \u6307\u5B9A\u3057\u305F\u5BFE\u89D2\u6210\u5206\
    \u3068\u975E\u5BFE\u89D2\u6210\u5206\u304B\u3089\u6B63\u65B9\u884C\u5217\u3092\
    \u4F5C\u308B\u3002\n        bind initMatrix\n        result = initMatrix[T](n,\
    \ n, zero)\n        for i in 0 ..< n:\n            result[i, i] = one\n    proc\
    \ identity_matrix*[T](n: int): Matrix[T] =\n        ## n\u884Cn\u5217\u306E\u5358\
    \u4F4D\u884C\u5217\u3092\u4F5C\u308B\u3002\n        bind identity_matrix\n   \
    \     identity_matrix[T](n, T.init(1), T.init(0))\n    proc pow*[T](a: Matrix[T],\
    \ exponent: int): Matrix[T] =\n        ## \u975E\u8CA0\u6574\u6570\u4E57\u3092\
    \u7E70\u308A\u8FD4\u3057\u4E8C\u4E57\u6CD5\u3067\u6C42\u3081\u308B\u3002\n   \
    \     bind identity_matrix\n        checkModulus(a)\n        doAssert a.h == a.w\
    \ and exponent >= 0, \"invalid matrix power\"\n        if exponent == 0:\n   \
    \         return identity_matrix[T](a.h)\n        if exponent == 1:\n        \
    \    return a\n        var base = a\n        var n = exponent\n        var initialized\
    \ = false\n        while n > 0:\n            if (n and 1) != 0:\n            \
    \    if initialized:\n                    result *= base\n                else:\n\
    \                    result = base\n                    initialized = true\n \
    \           n = n shr 1\n            if n != 0: base *= base\n    proc `**`*[T](a:\
    \ Matrix[T], exponent: int): Matrix[T] =\n        ## \u884C\u5217\u306E\u975E\u8CA0\
    \u6574\u6570\u4E57\u3092\u6C42\u3081\u308B\u3002\n        a.pow(exponent)\n  \
    \  proc sum*[T](a: Matrix[T]): T =\n        ## \u5168\u8981\u7D20\u306E\u548C\u3092\
    \u6C42\u3081\u308B\u3002\n        checkModulus(a)\n        result = T.init(0)\n\
    \        for i in 0 ..< a.h * a.w:\n            result += a.storage.values[i]\n\
    \    proc `==`*[T](a, b: Matrix[T]): bool =\n        ## modint\u306E\u5197\u9577\
    \u306A\u5185\u90E8\u8868\u73FE\u306B\u3088\u3089\u305A\u5F62\u72B6\u3068\u5024\
    \u3092\u6BD4\u8F03\u3059\u308B\u3002\n        checkModulus(a)\n        checkModulus(b)\n\
    \        if a.h != b.h or a.w != b.w: return false\n        let modulus = T.umod.int\n\
    \        for i in 0 ..< a.h * a.w:\n            if a.storage.values[i].val mod\
    \ modulus != b.storage.values[i].val mod modulus:\n                return false\n\
    \        true\n    proc hash*[T](a: Matrix[T]): Hash =\n        ## \u5F62\u72B6\
    \u3068\u6B63\u898F\u5316\u3057\u305F\u5024\u304B\u3089\u30CF\u30C3\u30B7\u30E5\
    \u3092\u6C42\u3081\u308B\u3002\n        checkModulus(a)\n        result = hash((a.h,\
    \ a.w, T.umod.int))\n        for i in 0 ..< a.h * a.w:\n            result = result\
    \ !& hash(a.storage.values[i].val mod T.umod.int)\n        result = !$result\n\
    \    proc `$`*[T](a: Matrix[T]): string =\n        ## \u5404\u884C\u3092\u7A7A\
    \u767D\u533A\u5207\u308A\u3067\u8868\u793A\u3059\u308B\u3002\n        checkModulus(a)\n\
    \        for i in 0 ..< a.h:\n            if i != 0: result.add('\\n')\n     \
    \       result.add(a[i].join(\" \"))\n\n    proc matrixProductLegacy[M: object,\
    \ T](a, b: M, Element: typedesc[T]): M =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\
    \u3092\u4FDD\u6301\u3059\u308B\u5F93\u6765\u306EMatrix\u306BAVX2\u306E\u7A4D\u3092\
    \u8FD4\u3059\u3002\n        # \u578B\u306Ftypedesc\u3067\u53D7\u3051\u53D6\u308A\
    \u3001Nim 1.6\u3067\u306Emodint\u306E\u578B\u5F15\u6570\u8AA4\u675F\u7E1B\u3092\
    \u907F\u3051\u308B\u3002\n        bind matrixProduct\n        mixin h, w, `[]`\n\
    \        when T isnot MontgomeryModint and T isnot BarrettModint:\n          \
    \  {.error: \"matrixProduct requires MontgomeryModint or BarrettModint\".}\n \
    \       let n = a.h\n        let m = a.w\n        let k = b.w\n        doAssert\
    \ m == b.h, \"matrix size mismatch\"\n        let modulus = T.umod.uint32\n  \
    \      doAssert modulus > 0 and modulus < (1u32 shl 30) and\n                (modulus\
    \ and 1u32) == 1, \"modulus must be odd and in [1, 2^30)\"\n        doAssert n\
    \ == 0 or m <= high(int) div n, \"matrix size overflow\"\n        doAssert m ==\
    \ 0 or k <= high(int) div m, \"matrix size overflow\"\n        var flatA = newSeq[uint32](n\
    \ * m)\n        var flatB = newSeq[uint32](m * k)\n        for i in 0 ..< n:\n\
    \            doAssert a[i].len == m, \"ragged matrix\"\n            for j in 0\
    \ ..< m:\n                flatA[i * m + j] = a[i, j].val.uint32\n        for i\
    \ in 0 ..< m:\n            doAssert b[i].len == k, \"ragged matrix\"\n       \
    \     for j in 0 ..< k:\n                flatB[i * k + j] = b[i, j].val.uint32\n\
    \        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)\n        #\
    \ \u65E7Matrix\u3092import\u305B\u305A\u3001\u63D0\u51FA\u7528\u306E\u30BD\u30FC\
    \u30B9\u5C55\u958B\u3067\u3082Matrix\u540D\u306E\u91CD\u8907\u3092\u9632\u3050\
    \u3002\n        for name, values in fieldPairs(result):\n            when name\
    \ == \"arr\" and values is seq[seq[T]]:\n                values = newSeq[seq[T]](n)\n\
    \                for i in 0 ..< n:\n                    values[i] = newSeq[T](k)\n\
    \                    for j in 0 ..< k:\n                        values[i][j] =\
    \ T.init(flatC[i * k + j].int)\n            elif name == \"emptyWidth\" and values\
    \ is int:\n                values = k\n            else:\n                {.error:\
    \ \"unsupported matrix representation\".}\n\n    type LegacyMatrix[T] = concept\
    \ x\n        x.h is int\n        x.w is int\n        x[0, 0] is T\n\n    proc\
    \ matrixProduct*[T](a, b: LegacyMatrix[T]): auto =\n        ## \u5F93\u6765\u306E\
    Matrix\u578B\u3092\u4FDD\u3063\u305F\u307E\u307EAVX2\u3067\u884C\u5217\u7A4D\u3092\
    \u8A08\u7B97\u3059\u308B\u3002\n        mixin `[]`\n        matrixProductLegacy(a,\
    \ b, typeof(a[0, 0]))\n\n    import options\n    import cplib/matrix/field_matrix_ops\n\
    \    export LinearSystemSolution\n\n    type FieldReduction = object\n       \
    \ values: seq[uint32]\n        pivots: seq[cint]\n        width, rank: int\n \
    \       determinant: uint32\n\n    proc fieldPointer[T](values: openArray[T]):\
    \ ptr uint32 =\n        ## \u7A7A\u914D\u5217\u3092\u542B\u3080modint\u5185\u90E8\
    \u5024\u306E\u9023\u7D9A\u9818\u57DF\u3092\u53C2\u7167\u3059\u308B\u3002\n   \
    \     if values.len == 0: nil\n        else: cast[ptr uint32](unsafeAddr values[0])\n\
    \n    proc fieldMatrixPointer[T](a: Matrix[T]): ptr uint32 =\n        ## \u7A7A\
    \u884C\u5217\u3092\u542B\u3080\u884C\u5217\u306E\u5185\u90E8\u9818\u57DF\u3092\
    \u8AAD\u307F\u53D6\u308B\u3002\n        when defined(gcDestructors):\n       \
    \     if a.storage.isNil: return nil\n        fieldPointer(a.storage.values)\n\
    \n    proc fieldPivotPointer(pivots: openArray[cint]): ptr cint =\n        ##\
    \ \u7A7A\u914D\u5217\u3092\u542B\u3080\u30D4\u30DC\u30C3\u30C8\u5217\u306E\u9818\
    \u57DF\u3092\u53C2\u7167\u3059\u308B\u3002\n        if pivots.len == 0: nil\n\
    \        else: cast[ptr cint](unsafeAddr pivots[0])\n\n    proc reduceFieldMatrix[T](a:\
    \ Matrix[T], extra: int, reduced: bool,\n            rhs: ptr uint32 = nil, identity:\
    \ bool = false): FieldReduction =\n        ## \u5165\u529B\u3092\u4FDD\u6301\u3057\
    \u305F\u307E\u307E\u3001\u62E1\u5927\u884C\u5217\u3092AVX2\u3067\u524D\u9032\u6D88\
    \u53BB\u30FB\u6383\u304D\u51FA\u3057\u3059\u308B\u3002\n        checkModulus(a)\n\
    \        doAssert extra >= 0 and extra <= high(cint).int - a.w, \"matrix size\
    \ overflow\"\n        result.width = a.w + extra\n        result.values = newSeq[uint32](matrixSize(a.h,\
    \ result.width))\n        result.pivots = newSeq[cint](min(a.h, a.w))\n      \
    \  let modulus = matrixModulus[T]()\n        fieldPrepareKernel(fieldMatrixPointer(a),\
    \ rhs, fieldPointer(result.values),\n            a.h, a.w, extra, modulus, T is\
    \ MontgomeryModint, identity)\n        result.rank = fieldEliminateKernel(fieldPointer(result.values),\
    \ a.h,\n            result.width, a.w, fieldPivotPointer(result.pivots), result.determinant,\
    \ modulus, reduced)\n\n    proc rank*[T](a: Matrix[T]): int =\n        ## AVX2\u306E\
    \u524D\u9032\u6D88\u53BB\u3067\u968E\u6570\u3092\u6C42\u3081\u308B\u3002O(h*w*min(h,w))\u3002\
    \n        reduceFieldMatrix(a, 0, false).rank\n\n    proc determinant*[T](a: Matrix[T]):\
    \ T =\n        ## AVX2\u306E\u524D\u9032\u6D88\u53BB\u3067\u884C\u5217\u5F0F\u3092\
    \u6C42\u3081\u308B\u3002\u7A7A\u884C\u5217\u306F1\u3002O(n^3)\u3002\n        assert\
    \ a.h == a.w\n        let reduced = reduceFieldMatrix(a, 0, false)\n        if\
    \ reduced.rank != a.h: return T.init(0)\n        T.init(fieldCanonicalKernel(reduced.determinant,\
    \ matrixModulus[T]()).int)\n\n    proc hafnian*[T](a: Matrix[T]): T =\n      \
    \  ## \u5BFE\u79F0\u306A\u5076\u6570\u6B21\u884C\u5217\u306Ehafnian\u3092AVX2\u306E\
    \u591A\u9805\u5F0F\u7A4D\u548C\u3067\u6C42\u3081\u308B\u3002O(n^2*2^(n/2))\u3002\
    \n        checkModulus(a)\n        assert a.h == a.w and a.h mod 2 == 0\n    \
    \    for i in 0..<a.h:\n            for j in 0..<i: assert a[i,j].val == a[j,i].val,\
    \ \"matrix must be symmetric\"\n        T.init(fieldHafnianKernel(fieldMatrixPointer(a),\
    \ a.h,\n            matrixModulus[T](), T is MontgomeryModint).int)\n\n    proc\
    \ solveLinearSystem*[T](a: Matrix[T], b: openArray[T]): Option[LinearSystemSolution[T]]\
    \ =\n        ## AVX2\u3067Ax=b\u3092\u6383\u304D\u51FA\u3057\u3001\u7279\u6B8A\
    \u89E3\u3068\u6838\u306E\u57FA\u5E95\u3092\u8FD4\u3059\u3002O(h*w*min(h,w)+w^2)\u3002\
    \n        assert b.len == a.h\n        var reduced = reduceFieldMatrix(a, 1, true,\
    \ fieldPointer(b))\n        for i in reduced.rank..<a.h:\n            if reduced.values[i\
    \ * reduced.width + a.w] != 0:\n                return none(LinearSystemSolution[T])\n\
    \        fieldRestoreKernel(fieldPointer(reduced.values), reduced.values.len,\n\
    \            matrixModulus[T](), T is MontgomeryModint)\n        var solution:\
    \ LinearSystemSolution[T]\n        solution.particular = newSeq[T](a.w)\n    \
    \    var isPivot = newSeq[bool](a.w)\n        for i in 0..<reduced.rank:\n   \
    \         let col = reduced.pivots[i].int\n            isPivot[col] = true\n \
    \           solution.particular[col] = cast[T](reduced.values[i * reduced.width\
    \ + a.w])\n        let one = T.init(1)\n        for free in 0..<a.w:\n       \
    \     if isPivot[free]: continue\n            var vector = newSeq[T](a.w)\n  \
    \          vector[free] = one\n            for i in 0..<reduced.rank:\n      \
    \          vector[reduced.pivots[i].int] = -cast[T](reduced.values[i * reduced.width\
    \ + free])\n            solution.basis.add(vector)\n        some(solution)\n\n\
    \    proc inverse*[T](a: Matrix[T]): Option[Matrix[T]] =\n        ## AVX2\u306E\
    \u6383\u304D\u51FA\u3057\u3067\u9006\u884C\u5217\u3092\u8FD4\u3059\u3002\u7279\
    \u7570\u884C\u5217\u306Fnone\u3002O(n^3)\u3002\n        assert a.h == a.w\n  \
    \      let reduced = reduceFieldMatrix(a, a.h, true, identity = true)\n      \
    \  if reduced.rank != a.h: return none(Matrix[T])\n        var answer = initMatrix[T](a.h,\
    \ a.h)\n        fieldInverseAdjugateKernel(fieldPointer(reduced.values), fieldMatrixPointer(answer),\n\
    \            a.h, reduced.rank, fieldPivotPointer(reduced.pivots), reduced.determinant,\n\
    \            matrixModulus[T](), T is MontgomeryModint, false)\n        some(answer)\n\
    \n    proc adjugate*[T](a: Matrix[T]): Matrix[T] =\n        ## AVX2\u3067\u7279\
    \u7570\u884C\u5217\u3092\u542B\u3080\u4F59\u56E0\u5B50\u884C\u5217\u3092\u8FD4\
    \u3059\u3002O(n^3)\u3002\n        assert a.h == a.w\n        let reduced = reduceFieldMatrix(a,\
    \ a.h, true, identity = true)\n        result = initMatrix[T](a.h, a.h)\n    \
    \    fieldInverseAdjugateKernel(fieldPointer(reduced.values), fieldMatrixPointer(result),\n\
    \            a.h, reduced.rank, fieldPivotPointer(reduced.pivots), reduced.determinant,\n\
    \            matrixModulus[T](), T is MontgomeryModint, true)\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: cplib/matrix/matrix_avx2.nim
  requiredBy:
  - verify/matrix/linear_algebra/field_algorithms_unit.nim
  - verify/matrix/linear_algebra/field_algorithms_unit.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  timestamp: '2026-09-11 02:58:09+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/matrix/matrix_avx2_test.nim
  - verify/matrix/matrix_avx2_test.nim
  - verify/matrix/matrix_avx2_unit_test.nim
  - verify/matrix/matrix_avx2_unit_test.nim
  - verify/matrix/matrix_avx2_gc_test.nim
  - verify/matrix/matrix_avx2_gc_test.nim
documentation_of: cplib/matrix/matrix_avx2.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix_avx2.nim
- /library/cplib/matrix/matrix_avx2.nim.html
title: cplib/matrix/matrix_avx2.nim
---
