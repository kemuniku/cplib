---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_segtree.nim
    title: cplib/collections/compressed_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_segtree.nim
    title: cplib/collections/compressed_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
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
    import cplib/collections/compressed_segtree\nimport random, algorithm\n\nproc\
    \ merge(x, y: int64): int64 = x + y\n\nblock:\n    let st = initCompressedSegmentTree([9'i64,\
    \ -1000000000000, 9, 1000000000000], merge, 0'i64)\n    doAssert st.len == 3\n\
    \    st[-1000000000000'i64] = 4\n    st[9'i64] = 7\n    st[1000000000000'i64]\
    \ = 11\n    doAssert st.get(-1000000000001'i64, 10'i64) == 11\n    doAssert st[8'i64]\
    \ == 0\n    doAssert st.get_all() == 22\n    doAssert st[low(int64)..high(int64)]\
    \ == 22\n    doAssert st.get(9'i64, 9'i64) == 0\n    doAssert st[10'i64..<10'i64]\
    \ == 0\n    var rejected = false\n    try: st[8'i64] = 1\n    except AssertionDefect:\
    \ rejected = true\n    doAssert rejected\n\nblock:\n    let st = initCompressedSegmentTree(newSeq[int](),\
    \ merge, 0'i64)\n    doAssert st.len == 0 and st.get_all() == 0\n    doAssert\
    \ st.get(-100, 100) == 0 and st[0] == 0\n\nblock:\n    proc concat(x, y: string):\
    \ string = x & y\n    let st = initCompressedSegmentTree([\"z\", \"a\", \"m\"\
    , \"a\"], concat, \"\",\n        proc(x: string): string = x)\n    doAssert st.get_all()\
    \ == \"amz\"\n    doAssert st.get(\"b\", \"zz\") == \"mz\"\n    st[\"m\"] = \"\
    M\"\n    doAssert st[\"a\"..\"m\"] == \"aM\"\n\nblock:\n    var rng = initRand(20260914)\n\
    \    for n in 0..40:\n        var coords: seq[int] = @[]\n        for i in 0..<n:\
    \ coords.add(i * 7 - 100)\n        let st = initCompressedSegmentTree(coords,\
    \ merge, 0'i64)\n        var values = newSeq[int64](n)\n        for step in 0..<300:\n\
    \            if n > 0 and rng.rand(2) == 0:\n                let i = rng.rand(n\
    \ - 1)\n                values[i] = int64(rng.rand(-100..100))\n             \
    \   st[coords[i]] = values[i]\n                doAssert st[coords[i]] == values[i]\n\
    \            var l = rng.rand(-120..220)\n            var r = rng.rand(-120..220)\n\
    \            if r < l: swap(l, r)\n            var expected, total: int64\n  \
    \          for i, x in coords:\n                total += values[i]\n         \
    \       if l <= x and x < r: expected += values[i]\n            doAssert st.get(l,\
    \ r) == expected\n            doAssert st.get_all() == total\n\nblock:\n    let\
    \ st = newCompressedSegWith([30, 10, 20, 10], l & r, \"\",\n        proc(x: int):\
    \ string = $x)\n    doAssert $st == \"10 20 30\"\n    doAssert st[10..20] == \"\
    1020\"\n    let empty = newCompressedSegWith(newSeq[int](), l + r, 0)\n    doAssert\
    \ $empty == \"\"\n\nblock:\n    proc concat(x, y: string): string = x & y\n  \
    \  for n in 0..17:\n        var coords: seq[int] = @[]\n        for i in countdown(n\
    \ - 1, 0):\n            coords.add(i * 3)\n            coords.add(i * 3)\n   \
    \     let original = coords\n        let st = initCompressedSegmentTree(coords,\
    \ concat, \"\",\n            proc(x: int): string = \"[\" & $x & \"]\")\n    \
    \    doAssert coords == original\n        doAssert st.len == n\n        for pass\
    \ in 0..1:\n            for l in -2..(n * 3 + 2):\n                for r in l..(n\
    \ * 3 + 2):\n                    var halfOpen, closed: string\n              \
    \      for i in 0..<n:\n                        let x = i * 3\n              \
    \          let value = if pass == 0: \"[\" & $x & \"]\" else: \"<\" & $x & \"\
    >\"\n                        if l <= x and x < r: halfOpen.add(value)\n      \
    \                  if l <= x and x <= r: closed.add(value)\n                 \
    \   doAssert st.get(l, r) == halfOpen\n                    doAssert st[l..r] ==\
    \ closed\n                    doAssert st[(r + 1)..l] == \"\"\n            for\
    \ i in 0..<n: st[i * 3] = \"<\" & $(i * 3) & \">\"\n\nblock:\n    proc checkClosure(separator:\
    \ string) =\n        proc concat(x, y: string): string =\n            if x.len\
    \ == 0: y\n            elif y.len == 0: x\n            else: x & separator & y\n\
    \        let st = initCompressedSegmentTree([0, 2, 4, 6, 8], concat, \"\",\n \
    \           proc(x: int): string = $x)\n        doAssert st.get(1, 7) == \"2\"\
    \ & separator & \"4\" & separator & \"6\"\n        st[4] = \"x\"\n        doAssert\
    \ st[2..6] == \"2\" & separator & \"x\" & separator & \"6\"\n    checkClosure(\"\
    :\")\n\nproc checkIntegerCoordinates[K: SomeInteger](coords: seq[K]) =\n    let\
    \ original = coords\n    var sorted = coords\n    sorted.sort()\n    var unique:\
    \ seq[K]\n    for x in sorted:\n        if unique.len == 0 or unique[^1] != x:\
    \ unique.add(x)\n    let ordinary = initCompressedSegmentTree(coords, merge, 0'i64)\n\
    \    let specialized: CompressedSegmentTree[K, int64] = newCompressedSegWith(coords,\
    \ l + r, 0'i64)\n    for st in [ordinary, specialized]:\n        doAssert st.len\
    \ == unique.len\n        for i, x in unique:\n            st[x] = int64(i + 1)\n\
    \        for i, x in unique:\n            doAssert st[x] == int64(i + 1)\n   \
    \         doAssert st[x..x] == int64(i + 1)\n        doAssert st.get_all() ==\
    \ int64(unique.len * (unique.len + 1) div 2)\n        for i in countup(0, unique.len\
    \ - 1, 31):\n            let j = min(i + 57, unique.len - 1)\n            doAssert\
    \ st.get(unique[i], unique[j]) == int64((i + 1 + j) * (j - i) div 2)\n    doAssert\
    \ coords == original\n\nblock:\n    var rng = initRand(129734)\n    var signed:\
    \ seq[int64] = @[low(int64), high(int64), -1'i64, 0'i64]\n    var unsigned: seq[uint64]\
    \ = @[low(uint64), high(uint64), 1u64 shl 63]\n    var small: seq[int8]\n    for\
    \ i in 0..<6000:\n        let bits = (uint64(rng.rand(high(int32))) shl 33) or\
    \ uint64(rng.rand(high(int32)))\n        signed.add(cast[int64](bits))\n     \
    \   unsigned.add(bits)\n        small.add(cast[int8](i and 255))\n    checkIntegerCoordinates(signed)\n\
    \    checkIntegerCoordinates(unsigned)\n    checkIntegerCoordinates(small)\n \
    \   checkIntegerCoordinates(@[3'i16, -2'i16, low(int16), high(int16)])\n    checkIntegerCoordinates(@[3'u16,\
    \ 0'u16, high(uint16)])\n    checkIntegerCoordinates(@[3'i32, -2'i32, low(int32),\
    \ high(int32)])\n    checkIntegerCoordinates(@[3'u32, 0'u32, high(uint32)])\n\
    \    for n in [63, 64, 65, 2047, 2048, 2049]:\n        var coords: seq[int]\n\
    \        for i in countdown(n - 1, 0): coords.add(i * 11)\n        checkIntegerCoordinates(coords)\n\
    \        let st = newCompressedSegWith(coords, l + r, 0)\n        doAssert st[-1]\
    \ == 0 and st[1] == 0 and st[n * 11] == 0\n        var rejected = false\n    \
    \    try: st[1] = 10\n        except AssertionDefect: rejected = true\n      \
    \  doAssert rejected\n\nblock:\n    proc make(separator: string): CompressedSegmentTree[int,\
    \ string] =\n        newCompressedSegWith([0, 2, 4, 6, 8],\n            (if l\
    \ == \"\": r elif r == \"\": l else: l & separator & r), \"\",\n            proc(x:\
    \ int): string = $x)\n    let a = make(\":\")\n    let b = make(\"/\")\n    for\
    \ st in [a, b]:\n        st[4] = \"X\"\n    doAssert a.get(1, 7) == \"2:X:6\"\n\
    \    doAssert b[2..6] == \"2/X/6\"\n    doAssert a.get_all() == \"0:2:X:6:8\"\n\
    \    doAssert b.get_all() == \"0/2/X/6/8\"\n    let empty: CompressedSegmentTree[int,\
    \ int] = newCompressedSegWith(newSeq[int](), l + r, 0)\n    doAssert empty.get(-1,\
    \ 1) == 0 and empty[-1..1] == 0\n\nblock:\n    let coords = @[\n        54, 58,\
    \ 168, 407, 752, 792, 967, 1039,\n        1050, 1100, 1161, 1197, 1310, 1381,\
    \ 1768, 2025,\n        2102, 2271, 2321, 2398, 2738, 3205, 3527, 3580,\n     \
    \   3920, 4018, 4468, 4583, 4617, 4755, 4798, 5289,\n        5311, 5456, 5468,\
    \ 5493, 5712, 5773, 5869, 5973,\n        6137, 6218, 6404, 6605, 6622, 6712, 6864,\
    \ 7018,\n        7337, 7389, 7434, 7668, 7824, 7896, 7942, 8182,\n        8204,\
    \ 8229, 8532, 8542, 8831, 8931, 9087, 9444\n    ]\n    checkIntegerCoordinates(coords)\n\
    \    let st = newCompressedSegWith(coords, l + r, 0)\n    doAssert st[9474] ==\
    \ 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/compressed_segtree.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/compressed_segtree.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/AI/compressed_segtree_test.nim
  requiredBy: []
  timestamp: '2026-09-17 19:00:20+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/compressed_segtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/compressed_segtree_test.nim
- /verify/verify/AI/compressed_segtree_test.nim.html
title: verify/AI/compressed_segtree_test.nim
---
