---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
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
    import cplib/collections/lazy_leftist_heap\nimport random\n\ntype Item = tuple[key:\
    \ int64, value: int]\nvar pool = initLazyLeftistHeapPool[int64, int](1000)\nvar\
    \ roots: array[16, int]\nvar oracle: array[16, seq[Item]]\nfor root in roots.mitems:\
    \ root = -1\nvar next = 0\nvar rng = initRand(940)\n\nproc best(items: seq[Item]):\
    \ int =\n    result = 0\n    for i in 1..<items.len:\n        if items[i].key\
    \ < items[result].key or\n                (items[i].key == items[result].key and\
    \ items[i].value < items[result].value):\n            result = i\n\nproc check()\
    \ =\n    for i in 0..<roots.len:\n        doAssert (roots[i] == -1) == (oracle[i].len\
    \ == 0)\n        if roots[i] != -1:\n            doAssert pool.top(roots[i]) ==\
    \ oracle[i][best(oracle[i])]\n\nproc insert(i: int, key: int64) =\n    let h =\
    \ pool.singleton(key, next)\n    oracle[i].add((key, next))\n    roots[i] = pool.meld(roots[i],\
    \ h)\n    inc next\n\nproc add(i: int, delta: int64) =\n    pool.addAll(roots[i],\
    \ delta)\n    for item in oracle[i].mitems: item.key += delta\n\nproc merge(a,\
    \ b: int) =\n    doAssert a != b\n    roots[a] = pool.meld(roots[a], roots[b])\n\
    \    roots[b] = -1\n    oracle[a].add(oracle[b])\n    oracle[b] = @[]\n\nproc\
    \ remove(i: int) =\n    let at = best(oracle[i])\n    doAssert pool.top(roots[i])\
    \ == oracle[i][at]\n    roots[i] = pool.pop(roots[i])\n    oracle[i].delete(at)\n\
    \n# \u9045\u5EF6\u52A0\u7B97\u5F8C\u306E\u65B0\u898F\u8981\u7D20\u3068\u5225\u30D2\
    \u30FC\u30D7\u3078\u3001\u4EE5\u524D\u306E\u52A0\u7B97\u304C\u6F0F\u308C\u306A\
    \u3044\u3053\u3068\u3092\u78BA\u8A8D\u3059\u308B\u3002\ninsert(0, 4)\ninsert(0,\
    \ 4)\nadd(0, -10)\ninsert(1, -6)\nmerge(1, 0)\ninsert(1, -6)\ncheck()\nwhile roots[1]\
    \ != -1:\n    remove(1)\n    check()\nadd(0, -99)\nmerge(0, 1)\n\nfor step in\
    \ 0..<50000:\n    let a = rng.rand(roots.len - 1)\n    case rng.rand(0..3)\n \
    \   of 0: insert(a, rng.rand(-30..30).int64)\n    of 1: add(a, rng.rand(-30..30).int64)\n\
    \    of 2:\n        let b = (a + rng.rand(1..<roots.len)) mod roots.len\n    \
    \    merge(a, b)\n    else:\n        if roots[a] != -1: remove(a)\n    check()\n\
    for i in 0..<roots.len:\n    while roots[i] != -1: remove(i)\ncheck()\n\nblock:\n\
    \    # payload \u306E\u6BD4\u8F03\u306F\u4E0D\u8981\u3002\u540C\u3058\u30AD\u30FC\
    \u306F\u4F75\u5408\u9806\u306B\u3088\u3089\u305A\u633F\u5165\u9806\u3002\n   \
    \ type Payload = object\n        label: string\n    var strings = initLazyLeftistHeapPool[int,\
    \ Payload]()\n    let a = strings.singleton(1, Payload(label: \"first\"))\n  \
    \  let b = strings.singleton(1, Payload(label: \"second\"))\n    var root = strings.meld(b,\
    \ a)\n    doAssert strings.top(root).value.label == \"first\"\n    root = strings.pop(root)\n\
    \    doAssert strings.top(root).value.label == \"second\"\n    doAssert strings.pop(root)\
    \ == -1\n\nblock:\n    var large = initLazyLeftistHeapPool[int64, int](200000)\n\
    \    var root = -1\n    for i in countdown(199999, 0):\n        root = large.meld(root,\
    \ large.singleton(i.int64, i))\n    large.addAll(root, -200000)\n    for i in\
    \ 0..<200000:\n        doAssert large.top(root) == (i.int64 - 200000, i)\n   \
    \     root = large.pop(root)\n    doAssert root == -1\n\nstderr.writeLine(\"lazy\
    \ leftist heap regression: 50000 oracle operations and 200000 elements passed\"\
    )\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/lazy_leftist_heap.nim
  - cplib/collections/lazy_leftist_heap.nim
  isVerificationFile: true
  path: verify/AI/lazy_leftist_heap_test.nim
  requiredBy: []
  timestamp: '2026-10-04 00:13:01+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lazy_leftist_heap_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lazy_leftist_heap_test.nim
- /verify/verify/AI/lazy_leftist_heap_test.nim.html
title: verify/AI/lazy_leftist_heap_test.nim
---
