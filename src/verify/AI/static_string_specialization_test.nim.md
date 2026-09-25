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
    import algorithm, random, sequtils\nimport cplib/str/static_string\nimport cplib/str/suffix_array\n\
    \nproc literalCmp[T](a, b: StaticString[T]): int =\n    for i in 0..<min(a.len,\
    \ b.len):\n        let c = system.cmp(a[i], b[i])\n        if c != 0: return c\n\
    \    return system.cmp(a.len, b.len)\n\nproc checkComparisons[T](s: StaticString[T])\
    \ =\n    var parts: seq[StaticString[T]]\n    for l in 0..s.len:\n        for\
    \ r in l..s.len:\n            parts.add(s[l..<r])\n            parts.add(s[l..<r].reversed)\n\
    \    for a in parts:\n        for b in parts:\n            doAssert cmp(a, b)\
    \ == literalCmp(a, b)\n    for index in 0..<parts.len:\n        let part = parts[index]\n\
    \        var expected = toSeq(0..<part.len)\n        expected.sort(proc(a, b:\
    \ int): int = literalCmp(part[a..<part.len], part[b..<part.len]))\n        let\
    \ actual = part.initSuffixArray()\n        doAssert actual.len == expected.len\n\
    \        for i, pos in expected:\n            doAssert actual[i].l == part.l +\
    \ pos\n            doAssert actual[i].r == part.r\n\nfor text in [\"\", \"a\"\
    , \"aaaaa\", \"banana\", \"abababa\", \"\\x00\\xFF\\x80\\x00\\xFF\"]:\n    let\
    \ values = @text\n    doAssert suffix_array(values) == suffix_array(text)\n  \
    \  for reversible in [false, true]:\n        let a = initStaticStringBase(text,\
    \ reversible)\n        let b = initStaticStringBase(values, reversible)\n    \
    \    doAssert a.SA == b.SA\n        doAssert a.LCP == b.LCP\n        doAssert\
    \ initSuffixArray(a).mapIt($it) == initSuffixArray(b).mapIt($it)\n    checkComparisons(toStaticString(values,\
    \ true))\n\ncheckComparisons(toStaticString(newSeq[int](), true))\ncheckComparisons(toStaticString(@[-5,\
    \ 3, -5, 3, -5, 8], true))\n\nvar rng = initRand(20260917)\nfor trial in 0..<30:\n\
    \    var text = newString(rng.rand(80))\n    for c in text.mitems: c = char(rng.rand(255))\n\
    \    let values = @text\n    var expected = toSeq(0..<text.len)\n    expected.sort(proc(a,\
    \ b: int): int = system.cmp(text[a..^1], text[b..^1]))\n    doAssert suffix_array(values)\
    \ == expected\n    doAssert toStaticString(values).base.SA.mapIt(int(it)) == expected\n\
    \nlet one = toStaticString(\"a\")\nlet another = toStaticString(\"a\")\nvar rejected\
    \ = false\ntry:\n    discard cmp(one[0..<0], another[0..<0])\nexcept AssertionDefect:\n\
    \    rejected = true\ndoAssert rejected\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/str/static_string.nim
  - cplib/str/suffix_array.nim
  - cplib/str/suffix_array.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  isVerificationFile: true
  path: verify/AI/static_string_specialization_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_string_specialization_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_string_specialization_test.nim
- /verify/verify/AI/static_string_specialization_test.nim.html
title: verify/AI/static_string_specialization_test.nim
---
