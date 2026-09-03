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
    echo \"Hello World\"\n\nimport cplib/str/fixedlength_merged_static_string\nimport\
    \ cplib/str/static_string\n\nlet strings = toStaticStrings(@[\"ab\", \"cd\", \"\
    abce\"])\nlet merged: FixedLengthMergedStaticString[char, 2] =\n    initFixedLengthMergedStaticString([strings[0],\
    \ strings[1]])\nassert $merged == \"abcd\"\nassert merged.len == 4\nassert merged[2]\
    \ == 'c'\nassert $merged[1..2] == \"bc\"\nlet leftHalf = initFixedLengthMergedStaticString([strings[0]])\n\
    let rightHalf = initFixedLengthMergedStaticString([strings[1]])\nlet mergedByOperator:\
    \ FixedLengthMergedStaticString[char, 2] = leftHalf & rightHalf\nassert mergedByOperator\
    \ == merged\n\nlet appended: FixedLengthMergedStaticString[char, 3] = merged &\
    \ strings[2]\nassert $appended == \"abcdabce\"\n\nlet compared = initFixedLengthMergedStaticString([strings[0],\
    \ strings[2]])\nassert lcp(merged, compared) == 2\nassert merged > compared\n\
    assert compared < merged\n\nlet ranged = initFixedLengthMergedStaticString(strings[2],\
    \ [(0, 2), (2, 4)])\nassert $ranged == \"abce\"\n\nlet integers = toStaticString([1,\
    \ 2, 3, 1, 2, 4])\nlet integerMerged = initFixedLengthMergedStaticString([integers[0..1],\
    \ integers[2..3]])\nassert $integerMerged == \"1 2 3 1\"\nassert integerMerged[2]\
    \ == 3\nassert $integerMerged[1..2] == \"2 3\"\nlet integerCompared = initFixedLengthMergedStaticString(integers,\
    \ [(0, 2), (4, 6)])\nassert lcp(integerMerged, integerCompared) == 2\nassert integerMerged\
    \ > integerCompared\n\nlet empty = initFixedLengthMergedStaticString(integers,\
    \ [(0, 0), (1, 1)])\nassert empty.len == 0\nassert $empty == \"\"\nlet integerMergedWithEmptyRanges\
    \ = initFixedLengthMergedStaticString(integers, [(0, 0), (0, 2), (3, 3)])\nlet\
    \ integerMergedWithTrailingEmpty = initFixedLengthMergedStaticString(integers,\
    \ [(0, 2), (3, 3)])\nassert cmp(empty, integerMergedWithEmptyRanges) < 0\nassert\
    \ cmp(integerMergedWithEmptyRanges, empty) > 0\nassert cmp(empty, empty) == 0\n\
    assert cmp(integerMergedWithEmptyRanges, integerMergedWithTrailingEmpty) == 0\n"
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/str/fixedlength_merged_static_string.nim
  - cplib/str/fixedlength_merged_static_string.nim
  isVerificationFile: true
  path: verify/AI/fixedlength_merged_static_string_test.nim
  requiredBy: []
  timestamp: '2026-08-01 10:17:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fixedlength_merged_static_string_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fixedlength_merged_static_string_test.nim
- /verify/verify/AI/fixedlength_merged_static_string_test.nim.html
title: verify/AI/fixedlength_merged_static_string_test.nim
---
