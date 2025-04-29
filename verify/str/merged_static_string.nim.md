---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':warning:'
    path: cplib/str/merged_static_string.nim
    title: cplib/str/merged_static_string.nim
  - icon: ':warning:'
    path: cplib/str/merged_static_string.nim
    title: cplib/str/merged_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
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
    echo \"Hello World\"\n\ninclude cplib/tmpl/sheep\nimport cplib/str/static_string\n\
    import cplib/str/merged_static_string\nimport std/random\nrandomize()\nfor _ in\
    \ 0..<1000:\n    var rawstr = newseqwith(10,\"ab\"[rand(0..<2)]).join(\"\")\n\
    \    var X = rawstr.toStaticString()\n\n    var tmp : seq[StaticString]\n    var\
    \ naive : string\n    for i in range(30):\n        var l = rand(0..<len(rawstr))\n\
    \        var r = rand(l..<len(rawstr))\n        tmp.add(X[l..r])\n        naive\
    \ &= rawstr[l..r]\n\n    var A = tmp.initMergedStaticString()\n\n    for l in\
    \ range(len(A)):\n        for r in range(l,len(A)):\n            assert $(A[l..r])\
    \ == naive[l..r]\n\n    assert len(A) == len(naive)\n\n    for i in range(len(naive)):\n\
    \        assert naive[i] == A[i]\n\n    for i in range(100):\n        var tmp2\
    \ : MergedStaticString\n        var naive2 : string\n        var tmp3 : MergedStaticString\n\
    \        var naive3 : string\n\n        for i in range(rand(0..50)):\n       \
    \     var l = rand(0..<len(rawstr))\n            var r = rand(l..<len(rawstr))\n\
    \            tmp2 &= X[l..r]\n            naive2 &= rawstr[l..r]\n        for\
    \ i in range(rand(0..50)):\n            var l = rand(0..<len(rawstr))\n      \
    \      var r = rand(l..<len(rawstr))\n            tmp3 &= X[l..r]\n          \
    \  naive3 &= rawstr[l..r]\n            \n        assert cmp(tmp3,tmp2) == sgn(cmp(naive3,naive2))\n\
    \        assert $tmp2 == naive2\n        assert $tmp3 == naive3\n        assert\
    \ cmp(tmp2,tmp2) == 0\n\n\n\n"
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/str/merged_static_string.nim
  - cplib/str/merged_static_string.nim
  - cplib/str/static_string.nim
  - cplib/tmpl/sheep.nim
  isVerificationFile: false
  path: verify/str/merged_static_string.nim
  requiredBy: []
  timestamp: '2025-04-01 08:20:08+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/str/merged_static_string.nim
layout: document
redirect_from:
- /library/verify/str/merged_static_string.nim
- /library/verify/str/merged_static_string.nim.html
title: verify/str/merged_static_string.nim
---
