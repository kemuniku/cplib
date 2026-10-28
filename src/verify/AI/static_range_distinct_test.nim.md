---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/static_range_distinct.nim
    title: cplib/collections/static_range_distinct.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/static_range_distinct.nim
    title: cplib/collections/static_range_distinct.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
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
    import cplib/collections/static_range_distinct\nimport random, hashes\n\nproc\
    \ naive[T](a: openArray[T], l, r: int): int =\n    var seen: seq[T]\n    for i\
    \ in l..<r:\n        if a[i] notin seen:\n            seen.add(a[i])\n    seen.len\n\
    \nvar rng = initRand(20261022)\n\nproc check[T](a: openArray[T]) =\n    let d\
    \ = initStaticRangeDistinct(a)\n    doAssert d.len == a.len\n    var intervals:\
    \ seq[tuple[l, r: int]]\n    for l in 0..a.len:\n        for r in l..a.len:\n\
    \            intervals.add((l, r))\n    rng.shuffle(intervals)\n    for (l, r)\
    \ in intervals:\n        doAssert d.count(l, r) == naive(a, l, r)\n\ncheck(newSeq[int]())\n\
    check(@[1])\ncheck(@[int.low, int.high, 0, int.low, int.high])\ncheck(@[0'u64,\
    \ uint64.high, 1'u64 shl 63, uint64.high])\ncheck(@[\"\", \"\u65E5\u672C\u8A9E\
    \", \"abc\", \"\u65E5\u672C\u8A9E\", \"\"])\ncheck(@[(1, \"a\"), (2, \"b\"), (1,\
    \ \"a\")])\n\ntype CollisionKey = object\n    value: int\nproc hash(x: CollisionKey):\
    \ Hash = Hash(0)\ncheck(@[CollisionKey(value: 1), CollisionKey(value: 2), CollisionKey(value:\
    \ 1)])\n\nproc checkCompared[T](a: openArray[T], keys: openArray[int], cmp: proc(a,\
    \ b: T): int) =\n    let d = initStaticRangeDistinct(a, cmp)\n    doAssert d.len\
    \ == a.len\n    for l in 0..a.len:\n        for r in l..a.len:\n            doAssert\
    \ d.count(l, r) == naive(keys, l, r)\n\ntype CompareOnly = object\n    value:\
    \ int\nproc hash(x: CompareOnly): Hash {.error: \"hash \u306F\u4F7F\u7528\u3067\
    \u304D\u307E\u305B\u3093\".}\nproc `==`(a, b: CompareOnly): bool {.error: \"==\
    \ \u306F\u4F7F\u7528\u3067\u304D\u307E\u305B\u3093\".}\nproc cmp(a, b: CompareOnly):\
    \ int = cmp(a.value, b.value)\n\ndoAssert not compiles(hash(CompareOnly(value:\
    \ 0)))\ndoAssert not compiles(CompareOnly(value: 0) == CompareOnly(value: 0))\n\
    for keys in [newSeq[int](), @[1], @[2, 1, 2, 3, 1], @[1, 1, 1]]:\n    var a: seq[CompareOnly]\n\
    \    for key in keys:\n        a.add(CompareOnly(value: key))\n    let d = initStaticRangeDistinct(a)\n\
    \    for l in 0..a.len:\n        for r in l..a.len:\n            doAssert d.count(l,\
    \ r) == naive(keys, l, r)\n    checkCompared(a, keys, cmp)\n\ncheckCompared(@[(1,\
    \ \"a\"), (2, \"b\"), (1, \"c\"), (2, \"d\")], @[1, 2, 1, 2],\n    proc(a, b:\
    \ (int, string)): int = cmp(a[0], b[0]))\ncheckCompared(@[int.low, int.high, 0,\
    \ int.low], @[0, 1, 2, 0],\n    proc(a, b: int): int = cmp(b, a))\nlet modulus\
    \ = 3\ncheckCompared(@[1, 4, 2, 5, 3, 6], @[1, 1, 2, 2, 0, 0],\n    proc(a, b:\
    \ int): int = cmp(a mod modulus, b mod modulus))\n\nfor n in [2, 3, 7, 8, 15,\
    \ 16, 63, 64, 65, 127, 128, 129]:\n    var equal = newSeq[int](n)\n    var unique\
    \ = newSeq[int](n)\n    var alternating = newSeq[int](n)\n    for i in 0..<n:\n\
    \        equal[i] = -17\n        unique[i] = i - n\n        alternating[i] = i\
    \ mod 2\n    check(equal)\n    check(unique)\n    check(alternating)\n\nfor trial\
    \ in 0..<100:\n    var a = newSeq[int](rng.rand(45))\n    for x in a.mitems:\n\
    \        x = rng.rand(20) - 10\n    check(a)\n    checkCompared(a, a, proc(a,\
    \ b: int): int = cmp(a, b))\n\nfor n in [255, 256, 257, 1024, 4097]:\n    var\
    \ a = newSeq[int](n)\n    for x in a.mitems:\n        x = rng.rand(99) - 50\n\
    \    let d = initStaticRangeDistinct(a)\n    let compared = initStaticRangeDistinct(a,\
    \ proc(a, b: int): int = cmp(a, b))\n    var previousAnswer = 0\n    for q in\
    \ 0..<500:\n        let x = (rng.rand(n) + previousAnswer) mod (n+1)\n       \
    \ let y = (rng.rand(n) + previousAnswer) mod (n+1)\n        let l = min(x, y)\n\
    \        let r = max(x, y)\n        previousAnswer = d.count(l, r)\n        doAssert\
    \ previousAnswer == naive(a, l, r)\n        doAssert compared.count(l, r) == previousAnswer\n\
    \nvar input = @[1, 2, 1]\nlet snapshot = initStaticRangeDistinct(input)\nlet comparedSnapshot\
    \ = initStaticRangeDistinct(input, proc(a, b: int): int = cmp(a, b))\ninput[1]\
    \ = 1\ndoAssert snapshot.count(0, 3) == 2\ndoAssert comparedSnapshot.count(0,\
    \ 3) == 2\nlet zero: StaticRangeDistinct = default(StaticRangeDistinct)\ndoAssert\
    \ zero.len == 0\ndoAssert zero.count(0, 0) == 0\nwhen compileOption(\"assertions\"\
    ):\n    for interval in [(-1, 0), (0, 4), (2, 1), (4, 4)]:\n        var caught\
    \ = false\n        try:\n            discard snapshot.count(interval[0], interval[1])\n\
    \        except AssertionDefect:\n            caught = true\n        doAssert\
    \ caught\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/static_range_distinct.nim
  - cplib/collections/static_range_distinct.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  isVerificationFile: true
  path: verify/AI/static_range_distinct_test.nim
  requiredBy: []
  timestamp: '2026-10-25 20:56:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_range_distinct_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_range_distinct_test.nim
- /verify/verify/AI/static_range_distinct_test.nim.html
title: verify/AI/static_range_distinct_test.nim
---
