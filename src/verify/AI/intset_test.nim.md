---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/intset.nim
    title: cplib/collections/intset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/intset.nim
    title: cplib/collections/intset.nim
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
    import algorithm, random, sequtils, sets\nimport cplib/collections/intset\n\n\
    proc checkState(actual: IntSet, expected: HashSet[int]) =\n    doAssert actual.len\
    \ == expected.len\n    var seen = initHashSet[int]()\n    for x in actual:\n \
    \       doAssert seen.len < expected.len\n        doAssert x in expected\n   \
    \     doAssert not seen.containsOrIncl(x)\n        doAssert x in actual\n    doAssert\
    \ seen == expected\n    for x in expected:\n        doAssert actual.contains(x)\n\
    \ntemplate expectError(errorType: typedesc, body: untyped) =\n    block:\n   \
    \     var raised = false\n        try:\n            body\n        except errorType:\n\
    \            raised = true\n        doAssert raised\n\nblock:\n    var s: IntSet\n\
    \    checkState(s, initHashSet[int]())\n    doAssert $s == \"{}\"\n    doAssert\
    \ s == initIntSet(0)\n    s.excl(0)\n    s.clear()\n    expectError(IndexDefect):\n\
    \        s.incl(0)\n    expectError(KeyError):\n        discard s.pop()\n    expectError(ValueError):\n\
    \        discard initIntSet(-1)\n    expectError(ValueError):\n        discard\
    \ initIntSet(low(int)..high(int))\n    expectError(ValueError):\n        discard\
    \ initIntSet(0..high(int))\n    for bounds in [0 .. -1, 10..9, high(int)..low(int)]:\n\
    \        var empty = initIntSet(bounds)\n        checkState(empty, initHashSet[int]())\n\
    \        doAssert empty == s\n        expectError(IndexDefect):\n            empty.incl(bounds.a)\n\
    \nblock:\n    var s = initIntSet(257)\n    var expected = initHashSet[int]()\n\
    \    for x in [0, 63, 64, 127, 128, 191, 192, 255, 256]:\n        doAssert s.containsOrIncl(x)\
    \ == expected.containsOrIncl(x)\n        doAssert s.containsOrIncl(x)\n      \
    \  checkState(s, expected)\n    for x in [64, 127, 256, 0, 63, 128, 191, 255,\
    \ 192]:\n        doAssert s.missingOrExcl(x) == expected.missingOrExcl(x)\n  \
    \      doAssert s.missingOrExcl(x)\n        checkState(s, expected)\n    for cycle\
    \ in 0..<3:\n        for x in [256, 128, 0, 192, 64]:\n            s.incl(x)\n\
    \            expected.incl(x)\n        checkState(s, expected)\n        s.clear()\n\
    \        expected.clear()\n        checkState(s, expected)\n\nfor lower in [low(int),\
    \ -129, 0, high(int) - 129]:\n    var s = initIntSet(lower..lower + 129)\n   \
    \ var expected = initHashSet[int]()\n    for offset in [0, 63, 64, 127, 128, 129]:\n\
    \        let x = lower + offset\n        s.incl(x)\n        expected.incl(x)\n\
    \    checkState(s, expected)\n    for x in [low(int), high(int)]:\n        if\
    \ x notin expected:\n            doAssert x notin s\n            doAssert s.missingOrExcl(x)\n\
    \            expectError(IndexDefect):\n                s.incl(x)\n    while s.len\
    \ > 0:\n        let x = s.pop()\n        doAssert not expected.missingOrExcl(x)\n\
    \        checkState(s, expected)\n\nblock:\n    let a = toIntSet([0, 63, 64, 0],\
    \ 129)\n    let b = toIntSet([64, 63, 0], -100..200)\n    doAssert a == b\n  \
    \  doAssert a != toIntSet([0, 63, 65], 129)\n    doAssert a != toIntSet([0, 63],\
    \ 129)\n    doAssert toSeq(a.items).sorted() == @[0, 63, 64]\n    doAssert $toIntSet([-3],\
    \ -10..10) == \"{-3}\"\n    var pairs = 0\n    for x in a:\n        for y in a:\n\
    \            doAssert x in b and y in b\n            inc pairs\n    doAssert pairs\
    \ == 9\n    var copy = a\n    copy.excl(0)\n    copy.incl(128)\n    doAssert a\
    \ == b\n    doAssert copy != a\n    copy.clear()\n    doAssert a == b\n    expectError(IndexDefect):\n\
    \        discard toIntSet([0, 129], 129)\n\nvar rng = initRand(843157)\nfor size\
    \ in [0, 1, 2, 63, 64, 65, 127, 128, 129, 257, 513, 4097]:\n    for lower in [-100,\
    \ 0, 100]:\n        var s = initIntSet(lower..<lower + size)\n        var expected\
    \ = initHashSet[int]()\n        for offset in 0..<size:\n            s.incl(lower\
    \ + offset)\n            expected.incl(lower + offset)\n        checkState(s,\
    \ expected)\n        var order = toSeq(expected.items)\n        rng.shuffle(order)\n\
    \        for x in order:\n            s.excl(x)\n            expected.excl(x)\n\
    \            if expected.len mod 64 == 0:\n                checkState(s, expected)\n\
    \        checkState(s, expected)\n        for step in 0..<1500:\n            let\
    \ x = lower + rng.rand(size + 2) - 1\n            let inRange = x >= lower and\
    \ x < lower + size\n            case rng.rand(9)\n            of 0, 1:\n     \
    \           if inRange:\n                    s.incl(x)\n                    expected.incl(x)\n\
    \                else:\n                    expectError(IndexDefect):\n      \
    \                  s.incl(x)\n            of 2:\n                if inRange:\n\
    \                    doAssert s.containsOrIncl(x) == expected.containsOrIncl(x)\n\
    \                else:\n                    expectError(IndexDefect):\n      \
    \                  discard s.containsOrIncl(x)\n            of 3:\n          \
    \      s.excl(x)\n                expected.excl(x)\n            of 4:\n      \
    \          doAssert s.missingOrExcl(x) == expected.missingOrExcl(x)\n        \
    \    of 5, 6:\n                doAssert (x in s) == (x in expected)\n        \
    \    of 7:\n                if expected.len == 0:\n                    expectError(KeyError):\n\
    \                        discard s.pop()\n                else:\n            \
    \        let removed = s.pop()\n                    doAssert not expected.missingOrExcl(removed)\n\
    \            of 8:\n                var copy = s\n                copy.clear()\n\
    \                if size > 0:\n                    copy.incl(lower)\n        \
    \            doAssert copy.len == 1 and lower in copy\n                checkState(s,\
    \ expected)\n            else:\n                if step mod 5 == 0:\n        \
    \            s.clear()\n                    expected.clear()\n            checkState(s,\
    \ expected)\n\nblock:\n    const size = 1 shl 24\n    var s = initIntSet(size)\n\
    \    let values = [0, size div 2, size - 1]\n    let expected = toHashSet(values)\n\
    \    for round in 0..<1000:\n        for x in values:\n            s.incl(x)\n\
    \        checkState(s, expected)\n        for x in values:\n            s.excl(x)\n\
    \            s.incl(x)\n        checkState(s, expected)\n        s.clear()\n \
    \       doAssert s.len == 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/intset.nim
  - cplib/collections/intset.nim
  isVerificationFile: true
  path: verify/AI/intset_test.nim
  requiredBy: []
  timestamp: '2026-09-27 00:37:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/intset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/intset_test.nim
- /verify/verify/AI/intset_test.nim.html
title: verify/AI/intset_test.nim
---
