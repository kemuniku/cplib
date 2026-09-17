---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
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
    import algorithm, random, sequtils\nimport cplib/str/static_string\n\nproc check[T](input:\
    \ seq[StaticString[T]]) =\n    var expected = toSeq(0..<input.len)\n    expected.sort(proc(a,\
    \ b: int): int =\n        for i in 0..<min(input[a].len, input[b].len):\n    \
    \        let c = system.cmp(input[a][i], input[b][i])\n            if c != 0:\
    \ return c\n        let c = system.cmp(input[a].len, input[b].len)\n        if\
    \ c != 0: return c\n        system.cmp(a, b))\n    var actual = input\n    actual.sortStaticStrings()\n\
    \    doAssert actual.len == input.len\n    for i, index in expected:\n       \
    \ doAssert actual[i].base == input[index].base\n        doAssert actual[i].l ==\
    \ input[index].l\n        doAssert actual[i].r == input[index].r\n\nproc checkIntervals[T](s:\
    \ StaticString[T]) =\n    var parts: seq[StaticString[T]]\n    for l in 0..s.len:\n\
    \        for r in l..s.len:\n            parts.add(s[l..<r])\n            parts.add(s[l..<r].reversed)\n\
    \    parts.reverse()\n    check(parts)\n\ncheck(newSeq[StaticString[char]]())\n\
    for n in 0..8:\n    for mask in 0..<(1 shl n):\n        var s = newString(n)\n\
    \        for i in 0..<n: s[i] = char(ord('a') + ((mask shr i) and 1))\n      \
    \  checkIntervals(toStaticString(s, reversible = true))\n\nvar rng = initRand(20260917)\n\
    for trial in 0..<50:\n    var values = newSeq[int](rng.rand(30))\n    for v in\
    \ values.mitems: v = rng.rand(10)-5\n    checkIntervals(toStaticString(values,\
    \ reversible = true))\n\ncheck(toStaticStrings([\"ab\", \"a\", \"\", \"ab\", \"\
    abc\", \"a\", \"\"]))\nlet s = toStaticString(\"banana\")\nvar parts = [s[0..<3],\
    \ s[1..<4], s[3..<6]]\nparts.sortStaticStrings()\ndoAssert parts.mapIt($it) ==\
    \ @[\"ana\", \"ana\", \"ban\"]\ndoAssert parts[0].l == 1 and parts[1].l == 3\n\
    var single = @[s]\nsingle.sortStaticStrings()\ndoAssert single[0].l == s.l and\
    \ single[0].r == s.r\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/suffix_array.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/suffix_array.nim
  - cplib/str/static_string.nim
  isVerificationFile: true
  path: verify/AI/static_string_sort_test.nim
  requiredBy: []
  timestamp: '2026-09-17 19:04:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_string_sort_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_string_sort_test.nim
- /verify/verify/AI/static_string_sort_test.nim.html
title: verify/AI/static_string_sort_test.nim
---
