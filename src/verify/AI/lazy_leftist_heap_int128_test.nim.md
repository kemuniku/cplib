---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
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
    import cplib/math/int128\nimport cplib/collections/lazy_leftist_heap\nimport random\n\
    \nvar pool = initLazyLeftistHeapPool[Int128, int](zero = to_Int128(0))\nvar roots:\
    \ array[8, int]\nvar oracle: array[8, seq[tuple[key: int64, value: int]]]\nfor\
    \ root in roots.mitems: root = -1\nvar rng = initRand(940128)\nvar next = 0\n\
    let offset = to_Int128(high(int64)) * to_Int128(4)\n\nproc check() =\n    for\
    \ i in 0..<roots.len:\n        doAssert (roots[i] == -1) == (oracle[i].len ==\
    \ 0)\n        if roots[i] != -1:\n            var at = 0\n            for j in\
    \ 1..<oracle[i].len:\n                if oracle[i][j] < oracle[i][at]: at = j\n\
    \            let actual = pool.top(roots[i])\n            doAssert actual.key\
    \ == offset + to_Int128(oracle[i][at].key)\n            doAssert actual.value\
    \ == oracle[i][at].value\n\nfor step in 0..<10000:\n    let a = rng.rand(roots.len\
    \ - 1)\n    case rng.rand(0..3)\n    of 0:\n        let key = rng.rand(-30..30).int64\n\
    \        roots[a] = pool.meld(roots[a], pool.singleton(offset + to_Int128(key),\
    \ next))\n        oracle[a].add((key, next))\n        inc next\n    of 1:\n  \
    \      let delta = rng.rand(-30..30).int64\n        pool.addAll(roots[a], to_Int128(delta))\n\
    \        for item in oracle[a].mitems: item.key += delta\n    of 2:\n        let\
    \ b = (a + rng.rand(1..<roots.len)) mod roots.len\n        roots[a] = pool.meld(roots[a],\
    \ roots[b])\n        roots[b] = -1\n        oracle[a].add(oracle[b])\n       \
    \ oracle[b] = @[]\n    else:\n        if roots[a] != -1:\n            var at =\
    \ 0\n            for j in 1..<oracle[a].len:\n                if oracle[a][j]\
    \ < oracle[a][at]: at = j\n            roots[a] = pool.pop(roots[a])\n       \
    \     oracle[a].delete(at)\n    check()\nfor i in 0..<roots.len:\n    while roots[i]\
    \ != -1:\n        check()\n        var at = 0\n        for j in 1..<oracle[i].len:\n\
    \            if oracle[i][j] < oracle[i][at]: at = j\n        roots[i] = pool.pop(roots[i])\n\
    \        oracle[i].delete(at)\ncheck()\nstderr.writeLine(\"Int128 lazy leftist\
    \ heap regression: 10000 oracle operations passed\")\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/lazy_leftist_heap.nim
  - cplib/math/int128.nim
  - cplib/collections/lazy_leftist_heap.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/AI/lazy_leftist_heap_int128_test.nim
  requiredBy: []
  timestamp: '2026-10-04 00:13:01+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lazy_leftist_heap_int128_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lazy_leftist_heap_int128_test.nim
- /verify/verify/AI/lazy_leftist_heap_int128_test.nim.html
title: verify/AI/lazy_leftist_heap_int128_test.nim
---
