---
data:
  _extendedDependsOn: []
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
    import random, hashes\ninclude ../../cplib/str/trie_string\n\nproc sign(x: int):\
    \ int =\n    if x < 0: -1 elif x > 0: 1 else: 0\n\nproc bruteLcp(a, b: string):\
    \ int =\n    while result < min(a.len, b.len) and a[result] == b[result]:\n  \
    \      inc result\n\ntemplate invalid(body: untyped) =\n    block:\n        var\
    \ caught = false\n        try:\n            body\n        except ValueError:\n\
    \            caught = true\n        doAssert caught\n\ntemplate checkBad(bad,\
    \ good, symbol: untyped) =\n    invalid: discard id(bad)\n    invalid: discard\
    \ bad.add(symbol)\n    invalid: discard bad.pop()\n    invalid: discard bad.length\n\
    \    invalid: discard len(bad)\n    invalid: discard bad.len\n    invalid: discard\
    \ bad.prefix(0)\n    invalid: discard bad[0]\n    invalid: discard bad.toSeq()\n\
    \    invalid: discard bad.cmp(good)\n    invalid: discard good.cmp(bad)\n    invalid:\
    \ discard bad < good\n    invalid: discard good < bad\n    invalid: discard bad\
    \ <= good\n    invalid: discard good <= bad\n    invalid: discard bad > good\n\
    \    invalid: discard good > bad\n    invalid: discard bad >= good\n    invalid:\
    \ discard good >= bad\n    invalid: discard bad.lcp(good)\n    invalid: discard\
    \ good.lcp(bad)\n    invalid: discard bad.lcpNode(good)\n    invalid: discard\
    \ good.lcpNode(bad)\n    invalid: discard bad == good\n    invalid: discard bad\
    \ == bad\n\ntemplate basics(makeTrie: untyped) =\n    block:\n        var trie\
    \ = makeTrie\n        let root = trie.root\n        var emptyArena: typeof(trie)\n\
    \        var defaultNode: typeof(root)\n        doAssert emptyArena.nodeCount\
    \ == 0\n        invalid: discard emptyArena.root\n        checkBad(defaultNode,\
    \ root, 'a')\n        invalid: discard ($defaultNode)\n        for id in [-1,\
    \ trie.nodeCount, high(int)]:\n            var bad = root\n            bad.id\
    \ = id\n            checkBad(bad, root, 'a')\n            invalid: discard ($bad)\n\
    \        let otherArena = makeTrie\n        let other = otherArena.root\n    \
    \    invalid: discard root.cmp(other)\n        invalid: discard other.cmp(root)\n\
    \        invalid: discard root < other\n        invalid: discard root <= other\n\
    \        invalid: discard root > other\n        invalid: discard root >= other\n\
    \        invalid: discard root.lcp(other)\n        invalid: discard other.lcp(root)\n\
    \        invalid: discard root.lcpNode(other)\n        invalid: discard other.lcpNode(root)\n\
    \        invalid: discard root == other\n        doAssert root.pop() == root and\
    \ root.prefix(0) == root\n        doAssert root.length == 0 and root.cmp(root)\
    \ == 0\n        doAssert root.lcp(root) == 0 and root.lcpNode(root) == root\n\
    \        doAssert ($root) == \"\" and root.toSeq().len == 0\n        invalid:\
    \ discard root[0]\n        invalid: discard root[-1]\n        invalid: discard\
    \ root.prefix(1)\n        invalid: discard root.prefix(-1)\n        let a = root.add('a')\n\
    \        let ab = a.add('b')\n        let aCopy = a\n        var moving = a\n\
    \        moving = moving.add('b')\n        doAssert moving == ab and aCopy ==\
    \ a and ($a) == \"a\"\n        moving = moving.pop()\n        doAssert moving\
    \ == a and ($ab) == \"ab\"\n        doAssert root.add('a').add('b') == ab\n  \
    \      let alias = trie\n        doAssert alias.root == root\n        trie = makeTrie\n\
    \        doAssert alias.root.add('a') == a\n        invalid: discard trie.root.cmp(a)\n\
    \        doAssert ($ab) == \"ab\"\n        for bad in [-1, 2, high(int)]:\n  \
    \          invalid: discard ab[bad]\n        for bad in [-1, 3, high(int)]:\n\
    \            invalid: discard ab.prefix(bad)\n\nbasics(initTrieStringTable(char))\n\
    basics(initTrieStringArray('a'..'b'))\nblock:\n    let a = initTrieStringArray('a'..'b')\n\
    \    for c in [char(0), '`', 'c', char(255)]:\n        invalid: discard a.root.add(c)\n\
    \    doAssert a.nodeCount == 1\n    let one = initTrieStringArray('z'..'z').root\n\
    \    doAssert one.add('z') == one.add('z')\n\ntemplate byteAlphabet(makeTrie:\
    \ untyped) =\n    block:\n        let arena = makeTrie\n        let root = arena.root\n\
    \        var nodes: seq[typeof(root)]\n        var chain = root\n        var word\
    \ = \"\"\n        for i in 0..255:\n            nodes.add(root.add(char(i)))\n\
    \            doAssert root.add(char(i)) == nodes[^1]\n            chain = chain.add(char(i))\n\
    \            word.add(char(i))\n        doAssert ($chain) == word\n        let\
    \ values = chain.toSeq()\n        for a in 0..255:\n            doAssert chain[a]\
    \ == char(a) and values[a] == char(a)\n            doAssert ($chain.prefix(a))\
    \ == word[0..<a]\n            for b in 0..255:\n                doAssert nodes[a].cmp(nodes[b])\
    \ == sign(a - b)\n                doAssert nodes[a].lcp(nodes[b]) == ord(a ==\
    \ b)\nbyteAlphabet(initTrieStringTable(char))\nbyteAlphabet(initTrieStringArray(char(0)..char(255)))\n\
    \nblock:\n    let arena = initTrieString()\n    var nodes = @[arena.root]\n  \
    \  var words = @[\"\"]\n    for i in 0..<511:\n        for c in ['a', 'b']:\n\
    \            nodes.add(nodes[i].add(c))\n            words.add(words[i] & c)\n\
    \    for a in 0..<nodes.len:\n        for b in 0..<nodes.len:\n            doAssert\
    \ nodes[a].cmp(nodes[b]) == sign(cmp(words[a], words[b]))\n            let common\
    \ = bruteLcp(words[a], words[b])\n            doAssert nodes[a].lcp(nodes[b])\
    \ == common\n            doAssert nodes[a].lcpNode(nodes[b]) == nodes[a].prefix(common)\n\
    \nfor seed in [1, 17, 20261024]:\n    let arena = initTrieString()\n    var nodes\
    \ = @[arena.root]\n    var words = @[\"\"]\n    var rng = initRand(seed)\n   \
    \ var cursor = 0\n    for i in 0..<20000:\n        let p = (if i mod 3 == 0: cursor\
    \ else: rng.rand(nodes.high))\n        let c = char(rng.rand(255))\n        let\
    \ v = nodes[p].add(c)\n        if v.id == nodes.len:\n            nodes.add(v)\n\
    \            words.add(words[p] & c)\n        doAssert ($v) == words[p] & c\n\
    \        doAssert nodes[p].add(c) == v and v.pop() == nodes[p]\n        doAssert\
    \ v.length == words[v.id].len and len(v) == words[v.id].len\n        cursor =\
    \ (if i mod 11 == 0: nodes[p].pop().id else: v.id)\n        for q in 0..<10:\n\
    \            let a = rng.rand(nodes.high)\n            let b = rng.rand(nodes.high)\n\
    \            doAssert nodes[a].cmp(nodes[b]) == sign(cmp(words[a], words[b]))\n\
    \            doAssert nodes[a].lcp(nodes[b]) == bruteLcp(words[a], words[b])\n\
    \        doAssert arena.nodeCount == nodes.len\n\nblock:\n    let arrayArena =\
    \ initTrieStringArray(char(0)..char(255))\n    let tableArena = initTrieString()\n\
    \    var aa = @[arrayArena.root]\n    var tt = @[tableArena.root]\n    var words\
    \ = @[\"\"]\n    var rng = initRand(991)\n    for i in 0..<20000:\n        let\
    \ p = rng.rand(words.high)\n        let c = char(rng.rand(255))\n        let a\
    \ = aa[p].add(c)\n        let b = tt[p].add(c)\n        doAssert a.id == b.id\n\
    \        if a.id == words.len:\n            aa.add(a)\n            tt.add(b)\n\
    \            words.add(words[p] & c)\n        doAssert aa[p].add(c) == a and a.pop()\
    \ == aa[p]\n        doAssert ($a) == words[a.id] and ($b) == words[b.id]\n   \
    \     for j in 0..<10:\n            let x = rng.rand(words.high)\n           \
    \ let y = rng.rand(words.high)\n            let expected = sign(cmp(words[x],\
    \ words[y]))\n            let common = bruteLcp(words[x], words[y])\n        \
    \    doAssert aa[x].cmp(aa[y]) == expected and tt[x].cmp(tt[y]) == expected\n\
    \            doAssert aa[x].lcp(aa[y]) == common and tt[x].lcp(tt[y]) == common\n\
    \    doAssert arrayArena.nodeCount == tableArena.nodeCount\n\nconst depth = 262145\n\
    template deepChains(makeTrie: untyped) =\n    block:\n        var arena = makeTrie\n\
    \        let root = arena.root\n        var left = @[root]\n        var right\
    \ = @[root]\n        for i in 1..depth:\n            left.add(left[^1].add('a'))\n\
    \            right.add(right[^1].add(if i == 1: 'b' else: 'a'))\n        arena\
    \ = nil\n        for i in 1..depth:\n            doAssert left[i].pop() == left[i\
    \ - 1]\n            doAssert left[i].cmp(right[i]) == -1\n            doAssert\
    \ left[depth].cmp(left[i - 1]) == 1\n            doAssert left[i].cmp(right[depth])\
    \ == -1\n            doAssert left[i - 1].add('a') == left[i]\n            doAssert\
    \ left[i].lcp(left[i]) == i\n            doAssert left[depth].lcp(left[i - 1])\
    \ == i - 1\n            doAssert left[i - 1].lcp(left[depth]) == i - 1\n     \
    \       doAssert left[i].lcp(right[depth]) == 0\n            doAssert root.lcp(left[i])\
    \ == 0 and left[i].lcp(root) == 0\n        for i in countup(0, depth - 1, 127):\n\
    \            let branch = left[i].add('b')\n            let extension = branch.add('a')\n\
    \            doAssert left[depth].cmp(branch) == -1\n            doAssert left[depth].cmp(extension)\
    \ == -1\n            doAssert left[i].cmp(branch) == -1 and branch.cmp(extension)\
    \ == -1\n            doAssert left[^1].lcpNode(extension) == left[i]\n       \
    \     doAssert left[^1].prefix(i) == left[i]\n            doAssert left[^1][i]\
    \ == 'a'\n        let restored = ($left[^1])\n        let values = left[^1].toSeq()\n\
    \        doAssert restored.len == depth and values.len == depth\n        for i\
    \ in 0..<depth:\n            doAssert restored[i] == 'a' and values[i] == 'a'\n\
    \        for i in 1..depth:\n            var v = left[i].id\n            var previous\
    \ = 0\n            var blocks = 0\n            while v != 0:\n               \
    \ let j = root.owner.nodes[v].jump\n                let weight = root.owner.nodes[v].depth\
    \ - root.owner.nodes[j].depth\n                doAssert (weight and (weight +\
    \ 1)) == 0\n                doAssert weight > previous or (blocks == 1 and weight\
    \ == previous)\n                previous = weight\n                inc blocks\n\
    \                v = j\n            doAssert blocks <= 20\n        for i in 0..depth:\n\
    \            doAssert left[^1].prefix(i) == left[i]\ndeepChains(initTrieString())\n\
    deepChains(initTrieStringArray('a'..'b'))\n\nblock:\n    let root = initTrieString().root\n\
    \    var chain = @[root]\n    for i in 1..2048:\n        chain.add(chain[^1].add('a'))\n\
    \    for d in 0..2048:\n        for target in 0..d:\n            doAssert chain[d].prefix(target)\
    \ == chain[target]\n\ntemplate longForks(makeTrie: untyped) =\n    block:\n  \
    \      let root = makeTrie.root\n        var chain = @[root]\n        for i in\
    \ 1..50000:\n            chain.add(chain[^1].add('a'))\n        for forkDepth\
    \ in [1, 2, 3, 30, 31, 32, 1023, 1024, 16383, 32767]:\n            var branch\
    \ = chain[forkDepth].add('b')\n            for distance in 1..4097:\n        \
    \        if distance > 1:\n                    branch = branch.add('a')\n    \
    \            doAssert chain[forkDepth + distance].cmp(branch) == -1\n        \
    \        doAssert chain[^1].cmp(branch) == -1\n                doAssert branch.cmp(chain[forkDepth])\
    \ == 1\n                doAssert chain[forkDepth + distance].lcp(branch) == forkDepth\n\
    \                doAssert branch.lcp(chain[^1]) == forkDepth\n               \
    \ doAssert branch.lcpNode(chain[^1]) == chain[forkDepth]\nlongForks(initTrieString())\n\
    longForks(initTrieStringArray('a'..'b'))\n\ntemplate navigation(makeTrie: untyped)\
    \ =\n    block:\n        let arena = makeTrie\n        var nodes = @[arena.root]\n\
    \        var words = @[\"\"]\n        var rng = initRand(20261101)\n        for\
    \ i in 1..3000:\n            let p = rng.rand(nodes.high)\n            let c =\
    \ char(rng.rand(255))\n            let node = nodes[p].add(c)\n            nodes.add(node)\n\
    \            words.add(words[p] & c)\n            let word = words[^1]\n     \
    \       doAssert ($node) == word\n            let values = node.toSeq()\n    \
    \        doAssert values.len == word.len\n            for j in 0..<word.len:\n\
    \                doAssert values[j] == word[j] and node[j] == word[j]\n      \
    \      var ancestor = node\n            for j in countdown(word.len, 0):\n   \
    \             doAssert node.prefix(j) == ancestor\n                doAssert ($ancestor)\
    \ == word[0..<j]\n                ancestor = ancestor.pop()\n            doAssert\
    \ node.prefix(word.len) == node and node.lcpNode(node) == node\n            doAssert\
    \ node.lcpNode(nodes[p]) == nodes[p] and nodes[p].lcpNode(node) == nodes[p]\n\
    \            for q in 0..<5:\n                let other = rng.rand(nodes.high)\n\
    \                let common = bruteLcp(word, words[other])\n                let\
    \ before = arena.nodeCount\n                doAssert node.lcpNode(nodes[other])\
    \ == node.prefix(common)\n                doAssert ($node.lcpNode(nodes[other]))\
    \ == word[0..<common]\n                doAssert arena.nodeCount == before\nnavigation(initTrieString())\n\
    navigation(initTrieStringArray(char(0)..char(255)))\n\nblock:\n    let arena =\
    \ initTrieStringTable(int)\n    let root = arena.root\n    var bad: typeof(root)\n\
    \    checkBad(bad, root, 1)\n    let other = initTrieStringTable(int).root\n \
    \   invalid: discard root.cmp(other)\n    invalid: discard root.lcp(other)\n \
    \   invalid: discard root.lcpNode(other)\n    invalid: discard root == other\n\
    \    var nodes = @[root]\n    var words: seq[seq[int]] = @[@[]]\n    var rng =\
    \ initRand(701)\n    for i in 1..3000:\n        let p = rng.rand(nodes.high)\n\
    \        let c = (if i == 1: low(int) elif i == 2: high(int) else: rng.rand(200)\
    \ - 100)\n        let node = nodes[p].add(c)\n        nodes.add(node)\n      \
    \  words.add(words[p] & @[c])\n        doAssert node.toSeq() == words[^1]\n  \
    \      for j in 0..<words[^1].len:\n            doAssert node[j] == words[^1][j]\n\
    \        for j in 0..words[^1].len:\n            doAssert node.prefix(j).toSeq()\
    \ == words[^1][0..<j]\n        let other = rng.rand(nodes.high)\n        var common\
    \ = 0\n        while common < min(words[^1].len, words[other].len) and words[^1][common]\
    \ == words[other][common]:\n            inc common\n        doAssert node.lcpNode(nodes[other])\
    \ == node.prefix(common)\n    invalid: discard nodes[^1][-1]\n    invalid: discard\
    \ nodes[^1][words[^1].len]\n    invalid: discard nodes[^1].prefix(-1)\n    invalid:\
    \ discard nodes[^1].prefix(words[^1].len + 1)\n\ntype Colliding = distinct int\n\
    proc hash(x: Colliding): Hash = 0\nproc `==`(a, b: Colliding): bool = int(a) ==\
    \ int(b)\nproc `<`(a, b: Colliding): bool = int(a) < int(b)\nblock:\n    let root\
    \ = initTrieStringTable(Colliding).root\n    var nodes: seq[typeof(root)]\n  \
    \  for i in 0..<256:\n        nodes.add(root.add(Colliding(i)))\n    for i in\
    \ 0..<256:\n        doAssert root.add(Colliding(i)) == nodes[i]\n        for j\
    \ in 0..<256:\n            doAssert nodes[i].cmp(nodes[j]) == sign(i - j)\nstderr.writeLine\
    \ \"PASS: typed handles, owners/lifetimes/copies, exact comparison/navigation,\
    \ bytes/integers/collisions, deep growth\"\necho \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/str/trie_string_test.nim
  requiredBy: []
  timestamp: '2026-10-26 02:50:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/trie_string_test.nim
layout: document
redirect_from:
- /verify/verify/str/trie_string_test.nim
- /verify/verify/str/trie_string_test.nim.html
title: verify/str/trie_string_test.nim
---
