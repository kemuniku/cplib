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
    path: cplib/str/fixedlength_merged_static_string.nim
    title: cplib/str/fixedlength_merged_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/fixedlength_merged_static_string.nim
    title: cplib/str/fixedlength_merged_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/repeated_static_string.nim
    title: cplib/str/repeated_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/repeated_static_string.nim
    title: cplib/str/repeated_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
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
    echo \"Hello World\"\n\nimport cplib/str/repeated_static_string\nimport cplib/str/static_string\n\
    \nlet strings = toStaticStrings(@[\"ab\", \"aba\", \"abab\", \"ababa\", \"ac\"\
    , \"\", \"b\"])\nlet ab = initRepeatedStaticString(strings[0], 7)\nlet aba = initRepeatedStaticString(strings[1],\
    \ 8)\nlet abab = initRepeatedStaticString(strings[2], 9)\n\nassert len(ab) ==\
    \ 7\nassert $ab == \"abababa\"\nassert ab[0] == 'a'\nassert ab[5] == 'b'\nassert\
    \ lcp(ab, aba) == 3\nassert lcp(aba, ab) == 3\nassert ab > aba\nassert aba < ab\n\
    \n# \u7570\u306A\u308B\u5468\u671F\u3067\u3082\u540C\u3058\u7121\u9650\u5217\u3092\
    \u8868\u305B\u308B\u3002\nassert lcp(ab, abab) == 7\nassert ab < abab\nlet ababa\
    \ = initRepeatedStaticString(strings[0], 5)\nassert ababa == strings[3]\nassert\
    \ strings[3] == ababa\nassert cmp(ababa, strings[3]) == 0\nassert lcp(ab, strings[4])\
    \ == 1\nassert ab < strings[4]\nassert strings[4] > ab\n\nlet emptyRepeat = initRepeatedStaticString(strings[0],\
    \ 0)\nlet emptyPeriod = initRepeatedStaticString(strings[5], 0)\nassert len(emptyRepeat)\
    \ == 0\nassert emptyRepeat == strings[5]\nassert emptyPeriod == strings[5]\nassert\
    \ emptyRepeat < strings[0]\nassert strings[0] > emptyRepeat\n\nlet integers =\
    \ toStaticString([1, 2, 1, 2, 3])\nlet integerRepeat = initRepeatedStaticString(integers[0..1],\
    \ 7)\nassert integerRepeat[6] == 1\nassert lcp(integerRepeat, integers[0..3])\
    \ == 4\nassert integerRepeat < integers\n\nproc naiveLcp(S, T: string): int =\n\
    \    result = min(len(S), len(T))\n    for i in 0..<result:\n        if S[i] !=\
    \ T[i]:\n            return i\n\nproc sign(x: int): int =\n    if x < 0: -1\n\
    \    elif x > 0: 1\n    else: 0\n\n# O(1)\u306E\u5404\u64CD\u4F5C\u3092\u3001\u5B9F\
    \u4F53\u5316\u3057\u305F\u6587\u5B57\u5217\u306B\u3088\u308B\u8A08\u7B97\u7D50\
    \u679C\u3068\u7DCF\u5F53\u305F\u308A\u3067\u6BD4\u8F03\u3059\u308B\u3002\nlet\
    \ source = toStaticString(\"aababb\")\nvar periods: seq[StaticString[char]]\n\
    for l in 0..<len(source):\n    for r in l..<len(source):\n        periods.add(source[l..r])\n\
    \nvar repeated: seq[RepeatedStaticString[char]]\nfor period in periods:\n    for\
    \ k in 0..10:\n        repeated.add(initRepeatedStaticString(period, k))\n\nfor\
    \ left in repeated:\n    let materializedLeft = $left\n    for right in repeated:\n\
    \        let materializedRight = $right\n        assert lcp(left, right) == naiveLcp(materializedLeft,\
    \ materializedRight)\n        assert cmp(left, right) == sign(cmp(materializedLeft,\
    \ materializedRight))\n    for right in periods:\n        let materializedRight\
    \ = $right\n        assert lcp(left, right) == naiveLcp(materializedLeft, materializedRight)\n\
    \        assert lcp(right, left) == naiveLcp(materializedRight, materializedLeft)\n\
    \        assert cmp(left, right) == sign(cmp(materializedLeft, materializedRight))\n\
    \        assert cmp(right, left) == sign(cmp(materializedRight, materializedLeft))\n"
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/str/fixedlength_merged_static_string.nim
  - cplib/str/fixedlength_merged_static_string.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/str/repeated_static_string.nim
  - cplib/str/repeated_static_string.nim
  isVerificationFile: true
  path: verify/AI/repeated_static_string_test.nim
  requiredBy: []
  timestamp: '2026-08-28 03:06:46+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/repeated_static_string_test.nim
layout: document
redirect_from:
- /verify/verify/AI/repeated_static_string_test.nim
- /verify/verify/AI/repeated_static_string_test.nim.html
title: verify/AI/repeated_static_string_test.nim
---
