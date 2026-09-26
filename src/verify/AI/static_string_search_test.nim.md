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
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string_search.nim
    title: cplib/str/static_string_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string_search.nim
    title: cplib/str/static_string_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
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
    import random\nimport cplib/str/static_string\nimport cplib/str/static_string_search\n\
    \nproc literalPositions[T](s, pattern: StaticString[T]): seq[int] =\n    if pattern.len\
    \ > s.len:\n        return\n    for start in 0..s.len-pattern.len:\n        var\
    \ matches = true\n        for i in 0..<pattern.len:\n            if s[start+i]\
    \ != pattern[i]:\n                matches = false\n                break\n   \
    \     if matches:\n            result.add(start)\n\nproc checkSearch[T](search:\
    \ StaticStringSearch[T], s, pattern: StaticString[T]) =\n    let expected = literalPositions(s,\
    \ pattern)\n    doAssert search.contains(s, pattern) == (expected.len > 0)\n \
    \   doAssert search.count(s, pattern) == expected.len\n    doAssert (pattern in\
    \ s) == (expected.len > 0)\n    doAssert (pattern notin s) == (expected.len ==\
    \ 0)\n    doAssert s.count(pattern) == expected.len\n    let target = search[s]\n\
    \    doAssert (pattern in target) == (expected.len > 0)\n    doAssert (pattern\
    \ notin target) == (expected.len == 0)\n    doAssert target.count(pattern) ==\
    \ expected.len\n    var actual: seq[int]\n    for position in target.findAll(pattern):\n\
    \        actual.add(position)\n    doAssert actual == expected\n    actual.setLen(0)\n\
    \    for position in s.findAll(pattern):\n        actual.add(position)\n    doAssert\
    \ actual == expected\n\nproc checkIntervals[T](s: StaticString[T]) =\n    let\
    \ search = initStaticStringSearch(s.base)\n    var parts: seq[StaticString[T]]\n\
    \    for l in 0..s.len:\n        for r in l..s.len:\n            parts.add(s[l..<r])\n\
    \            if s.base.reversible:\n                parts.add(s[l..<r].reversed)\n\
    \    for a in parts:\n        for b in parts:\n            checkSearch(search,\
    \ a, b)\n    clearStaticStringSearchCache(s.base)\n\nblock:\n    let parts = toStaticStrings([\"\
    banana\", \"ana\", \"apple\"])\n    doAssert parts[1] in parts[0]\n    doAssert\
    \ parts[2] notin parts[0]\n    let cached = initStaticStringSearch(parts[0].base)\n\
    \    doAssert cached == initStaticStringSearch(parts[0].base)\n    doAssert parts[0].count(parts[1])\
    \ == 2\n    doAssert cached == initStaticStringSearch(parts[0].base)\n    var\
    \ positions: seq[int]\n    for position in parts[0].findAll(parts[1]):\n     \
    \   clearStaticStringSearchCache()\n        positions.add(position)\n    doAssert\
    \ positions == @[1, 3]\n    doAssert cached != initStaticStringSearch(parts[0].base)\n\
    \    doAssert cached.contains(parts[0], parts[1])\n    clearStaticStringSearchCache()\n\
    \nblock:\n    let a = toStaticString(\"banana\")\n    let b = toStaticString(\"\
    banana\")\n    let numbers = toStaticString([1, 2, 1, 2])\n    let first = initStaticStringSearch(a.base)\n\
    \    let second = initStaticStringSearch(b.base)\n    let numeric = initStaticStringSearch(numbers.base)\n\
    \    doAssert first != second\n    doAssert a[1..<4] in a\n    doAssert b[1..<4]\
    \ in b\n    doAssert numbers[0..<2] in numbers\n    doAssert first == initStaticStringSearch(a.base)\n\
    \    doAssert second == initStaticStringSearch(b.base)\n    doAssert numeric ==\
    \ initStaticStringSearch(numbers.base)\n    clearStaticStringSearchCache(a.base)\n\
    \    clearStaticStringSearchCache(a.base)\n    doAssert first != initStaticStringSearch(a.base)\n\
    \    doAssert second == initStaticStringSearch(b.base)\n    doAssert numeric ==\
    \ initStaticStringSearch(numbers.base)\n    clearStaticStringSearchCache()\n \
    \   clearStaticStringSearchCache()\n    doAssert first.contains(a, a[1..<4])\n\
    \    doAssert second != initStaticStringSearch(b.base)\n    doAssert numeric !=\
    \ initStaticStringSearch(numbers.base)\n    clearStaticStringSearchCache()\n\n\
    for n in 0..5:\n    for mask in 0..<(1 shl n):\n        var text = newString(n)\n\
    \        for i in 0..<n:\n            text[i] = char(ord('a') + ((mask shr i)\
    \ and 1))\n        for reversible in [false, true]:\n            checkIntervals(toStaticString(text,\
    \ reversible))\n\nfor text in [\"banana\", \"aaaaaa\", \"\\x00\\xFF\\x80\\x00\\\
    xFF\", \"a$b$$a\"]:\n    for reversible in [false, true]:\n        checkIntervals(toStaticString(text,\
    \ reversible))\n\ncheckIntervals(toStaticString(newSeq[int](), true))\ncheckIntervals(toStaticString(@[-5,\
    \ 3, -5, 3, -5, 8], true))\n\nlet strings = toStaticStrings([\"banana\", \"ana\"\
    , \"nan\", \"apple\", \"\", \"a\", \"aa\"], true)\nlet search = initStaticStringSearch(strings[0].base)\n\
    for s in strings:\n    for pattern in strings:\n        checkSearch(search, s,\
    \ pattern)\n        checkSearch(search, s.reversed, pattern)\ndoAssert search.contains(strings[0],\
    \ strings[1])\ndoAssert not search.contains(strings[0][0..<3], strings[1])\ndoAssert\
    \ not search.contains(strings[0][3..<6], strings[2])\ndoAssert not search.contains(strings[5],\
    \ strings[6])\n\ndoAssert search.count(strings[0], strings[1]) == 2\nvar positions:\
    \ seq[int]\nfor position in search.findAll(strings[0][1..<6], strings[1]):\n \
    \   positions.add(position)\ndoAssert positions == @[0, 2]\nvar yielded = 0\n\
    for position in search[strings[0]].findAll(strings[1]):\n    doAssert position\
    \ == 1\n    inc yielded\n    break\ndoAssert yielded == 1\n\nvar rng = initRand(20260926)\n\
    for n in [63, 64, 65, 127, 128, 129, 511]:\n    var values = newSeq[int](n)\n\
    \    for value in values.mitems:\n        value = rng.rand(4) - 2\n    let s =\
    \ toStaticString(values, true)\n    let search = initStaticStringSearch(s.base)\n\
    \    for trial in 0..<1000:\n        let l = rng.rand(n)\n        let r = rng.rand(l..n)\n\
    \        let pl = rng.rand(n)\n        let pr = rng.rand(pl..min(n, pl + 12))\n\
    \        var a = s[l..<r]\n        var b = s[pl..<pr]\n        if rng.rand(1)\
    \ == 1: a = a.reversed\n        if rng.rand(1) == 1: b = b.reversed\n        checkSearch(search,\
    \ a, b)\n    clearStaticStringSearchCache(s.base)\n\ntemplate expectAssertion(body:\
    \ untyped) =\n    block:\n        var rejected = false\n        try:\n       \
    \     body\n        except AssertionDefect:\n            rejected = true\n   \
    \     doAssert rejected\n\nlet one = toStaticString(\"a\")\nlet another = toStaticString(\"\
    a\")\nlet oneSearch = initStaticStringSearch(one.base)\nfor s in [one, one[0..<0],\
    \ another, another[0..<0]]:\n    for pattern in [one, one[0..<0], another, another[0..<0]]:\n\
    \        if s.base == one.base and pattern.base == one.base:\n            continue\n\
    \        expectAssertion:\n            discard oneSearch.contains(s, pattern)\n\
    \        expectAssertion:\n            discard oneSearch.count(s, pattern)\n \
    \       expectAssertion:\n            discard pattern in oneSearch[s]\n      \
    \  expectAssertion:\n            discard pattern notin oneSearch[s]\n        expectAssertion:\n\
    \            for position in oneSearch.findAll(s, pattern):\n                discard\
    \ position\n        if s.base != pattern.base:\n            expectAssertion:\n\
    \                discard pattern in s\n            expectAssertion:\n        \
    \        discard pattern notin s\n            expectAssertion:\n             \
    \   discard s.count(pattern)\n            expectAssertion:\n                for\
    \ position in s.findAll(pattern):\n                    discard position\n\nexpectAssertion:\n\
    \    discard oneSearch[another]\nexpectAssertion:\n    discard oneSearch[another[0..<0]]\n\
    \nclearStaticStringSearchCache()\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/bitvector.nim
  - cplib/str/suffix_array.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string_search.nim
  - cplib/str/static_string_search.nim
  - cplib/utils/backwards_index.nim
  - cplib/str/static_string.nim
  - cplib/str/suffix_array.nim
  - cplib/str/static_string.nim
  - cplib/collections/bitvector.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: true
  path: verify/AI/static_string_search_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:42:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_string_search_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_string_search_test.nim
- /verify/verify/AI/static_string_search_test.nim.html
title: verify/AI/static_string_search_test.nim
---
