---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
    echo \"Hello World\"\n\nimport cplib/math/int128\n\nlet a = parseInt128(\"123456789012345678901234567890\"\
    )\nlet b = parseInt128(\"10\")\nassert $a == \"123456789012345678901234567890\"\
    \nassert $(a + b) == \"123456789012345678901234567900\"\nassert $((a + b) - a)\
    \ == \"10\"\nassert $(b * b) == \"100\"\nassert $(parseInt128(\"100\") div b)\
    \ == \"10\"\nassert $(parseInt128(\"103\") mod b) == \"3\"\nassert (parseInt128(\"\
    5\") & parseInt128(\"3\")).to_int == 1\nassert (parseInt128(\"5\") | parseInt128(\"\
    2\")).to_int == 7\nassert (parseInt128(\"5\") ^ parseInt128(\"1\")).to_int ==\
    \ 4\nassert (parseInt128(\"1\") << parseInt128(\"5\")).to_int == 32\nassert (parseInt128(\"\
    32\") >> parseInt128(\"2\")).to_int == 8\nassert -b < b\nassert abs(-b) == b\n\
    assert cmp(b, parseInt128(\"10\")) == 0\nassert pow(parseInt128(\"2\"), parseInt128(\"\
    10\")).to_int == 1024\nassert pow(parseInt128(\"2\"), parseInt128(\"10\"), parseInt128(\"\
    1000\")).to_int == 24\n\nimport hashes, tables\n\nlet boundaryStrings = @[\n \
    \   \"0\", \"1\", \"-1\", \"9999\", \"10000\", \"-10000\",\n    \"18446744073709551616\"\
    , \"-18446744073709551616\",\n    \"170141183460469231731687303715884105727\"\
    ,\n    \"-170141183460469231731687303715884105728\"\n]\nvar values = initTable[Int128,\
    \ string]()\nfor s in boundaryStrings:\n    let x = parseInt128(s)\n    assert\
    \ $x == s\n    assert hash(x) == hash(parseInt128(s))\n    values[x] = s\nfor\
    \ s in boundaryStrings:\n    assert values[parseInt128(s)] == s\nassert values.len\
    \ == boundaryStrings.len\nassert $(parseInt128(boundaryStrings[^1]) + 1) == \"\
    -170141183460469231731687303715884105727\"\nassert $(parseInt128(boundaryStrings[^2])\
    \ - 1) == \"170141183460469231731687303715884105726\"\nassert $parseInt128(\"\
    0\") == \"0\"\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/AI/int128_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/int128_test.nim
layout: document
redirect_from:
- /verify/verify/AI/int128_test.nim
- /verify/verify/AI/int128_test.nim.html
title: verify/AI/int128_test.nim
---
