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
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
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
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import hashes, os, random, sequtils, sets, strutils, std/tempfiles\nimport cplib/matrix/matrix_avx2\n\
    import cplib/modint/modint\n\nproc residue[T](x: T): uint64 =\n    ## modint\u306E\
    \u5185\u90E8\u8868\u73FE\u306B\u3088\u3089\u305A\u6A19\u6E96\u5270\u4F59\u3092\
    \u8FD4\u3059\u3002\n    x.val.uint64 mod T.umod.uint64\n\nproc naiveProduct[T](a,\
    \ b: Matrix[T]): seq[uint64] =\n    ## 64\u30D3\u30C3\u30C8\u6574\u6570\u306E\u5270\
    \u4F59\u6F14\u7B97\u306B\u3088\u308B\u72EC\u7ACB\u3057\u305F\u884C\u5217\u7A4D\
    \u3092\u6C42\u3081\u308B\u3002\n    result = newSeq[uint64](a.h * b.w)\n    let\
    \ p = T.umod.uint64\n    for i in 0 ..< a.h:\n        for j in 0 ..< b.w:\n  \
    \          for k in 0 ..< a.w:\n                result[i * b.w + j] = (result[i\
    \ * b.w + j] +\n                    residue(a[i, k]) * residue(b[k, j])) mod p\n\
    \nproc checkEntries[T](a: Matrix[T], expected: openArray[uint64]) =\n    ## \u3059\
    \u3079\u3066\u306E\u8981\u7D20\u3092\u72EC\u7ACB\u8A08\u7B97\u3057\u305F\u6A19\
    \u6E96\u5270\u4F59\u3068\u6BD4\u8F03\u3059\u308B\u3002\n    doAssert a.h * a.w\
    \ == expected.len\n    for i in 0 ..< a.h:\n        for j in 0 ..< a.w:\n    \
    \        doAssert residue(a[i, j]) == expected[i * a.w + j]\n\nproc checkProduct[T](a,\
    \ b: Matrix[T]) =\n    ## \u7A4D\u3068\u8907\u5408\u4EE3\u5165\u3092\u691C\u8A3C\
    \u3057\u3001\u5165\u529B\u884C\u5217\u304C\u5909\u308F\u3089\u306A\u3044\u3053\
    \u3068\u3092\u78BA\u8A8D\u3059\u308B\u3002\n    let savedA = a\n    let savedB\
    \ = b\n    let expected = naiveProduct(a, b)\n    let c = a * b\n    doAssert\
    \ c.h == a.h and c.w == b.w\n    checkEntries(c, expected)\n    doAssert matrixProduct(a,\
    \ b) == c\n    var d = a\n    d *= b\n    doAssert d.h == a.h and d.w == b.w\n\
    \    checkEntries(d, expected)\n    doAssert a == savedA and b == savedB\n\nproc\
    \ checkRandom[T](seed: int64) =\n    ## \u5C0F\u3055\u3044\u975E\u6B63\u65B9\u884C\
    \u5217\u3068\u6F14\u7B97\u5F8C\u306E\u5197\u9577\u8868\u73FE\u3092\u7D20\u6734\
    \u306A\u7A4D\u3068\u6BD4\u8F03\u3059\u308B\u3002\n    var rng = initRand(seed)\n\
    \    let bound = T.umod.int - 1\n    for trial in 0 ..< 45:\n        let h = rng.rand(0\
    \ .. 17)\n        let w = rng.rand(0 .. 17)\n        let k = rng.rand(0 .. 17)\n\
    \        var a = initMatrix[T](h, w, T.init(0))\n        var b = initMatrix[T](w,\
    \ k, T.init(0))\n        for i in 0 ..< h:\n            for j in 0 ..< w:\n  \
    \              a[i, j] = T.init(rng.rand(-bound .. bound))\n                a[i,\
    \ j] += T.init(rng.rand(0 .. bound))\n                a[i, j] -= T.init(rng.rand(0\
    \ .. bound))\n        for i in 0 ..< w:\n            for j in 0 ..< k:\n     \
    \           b[i][j] = T.init(rng.rand(-bound .. bound))\n                b[i][j]\
    \ += T.init(rng.rand(0 .. bound))\n                b[i][j] -= T.init(rng.rand(0\
    \ .. bound))\n        checkProduct(a, b)\n\nproc checkApi[T]() =\n    ## \u65E2\
    \u5B58\u306E\u884C\u5217API\u3068\u30B3\u30D4\u30FC\u3001\u884C\u30D3\u30E5\u30FC\
    \u306E\u6240\u6709\u6A29\u3092\u691C\u8A3C\u3059\u308B\u3002\n    let zero = T.init(0)\n\
    \    let one = T.init(1)\n    let two = T.init(2)\n    let three = T.init(3)\n\
    \    let source = @[@[one, two], @[three, T.init(4)]]\n    let a = initMatrix(source)\n\
    \    doAssert a.h == 2 and a.w == 2\n    doAssert initMatrix[T](2, 3) == initMatrix[T](2,\
    \ 3, zero)\n    doAssert a == source.toMatrix\n    doAssert $a == \"1 2\\n3 4\"\
    \n    doAssert a[0].join(\" \") == \"1 2\"\n    doAssert residue(a.sum) == 10\n\
    \    doAssert a[0].len == 2\n    doAssert toSeq(a[1]).mapIt(residue(it)) == @[3u64,\
    \ 4u64]\n    var seen: seq[uint64]\n    for x in a[0]: seen.add(residue(x))\n\
    \    doAssert seen == @[1u64, 2u64]\n    for i, x in a[1]: doAssert residue(x)\
    \ == (i + 3).uint64\n\n    var rowInput = @[one, two, three]\n    let horizontal\
    \ = initMatrix(rowInput)\n    let vertical = initMatrix(rowInput, true)\n    doAssert\
    \ horizontal.h == 1 and horizontal.w == 3\n    doAssert vertical.h == 3 and vertical.w\
    \ == 1\n    rowInput[0] = T.init(90)\n    doAssert residue(horizontal[0, 0]) ==\
    \ 1\n    doAssert residue(vertical[0, 0]) == 1\n    var flatInput = @[one, two,\
    \ three, T.init(4)]\n    let flat = initMatrix[T](2, 2, flatInput)\n    flatInput[0]\
    \ = T.init(90)\n    doAssert flat == a\n\n    var b = a\n    b[0, 0] = T.init(8)\n\
    \    b[1][1] += one\n    doAssert residue(a[0, 0]) == 1 and residue(a[1, 1]) ==\
    \ 4\n    doAssert residue(b[0, 0]) == 8 and residue(b[1, 1]) == 5\n    b[0] =\
    \ @[three, two]\n    doAssert residue(b[0, 0]) == 3 and residue(b[0, 1]) == 2\n\
    \    b[0] = b[1]\n    doAssert toSeq(b[0]).mapIt(residue(it)) == @[3u64, 5u64]\n\
    \n    var owner = a\n    var mutableRow = owner[0]\n    let copiedAfterView =\
    \ owner\n    mutableRow[0] = T.init(9)\n    for x in mutableRow.mitems: x += one\n\
    \    doAssert residue(owner[0, 0]) == 10 and residue(owner[0, 1]) == 3\n    doAssert\
    \ residue(copiedAfterView[0, 0]) == 1\n    var copiedRow = mutableRow\n    copiedRow[1]\
    \ = T.init(6)\n    doAssert residue(owner[0, 1]) == 6\n    var detached = toSeq(mutableRow)\n\
    \    detached[0] = zero\n    doAssert residue(owner[0, 0]) == 10\n    owner =\
    \ initMatrix[T](1, 1, zero)\n    mutableRow[0] = T.init(7)\n    doAssert residue(mutableRow[0])\
    \ == 7 and residue(owner[0, 0]) == 0\n    let temporaryRow = (a * a)[0]\n    doAssert\
    \ toSeq(temporaryRow).mapIt(residue(it)) == @[7u64, 10u64]\n    let scopedRow\
    \ = block:\n        let temporaryOwner = a * a\n        temporaryOwner[1]\n  \
    \  doAssert toSeq(scopedRow).mapIt(residue(it)) == @[15u64, 22u64]\n\n    checkEntries(a\
    \ + a, [2u64, 4, 6, 8])\n    checkEntries(a - a, [0u64, 0, 0, 0])\n    checkEntries(a\
    \ + three, [4u64, 5, 6, 7])\n    checkEntries(three + a, [4u64, 5, 6, 7])\n  \
    \  checkEntries(a * three, [3u64, 6, 9, 12])\n    checkEntries(three * a, [3u64,\
    \ 6, 9, 12])\n    checkEntries(5 - a, [4u64, 3, 2, 1])\n    checkEntries(a + 3,\
    \ [4u64, 5, 6, 7])\n    checkEntries(3 + a, [4u64, 5, 6, 7])\n    checkEntries(3\
    \ * a, [3u64, 6, 9, 12])\n    doAssert (a - three) + three == a\n    doAssert\
    \ -(-a) == a\n    b = a\n    b += a\n    doAssert b == a + a\n    b -= a\n   \
    \ doAssert b == a\n    b += three\n    b -= three\n    b *= three\n    doAssert\
    \ b == a * three\n    doAssert a == source.toMatrix\n\n    let p = T.umod.uint64\n\
    \    var scalarMatrix = initMatrix[T](1, 1, high(uint64))\n    doAssert residue(scalarMatrix[0,\
    \ 0]) == high(uint64) mod p\n    scalarMatrix[0][0] = low(int64)\n    let signedResidue\
    \ = ((low(int64) mod p.int64) + p.int64).uint64 mod p\n    doAssert residue(scalarMatrix[0,\
    \ 0]) == signedResidue\n    scalarMatrix += high(uint64)\n    doAssert residue(scalarMatrix[0,\
    \ 0]) == (signedResidue + high(uint64) mod p) mod p\n    scalarMatrix -= high(uint64)\n\
    \    scalarMatrix *= high(uint64)\n    doAssert residue(scalarMatrix[0, 0]) ==\
    \ signedResidue * (high(uint64) mod p) mod p\n\n    let identity = identity_matrix[T](2)\n\
    \    doAssert identity == identity_matrix[T](2, one, zero)\n    doAssert identity.sum.residue\
    \ == 2\n    var expected = identity\n    for exponent in 0 .. 7:\n        if exponent\
    \ in [0, 1, 2, 7]:\n            doAssert a.pow(exponent) == expected\n       \
    \     doAssert (a ** exponent) == expected\n        let values = naiveProduct(expected,\
    \ a)\n        for i in 0 ..< 2:\n            for j in 0 ..< 2:\n             \
    \   expected[i, j] = T.init(values[i * 2 + j].int)\n    b = a\n    let square\
    \ = naiveProduct(a, a)\n    b *= b\n    checkEntries(b, square)\n    doAssert\
    \ a == source.toMatrix\n\n    var st = initHashSet[Matrix[T]]()\n    st.incl(a)\n\
    \    st.incl(source.toMatrix)\n    st.incl(a + a)\n    doAssert st.len == 2\n\
    \    doAssert hash(a) == hash(source.toMatrix)\n    let redundant = (a + T.init(T.umod.int\
    \ - 1)) + one\n    doAssert redundant == a and hash(redundant) == hash(a)\n  \
    \  checkProduct(-a, redundant)\n\nproc checkBoundaries[T]() =\n    ## \u30D6\u30ED\
    \u30C3\u30AF\u3068Strassen\u5206\u5272\u306E\u5883\u754C\u3092\u4F4E\u30E9\u30F3\
    \u30AF\u884C\u5217\u306E\u9589\u5F62\u5F0F\u3067\u691C\u8A3C\u3059\u308B\u3002\
    \n    for size in [65, 129, 257]:\n        let h = size\n        let w = size\
    \ + 2\n        let k = size - 1\n        var a = initMatrix[T](h, w, T.init(0))\n\
    \        var b = initMatrix[T](w, k, T.init(0))\n        var inner = 0u64\n  \
    \      for t in 0 ..< w:\n            inner += ((t mod 7 + 1) * (t mod 5 + 1)).uint64\n\
    \        for i in 0 ..< h:\n            for t in 0 ..< w:\n                a[i,\
    \ t] = (T.init((i + 1) * (t mod 7 + 1)) -\n                    T.init(T.umod.int\
    \ - 1)) - T.init(1)\n        for t in 0 ..< w:\n            for j in 0 ..< k:\n\
    \                b[t, j] = T.init((t mod 5 + 1) * (j + 1))\n        let c = a\
    \ * b\n        doAssert c.h == h and c.w == k\n        for i in 0 ..< h:\n   \
    \         for j in 0 ..< k:\n                doAssert residue(c[i, j]) ==\n  \
    \                  ((i + 1).uint64 * (j + 1).uint64 * inner) mod T.umod.uint64\n\
    \ntemplate expectAssertion(body: untyped) =\n    block:\n        var caught =\
    \ false\n        try:\n            body\n        except AssertionDefect:\n   \
    \         caught = true\n        doAssert caught\n\nproc checkRawAndJoin[T]()\
    \ =\n    ## \u516C\u958B\u5024\u306E\u4E00\u62EC\u5909\u63DB\u306E\u6240\u6709\
    \u6A29\u3068\u5404\u6841\u5883\u754C\u306E\u884C\u51FA\u529B\u3092\u691C\u8A3C\
    \u3059\u308B\u3002\n    let p = T.umod\n    var boundaries: seq[uint32]\n    for\
    \ value in [0u32, 9, 10, 99, 100, 999, 1000, 9999, 10000,\n            99999999,\
    \ 100000000]:\n        if value < p: boundaries.add(value)\n    boundaries.add(p\
    \ - 1)\n    var raw = boundaries\n    for i in countdown(boundaries.high, 0):\
    \ raw.add(boundaries[i])\n    let saved = raw.mapIt(it)\n    let a = initMatrix[T](2,\
    \ boundaries.len, raw)\n    doAssert raw == saved\n    checkEntries(a, saved.mapIt(it.uint64))\n\
    \    raw[0] = p - 1\n    doAssert residue(a[0, 0]) == saved[0].uint64\n    var\
    \ b = initMatrix[T](2, boundaries.len, raw)\n    b[0, 0] = T.init(0)\n    doAssert\
    \ raw[0] == p - 1\n    for row in 0 ..< a.h:\n        var strings: seq[string]\n\
    \        for column in 0 ..< a.w:\n            strings.add(system.`$`(saved[row\
    \ * a.w + column].uint64))\n        for separator in [\"\", \" \", \" / \", \"\
    \\0x\"]:\n            let expected = strutils.join(strings, separator)\n     \
    \       doAssert a[row].join(separator) == expected\n            var mutable =\
    \ a\n            doAssert mutable[row].join(separator) == expected\n         \
    \   let redundant = (a + T.init(p.int - 1)) + T.init(1)\n            doAssert\
    \ redundant[row].join(separator) == expected\n\n    for width in [0, 1, 3, 7,\
    \ 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65]:\n        var values = newSeq[uint32](width\
    \ + 2)\n        for i in 0 ..< values.len: values[i] = boundaries[i mod boundaries.len]\n\
    \        let savedValues = values.mapIt(it)\n        let fromSlice = initMatrix[T](1,\
    \ width, values.toOpenArray(1, width))\n        doAssert values == savedValues\n\
    \        for j in 0 ..< width:\n            doAssert residue(fromSlice[0, j])\
    \ == savedValues[j + 1].uint64\n        let zeros = initMatrix[T](1, width)\n\
    \        let expected = newSeq[uint64](width)\n        checkEntries(zeros, expected)\n\
    \        doAssert zeros == initMatrix[T](1, width, T.init(0))\n        if width\
    \ == 0:\n            for separator in [\"\", \" \", \" / \", \"\\0x\"]:\n    \
    \            doAssert fromSlice[0].join(separator) == \"\"\n    let empty = newSeq[uint32]()\n\
    \    let zeroHeight = initMatrix[T](0, 7, empty)\n    let zeroWidth = initMatrix[T](4,\
    \ 0, empty)\n    doAssert zeroHeight.h == 0 and zeroHeight.w == 7\n    doAssert\
    \ zeroWidth.h == 4 and zeroWidth.w == 0\n    doAssert zeroWidth[3].join(\" / \"\
    ) == \"\"\n    let fromArray = initMatrix[T](1, 3, [0u32, p - 1, 0u32])\n    checkEntries(fromArray,\
    \ [0u64, (p - 1).uint64, 0u64])\n    let fromTemporary = initMatrix[T](1, 3, @[0u32,\
    \ p - 1, 0u32])\n    doAssert fromTemporary == fromArray\n    let fromScope =\
    \ block:\n        let local = @[0u32, p - 1, 0u32]\n        initMatrix[T](1, 3,\
    \ local)\n    doAssert fromScope == fromArray\n    var moveInput = @[0u32, p -\
    \ 1, 0u32]\n    let keptInput = moveInput.mapIt(it)\n    var fromMove = initMatrix[T](1,\
    \ 3, move(moveInput))\n    doAssert moveInput.len == 0\n    doAssert fromMove\
    \ == fromArray\n    fromMove[0, 1] = T.init(0)\n    doAssert keptInput == @[0u32,\
    \ p - 1, 0u32]\n    var moveEmpty = newSeq[uint32]()\n    let fromMoveEmpty =\
    \ initMatrix[T](3, 0, move(moveEmpty))\n    doAssert moveEmpty.len == 0\n    doAssert\
    \ fromMoveEmpty.h == 3 and fromMoveEmpty.w == 0\n    expectAssertion:\n      \
    \  discard initMatrix[T](1, 2, empty)\n    expectAssertion:\n        discard initMatrix[T](0,\
    \ 7, @[0u32])\n    expectAssertion:\n        discard initMatrix[T](1, 2, @[0u32,\
    \ 0u32, 0u32])\n\nproc checkWriteRows[T]() =\n    ## \u884C\u306E\u76F4\u63A5\u51FA\
    \u529B\u3092\u7A7A\u884C\u3068\u56FA\u5B9A\u30D0\u30C3\u30D5\u30A1\u306E\u5883\
    \u754C\u3067\u6587\u5B57\u5217\u51FA\u529B\u3068\u6BD4\u8F03\u3059\u308B\u3002\
    \n    let (output, path) = createTempFile(\"matrix_avx2_write_row_\", \".tmp\"\
    )\n    defer:\n        close(output)\n        removeFile(path)\n    var expected\
    \ = \"\"\n    let p = T.umod\n    let values = [0u32, 9, 10, 9999, 10000, 99999999,\
    \ 100000000, p - 1]\n    for width in [0, 1, 1023, 1024, 1025, 2049]:\n      \
    \  var raw = newSeq[uint32](2 * width)\n        for i in 0 ..< raw.len: raw[i]\
    \ = values[i mod values.len] mod p\n        var a = initMatrix[T](2, width, raw)\n\
    \        a[0].writeRow(output)\n        expected.add(a[0].join(\" \") & \"\\n\"\
    )\n        let immutable = (a + T.init(p.int - 1)) + T.init(1)\n        immutable[1].writeRow(output)\n\
    \        expected.add(immutable[1].join(\" \") & \"\\n\")\n    flushFile(output)\n\
    \    setFilePos(output, 0)\n    doAssert readAll(output) == expected\n\nproc checkShapes()\
    \ =\n    ## \u7A7A\u884C\u5217\u306E\u5F62\u72B6\u4FDD\u5B58\u3068\u4E0D\u6B63\
    \u306A\u6B21\u5143\u306E\u62D2\u5426\u3092\u78BA\u8A8D\u3059\u308B\u3002\n   \
    \ type T = modint998244353_montgomery\n    let zero = T.init(0)\n    for shape\
    \ in [(0, 0, 0), (0, 3, 7), (4, 0, 5), (3, 2, 0)]:\n        let (h, w, k) = shape\n\
    \        let a = initMatrix[T](h, w, zero)\n        let b = initMatrix[T](w, k,\
    \ zero)\n        checkProduct(a, b)\n        doAssert a.h == h and a.w == w\n\
    \    let empty = identity_matrix[T](0)\n    doAssert empty.h == 0 and empty.w\
    \ == 0\n    doAssert empty.pow(0) == empty\n    doAssert residue(empty.sum) ==\
    \ 0\n    var zeroWidth = initMatrix[T](3, 0, zero)\n    doAssert zeroWidth[0].len\
    \ == 0\n    zeroWidth[1] = newSeq[T]()\n    expectAssertion:\n        discard\
    \ initMatrix[T](-1, 2, zero)\n    expectAssertion:\n        discard initMatrix[T](2,\
    \ 3, @[zero])\n    expectAssertion:\n        discard initMatrix(@[@[zero], @[zero,\
    \ zero]])\n    expectAssertion:\n        discard initMatrix[T](2, 3, zero) * initMatrix[T](2,\
    \ 1, zero)\n    expectAssertion:\n        discard initMatrix[T](2, 3, zero) +\
    \ initMatrix[T](2, 1, zero)\n    expectAssertion:\n        var a = initMatrix[T](2,\
    \ 3, zero)\n        a[0] = @[zero]\n    expectAssertion:\n        discard initMatrix[T](2,\
    \ 3, zero).pow(2)\n    expectAssertion:\n        discard identity_matrix[T](2).pow(-1)\n\
    \nproc checkDynamicModulus() =\n    ## \u884C\u5217\u306E\u4F5C\u6210\u5F8C\u306B\
    mod\u3092\u5909\u3048\u305F\u5834\u5408\u306F\u7A4D\u3067\u8AA4\u3063\u305F\u5024\
    \u3092\u8A08\u7B97\u3057\u306A\u3044\u3002\n    modint_montgomery.setMod(998244353)\n\
    \    let montgomeryMatrix = identity_matrix[modint_montgomery](2)\n    modint_montgomery.setMod(1000000007)\n\
    \    expectAssertion:\n        discard montgomeryMatrix * montgomeryMatrix\n \
    \   modint_montgomery.setMod(998244353)\n    doAssert montgomeryMatrix * montgomeryMatrix\
    \ == montgomeryMatrix\n    modint_barrett.setMod(1000000007)\n    let barrettMatrix\
    \ = identity_matrix[modint_barrett](2)\n    modint_barrett.setMod(998244353)\n\
    \    expectAssertion:\n        discard barrettMatrix * barrettMatrix\n    modint_barrett.setMod(1000000007)\n\
    \    doAssert barrettMatrix * barrettMatrix == barrettMatrix\n\ncheckApi[modint998244353_montgomery]()\n\
    checkApi[modint1000000007_montgomery]()\ncheckApi[modint998244353_barrett]()\n\
    checkApi[modint1000000007_barrett]()\ncheckRawAndJoin[modint998244353_montgomery]()\n\
    checkRawAndJoin[modint1000000007_montgomery]()\ncheckRawAndJoin[modint998244353_barrett]()\n\
    checkRawAndJoin[modint1000000007_barrett]()\ncheckWriteRows[modint998244353_montgomery]()\n\
    checkWriteRows[modint1000000007_montgomery]()\ncheckWriteRows[modint998244353_barrett]()\n\
    checkWriteRows[modint1000000007_barrett]()\ncheckRandom[StaticMontgomeryModint[1u32]](0)\n\
    checkRandom[StaticMontgomeryModint[3u32]](1)\ncheckRandom[modint998244353_montgomery](2)\n\
    checkRandom[modint1000000007_montgomery](3)\ncheckRandom[StaticMontgomeryModint[1073741823u32]](4)\n\
    checkRandom[StaticBarrettModint[1u32]](5)\ncheckRandom[StaticBarrettModint[3u32]](6)\n\
    checkRandom[modint998244353_barrett](7)\ncheckRandom[modint1000000007_barrett](8)\n\
    checkRandom[StaticBarrettModint[1073741823u32]](9)\nfor modulus in [1, 3, 998244353,\
    \ 1000000007, 1073741823]:\n    modint_montgomery.setMod(modulus)\n    modint_barrett.setMod(modulus)\n\
    \    checkRandom[modint_montgomery](modulus.int64)\n    checkRandom[modint_barrett](modulus.int64\
    \ + 1)\n    checkRawAndJoin[modint_montgomery]()\n    checkRawAndJoin[modint_barrett]()\n\
    \    checkWriteRows[modint_montgomery]()\n    checkWriteRows[modint_barrett]()\n\
    modint_montgomery.setMod(998244353)\nmodint_barrett.setMod(1000000007)\ncheckApi[modint_montgomery]()\n\
    checkApi[modint_barrett]()\ncheckBoundaries[modint998244353_montgomery]()\ncheckBoundaries[modint1000000007_barrett]()\n\
    checkShapes()\ncheckDynamicModulus()\necho \"Hello World\"\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/matrix/matrix_avx2_unit_test.nim
  requiredBy: []
  timestamp: '2026-09-08 11:57:55+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_avx2_unit_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_avx2_unit_test.nim
- /verify/verify/matrix/matrix_avx2_unit_test.nim.html
title: verify/matrix/matrix_avx2_unit_test.nim
---
