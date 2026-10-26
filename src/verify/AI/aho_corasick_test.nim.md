---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/aho_corasick.nim
    title: cplib/str/aho_corasick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/aho_corasick.nim
    title: cplib/str/aho_corasick.nim
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
    \nimport random, strutils, algorithm\nimport cplib/str/aho_corasick\nimport cplib/graph/graph\n\
    \nproc verifyGraphs[chars](ac: AhoCorasick[chars]) =\n    let trieGraph = ac.toTrieGraph()\n\
    \    let failureGraph = ac.toFailureGraph()\n    assert trieGraph.len == ac.nodeCount\n\
    \    assert failureGraph.len == ac.nodeCount\n    assert trieGraph.edge_count\
    \ == ac.nodeCount - 1\n    assert failureGraph.edge_count == ac.nodeCount - 1\n\
    \    var incoming = newSeq[int](ac.nodeCount)\n    for edge in trieGraph.edge_info:\n\
    \        inc incoming[edge.dst]\n        assert edge.src == ac.getParent(edge.dst)\n\
    \        assert ac.restoreString(edge.src) & edge.cost == ac.restoreString(edge.dst)\n\
    \    assert incoming[ac.root] == 0\n    for node in 1..<ac.nodeCount:\n      \
    \  assert incoming[node] == 1\n        assert failureGraph.edges[node].len ==\
    \ 1\n    assert failureGraph.edges[ac.root].len == 0\n    for edge in failureGraph.edge_info:\n\
    \        assert edge.src != ac.root\n        assert edge.dst == ac.failure(edge.src)\n\
    \nlet orderedWords = @[\"bc\", \"b\", \"abc\", \"aa\", \"\", \"abc\"]\nlet ordered\
    \ = initAhoCorasick(orderedWords, 'a'..'c')\nlet expectedNodes = @[\"\", \"b\"\
    , \"bc\", \"a\", \"ab\", \"abc\", \"aa\"]\nassert ordered.nodeCount == expectedNodes.len\n\
    for id, word in expectedNodes:\n    assert ordered.restoreString(id) == word\n\
    \    assert ordered.findNode(word) == id\nassert ordered.findNode(\"ac\") == -1\n\
    assert ordered.findNode(\"aabc\") == -1\nassert ordered.findNode(\"c\") == -1\n\
    assert ordered.findNode(\"#abc\") == -1\nfor i, word in orderedWords:\n    assert\
    \ ordered.patternNode(i) == expectedNodes.find(word)\nassert ordered.failure(ordered.patternNode(2))\
    \ == ordered.patternNode(0)\nassert ordered.getParent(ordered.root) == -1\n\n\
    var ac = initAhoCorasick(@[\"he\", \"she\", \"hers\", \"his\", \"he\", \"\"],\
    \ 'a'..'z')\nverifyGraphs(ac)\nvar p = ac.initAhoCorasickPointer()\nassert p.nodeId\
    \ == ac.root\nassert p.matchCount == 1\np.add(\"ush\")\nassert $p == \"sh\"\n\
    assert p.terminal == 0\nlet q = p & 'e'\nassert $p == \"sh\"\nassert $q == \"\
    she\"\nassert ac.findNode(\"she\") == q.nodeId\nassert ac.findNode(\"sh\") ==\
    \ p.nodeId\nassert ac.findNode(\"ushe\") == -1\nassert ac.findNode(\"shers\")\
    \ == -1\nassert ac.initAhoCorasickPointer(ac.findNode(\"she\")).nodeId == q.nodeId\n\
    assert $q.getParent == \"sh\"\nassert q.getParent.nodeId == p.nodeId\nassert $q\
    \ == \"she\"\nassert q.matchCount == 4\nvar found: seq[string]\nfor node in q.matches:\n\
    \    found.add(ac.restoreString(node))\nassert found == @[\"she\", \"he\", \"\"\
    ]\np &= \"ers\"\nassert $p == \"hers\"\nassert p.matchCount == 2\np &= '#'\nassert\
    \ $p == \"\"\nassert ac.patternNode(0) == ac.patternNode(4)\nassert ac.terminal(ac.patternNode(0))\
    \ == 2\nassert ac.restoreString(ac.failure(ac.patternNode(1))) == \"he\"\nassert\
    \ ac.failure(ac.root) == ac.root\nassert $q.failure == \"he\"\nassert q.failure.nodeId\
    \ == ac.patternNode(0)\nassert q.failure.matchCount == 3\nassert $q == \"she\"\
    \nvar failurePointer = q\nfailurePointer = failurePointer.failure\nassert $failurePointer\
    \ == \"he\"\nassert $(failurePointer & \"rs\") == \"hers\"\nfailurePointer = failurePointer.failure\n\
    assert failurePointer.nodeId == ac.root\nassert failurePointer.failure.nodeId\
    \ == ac.root\nassert $(ac.initAhoCorasickPointer(ac.patternNode(1)) & \"rs\")\
    \ == \"hers\"\nassert ac.next(ac.root, \"ushers\") == ac.patternNode(2)\nvar parentPointer\
    \ = q\nparentPointer = parentPointer.getParent\nassert $parentPointer == \"sh\"\
    \nparentPointer = parentPointer.getParent\nassert $parentPointer == \"s\"\nparentPointer\
    \ = parentPointer.getParent\nassert parentPointer.nodeId == ac.root\ntry:\n  \
    \  discard parentPointer.getParent\n    assert false\nexcept AssertionDefect:\n\
    \    discard\n\nvar empty = initAhoCorasick(newSeq[string](), 'a'..'z')\nverifyGraphs(empty)\n\
    assert empty.nodeCount == 1\nassert empty.findNode(\"\") == empty.root\nassert\
    \ empty.findNode(\"a\") == -1\nvar uninitialized: AhoCorasick['a'..'z']\nassert\
    \ uninitialized.findNode(\"\") == -1\nvar ep = empty.initAhoCorasickPointer()\n\
    ep.add(\"anything#\")\nassert ep.nodeId == 0\nassert ep.matchCount == 0\nfor node\
    \ in ep.matches:\n    assert false\nvar blanks = initAhoCorasick(@[\"\", \"\"\
    ], 'x'..'x')\nverifyGraphs(blanks)\nassert blanks.matchCount(blanks.root) == 2\n\
    assert blanks.next(0, \"xxx!\") == 0\nvar bytes = initAhoCorasick(@[\"\\0\\255\"\
    , \"\\255\", \"\\0\"], '\\0'..'\\255')\nverifyGraphs(bytes)\nvar bp = bytes.initAhoCorasickPointer()\n\
    assert bytes.findNode(\"\\0\\255\") == bytes.patternNode(0)\nassert bytes.findNode(\"\
    \\255\\255\") == -1\nbp &= \"\\0\\255\"\nassert $bp == \"\\0\\255\"\nassert bp.matchCount\
    \ == 2\nbp.add('\\255')\nassert $bp == \"\\255\"\nassert bp.matchCount == 1\n\n\
    var rng = initRand(981723)\nfor trial in 0..<300:\n    var words: seq[string]\n\
    \    for i in 0..<rng.rand(0..25):\n        var word = \"\"\n        for j in\
    \ 0..<rng.rand(0..8):\n            word.add(char(ord('a') + rng.rand(0..2)))\n\
    \        words.add(word)\n    var automaton = initAhoCorasick(words, 'a'..'c')\n\
    \    verifyGraphs(automaton)\n    var prefixes = @[\"\"]\n    for word in words:\n\
    \        for length in 1..word.len:\n            let prefix = word[0..<length]\n\
    \            if prefix notin prefixes:\n                prefixes.add(prefix)\n\
    \    assert automaton.nodeCount == prefixes.len\n    for id, prefix in prefixes:\n\
    \        assert automaton.restoreString(id) == prefix\n        assert automaton.findNode(prefix)\
    \ == id\n        for c in 'a'..'d':\n            let query = prefix & c\n    \
    \        assert automaton.findNode(query) == prefixes.find(query)\n    var pointer\
    \ = automaton.initAhoCorasickPointer()\n    for i, word in words:\n        assert\
    \ automaton.restoreString(automaton.patternNode(i)) == word\n    for node in 0..<automaton.nodeCount:\n\
    \        let s = automaton.restoreString(node)\n        if node != automaton.root:\n\
    \            let parent = automaton.getParent(node)\n            assert parent\
    \ < node\n            assert automaton.restoreString(parent) == s[0..<s.high]\n\
    \            assert automaton.initAhoCorasickPointer(node).getParent.nodeId ==\
    \ parent\n        var expectedFailure = \"\"\n        for other in 0..<automaton.nodeCount:\n\
    \            let suffix = automaton.restoreString(other)\n            if suffix.len\
    \ < s.len and s.endsWith(suffix) and suffix.len > expectedFailure.len:\n     \
    \           expectedFailure = suffix\n        assert automaton.restoreString(automaton.failure(node))\
    \ == expectedFailure\n        let nodePointer = automaton.initAhoCorasickPointer(node)\n\
    \        assert nodePointer.failure.nodeId == automaton.failure(node)\n      \
    \  assert $nodePointer.failure == expectedFailure\n    var text = \"\"\n    for\
    \ step in 0..<70:\n        var longest = \"\"\n        for word in words:\n  \
    \          for length in 0..word.len:\n                let prefix = word[0..<length]\n\
    \                if text.endsWith(prefix) and prefix.len > longest.len:\n    \
    \                longest = prefix\n        assert $pointer == longest\n      \
    \  var expectedCount, terminalCount: int\n        var expectedMatches: seq[string]\n\
    \        for word in words:\n            if text.endsWith(word):\n           \
    \     inc expectedCount\n                if word notin expectedMatches:\n    \
    \                expectedMatches.add(word)\n            if word == longest:\n\
    \                inc terminalCount\n        assert pointer.matchCount == expectedCount\n\
    \        assert pointer.terminal == terminalCount\n        var actualMatches:\
    \ seq[string]\n        var previousLength = high(int)\n        for node in pointer.matches:\n\
    \            let word = automaton.restoreString(node)\n            assert word.len\
    \ < previousLength\n            previousLength = word.len\n            actualMatches.add(word)\n\
    \        actualMatches.sort()\n        expectedMatches.sort()\n        assert\
    \ actualMatches == expectedMatches\n        var chunk = \"\"\n        for j in\
    \ 0..<rng.rand(0..5):\n            chunk.add(char(ord('a') + rng.rand(0..3)))\n\
    \        let saved = pointer\n        pointer.add(chunk)\n        assert $saved\
    \ == longest\n        assert (saved & chunk).nodeId == pointer.nodeId\n      \
    \  var byChar = saved\n        for c in chunk:\n            byChar &= c\n    \
    \    assert byChar.nodeId == pointer.nodeId\n        text.add(chunk)\n\nlet longWord\
    \ = repeat(\"a\", 100000)\nvar longAc = initAhoCorasick(@[longWord, \"a\"], 'a'..'a')\n\
    var lp = longAc.initAhoCorasickPointer()\nlp.add(longWord)\nassert lp.matchCount\
    \ == 2\nlp.add('a')\nassert lp.nodeId == longAc.patternNode(0)\nassert lp.restoreString\
    \ == longWord\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/aho_corasick.nim
  - cplib/graph/graph.nim
  - cplib/str/aho_corasick.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/aho_corasick_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/aho_corasick_test.nim
layout: document
redirect_from:
- /verify/verify/AI/aho_corasick_test.nim
- /verify/verify/AI/aho_corasick_test.nim.html
title: verify/AI/aho_corasick_test.nim
---
