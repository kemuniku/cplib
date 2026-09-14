---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/trie.nim
    title: cplib/str/trie.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/trie.nim
    title: cplib/str/trie.nim
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
    \nimport random, strutils\nimport cplib/str/trie\nimport cplib/graph/graph\n\n\
    const alphabet = 'a'..'c'\nvar tree = initTrie(@[\"\", \"a\", \"ab\", \"ab\",\
    \ \"ac\", \"b\"], alphabet)\nassert tree.len == 6\nassert \"ab\" in tree\nassert\
    \ \"abc\" notin tree\nassert tree.count(\"ab\") == 2\nassert tree.count(\"\")\
    \ == 1\nassert tree.countPrefix(\"a\") == 4\nassert tree.countPrefix(\"\") ==\
    \ 6\nassert tree.lowerBound(\"ab\") == 2\nassert tree.upperBound(\"ab\") == 4\n\
    assert tree.lowerBound(\"`\") == 1\nassert tree.upperBound(\"d\") == 6\nassert\
    \ tree.count(\"ad\") == 0\nassert tree.countPrefix(\"`\") == 0\ntree.excl(\"ab\"\
    )\nassert tree.count(\"ab\") == 1\ntree.excl(\"ab\", 10)\ntree.excl(\"missing\"\
    )\nassert tree.count(\"ab\") == 0\nassert tree.len == 4\ntree.incl(\"ab\", 3)\n\
    assert tree.count(\"ab\") == 3\ntree.excl(\"\", 5)\nassert tree.count(\"\") ==\
    \ 0\ntree.incl(\"\", 2)\nassert tree.lowerBound(\"\") == 0\nassert tree.upperBound(\"\
    \") == 2\nlet before = tree.len\ntry:\n    tree.incl(\"acd\")\n    assert false\n\
    except AssertionDefect:\n    discard\nassert tree.len == before\nassert tree.countPrefix(\"\
    ac\") == 1\n\nvar empty: Trie[alphabet]\nassert empty.len == 0\nassert empty.count(\"\
    \") == 0\nassert empty.countPrefix(\"\") == 0\nassert empty.lowerBound(\"abc\"\
    ) == 0\nassert empty.upperBound(\"\") == 0\nempty.excl(\"\")\nempty.incl(\"abc\"\
    )\nassert empty.count(\"abc\") == 1\nassert initTrie(newSeq[string](), alphabet).len\
    \ == 0\n\nvar single = initTrie('x'..'x')\nsingle.incl(\"xx\", 2)\nassert single.countPrefix(\"\
    x\") == 2\nassert single.lowerBound(\"w\") == 0\nassert single.lowerBound(\"y\"\
    ) == 2\nvar bytes = initTrie('\\0'..'\\255')\nbytes.incl(\"\\0\")\nbytes.incl(\"\
    \\255\")\nassert bytes.lowerBound(\"\\255\") == 1\nassert bytes.upperBound(\"\\\
    255\") == 2\n\nvar rng = initRand(12345)\nassert sizeof(TrieNode['a'..'z']) ==\
    \ 120\nvar navigation = initTrie(alphabet)\nassert navigation.getParent(navigation.root)\
    \ == -1\nassert navigation.restoreString(navigation.root) == \"\"\nlet a = navigation.getChild(navigation.root,\
    \ 'a')\nlet ab = navigation.getChild(a, 'b')\nassert navigation.getChild(a, 'b')\
    \ == ab\nassert navigation.nodes.len == 3\nassert navigation.nodes[ab].parent\
    \ == a\nassert navigation.getParent(ab) == a\nassert navigation.restoreString(ab)\
    \ == \"ab\"\nassert navigation.findNode(\"ab\") == ab\nassert navigation.findNode(\"\
    ac\") == -1\nassert navigation.len == 0\nassert navigation.countPrefix(\"a\")\
    \ == 0\nassert navigation.upperBound(\"c\") == 0\nnavigation.incl(\"ab\", 2)\n\
    assert navigation.nodes[ab].terminal == 2\nassert navigation.nodes[a].subtree\
    \ == 2\nnavigation.excl(\"ab\", 2)\nassert navigation.restoreString(ab) == \"\
    ab\"\nassert navigation.getChild(a, 'b') == ab\nvar defaultNavigation: Trie[alphabet]\n\
    let first = defaultNavigation.getChild(defaultNavigation.root, 'c')\nassert defaultNavigation.restoreString(first)\
    \ == \"c\"\nassert defaultNavigation.getParent(0) == -1\nlet longWord = repeat(\"\
    abc\", 10000)\nnavigation.incl(longWord)\nassert navigation.restoreString(navigation.findNode(longWord))\
    \ == longWord\nassert navigation.restoreString(ab) == \"ab\"\nassert bytes.restoreString(bytes.findNode(\"\
    \\0\")) == \"\\0\"\nassert bytes.restoreString(bytes.findNode(\"\\255\")) == \"\
    \\255\"\n\nvar large = initTrie('a'..'z')\nlarge.incl(\"a\", int(high(int32))\
    \ - 1)\nlarge.incl(\"ab\")\nassert large.len == int(high(int32))\nassert large.count(\"\
    a\") == int(high(int32)) - 1\nassert large.countPrefix(\"a\") == int(high(int32))\n\
    assert large.upperBound(\"ab\") == int(high(int32))\ntry:\n    large.incl(\"b\"\
    )\n    assert false\nexcept AssertionDefect:\n    discard\nassert large.len ==\
    \ int(high(int32))\nassert large.count(\"b\") == 0\nlarge.excl(\"a\", int(high(int32)))\n\
    assert large.len == 1\n\nvar actual = initTrie(alphabet)\nvar expected: seq[string]\n\
    proc randomWord(rng: var Rand, low, high: char): string =\n    for i in 0..<rng.rand(0..6):\n\
    \        result.add(char(rng.rand(ord(low)..ord(high))))\n\nfor step in 0..<3000:\n\
    \    let word = rng.randomWord('a', 'c')\n    let copies = rng.rand(0..3)\n  \
    \  if rng.rand(0..1) == 0:\n        actual.incl(word, copies)\n        for i in\
    \ 0..<copies:\n            expected.add(word)\n    else:\n        actual.excl(word,\
    \ copies)\n        for i in 0..<copies:\n            let index = expected.find(word)\n\
    \            if index >= 0:\n                expected.delete(index)\n    assert\
    \ actual.len == expected.len\n    for query in [word, rng.randomWord('`', 'd'),\
    \ \"\"]:\n        var equal, prefix, less, lessEqual: int\n        for s in expected:\n\
    \            equal += int(s == query)\n            prefix += int(s.startsWith(query))\n\
    \            less += int(s < query)\n            lessEqual += int(s <= query)\n\
    \        assert actual.count(query) == equal\n        assert actual.contains(query)\
    \ == (equal > 0)\n        assert actual.countPrefix(query) == prefix\n       \
    \ assert actual.lowerBound(query) == less\n        assert actual.upperBound(query)\
    \ == lessEqual\n        let node = actual.findNode(query)\n        if node >=\
    \ 0:\n            assert actual.restoreString(node) == query\n            if query.len\
    \ > 0:\n                assert actual.restoreString(actual.getParent(node)) ==\
    \ query[0..<query.high]\n\nfor s in expected:\n    actual.excl(s)\nassert actual.len\
    \ == 0\nassert actual.countPrefix(\"\") == 0\nassert actual.upperBound(\"d\")\
    \ == 0\n\nvar pointerTree = initTrie(alphabet)\nvar p = pointerTree.initTriePointer()\n\
    assert $p == \"\"\nassert p.nodeId == pointerTree.root\np &= 'a'\nlet q = p &\
    \ 'b'\nassert $p == \"a\"\nassert $q == \"ab\"\nassert q.getParent.nodeId == p.nodeId\n\
    assert q.restoreString == \"ab\"\nassert pointerTree.initTriePointer(q.nodeId).restoreString\
    \ == \"ab\"\nvar copied = q\nassert copied.pop() == 'b'\nassert $copied == \"\
    a\"\nassert $q == \"ab\"\nassert copied.pop() == 'a'\nassert $copied == \"\"\n\
    try:\n    discard copied.pop()\n    assert false\nexcept AssertionDefect:\n  \
    \  discard\ntry:\n    p.add('z')\n    assert false\nexcept AssertionDefect:\n\
    \    discard\nassert $p == \"a\"\nassert pointerTree.len == 0\nassert q.terminal\
    \ == 0\nassert q.subtree == 0\npointerTree.incl(\"ab\", 2)\nassert pointerTree.nodes[q.nodeId].terminal\
    \ == 2\nassert q.terminal == 2\nassert p.terminal == 0\nassert p.subtree == 2\n\
    pointerTree.incl(longWord)\nassert $q == \"ab\"\nassert q.terminal == 2\nassert\
    \ q.subtree == 3\nassert pointerTree.initTriePointer().subtree == pointerTree.len\n\
    pointerTree.excl(\"ab\", 2)\nassert $q == \"ab\"\nassert q.terminal == 0\nassert\
    \ q.subtree == 1\nvar lazyTree: Trie[alphabet]\nlet lazyPointer = lazyTree.initTriePointer()\n\
    assert $(lazyPointer & 'c') == \"c\"\nvar bytePointer = bytes.initTriePointer()\n\
    bytePointer.add('\\0')\nbytePointer.add('\\255')\nassert $bytePointer == \"\\\
    0\\255\"\nassert bytePointer.pop() == '\\255'\n\nvar graphTree = initTrie(@[\"\
    \", \"ab\", \"ab\", \"ac\", \"b\"], alphabet)\ngraphTree.excl(\"b\")\ndiscard\
    \ graphTree.getChild(graphTree.root, 'c')\nlet g = graphTree.toGraph()\nassert\
    \ g.len == graphTree.nodes.len\nassert g.edge_count == g.len - 1\nvar visited\
    \ = newSeq[bool](g.len)\nvisited[0] = true\nfor u in 0..<g.len:\n    for (v, c)\
    \ in g[u]:\n        assert not visited[v]\n        visited[v] = true\n       \
    \ assert graphTree.getParent(v) == u\n        assert graphTree.restoreString(v)\
    \ == graphTree.restoreString(u) & c\nfor seen in visited:\n    assert seen\nassert\
    \ g.edges[graphTree.findNode(\"b\")].len == 0\nlet oldLen = g.len\ngraphTree.incl(\"\
    aaa\")\nassert g.len == oldLen\nlet emptyGraph = initTrie(alphabet).toGraph()\n\
    assert emptyGraph.len == 1\nassert emptyGraph.edge_count == 0\nvar defaultGraphTree:\
    \ Trie[alphabet]\nassert defaultGraphTree.toGraph().len == 1\nlet byteGraph =\
    \ bytes.toGraph()\nfor edge in byteGraph.edge_info:\n    assert bytes.nodes[edge.dst].character\
    \ == edge.cost\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/trie.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/str/trie.nim
  isVerificationFile: true
  path: verify/AI/trie_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:33:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/trie_test.nim
layout: document
redirect_from:
- /verify/verify/AI/trie_test.nim
- /verify/verify/AI/trie_test.nim.html
title: verify/AI/trie_test.nim
---
