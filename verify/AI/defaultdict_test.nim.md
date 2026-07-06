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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport algorithm, tables\nimport cplib/collections/defaultdict\n\
    \nvar d = initDefaultDict[string, int](0)\nassert d.len == 0\nassert d[\"missing\"\
    ] == 0\nassert d.len == 1\nd[\"a\"] += 2\nd[\"b\"] = 5\nassert d[\"a\"] == 2\n\
    assert d.hasKey(\"b\")\nassert d.contains(\"a\")\nvar keys: seq[string]\nfor k\
    \ in d.keys:\n  keys.add(k)\nkeys.sort()\nassert keys == @[\"a\", \"b\", \"missing\"\
    ]\nvar vals: seq[int]\nfor v in d.values:\n  vals.add(v)\nvals.sort()\nassert\
    \ vals == @[0, 2, 5]\nfor k, v in d.mpairs:\n  if k == \"a\":\n    v = 7\nassert\
    \ d[\"a\"] == 7\nvar popped = 0\nassert d.pop(\"a\", popped)\nassert popped ==\
    \ 7\nassert d.take(\"b\", popped)\nassert popped == 5\nd.del(\"missing\")\nassert\
    \ d.len == 0\n\nlet c = toDefaultDict({\"x\": 1, \"y\": 2}.toTable, -1)\nassert\
    \ c[\"x\"] == 1\nassert c[\"z\"] == -1\nlet e = toDefaultDict([(\"x\", 1), (\"\
    y\", 2)], -1)\nassert e == c\nassert $e == \"\"\"{\"x\": 1, \"y\": 2}\"\"\" or\
    \ $e == \"\"\"{\"y\": 2, \"x\": 1}\"\"\"\nd.clear()\nassert d.len == 0\n"
  dependsOn:
  - cplib/collections/defaultdict.nim
  - cplib/collections/defaultdict.nim
  isVerificationFile: true
  path: verify/AI/defaultdict_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/defaultdict_test.nim
layout: document
redirect_from:
- /verify/verify/AI/defaultdict_test.nim
- /verify/verify/AI/defaultdict_test.nim.html
title: verify/AI/defaultdict_test.nim
---
