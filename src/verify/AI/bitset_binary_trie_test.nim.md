---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_binary_trie.nim
    title: cplib/collections/bitset_binary_trie.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_binary_trie.nim
    title: cplib/collections/bitset_binary_trie.nim
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
    import random, algorithm\nimport cplib/collections/bitset_binary_trie\nwhen defined(cpp):\n\
    \    import cplib/collections/bitset as scalar\n    import cplib/collections/staticbitset\
    \ as fixed\nimport cplib/collections/bitset_avx2 as avx2\nimport cplib/collections/bitset_avx512\
    \ as avx512\nimport cplib/collections/staticbitset_avx2 as fixed2\nimport cplib/collections/staticbitset_avx512\
    \ as fixed512\n\nproc compare[T, U](a: T, b: U): int =\n    for i in 0..<a.len:\n\
    \        if a[i] != b[i]:\n            return if a[i]: 1 else: -1\n\nproc makeKey[T](sample:\
    \ T, bits: seq[bool]): T =\n    result = sample\n    for i in 0..<bits.len:\n\
    \        result[i] = bits[i]\n\nproc test[T](sample: T) =\n    var trie = initBitSetBinaryTrie(sample)\n\
    \    var explicitTrie = initBitSetBinaryTrie[T](sample.len)\n    explicitTrie.incl(sample)\n\
    \    doAssert explicitTrie.count(sample) == 1\n    var expected: seq[seq[bool]]\n\
    \    var rng = initRand(8247)\n\n    proc checkState(query, mask: T) =\n     \
    \   doAssert trie.len == expected.len\n        var expectedCount, lower, upper,\
    \ xorLower, xorUpper: int\n        for key in expected:\n            let order\
    \ = compare(key, query)\n            expectedCount += ord(order == 0)\n      \
    \      lower += ord(order < 0)\n            upper += ord(order <= 0)\n       \
    \     var xorOrder = 0\n            for i in 0..<query.len:\n                let\
    \ bit = key[i] xor mask[i]\n                if bit != query[i]:\n            \
    \        xorOrder = if bit: 1 else: -1\n                    break\n          \
    \  xorLower += ord(xorOrder < 0)\n            xorUpper += ord(xorOrder <= 0)\n\
    \        doAssert trie.count(query) == expectedCount\n        doAssert (query\
    \ in trie) == (expectedCount > 0)\n        doAssert trie.lowerBound(query) ==\
    \ lower\n        doAssert trie.upperBound(query) == upper\n        doAssert trie.lowerBound(query,\
    \ mask) == xorLower\n        doAssert trie.upperBound(query, mask) == xorUpper\n\
    \        var ordered = newSeq[int](expected.len)\n        for i in 0..<ordered.len:\n\
    \            ordered[i] = i\n        ordered.sort(proc(a, b: int): int = compare(expected[a],\
    \ expected[b]))\n        for i in 0..<ordered.len:\n            doAssert compare(trie[i],\
    \ expected[ordered[i]]) == 0\n        ordered.sort(proc(a, b: int): int =\n  \
    \          for i in 0..<mask.len:\n                let abit = expected[a][i] xor\
    \ mask[i]\n                let bbit = expected[b][i] xor mask[i]\n           \
    \     if abit != bbit:\n                    return if abit: 1 else: -1)\n    \
    \    for i in 0..<ordered.len:\n            doAssert compare(trie.get_kth(i, mask),\
    \ expected[ordered[i]]) == 0\n        var raised = false\n        try:\n     \
    \       discard trie.get_kth(expected.len)\n        except IndexDefect:\n    \
    \        raised = true\n        doAssert raised\n\n    checkState(sample, sample)\n\
    \    for bit in [0, 63, 64, 255, 256, 511, 512, sample.len - 1]:\n        if bit\
    \ >= 0 and bit < sample.len:\n            var key = sample\n            key[bit]\
    \ = true\n            trie.incl(key)\n            var bits = newSeq[bool](sample.len)\n\
    \            bits[bit] = true\n            expected.add(bits)\n            checkState(key,\
    \ key)\n    for step in 0..<120:\n        var key = sample\n        var mask =\
    \ sample\n        for i in 0..<sample.len:\n            key[i] = rng.rand(1) ==\
    \ 1\n            mask[i] = rng.rand(1) == 1\n        if step mod 3 != 0 or expected.len\
    \ == 0:\n            let copies = rng.rand(2) + 1\n            trie.incl(key,\
    \ copies)\n            var bits = newSeq[bool](sample.len)\n            for i\
    \ in 0..<sample.len:\n                bits[i] = key[i]\n            for j in 0..<copies:\n\
    \                expected.add(bits)\n        else:\n            let index = rng.rand(expected.high)\n\
    \            key = makeKey(sample, expected[index])\n            trie.excl(key)\n\
    \            expected.delete(index)\n        checkState(key, mask)\n        checkState(mask,\
    \ mask)\n        for invalid in [-1, trie.count(key) + 1]:\n            var raised\
    \ = false\n            try:\n                trie.excl(key, invalid)\n       \
    \     except ValueError:\n                raised = true\n            doAssert\
    \ raised\n            checkState(key, mask)\n    while expected.len > 0:\n   \
    \     trie.excl(makeKey(sample, expected.pop()))\n    checkState(sample, sample)\n\
    \    trie.incl(sample, 3)\n    trie.excl(sample, 3)\n    trie.incl(sample)\n \
    \   doAssert compare(trie[0], sample) == 0\n    var inserted = sample\n    trie.excl(sample)\n\
    \    trie.incl(inserted)\n    if sample.len > 0:\n        inserted[0] = not inserted[0]\n\
    \        doAssert compare(trie[0], sample) == 0\n        var retrieved = trie[0]\n\
    \        retrieved[0] = not retrieved[0]\n        doAssert compare(trie[0], sample)\
    \ == 0\n    trie.excl(sample)\n    trie.incl(sample, 0)\n    trie.excl(sample,\
    \ 0)\n    doAssert trie.len == 0\n    var raised = false\n    try:\n        trie.incl(sample,\
    \ -1)\n    except ValueError:\n        raised = true\n    doAssert raised\n  \
    \  trie.incl(sample, high(int))\n    raised = false\n    try:\n        trie.incl(sample)\n\
    \    except OverflowDefect:\n        raised = true\n    doAssert raised and trie.len\
    \ == high(int)\n    trie.excl(sample, high(int))\n    doAssert trie.len == 0\n\
    \ntemplate testSize(n: static int) =\n    when defined(cpp):\n        test(scalar.initBitSet(n))\n\
    \        test(fixed.initBitSet(n))\n    test(avx2.initBitSet(n))\n    test(avx512.initBitSet(n))\n\
    \    test(fixed2.initBitSet(n))\n    test(fixed512.initBitSet(n))\n\ntestSize(0)\n\
    testSize(1)\ntestSize(65)\ntestSize(513)\n\nblock:\n    var trie = initBitSetBinaryTrie[avx2.BitSetAvx2](100000)\n\
    \    var key = avx2.initBitSet(100000)\n    key[99999] = true\n    for i in 0..<3:\n\
    \        trie.incl(key)\n        doAssert trie.count(key) == 1\n        doAssert\
    \ compare(trie[0], key) == 0\n        trie.excl(key)\n        doAssert trie.len\
    \ == 0\n    var raised = false\n    try:\n        trie.incl(avx2.initBitSet(1))\n\
    \    except ValueError:\n        raised = true\n    doAssert raised and trie.len\
    \ == 0\n    raised = false\n    try:\n        discard initBitSetBinaryTrie[avx2.BitSetAvx2](-1)\n\
    \    except ValueError:\n        raised = true\n    doAssert raised\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/collections/bitset_binary_trie.nim
  - cplib/collections/bitset_binary_trie.nim
  isVerificationFile: true
  path: verify/AI/bitset_binary_trie_test.nim
  requiredBy: []
  timestamp: '2026-09-13 04:30:30+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_binary_trie_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_binary_trie_test.nim
- /verify/verify/AI/bitset_binary_trie_test.nim.html
title: verify/AI/bitset_binary_trie_test.nim
---
