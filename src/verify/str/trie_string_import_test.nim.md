---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/trie_string.nim
    title: cplib/str/trie_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/trie_string.nim
    title: cplib/str/trie_string.nim
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
    import cplib/str/trie_string\nimport hashes, heapqueue, algorithm\n\ntype Symbol\
    \ = distinct int\nproc hash(x: Symbol): Hash = hash(int(x))\nproc `==`(a, b: Symbol):\
    \ bool = int(a) == int(b)\nproc `<`(a, b: Symbol): bool = int(a) < int(b)\n\n\
    let arrayTrie = initTrieStringArray('a'..'z')\nlet a = arrayTrie.root.add('a')\n\
    let ab = a.add('b')\ndoAssert a.cmp(ab) == -1\ndoAssert a.lcp(ab) == 1 and ab.lcp(ab)\
    \ == 2\ndoAssert ($ab) == \"ab\" and ab.toSeq() == @['a', 'b']\ndoAssert ab[1]\
    \ == 'b' and ab.prefix(1) == a\ndoAssert a.lcpNode(ab) == a and ab.pop() == a\n\
    doAssert a.add('b') == ab and a.length == 1\ndoAssert len(arrayTrie.root) == 0\
    \ and arrayTrie.root.len == 0\ndoAssert len(a) == 1 and ab.len == 2\ndoAssert\
    \ ab.pop().len == 1 and ab.prefix(0).len == 0\nlet tableTrie = initTrieStringTable(Symbol)\n\
    let x = tableTrie.root.add(Symbol(-1))\nlet y = tableTrie.root.add(Symbol(2))\n\
    doAssert x.cmp(y) == -1 and x.lcp(y) == 0\ndoAssert x.lcp(x) == 1 and x.toSeq()\
    \ == @[Symbol(-1)]\ndoAssert x[0] == Symbol(-1) and x.prefix(0) == tableTrie.root\n\
    doAssert x.lcpNode(y) == tableTrie.root and x.pop() == tableTrie.root\ndoAssert\
    \ tableTrie.root.add(Symbol(-1)) == x\ndoAssert y.length == 1 and tableTrie.nodeCount\
    \ == 3\ndoAssert len(tableTrie.root) == 0 and tableTrie.root.len == 0\ndoAssert\
    \ len(x) == 1 and y.len == 1\n\ntemplate checkHeap(first, second: untyped) =\n\
    \    block:\n        doAssert cmp(first, second) == -1\n        doAssert cmp(second,\
    \ first) == 1\n        doAssert cmp(first, first) == 0\n        doAssert (first,\
    \ 2) < (second, 0)\n        doAssert (first, 1) < (first, 2)\n        var queue\
    \ = initHeapQueue[(typeof(first), int)]()\n        queue.push((second, 0))\n \
    \       queue.push((first, 2))\n        queue.push((first, 1))\n        doAssert\
    \ queue.pop() == (first, 1)\n        doAssert queue.pop() == (first, 2)\n    \
    \    doAssert queue.pop() == (second, 0)\n        doAssert queue.len == 0\n\n\
    checkHeap(a, ab)\ncheckHeap(x, y)\n\ntemplate checkComparisons(ordered: untyped)\
    \ =\n    block:\n        let nodes = ordered\n        for i in 0..<nodes.len:\n\
    \            for j in 0..<nodes.len:\n                doAssert (nodes[i] < nodes[j])\
    \ == (i < j)\n                doAssert (nodes[i] <= nodes[j]) == (i <= j)\n  \
    \              doAssert (nodes[i] > nodes[j]) == (i > j)\n                doAssert\
    \ (nodes[i] >= nodes[j]) == (i >= j)\n                doAssert (nodes[i] != nodes[j])\
    \ == (i != j)\n        var shuffled = nodes\n        shuffled.reverse()\n    \
    \    shuffled.sort()\n        doAssert shuffled == nodes\n        var queue =\
    \ initHeapQueue[typeof(nodes[0])]()\n        for node in nodes:\n            queue.push(node)\n\
    \        for node in nodes:\n            doAssert queue.pop() == node\n\ncheckComparisons(@[arrayTrie.root,\
    \ a, ab, arrayTrie.root.add('b')])\ncheckComparisons(@[tableTrie.root, x, y])\n\
    \ntemplate rejectComparisons(first, second: untyped) =\n    static:\n        doAssert\
    \ not compiles(first < second)\n        doAssert not compiles(first <= second)\n\
    \        doAssert not compiles(first > second)\n        doAssert not compiles(first\
    \ >= second)\n\nrejectComparisons(a, x)\nrejectComparisons(a, initTrieStringArray('a'..'b').root)\n\
    rejectComparisons(x, initTrieStringTable(int).root)\n\nproc escapedTable(): TrieStringTableNode[int]\
    \ =\n    let arena = initTrieStringTable(int)\n    return arena.root.add(-1).add(2)\n\
    \nproc escapedArray(): TrieStringArrayNode['a'..'z'] =\n    let arena = initTrieStringArray('a'..'z')\n\
    \    return arena.root.add('a').add('b')\n\nlet ints = escapedTable()\nlet chars\
    \ = escapedArray()\ndoAssert ints.toSeq() == @[-1, 2]\ndoAssert len(ints) == 2\
    \ and chars.len == 2\ndoAssert ($chars) == \"ab\"\ndoAssert ($arrayTrie.root)\
    \ == \"\"\nlet text = initTrieString().root.add('a').add('b')\ndoAssert ($text)\
    \ == \"ab\" and ($text.prefix(0)) == \"\"\ndoAssert ($text.pop()) == \"a\"\ndoAssert\
    \ ints.pop().add(2) == ints\ndoAssert chars.pop().add('b') == chars\n\ntemplate\
    \ checkIds(makeRoot: untyped) =\n    block:\n        let root = makeRoot\n   \
    \     let first = root.add('a')\n        let firstId = first.id\n        doAssert\
    \ root.id == 0\n        doAssert firstId == 1\n        doAssert root.add('a').id\
    \ == firstId\n        doAssert root.add('b').id == 2\n        doAssert first.pop().id\
    \ == 0\n        var chain = first\n        for i in 0..<1024:\n            chain\
    \ = chain.add('a')\n        doAssert first.id == firstId\n        doAssert id(first)\
    \ == firstId\n        var bad: typeof(first)\n        var caught = false\n   \
    \     try:\n            discard bad.id\n        except ValueError:\n         \
    \   caught = true\n        doAssert caught\n        static:\n            doAssert\
    \ not compiles(block:\n                var node = first\n                node.id\
    \ = 1)\n            doAssert not compiles(typeof(first)(id: 1))\n\ncheckIds(initTrieStringArray('a'..'b').root)\n\
    checkIds(initTrieStringTable(char).root)\ndoAssert ints.id == 2 and chars.id ==\
    \ 2\n\nstatic:\n    doAssert not compiles(a.owner)\n    doAssert not compiles(arrayTrie.add(0,\
    \ 'a'))\n    doAssert not compiles(arrayTrie.cmp(0, 0))\n    doAssert not compiles(a.cmp(x))\n\
    \    doAssert not compiles(a.cmp(initTrieStringArray('a'..'b').root))\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/str/trie_string.nim
  - cplib/str/trie_string.nim
  isVerificationFile: true
  path: verify/str/trie_string_import_test.nim
  requiredBy: []
  timestamp: '2026-10-26 02:50:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/trie_string_import_test.nim
layout: document
redirect_from:
- /verify/verify/str/trie_string_import_test.nim
- /verify/verify/str/trie_string_import_test.nim.html
title: verify/str/trie_string_import_test.nim
---
