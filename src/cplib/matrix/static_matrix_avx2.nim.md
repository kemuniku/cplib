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
    path: verify/matrix/linear_algebra/judge_driver.nim
    title: verify/matrix/linear_algebra/judge_driver.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/judge_driver.nim
    title: verify/matrix/linear_algebra/judge_driver.nim
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
  code: "when not declared CPLIB_MATRIX_STATIC_MATRIX_AVX2:\n    const CPLIB_MATRIX_STATIC_MATRIX_AVX2*\
    \ = 1\n    import cplib/modint/modint\n    import cplib/matrix/matrix_avx2_kernel\n\
    \    import cplib/matrix/field_matrix_ops\n    import options\n    export LinearSystemSolution\n\
    \n    type StaticMatrix*[H: static int, W: static int, T] = object\n        values:\
    \ array[H*W,T]\n        modulus: uint32\n\n    proc fieldModulus[T](): uint32\
    \ =\n        ## AVX2\u3067\u6271\u3048\u308Bmodint\u578B\u3068\u6CD5\u3092\u691C\
    \u67FB\u3059\u308B\u3002\n        when T isnot MontgomeryModint and T isnot BarrettModint:\n\
    \            {.error: \"static_matrix_avx2 requires MontgomeryModint or BarrettModint\"\
    .}\n        static: doAssert sizeof(T) == sizeof(uint32) and alignof(T) == alignof(uint32)\n\
    \        result = T.umod\n        doAssert result > 0 and result < (1u32 shl 30)\
    \ and (result and 1) == 1\n\n    proc checkMatrix[H: static int, W: static int,\
    \ T](a: StaticMatrix[H,W,T]) =\n        ## \u56FA\u5B9A\u9577\u306E\u5BF8\u6CD5\
    \u3068\u4F5C\u6210\u6642\u306E\u6CD5\u3092\u691C\u67FB\u3059\u308B\u3002\n   \
    \     static:\n            doAssert H >= 0 and W >= 0 and H <= high(cint).int\
    \ and W <= high(cint).int\n            doAssert H == 0 or W <= (high(int) div\
    \ sizeof(T)) div H\n        let modulus = fieldModulus[T]()\n        doAssert\
    \ a.modulus == 0 or a.modulus == modulus, \"matrix modulus has changed\"\n\n \
    \   proc buffer[T](a: openArray[T]): ptr uint32 =\n        ## \u7A7A\u914D\u5217\
    \u3092\u542B\u3080\u9023\u7D9A\u9818\u57DF\u306E\u5148\u982D\u3092\u8FD4\u3059\
    \u3002\n        if a.len == 0: nil\n        else: cast[ptr uint32](unsafeAddr\
    \ a[0])\n\n    proc initMatrix*[H: static int, W: static int, T](value: T = T.init(0)):\
    \ StaticMatrix[H,W,T] =\n        ## H\u884CW\u5217\u306E\u56FA\u5B9A\u9577\u884C\
    \u5217\u3092\u6307\u5B9A\u5024\u3067\u521D\u671F\u5316\u3059\u308B\u3002O(H*W)\u3002\
    \n        checkMatrix(result)\n        result.modulus = fieldModulus[T]()\n  \
    \      for i in 0..<H*W: result.values[i] = value\n\n    proc toMatrix*[H: static\
    \ int, W: static int, T](rows: array[H,array[W,T]]): StaticMatrix[H,W,T] =\n \
    \       ## \u4E8C\u6B21\u5143\u56FA\u5B9A\u9577\u914D\u5217\u3092\u884C\u5217\u306B\
    \u3059\u308B\u3002O(H*W)\u3002\n        checkMatrix(result)\n        result.modulus\
    \ = fieldModulus[T]()\n        for i in 0..<H:\n            for j in 0..<W: result.values[i*W+j]\
    \ = rows[i][j]\n\n    proc h*[H: static int, W: static int, T](a: StaticMatrix[H,W,T]):\
    \ int =\n        ## \u884C\u6570\u3092\u8FD4\u3059\u3002\n        H\n    proc\
    \ w*[H: static int, W: static int, T](a: StaticMatrix[H,W,T]): int =\n       \
    \ ## \u5217\u6570\u3092\u8FD4\u3059\u3002\n        W\n    proc `[]`*[H: static\
    \ int, W: static int, T](a: StaticMatrix[H,W,T], i,j: int): T =\n        ## \u6307\
    \u5B9A\u4F4D\u7F6E\u306E\u8981\u7D20\u3092\u8FD4\u3059\u3002\n        assert i\
    \ in 0..<H and j in 0..<W\n        a.values[i*W+j]\n    proc `[]`*[H: static int,\
    \ W: static int, T](a: var StaticMatrix[H,W,T], i,j: int): var T =\n        ##\
    \ \u6307\u5B9A\u4F4D\u7F6E\u306E\u8981\u7D20\u3092\u5909\u66F4\u53EF\u80FD\u306A\
    \u53C2\u7167\u3067\u8FD4\u3059\u3002\n        assert i in 0..<H and j in 0..<W\n\
    \        a.values[i*W+j]\n    proc `[]=`*[H: static int, W: static int, T](a:\
    \ var StaticMatrix[H,W,T], i,j: int, value: T) =\n        ## \u6307\u5B9A\u4F4D\
    \u7F6E\u306E\u8981\u7D20\u3092\u66F4\u65B0\u3059\u308B\u3002\n        assert i\
    \ in 0..<H and j in 0..<W\n        a.values[i*W+j] = value\n    proc `[]`*[H:\
    \ static int, W: static int, T](a: StaticMatrix[H,W,T], i: int): array[W,T] =\n\
    \        ## \u6307\u5B9A\u884C\u3092\u30B3\u30D4\u30FC\u3059\u308B\u3002O(W)\u3002\
    \n        assert i in 0..<H\n        for j in 0..<W: result[j] = a.values[i*W+j]\n\
    \    proc `[]=`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T],\
    \ i: int, row: array[W,T]) =\n        ## \u6307\u5B9A\u884C\u3092\u7F6E\u304D\u63DB\
    \u3048\u308B\u3002O(W)\u3002\n        assert i in 0..<H\n        for j in 0..<W:\
    \ a.values[i*W+j] = row[j]\n    proc `==`*[H: static int, W: static int, T](a,b:\
    \ StaticMatrix[H,W,T]): bool =\n        ## \u516C\u958B\u5024\u3067\u5168\u8981\
    \u7D20\u3092\u6BD4\u8F03\u3059\u308B\u3002O(H*W)\u3002\n        checkMatrix(a)\n\
    \        checkMatrix(b)\n        for i in 0..<H*W:\n            if a.values[i].val\
    \ != b.values[i].val: return false\n        true\n    proc `$`*[H: static int,\
    \ W: static int, T](a: StaticMatrix[H,W,T]): string =\n        ## \u884C\u3092\
    \u6539\u884C\u3067\u533A\u5207\u3063\u305F\u6587\u5B57\u5217\u306B\u3059\u308B\
    \u3002O(H*W)\u3002\n        checkMatrix(a)\n        for i in 0..<H:\n        \
    \    if i > 0: result.add('\\n')\n            when W > 0:\n                result.add(matrixJoinValues(cast[ptr\
    \ uint32](unsafeAddr a.values[i*W]), W, fieldModulus[T](), T is MontgomeryModint,\
    \ \" \"))\n\n    proc `*`*[H: static int, W: static int, K: static int, T](a:\
    \ StaticMatrix[H,W,T], b: StaticMatrix[W,K,T]): StaticMatrix[H,K,T] =\n      \
    \  ## \u5404\u5BF8\u6CD5\u304C4\u4EE5\u4E0B\u306A\u3089\u76F4\u63A5\u4E57\u7B97\
    \u3057\u3001\u305D\u308C\u4EE5\u5916\u306FAVX2\u3067\u884C\u5217\u7A4D\u3092\u6C42\
    \u3081\u308B\u3002\n        bind initMatrix\n        checkMatrix(a)\n        checkMatrix(b)\n\
    \        result = initMatrix[H,K,T]()\n        when H <= 4 and W <= 4 and K <=\
    \ 4:\n            # \u6975\u5C0F\u884C\u5217\u3067\u306F16\u5358\u4F4D\u306E\u30D1\
    \u30C7\u30A3\u30F3\u30B0\u3068\u4F5C\u696D\u9818\u57DF\u306E\u78BA\u4FDD\u3092\
    \u907F\u3051\u308B\u3002\n            for i in 0..<H:\n                for j in\
    \ 0..<K:\n                    for k in 0..<W:\n                        result.values[i*K+j]\
    \ += a.values[i*W+k] * b.values[k*K+j]\n        elif H > 0 and W > 0 and K > 0:\n\
    \            when T is MontgomeryModint:\n                matrixProductMontgomeryKernel(buffer(a.values),\
    \ buffer(b.values), buffer(result.values), H.cint, W.cint, K.cint, fieldModulus[T]())\n\
    \            else:\n                matrixProductKernel(buffer(a.values), buffer(b.values),\
    \ buffer(result.values), H.cint, W.cint, K.cint, fieldModulus[T]())\n    proc\
    \ `*=`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], b: StaticMatrix[W,W,T])\
    \ =\n        ## \u884C\u5217\u7A4D\u3067\u7F6E\u304D\u63DB\u3048\u308B\u3002\n\
    \        a = a * b\n    proc matrixProduct*[H: static int, W: static int, K: static\
    \ int, T](a: StaticMatrix[H,W,T], b: StaticMatrix[W,K,T]): StaticMatrix[H,K,T]\
    \ =\n        ## \u95A2\u6570\u5F62\u5F0F\u3067AVX2\u884C\u5217\u7A4D\u3092\u6C42\
    \u3081\u308B\u3002\n        a * b\n\n    template defineElementwise(assign, op:\
    \ untyped) =\n        ## \u6210\u5206\u3054\u3068\u306E\u52A0\u6E1B\u7B97\u3068\
    \u4EE3\u5165\u3092\u5B9A\u7FA9\u3059\u308B\u3002\n        proc assign*[H: static\
    \ int, W: static int, T](a: var StaticMatrix[H,W,T], b: StaticMatrix[H,W,T]) =\n\
    \            ## \u6210\u5206\u3054\u3068\u306B\u52A0\u6E1B\u7B97\u3059\u308B\u3002\
    O(H*W)\u3002\n            checkMatrix(a)\n            checkMatrix(b)\n       \
    \     for i in 0..<H*W: assign(a.values[i], b.values[i])\n        proc op*[H:\
    \ static int, W: static int, T](a,b: StaticMatrix[H,W,T]): StaticMatrix[H,W,T]\
    \ =\n            ## \u6210\u5206\u3054\u3068\u306E\u52A0\u6E1B\u7B97\u306E\u7D50\
    \u679C\u3092\u8FD4\u3059\u3002O(H*W)\u3002\n            result = a\n         \
    \   assign(result,b)\n        proc assign*[H: static int, W: static int, T](a:\
    \ var StaticMatrix[H,W,T], value: T) =\n            ## \u5168\u6210\u5206\u306B\
    \u5B9A\u6570\u3092\u52A0\u6E1B\u7B97\u3059\u308B\u3002O(H*W)\u3002\n         \
    \   checkMatrix(a)\n            for i in 0..<H*W: assign(a.values[i],value)\n\
    \        proc op*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], value:\
    \ T): StaticMatrix[H,W,T] =\n            ## \u5168\u6210\u5206\u306B\u5B9A\u6570\
    \u3092\u52A0\u6E1B\u7B97\u3057\u305F\u884C\u5217\u3092\u8FD4\u3059\u3002O(H*W)\u3002\
    \n            result = a\n            assign(result,value)\n    defineElementwise(`+=`,\
    \ `+`)\n    defineElementwise(`-=`, `-`)\n    proc `*=`*[H: static int, W: static\
    \ int, T](a: var StaticMatrix[H,W,T], value: T) =\n        ## \u5168\u6210\u5206\
    \u3092\u5B9A\u6570\u500D\u3059\u308B\u3002O(H*W)\u3002\n        checkMatrix(a)\n\
    \        for i in 0..<H*W: a.values[i] *= value\n    proc `*`*[H: static int,\
    \ W: static int, T](a: StaticMatrix[H,W,T], value: T): StaticMatrix[H,W,T] =\n\
    \        ## \u5B9A\u6570\u500D\u3057\u305F\u884C\u5217\u3092\u8FD4\u3059\u3002\
    O(H*W)\u3002\n        result = a\n        result *= value\n    proc `*`*[H: static\
    \ int, W: static int, T](value: T, a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T]\
    \ =\n        ## \u5B9A\u6570\u500D\u3057\u305F\u884C\u5217\u3092\u8FD4\u3059\u3002\
    O(H*W)\u3002\n        a * value\n    proc `-`*[H: static int, W: static int, T](a:\
    \ StaticMatrix[H,W,T]): StaticMatrix[H,W,T] =\n        ## \u5168\u6210\u5206\u306E\
    \u7B26\u53F7\u3092\u53CD\u8EE2\u3059\u308B\u3002O(H*W)\u3002\n        a * (-T.init(1))\n\
    \    proc identity_matrix*[H: static int, W: static int, T](n: int = H): StaticMatrix[H,W,T]\
    \ =\n        ## H\xD7H\u5358\u4F4D\u884C\u5217\u3092\u8FD4\u3059\u3002O(H^2)\u3002\
    \n        bind initMatrix\n        static: doAssert H == W\n        assert n ==\
    \ H\n        checkMatrix(result)\n        result.modulus = fieldModulus[T]()\n\
    \        for i in 0..<H: result.values[i*W+i] = T.init(1)\n    proc pow*[H: static\
    \ int, W: static int, T](a: StaticMatrix[H,W,T], exponent: int): StaticMatrix[H,W,T]\
    \ =\n        ## \u4E8C\u5206\u7D2F\u4E57\u6CD5\u3067\u975E\u8CA0\u6574\u6570\u4E57\
    \u3092\u6C42\u3081\u308B\u3002\n        bind identity_matrix\n        static:\
    \ doAssert H == W\n        doAssert exponent >= 0\n        checkMatrix(a)\n  \
    \      result = identity_matrix[H,W,T]()\n        var base = a\n        var e\
    \ = exponent\n        while e > 0:\n            if (e and 1) != 0: result *= base\n\
    \            e = e shr 1\n            if e > 0: base *= base\n    proc `**`*[H:\
    \ static int, W: static int, T](a: StaticMatrix[H,W,T], exponent: int): StaticMatrix[H,W,T]\
    \ =\n        ## \u975E\u8CA0\u6574\u6570\u4E57\u3092\u6C42\u3081\u308B\u3002\n\
    \        a.pow(exponent)\n\n    proc sum*[H: static int, W: static int, T](a:\
    \ StaticMatrix[H,W,T]): T =\n        ## \u5168\u6210\u5206\u306E\u548C\u3092\u8FD4\
    \u3059\u3002O(H*W)\u3002\n        checkMatrix(a)\n        for i in 0..<H*W: result\
    \ += a.values[i]\n\n    type Reduction[H: static int, W: static int, E: static\
    \ int] = object\n        values: array[H*(W+E),uint32]\n        pivots: array[min(H,W),cint]\n\
    \        width, rank: int\n        determinant: uint32\n\n    proc reduce[H: static\
    \ int, W: static int, T](a: StaticMatrix[H,W,T], height, width: int, extra: static\
    \ int, reduced: bool, rhs: ptr uint32 = nil, identity: bool = false): ref Reduction[H,W,extra]\
    \ =\n        ## \u56FA\u5B9A\u5BB9\u91CF\u306E\u4F5C\u696D\u9818\u57DF\u3092\u30D2\
    \u30FC\u30D7\u306B\u78BA\u4FDD\u3057\u3066AVX2\u3067\u6D88\u53BB\u3059\u308B\u3002\
    \n        checkMatrix(a)\n        doAssert height in 0..H and width in 0..W\n\
    \        static: doAssert extra >= 0 and W <= high(cint).int-extra\n        new\
    \ result\n        let actualExtra = if identity: height else: extra\n        result.width\
    \ = width + actualExtra\n        fieldPrepareKernel(buffer(a.values), rhs, buffer(result.values),\
    \ height, width, actualExtra, fieldModulus[T](), T is MontgomeryModint, identity,\
    \ W)\n        result.rank = fieldEliminateKernel(buffer(result.values), height,\
    \ result.width, width, cast[ptr cint](buffer(result.pivots)), result.determinant,\
    \ fieldModulus[T](), reduced)\n\n    proc rank*[H: static int, W: static int,\
    \ T](a: StaticMatrix[H,W,T], height: int = H, width: int = W): int =\n       \
    \ ## \u5DE6\u4E0Aheight\xD7width\u306E\u968E\u6570\u3092AVX2\u3067\u6C42\u3081\
    \u308B\u3002O(H*W+h*w*min(h,w))\u3002\n        reduce(a,height,width,0,false).rank\n\
    \    proc determinant*[H: static int, W: static int, T](a: StaticMatrix[H,W,T],\
    \ n: int = H): T =\n        ## \u5DE6\u4E0An\xD7n\u306E\u884C\u5217\u5F0F\u3092\
    AVX2\u3067\u6C42\u3081\u308B\u3002\u7A7A\u884C\u5217\u306F1\u3002O(H*W+n^3)\u3002\
    \n        let r = reduce(a,n,n,0,false)\n        if r.rank != n: return T.init(0)\n\
    \        T.init(fieldCanonicalKernel(r.determinant,fieldModulus[T]()).int)\n \
    \   proc hafnian*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], n:\
    \ int = H): T =\n        ## \u5BFE\u79F0\u306A\u5DE6\u4E0An\xD7n\u306Ehafnian\u3092\
    AVX2\u3067\u6C42\u3081\u308B\u3002O(n^2*2^(n/2))\u3002\n        checkMatrix(a)\n\
    \        doAssert n in 0..min(H,W) and n mod 2 == 0\n        for i in 0..<n:\n\
    \            for j in 0..<i: assert a[i,j].val == a[j,i].val\n        T.init(fieldHafnianKernel(buffer(a.values),n,fieldModulus[T](),T\
    \ is MontgomeryModint,W).int)\n    proc solveLinearSystem*[H: static int, W: static\
    \ int, T](a: StaticMatrix[H,W,T], b: openArray[T], height: int = H, width: int\
    \ = W): Option[LinearSystemSolution[T]] =\n        ## \u5DE6\u4E0Aheight\xD7width\u3067\
    Ax=b\u306E\u7279\u6B8A\u89E3\u3068\u6838\u306E\u57FA\u5E95\u3092\u6C42\u3081\u308B\
    \u3002O(H*W+h*w*min(h,w)+w^2)\u3002\n        doAssert b.len == height\n      \
    \  let r = reduce(a,height,width,1,true,buffer(b))\n        for i in r.rank..<height:\n\
    \            if r.values[i*r.width+width] != 0: return none(LinearSystemSolution[T])\n\
    \        fieldRestoreKernel(buffer(r.values),height*r.width,fieldModulus[T](),T\
    \ is MontgomeryModint)\n        var solution: LinearSystemSolution[T]\n      \
    \  solution.particular = newSeq[T](width)\n        var isPivot = newSeq[bool](width)\n\
    \        for i in 0..<r.rank:\n            let col = r.pivots[i].int\n       \
    \     isPivot[col] = true\n            solution.particular[col] = cast[T](r.values[i*r.width+width])\n\
    \        for free in 0..<width:\n            if isPivot[free]: continue\n    \
    \        var vector = newSeq[T](width)\n            vector[free] = T.init(1)\n\
    \            for i in 0..<r.rank: vector[r.pivots[i].int] = -cast[T](r.values[i*r.width+free])\n\
    \            solution.basis.add(vector)\n        some(solution)\n    proc inverse*[H:\
    \ static int, W: static int, T](a: StaticMatrix[H,W,T], n: int = H): Option[StaticMatrix[H,W,T]]\
    \ =\n        ## \u5DE6\u4E0An\xD7n\u306E\u9006\u884C\u5217\u3092AVX2\u3067\u6C42\
    \u3081\u308B\u3002\u7BC4\u56F2\u5916\u306F\u96F6\u3001\u7279\u7570\u884C\u5217\
    \u306Fnone\u3002O(H*W+n^3)\u3002\n        bind initMatrix\n        let r = reduce(a,n,n,min(H,W),true,identity=true)\n\
    \        if r.rank != n: return none(StaticMatrix[H,W,T])\n        var answer\
    \ = initMatrix[H,W,T]()\n        fieldInverseAdjugateKernel(buffer(r.values),buffer(answer.values),n,r.rank,cast[ptr\
    \ cint](buffer(r.pivots)),r.determinant,fieldModulus[T](),T is MontgomeryModint,false,W)\n\
    \        some(answer)\n    proc adjugate*[H: static int, W: static int, T](a:\
    \ StaticMatrix[H,W,T], n: int = H): StaticMatrix[H,W,T] =\n        ## \u5DE6\u4E0A\
    n\xD7n\u306E\u4F59\u56E0\u5B50\u884C\u5217\u3092AVX2\u3067\u6C42\u3081\u308B\u3002\
    \u7BC4\u56F2\u5916\u306F\u96F6\u3002O(H*W+n^3)\u3002\n        bind initMatrix\n\
    \        let r = reduce(a,n,n,min(H,W),true,identity=true)\n        checkMatrix(result)\n\
    \        result.modulus = fieldModulus[T]()\n        fieldInverseAdjugateKernel(buffer(r.values),buffer(result.values),n,r.rank,cast[ptr\
    \ cint](buffer(r.pivots)),r.determinant,fieldModulus[T](),T is MontgomeryModint,true,W)\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/matrix/field_matrix_ops.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  isVerificationFile: false
  path: cplib/matrix/static_matrix_avx2.nim
  requiredBy:
  - verify/matrix/linear_algebra/judge_driver.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  timestamp: '2026-09-11 02:58:09+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/matrix/static_matrix_avx2.nim
layout: document
redirect_from:
- /library/cplib/matrix/static_matrix_avx2.nim
- /library/cplib/matrix/static_matrix_avx2.nim.html
title: cplib/matrix/static_matrix_avx2.nim
---
