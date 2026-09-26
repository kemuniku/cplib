---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
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
    path: cplib/math/modfast.nim
    title: cplib/math/modfast.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/modfast.nim
    title: cplib/math/modfast.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primitive_root.nim
    title: cplib/math/primitive_root.nim
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
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
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
    import random\nimport cplib/math/modfast\nimport cplib/math/powmod\nimport cplib/modint/modint\n\
    \ntype TestMint = DynamicBarrettModint[20260914u32]\n\nproc checkAll(p: int) =\n\
    \    TestMint.setMod(p)\n    let table = initModFast[TestMint]()\n    doAssert\
    \ table.p == p\n    var x = 1\n    for e in 0..<p - 1:\n        doAssert table.log(x)\
    \ == e\n        doAssert table.powRoot(e).val == x\n        doAssert x * table.inv(x).val\
    \ mod p == 1\n        doAssert table.pow(x, -1).val == table.inv(x).val\n    \
    \    if p < 100:\n            for k in 0..2 * p:\n                doAssert table.pow(x,\
    \ k).val == powmod(x, k, p)\n        x = x * table.root.val mod p\n    doAssert\
    \ table.pow(0, 0).val == 1\n    doAssert table.pow(0, p - 1).val == 0\n    doAssert\
    \ table.powRoot(-1).val * table.root.val mod p == 1\n\nfor p in [2, 3, 5, 7, 11,\
    \ 17, 31, 61, 67, 97, 127, 257, 509, 1021,\n          4093, 65537, 100003]:\n\
    \    checkAll(p)\n\nvar rng = initRand(123456789)\nfor p in [998244353, 1000000007,\
    \ 1000000009, 1073741789]:\n    TestMint.setMod(p)\n    let table = initModFast[TestMint]()\n\
    \    var width = 1\n    while width * width * width < p: width *= 2\n    var boundary\
    \ = width\n    while boundary < p:\n        for x in max(1, boundary - 1)..min(p\
    \ - 1, boundary + 1):\n            doAssert table.powRoot(table.log(x)).val ==\
    \ x\n        boundary += width\n    for i in 0..<20000:\n        let x = if i\
    \ < 1024: i + 1 elif i < 2048: p - (i - 1023) else: rng.rand(1..p - 1)\n     \
    \   let e = rng.rand(high(int))\n        let logarithm = table.log(x)\n      \
    \  doAssert logarithm >= 0 and logarithm < p - 1\n        doAssert powmod(table.root.val,\
    \ logarithm, p) == x\n        doAssert table.powRoot(e).val == powmod(table.root.val,\
    \ e, p)\n        doAssert table.inv(x).val == powmod(x, p - 2, p)\n        doAssert\
    \ table.pow(x, e).val == powmod(x, e, p)\n        doAssert table.pow(x, -e).val\
    \ == powmod(table.inv(x).val, e, p)\n    for e in [low(int), high(int), -p, -1,\
    \ 0, 1, p - 1, p]:\n        let reduced = ((e mod (p - 1)) + p - 1) mod (p - 1)\n\
    \        doAssert table.powRoot(e).val == powmod(table.root.val, reduced, p)\n\
    \        doAssert table.pow(2, e).val == powmod(2, reduced, p)\n\nproc checkMint[T:\
    \ BarrettModint or MontgomeryModint]() =\n    let table: ModFast[T] = initModFast[T]()\n\
    \    static:\n        doAssert typeof(table.root) is T\n        doAssert typeof(table.inv(1))\
    \ is T\n        doAssert typeof(table.pow(1, 0)) is T\n        doAssert typeof(table.powRoot(0))\
    \ is T\n        doAssert typeof(table.log(init(T, 1))) is int\n    let p = T.umod.int\n\
    \    for i in 1..1000:\n        let x = init(T, i mod (p - 1) + 1)\n        let\
    \ e = i * 123456789\n        doAssert table.inv(x).val == powmod(x.val, p - 2,\
    \ p)\n        doAssert table.pow(x, e).val == powmod(x.val, e, p)\n        doAssert\
    \ table.powRoot(table.log(x)).val == x.val\n    doAssert table.pow(init(T, 0),\
    \ 0).val == 1\n    doAssert table.inv(init(T, -1)).val == p - 1\n\ncheckMint[StaticBarrettModint[2u32]]()\n\
    checkMint[StaticMontgomeryModint[3u32]]()\ncheckMint[modint998244353_barrett]()\n\
    checkMint[modint998244353_montgomery]()\ncheckMint[modint1000000007_barrett]()\n\
    checkMint[modint1000000007_montgomery]()\ntype DynamicMint = DynamicMontgomeryModint[20260914u32]\n\
    DynamicMint.setMod(1000000007)\ncheckMint[DynamicMint]()\n\nwhen compileOption(\"\
    assertions\"):\n    TestMint.setMod(17)\n    let old = initModFast[TestMint]()\n\
    \    TestMint.setMod(19)\n    var rejected = false\n    try:\n        discard\
    \ old.inv(init(TestMint, 2))\n    except AssertionDefect:\n        rejected =\
    \ true\n    doAssert rejected\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/primefactor.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/modfast.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/powmod.nim
  - cplib/math/powmod.nim
  - cplib/math/modfast.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/str/run_length_encode.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/primitive_root.nim
  - cplib/math/isprime.nim
  - cplib/math/primefactor.nim
  - cplib/math/isqrt.nim
  - cplib/math/primitive_root.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/inner_math.nim
  - cplib/math/inner_math.nim
  isVerificationFile: true
  path: verify/math/modfast_test.nim
  requiredBy: []
  timestamp: '2026-09-18 02:04:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/modfast_test.nim
layout: document
redirect_from:
- /verify/verify/math/modfast_test.nim
- /verify/verify/math/modfast_test.nim.html
title: verify/math/modfast_test.nim
---
