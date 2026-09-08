---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/hash_string.nim
    title: cplib/str/hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/hash_string.nim
    title: cplib/str/hash_string.nim
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
    echo \"Hello World\"\n\nimport cplib/str/hash_string\n\nlet emptyRollingHash =\
    \ initRollingHash(\"\")\nassert emptyRollingHash.len == 0\nassert $emptyRollingHash\
    \ == \"\"\nassert HashString(emptyRollingHash) == get_emptystring_hash()\nassert\
    \ emptyRollingHash[0..<0].len == 0\n\nlet a = \"ab\".tohash\nlet b = 'c'.tohash\n\
    let abc = \"abc\".tohash\nassert len(a) == 2\nassert a & b == abc\nassert get_emptystring_hash()\
    \ & abc == abc\nassert \"xy\".tohash * 3 == \"xyxyxy\".tohash\nassert \"abc\"\
    .tohash.removePrefix(\"ab\".tohash) == \"c\".tohash\nassert 65.tohash == 'A'.tohash\n\
    assert ['a', 'b', 'c'].tohash == abc\nassert [65, 66].tohash == \"AB\".tohash\n\
    \nconst hashMod = (1 shl 61) - 1\nlet boundaryValues = [int.low, -hashMod, -1,\
    \ 0, 1, hashMod - 1,\n                      hashMod, hashMod + 1, int.high]\n\
    for value in boundaryValues:\n    assert [value].tohash == value.tohash\nassert\
    \ newSeq[int]().tohash == get_emptystring_hash()\nvar values: seq[int]\nvar concatenated\
    \ = get_emptystring_hash()\nfor i in 0..<4096:\n    let value = boundaryValues[i\
    \ mod boundaryValues.len]\n    values.add(value)\n    concatenated = concatenated\
    \ & value.tohash\nassert values.tohash == concatenated\nassert values.toOpenArray(1,\
    \ values.high - 1).tohash ==\n    values[1..^2].tohash\n\nlet rh = initRollingHash(\"\
    banana\")\nassert $rh[1..3] == \"ana\"\nassert rh[1..3] == rh[3..5]\nassert rh[0]\
    \ == 'b'\nassert rh[1..5].LCP(rh[3..5]) == 3\nassert cmp(rh[1..3], rh[1..3]) ==\
    \ 0\nassert rh[1..3] < rh[0..2]\nlet hs: HashString = rh[1..3]\nassert hs == \"\
    ana\".tohash\nlet arrayRh = initRollingHash(['b', 'a', 'n', 'a', 'n', 'a'])\n\
    assert arrayRh[1..3] == rh[1..3]\nassert initRollingHash(newSeq[char]()).len ==\
    \ 0\n"
  dependsOn:
  - cplib/str/hash_string.nim
  - cplib/str/hash_string.nim
  isVerificationFile: true
  path: verify/AI/hash_string_test.nim
  requiredBy: []
  timestamp: '2026-09-08 05:46:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/hash_string_test.nim
layout: document
redirect_from:
- /verify/verify/AI/hash_string_test.nim
- /verify/verify/AI/hash_string_test.nim.html
title: verify/AI/hash_string_test.nim
---
