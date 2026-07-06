---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashtable.nim
    title: cplib/collections/hashtable.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashtable.nim
    title: cplib/collections/hashtable.nim
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
    echo \"Hello World\"\n\nimport algorithm\nimport cplib/collections/hashtable\n\
    \nvar ht = initHashTable[string, int]()\nassert ht.len == 0\nht[\"a\"] = 1\nht[\"\
    b\"] = 2\nht[\"a\"] = 3\nassert ht.len == 2\nassert ht[\"a\"] == 3\nht[\"a\"]\
    \ += 4\nassert ht[\"a\"] == 7\nassert ht.contains(\"b\")\nassert ht.hasKey(\"\
    a\")\nht.del(\"b\")\nassert not ht.contains(\"b\")\nfor i in 0..20:\n  ht[$i]\
    \ = i\nassert not ht.contains(\"b\")\nassert ht[\"20\"] == 20\n\nvar keys: seq[string]\n\
    for k in ht.keys:\n  keys.add(k)\nkeys.sort()\nassert \"a\" in keys\nassert \"\
    20\" in keys\n\nvar valList: seq[int]\nfor v in values(ht):\n  valList.add(v)\n\
    valList.sort()\nassert 7 in valList\nassert 20 in valList\n\nvar pairs: seq[(string,\
    \ int)]\nfor p in ht.pairs:\n  pairs.add(p)\nassert (\"a\", 7) in pairs\n\nlet\
    \ oldHash = hash(ht)\nassert oldHash == hash(ht)\nht.clear()\nassert ht.len ==\
    \ 0\n\nvar ht2 = initHashTable[int, int](10)\nht2.incl((1, 2))\nht2.incl((1, 5))\n\
    assert ht2.len == 1\nassert ht2[1] == 5\nht2.excl(1)\nassert not ht2.hasKey(1)\n"
  dependsOn:
  - cplib/collections/hashtable.nim
  - cplib/collections/hashtable.nim
  isVerificationFile: true
  path: verify/AI/hashtable_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/hashtable_test.nim
layout: document
redirect_from:
- /verify/verify/AI/hashtable_test.nim
- /verify/verify/AI/hashtable_test.nim.html
title: verify/AI/hashtable_test.nim
---
