---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/defaultdict.nim
    title: cplib/collections/defaultdict.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/defaultdict.nim
    title: cplib/collections/defaultdict.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\nimport tables, hashes\nimport cplib/collections/defaultdict\n\
    \nvar d1 = @[(0, 0), (1, 1), (2, 2)].toDefaultDict(0)\nvar d2 = initDefaultDict[int,\
    \ int](0)\nassert d2[0] == 0\nd2[1] = 1\nd2[2] = 2\nassert d1 == d2\nd1.clear\n\
    assert d1[1] == 0\nd2.del(1)\nvar x: int\nassert d2.pop(2, x)\nassert x == 2\n\
    assert d2.take(0, x)\nassert x == 0\nassert d2[1] == 0\nassert hash(d1) == hash(d1)\n\
    assert 1 in d1\nassert 2 notin d1\nfor k, v in d1:\n    assert k == 1 and v ==\
    \ 0\nassert ($d1) == \"{1: 0}\"\n"
  dependsOn:
  - cplib/collections/defaultdict.nim
  - cplib/collections/defaultdict.nim
  isVerificationFile: true
  path: verify/collections/defaultdict/defaultdict_unit_test.nim
  requiredBy: []
  timestamp: '2024-02-07 11:08:04+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/defaultdict/defaultdict_unit_test.nim
layout: document
redirect_from:
- /verify/verify/collections/defaultdict/defaultdict_unit_test.nim
- /verify/verify/collections/defaultdict/defaultdict_unit_test.nim.html
title: verify/collections/defaultdict/defaultdict_unit_test.nim
---
