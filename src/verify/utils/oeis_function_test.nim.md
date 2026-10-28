---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/oeis.nim
    title: cplib/utils/oeis.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/oeis.nim
    title: cplib/utils/oeis.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://oeis.org/search?q=13,14,15,23,24,25&fmt=json
    - https://oeis.org/search?q=13,14,23,15,24,25&fmt=json
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    \ntype\n    HttpClient = ref object\n    MockResponse = object\n        code:\
    \ int\n        body: string\n\nconst Http200 = 200\nvar requests: seq[string]\n\
    var closedClients = 0\n\nproc newHttpClient(): HttpClient = HttpClient()\nproc\
    \ close(client: HttpClient) = inc closedClients\nproc get(client: HttpClient,\
    \ url: string): MockResponse =\n    requests.add(url)\n    MockResponse(code:\
    \ Http200,\n        body: \"[{\\\"number\\\":27,\\\"name\\\":\\\"test\\\",\\\"\
    data\\\":\\\"1,2,3\\\"}]\")\n\ninclude cplib/utils/oeis\n\nproc f(x, y: int):\
    \ int = x * 10 + y\n\nblock:\n    let matches = searchOEIS(f, 1..2, 3..5)\n  \
    \  doAssert matches.len == 2\n    doAssert matches[0].query == \"13,14,15,23,24,25\"\
    \n    doAssert matches[1].query == \"13,14,23,15,24,25\"\n    doAssert matches[0].kind\
    \ == oeisMatrixRowMajor\n    doAssert matches[1].kind == oeisMatrixAntidiagonal\n\
    \    doAssert requests == @[\n        \"https://oeis.org/search?q=13,14,15,23,24,25&fmt=json\"\
    ,\n        \"https://oeis.org/search?q=13,14,23,15,24,25&fmt=json\"]\n    doAssert\
    \ closedClients == 1\n\nblock:\n    var calls: seq[(int, int)]\n    let offset\
    \ = 100'i64\n    let captured = proc(x, y: int): int64 =\n        calls.add((x,\
    \ y))\n        offset + int64(x * 10 + y)\n    let matches = searchOEIS(captured,\
    \ xRange = -1..1, yRange = 2..3)\n    doAssert calls == @[(-1, 2), (-1, 3), (0,\
    \ 2), (0, 3), (1, 2), (1, 3)]\n    doAssert matches[0].query == \"92,93,102,103,112,113\"\
    \n    doAssert matches[1].query == \"92,93,102,103,112,113\"\n\nblock:\n    var\
    \ calls: seq[(int, int)]\n    let matches = searchOEIS(proc(x, y: int): int =\n\
    \        calls.add((x, y))\n        f(x, y))\n    doAssert calls.len == 100\n\
    \    doAssert calls[0] == (0, 0)\n    doAssert calls[^1] == (9, 9)\n    doAssert\
    \ matches[0].query.split(',').len == 100\n    doAssert matches[1].query.split(',').len\
    \ == 100\n\nblock:\n    let matches = searchOEIS(proc(x, y: int): uint64 = uint64(y),\
    \ 0..0, 2..4)\n    doAssert matches[0].query == \"2,3,4\"\n    doAssert matches[1].query\
    \ == \"2,3,4\"\n\nblock:\n    let requestCount = requests.len\n    let closeCount\
    \ = closedClients\n    var calls = 0\n    let counted = proc(x, y: int): int =\n\
    \        inc calls\n        f(x, y)\n    doAssert searchOEIS(counted, 1..0, 0..2).len\
    \ == 0\n    doAssert searchOEIS(counted, 0..2, 1..0).len == 0\n    doAssert calls\
    \ == 0\n    doAssert requests.len == requestCount\n    doAssert closedClients\
    \ == closeCount\n\nblock:\n    let requestCount = requests.len\n    var failed\
    \ = false\n    try:\n        discard searchOEIS(proc(x, y: int): int =\n     \
    \       raise newException(ValueError, \"test\"), 0..1, 0..1)\n    except ValueError:\n\
    \        failed = true\n    doAssert failed\n    doAssert requests.len == requestCount\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/utils/oeis.nim
  - cplib/utils/oeis.nim
  isVerificationFile: true
  path: verify/utils/oeis_function_test.nim
  requiredBy: []
  timestamp: '2026-10-14 21:36:14+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/oeis_function_test.nim
layout: document
redirect_from:
- /verify/verify/utils/oeis_function_test.nim
- /verify/verify/utils/oeis_function_test.nim.html
title: verify/utils/oeis_function_test.nim
---
