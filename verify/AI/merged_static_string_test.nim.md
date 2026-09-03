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
    path: cplib/str/merged_static_string.nim
    title: cplib/str/merged_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/merged_static_string.nim
    title: cplib/str/merged_static_string.nim
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/str/merged_static_string

    import cplib/str/static_string


    let ss = toStaticStrings(@["ab", "cd", "abce"])

    let m1 = ss[0] & ss[1]

    assert $m1 == "abcd"

    assert m1.len == 4

    assert m1[2] == ''c''

    assert $m1[1..2] == "bc"

    var m2 = initMergedStaticString(@[ss[0]])

    m2 &= ss[1]

    assert m1 == m2

    let m3 = ss[0] & ss[2]

    assert lcp(m1, m3) == 2

    assert cmp(m1, m3) > 0

    assert m3 < m1

    assert m1 >= m2


    let integerStatic = toStaticString([1, 2, 3, 1, 2, 4])

    let integerMerged = integerStatic[0..1] & integerStatic[2..3]

    assert $integerMerged == "1 2 3 1"

    assert integerMerged.len == 4

    assert integerMerged[2] == 3

    assert $integerMerged[1..2] == "2 3"

    var integerMerged2 = initMergedStaticString(@[integerStatic[0..1]])

    integerMerged2 &= integerStatic[2..3]

    assert integerMerged == integerMerged2

    let integerMerged3 = integerStatic[0..1] & integerStatic[4..5]

    assert lcp(integerMerged, integerMerged3) == 2

    assert integerMerged > integerMerged3

    var emptyIntegerMerged: MergedStaticString[int]

    assert $emptyIntegerMerged == ""

    let initializedEmptyIntegerMerged = initMergedStaticString(newSeq[StaticString[int]]())

    assert initializedEmptyIntegerMerged.len == 0


    let integerMergedFromRanges = initMergedStaticString(integerStatic, @[(0, 2),
    (2, 4)])

    assert integerMergedFromRanges == integerMerged

    let integerSubStatic = integerStatic[1..5]

    let integerSubMergedFromRanges = initMergedStaticString(integerSubStatic, @[(0,
    2), (3, 5)])

    assert $integerSubMergedFromRanges == "2 3 2 4"

    let emptyIntegerMergedFromRanges = initMergedStaticString(integerStatic, newSeq[(int,
    int)]())

    assert emptyIntegerMergedFromRanges.len == 0

    let integerMergedWithEmptyRange = initMergedStaticString(integerStatic, @[(1,
    1), (0, 2)])

    assert $integerMergedWithEmptyRange == "1 2"

    let allEmptyIntegerMerged = initMergedStaticString(integerStatic, @[(0, 0), (2,
    2)])

    let integerMergedWithTrailingEmpty = initMergedStaticString(integerStatic, @[(0,
    2), (3, 3)])

    assert cmp(allEmptyIntegerMerged, integerMergedWithEmptyRange) < 0

    assert cmp(integerMergedWithEmptyRange, allEmptyIntegerMerged) > 0

    assert cmp(allEmptyIntegerMerged, allEmptyIntegerMerged) == 0

    assert cmp(integerMergedWithEmptyRange, integerMergedWithTrailingEmpty) == 0


    let reversibleIntegerStatic = toStaticString([1, 2, 3, 4], reversible=true).reversed

    let reversedIntegerMergedFromRanges = initMergedStaticString(reversibleIntegerStatic,
    @[(1, 3), (0, 1)])

    assert $reversedIntegerMergedFromRanges == "3 2 4"

    '
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/str/merged_static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/merged_static_string.nim
  - cplib/str/static_string.nim
  - cplib/str/static_string.nim
  isVerificationFile: true
  path: verify/AI/merged_static_string_test.nim
  requiredBy: []
  timestamp: '2026-08-01 10:17:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/merged_static_string_test.nim
layout: document
redirect_from:
- /verify/verify/AI/merged_static_string_test.nim
- /verify/verify/AI/merged_static_string_test.nim.html
title: verify/AI/merged_static_string_test.nim
---
