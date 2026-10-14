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
    import hashes, tables\nimport cplib/collections/defaultdict\n\ntype CollisionKey\
    \ = object\n    id: int\nproc hash(key: CollisionKey): Hash = 0\n\nvar d = initDefaultDict[CollisionKey,\
    \ int](17)\nvar model: seq[(int, int)]\nlet sampleKeys = @[low(int), high(int),\
    \ -1, 0, 1, 2, 7, 9, 15]\n\nproc find(key: int): int =\n    for i, pair in model:\n\
    \        if pair[0] == key: return i\n    -1\n\nproc check() =\n    let beforeLen\
    \ = d.len\n    let beforeHash = d.hash\n    let beforeText = $d\n    for id in\
    \ sampleKeys:\n        let i = find(id)\n        let key = CollisionKey(id: id)\n\
    \        let expected = if i < 0: 17 else: model[i][1]\n        doAssert d.get(key)\
    \ == expected\n        doAssert d.hasKey(key) == (i >= 0)\n    doAssert d.len\
    \ == beforeLen\n    doAssert d.hash == beforeHash\n    doAssert $d == beforeText\n\
    \    var count = 0\n    for key, value in d.pairs:\n        let i = find(key.id)\n\
    \        doAssert i >= 0 and model[i][1] == value\n        inc count\n    doAssert\
    \ count == model.len and d.len == model.len\n\ncheck()\nfor step in 0..<500:\n\
    \    let id = sampleKeys[(step * 7 + step div 9) mod sampleKeys.len]\n    let\
    \ key = CollisionKey(id: id)\n    let i = find(id)\n    case step mod 11\n   \
    \ of 0:\n        d.clear()\n        model.setLen(0)\n    of 1, 2:\n        d.del(key)\n\
    \        if i >= 0: model.delete(i)\n    of 3, 4, 5:\n        let delta = step\
    \ mod 17 - 8\n        d[key] += delta\n        if i >= 0: model[i][1] += delta\n\
    \        else: model.add((id, 17 + delta))\n    of 6, 7:\n        let value =\
    \ step - 250\n        d[key] = value\n        if i >= 0: model[i][1] = value\n\
    \        else: model.add((id, value))\n    else:\n        discard d.get(key)\n\
    \    check()\n\nlet immutable = [(\"present\", 0)].toDefaultDict(-3)\ndoAssert\
    \ immutable.get(\"present\") == 0\ndoAssert immutable.get(\"missing\") == -3\n\
    doAssert immutable.len == 1 and not immutable.hasKey(\"missing\")\nlet converted\
    \ = {\"present\": 5}.toTable.toDefaultDict(-9)\ndoAssert converted.get(\"present\"\
    ) == 5\ndoAssert converted.get(\"missing\") == -9\ndoAssert converted.len == 1\n\
    \nvar sequenceDict = initDefaultDict[int, seq[int]](@[10])\ndoAssert sequenceDict.get(1)\
    \ == @[10]\ndoAssert sequenceDict.len == 0\nvar copied = sequenceDict.get(1)\n\
    copied.add(99)\ndoAssert sequenceDict.get(2) == @[10] and sequenceDict.len ==\
    \ 0\nsequenceDict[1].add(20)\ndoAssert sequenceDict.get(1) == @[10, 20]\ndoAssert\
    \ sequenceDict.get(2) == @[10]\ndoAssert sequenceDict.len == 1 and not sequenceDict.hasKey(2)\n\
    \ntype Payload = object\n    number: int\n    text: string\nproc update(value:\
    \ var Payload) =\n    inc value.number\n    value.text.add(\"!\")\nvar objects\
    \ = initDefaultDict[int, Payload](Payload(number: 7, text: \"default\"))\ndoAssert\
    \ objects.get(1).number == 7\ndoAssert objects.len == 0\nobjects[1].update()\n\
    doAssert objects.get(1) == Payload(number: 8, text: \"default!\")\ndoAssert objects.get(2)\
    \ == Payload(number: 7, text: \"default\")\ndoAssert objects.len == 1\n\ntype\
    \ Reference = ref object\n    number: int\nlet fallback = Reference(number: 7)\n\
    var references = initDefaultDict[int, Reference](fallback)\ndoAssert references.get(1)\
    \ == fallback\ndoAssert references.len == 0\nreferences.get(1).number = 9\ndoAssert\
    \ fallback.number == 9 and not references.hasKey(1)\nvar nilDefaults = initDefaultDict[int,\
    \ Reference](nil)\ndoAssert nilDefaults.get(0).isNil and nilDefaults.len == 0\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/defaultdict.nim
  - cplib/collections/defaultdict.nim
  isVerificationFile: true
  path: verify/collections/defaultdict/defaultdict_get_test.nim
  requiredBy: []
  timestamp: '2026-10-04 21:25:36+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/defaultdict/defaultdict_get_test.nim
layout: document
redirect_from:
- /verify/verify/collections/defaultdict/defaultdict_get_test.nim
- /verify/verify/collections/defaultdict/defaultdict_get_test.nim.html
title: verify/collections/defaultdict/defaultdict_get_test.nim
---
