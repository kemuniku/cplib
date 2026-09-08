---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
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
    echo \"Hello World\"\n\nimport cplib/str/can_reverse_hash_string\n\nlet emptyRollingHash\
    \ = initRollingHash(\"\")\nassert emptyRollingHash.len == 0\nassert $emptyRollingHash\
    \ == \"\"\nassert HashString(emptyRollingHash) == get_emptystring_hash()\nassert\
    \ emptyRollingHash[0..<0].len == 0\n\nlet aba = \"aba\".tohash\nlet ab = \"ab\"\
    .tohash\nassert aba.isPalindrome\nassert not ab.isPalindrome\nassert ab.reversed\
    \ == \"ba\".tohash\nassert \"ab\".tohash & \"c\".tohash == \"abc\".tohash\nassert\
    \ \"ab\".tohash * 3 == \"ababab\".tohash\nassert get_emptystring_hash() & aba\
    \ == aba\nassert 65.tohash == 'A'.tohash\nassert ['a', 'b', 'a'].tohash == aba\n\
    assert [65, 66].tohash == \"AB\".tohash\n\nconst hashMod = (1 shl 61) - 1\nlet\
    \ boundaryValues = [0, 1, hashMod - 1]\nassert newSeq[int]().tohash == get_emptystring_hash()\n\
    var values: seq[int]\nvar concatenated = get_emptystring_hash()\nvar reverseConcatenated\
    \ = get_emptystring_hash()\nfor i in 0..<4096:\n    let value = boundaryValues[i\
    \ mod boundaryValues.len]\n    values.add(value)\n    concatenated = concatenated\
    \ & value.tohash\n    reverseConcatenated = value.tohash & reverseConcatenated\n\
    assert values.tohash == concatenated\nassert values.tohash.reversed == reverseConcatenated\n\
    assert values.toOpenArray(1, values.high - 1).tohash.reversed ==\n    values[1..^2].tohash.reversed\n\
    \nwhen compileOption(\"assertions\"):\n    for value in [int.low, -1, hashMod,\
    \ hashMod + 1, int.high]:\n        for index in 0..<5:\n            var invalidValues\
    \ = @[0, 1, 2, 3, 4]\n            invalidValues[index] = value\n            var\
    \ rejected = false\n            try:\n                discard invalidValues.tohash\n\
    \            except AssertionDefect:\n                rejected = true\n      \
    \      doAssert rejected\n\nlet rh = initRollingHash(\"abacaba\")\nassert $rh[0..2]\
    \ == \"aba\"\nassert rh[0..2].isPalindrome\nassert rh[0..2].reversed == rh[0..2]\n\
    assert rh[0..2] == rh[4..6]\nassert rh[0] == 'a'\nassert rh[0..6].LCP(rh[4..6])\
    \ == 3\nassert cmp(rh[0..2], rh[1..3]) < 0\nlet hs: HashString = rh[0..2]\nassert\
    \ hs == aba\nlet arrayRh = initRollingHash(['a', 'b', 'a', 'c', 'a', 'b', 'a'])\n\
    assert arrayRh[0..2] == rh[0..2]\nassert initRollingHash(newSeq[char]()).len ==\
    \ 0\n"
  dependsOn:
  - cplib/str/can_reverse_hash_string.nim
  - cplib/str/can_reverse_hash_string.nim
  isVerificationFile: true
  path: verify/AI/can_reverse_hash_string_test.nim
  requiredBy: []
  timestamp: '2026-09-08 05:46:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/can_reverse_hash_string_test.nim
layout: document
redirect_from:
- /verify/verify/AI/can_reverse_hash_string_test.nim
- /verify/verify/AI/can_reverse_hash_string_test.nim.html
title: verify/AI/can_reverse_hash_string_test.nim
---
