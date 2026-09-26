---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/avx512utils.nim
    title: cplib/utils/avx512utils.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/avx512utils.nim
    title: cplib/utils/avx512utils.nim
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
    import cplib/utils/avx512utils\nimport random\n\nproc checkType[T: Avx512Integer]()\
    \ =\n    var rng = initRand(512)\n    for size in 0..143:\n        let n = if\
    \ size <= 140: size else: [1023, 1024, 4097][size-141]\n        var a, b = newSeq[T](n)\n\
    \        for i in 0..<n:\n            a[i] = cast[T](rng.next())\n           \
    \ b[i] = cast[T](rng.next())\n        if n > 1:\n            a[0] = low(T)\n \
    \           a[n - 1] = high(T)\n        let add = avx512Add(a, b)\n        let\
    \ sub = avx512Sub(a, b)\n        let mn = avx512Min(a, b)\n        let mx = avx512Max(a,\
    \ b)\n        let ba = avx512And(a, b)\n        let bo = avx512Or(a, b)\n    \
    \    let bx = avx512Xor(a, b)\n        var dst = newSeq[T](n)\n        avx512Add(a,\
    \ b, dst)\n        doAssert dst == add\n        for i in 0..<n:\n            when\
    \ T is SomeUnsignedInt:\n                doAssert add[i] == a[i] + b[i]\n    \
    \            doAssert sub[i] == a[i] - b[i]\n            else:\n             \
    \   doAssert add[i] == a[i] +% b[i]\n                doAssert sub[i] == a[i] -%\
    \ b[i]\n            doAssert mn[i] == min(a[i], b[i])\n            doAssert mx[i]\
    \ == max(a[i], b[i])\n            doAssert ba[i] == (a[i] and b[i])\n        \
    \    doAssert bo[i] == (a[i] or b[i])\n            doAssert bx[i] == (a[i] xor\
    \ b[i])\n        if n > 0:\n            var lo = a[0]\n            var hi = a[0]\n\
    \            for x in a:\n                lo = min(lo, x)\n                hi\
    \ = max(hi, x)\n            doAssert avx512Min(a) == lo\n            doAssert\
    \ avx512Max(a) == hi\n            if n > 2:\n                avx512Sub(a.toOpenArray(1,\
    \ n-2), b.toOpenArray(1, n-2), dst.toOpenArray(1, n-2))\n                for i\
    \ in 1..<n-1: doAssert dst[i] == sub[i]\n                lo = a[1]\n         \
    \       hi = a[1]\n                for i in 1..<n-1:\n                    lo =\
    \ min(lo, a[i])\n                    hi = max(hi, a[i])\n                doAssert\
    \ avx512Min(a.toOpenArray(1, n-2)) == lo\n                doAssert avx512Max(a.toOpenArray(1,\
    \ n-2)) == hi\n        avx512Xor(a, b, a)\n        doAssert a == bx\n        let\
    \ expected = avx512Xor(a, b)\n        avx512Xor(a, b, b)\n        doAssert b ==\
    \ expected\n        avx512Sub(a, a, a)\n        for x in a: doAssert x == 0\n\
    \    var emptyA, emptyB: array[0, T]\n    let emptyResult: array[0, T] = avx512And(emptyA,\
    \ emptyB)\n    doAssert emptyResult.len == 0\n    var offsetA, offsetB: array[5..8,\
    \ T]\n    offsetA[5] = T(12)\n    offsetB[5] = T(3)\n    let offsetResult: array[5..8,\
    \ T] = avx512Xor(offsetA, offsetB)\n    doAssert offsetResult[5] == T(15)\n  \
    \  var a, b: array[32, T]\n    for i in 0..<32:\n        a[i] = T(i)\n       \
    \ b[i] = T(31-i)\n    let c: array[32, T] = avx512Add(a, b)\n    for x in c: doAssert\
    \ x == 31\n    doAssert avx512Min(a) == 0\n    doAssert avx512Max(a) == 31\n \
    \   var failed = false\n    try: discard avx512Min(newSeq[T]())\n    except ValueError:\
    \ failed = true\n    doAssert failed\n    failed = false\n    try: discard avx512Max(newSeq[T]())\n\
    \    except ValueError: failed = true\n    doAssert failed\n    failed = false\n\
    \    try: discard avx512Add(@[T(1)], newSeq[T]())\n    except ValueError: failed\
    \ = true\n    doAssert failed\n    failed = false\n    var dst = @[T(42)]\n  \
    \  try: avx512Add(newSeq[T](), newSeq[T](), dst)\n    except ValueError: failed\
    \ = true\n    doAssert failed and dst == @[T(42)]\n\ncheckType[int8]()\ncheckType[uint8]()\n\
    checkType[int16]()\ncheckType[uint16]()\ncheckType[int32]()\ncheckType[uint32]()\n\
    checkType[int64]()\ncheckType[uint64]()\ncheckType[int]()\ncheckType[uint]()\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/utils/avx512utils.nim
  - cplib/utils/avx512utils.nim
  isVerificationFile: true
  path: verify/AI/avx512utils_test.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:49+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/avx512utils_test.nim
layout: document
redirect_from:
- /verify/verify/AI/avx512utils_test.nim
- /verify/verify/AI/avx512utils_test.nim.html
title: verify/AI/avx512utils_test.nim
---
