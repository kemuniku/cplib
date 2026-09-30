---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
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
    import random\nimport cplib/collections/persistent_array\n\nproc check(shift:\
    \ static int) =\n    let empty = initPersistentArray(newSeq[int](), shift)\n \
    \   doAssert empty.toseq() == newSeq[int]()\n    let emptyStrings = initPersistentArray(newSeq[string](),\
    \ shift)\n    doAssert emptyStrings.toseq() == newSeq[string]()\n    var rng =\
    \ initRand(18731 + shift)\n    for size in 1..100:\n        var initial = newSeq[int](size)\n\
    \        for i in 0..<size:\n            initial[i] = i\n        var versions\
    \ = @[initPersistentArray(initial, shift)]\n        var expected = @[initial]\n\
    \        for step in 0..<30:\n            let parent = rng.rand(versions.high)\n\
    \            let index = rng.rand(size-1)\n            let value = rng.rand(-100..100)\n\
    \            versions.add(versions[parent].change_value(index, value))\n     \
    \       var next = expected[parent]\n            next[index] = value\n       \
    \     expected.add(next)\n            doAssert versions[parent].toseq() == expected[parent]\n\
    \            doAssert versions[^1].toseq() == next\n            doAssert versions[^1][index]\
    \ == value\n        for i in 0..<versions.len:\n            doAssert versions[i].toseq()\
    \ == expected[i]\n\ncheck(1)\ncheck(2)\ncheck(5)\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/persistent_array.nim
  - cplib/collections/persistent_array.nim
  isVerificationFile: true
  path: verify/collections/persistent_array_empty_test.nim
  requiredBy: []
  timestamp: '2026-10-01 01:56:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/persistent_array_empty_test.nim
layout: document
redirect_from:
- /verify/verify/collections/persistent_array_empty_test.nim
- /verify/verify/collections/persistent_array_empty_test.nim.html
title: verify/collections/persistent_array_empty_test.nim
---
