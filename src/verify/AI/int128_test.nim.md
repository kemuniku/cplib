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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
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
    0\") == \"0\"\n\nassert sizeof(Int128) == 16\nassert $to_Int128(high(uint64))\
    \ == \"18446744073709551615\"\nassert $to_Int128(low(int64)) == \"-9223372036854775808\"\
    \nassert to_Int128(high(int64)).to_int == high(int64)\nassert to_Int128(low(int64)).to_int\
    \ == low(int64)\nassert to_Int128(high(uint8)) == 255\nassert to_Int128(low(int8))\
    \ == -128\nassert to_Int128(high(uint16)) == 65535\nassert to_Int128(low(int16))\
    \ == -32768\nassert $to_Int128(high(uint32)) == \"4294967295\"\nassert to_Int128(low(int32))\
    \ == -2147483648\n\nlet wide = parseInt128(\"18446744073709551616\")\nvar updated\
    \ = wide\nupdated += updated\nassert updated == wide * 2\nupdated -= wide\nupdated\
    \ *= 3\nupdated.div= to_Int128(3)\nassert updated == wide\nupdated.mod= to_Int128(3)\n\
    assert updated == 1\nupdated <<= 65\nassert updated == wide * 2\nupdated >>= 64\n\
    assert updated == 2\nupdated |= wide\nupdated ^= 3\nupdated &= wide + 1\nassert\
    \ updated == wide + 1\nupdated = -wide\nupdated >>= 64\nassert updated == -1\n\
    assert (-wide - 1) div to_Int128(3) == -parseInt128(\"6148914691236517205\")\n\
    assert (-wide - 1) mod to_Int128(3) == -2\nassert wide > wide - 1\nassert wide\
    \ >= wide\nassert -wide <= -wide\nassert -wide < 0\n\ntype Int128Holder = object\n\
    \    value: Int128\n    marker: int\n\nvar holders = newSeq[Int128Holder](2)\n\
    assert holders[0].value == 0\nholders[0] = Int128Holder(value: wide, marker: 7)\n\
    holders[1] = Int128Holder(value: -wide, marker: 9)\nfor i in 0..<100:\n    holders.add(Int128Holder(value:\
    \ wide + i, marker: i))\nswap(holders[0], holders[1])\nassert holders[0].value\
    \ == -wide and holders[0].marker == 9\nassert holders[1].value == wide and holders[1].marker\
    \ == 7\nfor i in 0..<100:\n    assert holders[i + 2].value == wide + i\n    assert\
    \ holders[i + 2].marker == i\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/AI/int128_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:38:30+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/int128_test.nim
layout: document
redirect_from:
- /verify/verify/AI/int128_test.nim
- /verify/verify/AI/int128_test.nim.html
title: verify/AI/int128_test.nim
---
