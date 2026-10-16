---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_automaton_table.nim
    title: cplib/str/suffix_automaton_table.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_automaton_table.nim
    title: cplib/str/suffix_automaton_table.nim
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
    import tables, sets, random, hashes\nimport cplib/str/suffix_automaton_table\n\
    import cplib/str/suffix_array\n\nvar checkedPrefixes = 0\nvar sawClone = false\n\
    \nproc check[T](sam: SuffixAutomatonTable[T], s: seq[T]) =\n    inc checkedPrefixes\n\
    \    doAssert sam.root == 0\n    doAssert sam.nodes[0].len == 0 and sam.nodes[0].link\
    \ == -1\n    doAssert sam.nodeCount <= max(1, 2 * s.len)\n    doAssert sam.nodes[sam.last].len\
    \ == s.len\n    doAssert sam.findNode(s) == sam.last\n    doAssert sam.contains(newSeq[T]())\n\
    \    var oracle = initTable[seq[T], seq[int]]()\n    for l in 0..<s.len:\n   \
    \     for r in l..<s.len:\n            oracle.mgetOrPut(s[l..r], @[]).add(r)\n\
    \    doAssert sam.countDistinctSubstrings == int64(oracle.len)\n    var endings\
    \ = newSeq[seq[int]](sam.nodeCount)\n    var lengths = newSeq[HashSet[int]](sam.nodeCount)\n\
    \    for word, positions in oracle:\n        let v = sam.findNode(word)\n    \
    \    doAssert v > 0 and v < sam.nodeCount\n        doAssert sam.contains(word)\n\
    \        if endings[v].len == 0:\n            endings[v] = positions\n       \
    \ doAssert endings[v] == positions\n        lengths[v].incl(word.len)\n      \
    \  let link = sam.nodes[v].link\n        let suffixLen = sam.nodes[link].len\n\
    \        let suffix = if suffixLen == 0: newSeq[T]() else: word[word.len - suffixLen..word.high]\n\
    \        doAssert sam.findNode(suffix) == link\n    for v in 1..<sam.nodeCount:\n\
    \        let parent = sam.nodes[v].link\n        doAssert parent >= 0 and parent\
    \ < sam.nodeCount\n        doAssert sam.nodes[parent].len < sam.nodes[v].len\n\
    \        doAssert lengths[v].len == sam.nodes[v].len - sam.nodes[parent].len\n\
    \        for length in sam.nodes[parent].len + 1..sam.nodes[v].len:\n        \
    \    doAssert length in lengths[v]\n    var accepted = initHashSet[seq[T]]()\n\
    \    proc walk(v: int, word: seq[T]) =\n        for c, dest in sam.nodes[v].next:\n\
    \            doAssert dest > 0 and dest < sam.nodeCount\n            doAssert\
    \ sam.nodes[dest].len > sam.nodes[v].len\n            let nextWord = word & @[c]\n\
    \            doAssert oracle.hasKey(nextWord)\n            doAssert nextWord notin\
    \ accepted\n            accepted.incl(nextWord)\n            walk(dest, nextWord)\n\
    \    walk(0, @[])\n    doAssert accepted.len == oracle.len\n    var suffixStates\
    \ = initHashSet[int]()\n    var v = sam.last\n    while v != -1:\n        suffixStates.incl(v)\n\
    \        v = sam.nodes[v].link\n    for l in 0..s.len:\n        let suffix = if\
    \ l == s.len: newSeq[T]() else: s[l..s.high]\n        doAssert sam.findNode(suffix)\
    \ in suffixStates\n    for word, positions in oracle:\n        doAssert (sam.findNode(word)\
    \ in suffixStates) == (positions[^1] == s.high)\n\nproc checkPrefixes[T](s: seq[T])\
    \ =\n    var sam = initSuffixAutomatonTable(T)\n    check(sam, newSeq[T]())\n\
    \    for i, c in s:\n        let before = sam.nodeCount\n        let last = sam.extend(c)\n\
    \        doAssert last == sam.last and last == before\n        if sam.nodeCount\
    \ > before + 1:\n            sawClone = true\n        check(sam, s[0..i])\n  \
    \  let built = initSuffixAutomatonTable(s)\n    doAssert sam.nodes == built.nodes\
    \ and sam.last == built.last\n\nproc exhaustive(s: var seq[int], i, alphabet:\
    \ int) =\n    if i == s.len:\n        checkPrefixes(s)\n    else:\n        for\
    \ c in 0..<alphabet:\n            s[i] = c\n            exhaustive(s, i + 1, alphabet)\n\
    \nfor n in 0..8:\n    var s = newSeq[int](n)\n    exhaustive(s, 0, 2)\nfor n in\
    \ 0..6:\n    var s = newSeq[int](n)\n    exhaustive(s, 0, 3)\n\nfor text in [\"\
    \", \"a\", \"aaaaaaaaaaaa\", \"abababababab\", \"banana\", \"mississippi\", \"\
    abcbc\", \"abbbab\"]:\n    checkPrefixes(@text)\nfor values in [@[0, 255, 128,\
    \ 0, 127, 255], @[int.low, int.high, 0, int.low, -1]]:\n    checkPrefixes(values)\n\
    checkPrefixes(@[\"red\", \"blue\", \"red\", \"blue\", \"green\"])\n\ntype Colliding\
    \ = object\n    value: int\nproc hash(x: Colliding): Hash = 0\ncheckPrefixes(@[Colliding(value:\
    \ 1), Colliding(value: 2), Colliding(value: 1), Colliding(value: 3)])\n\nvar rng\
    \ = initRand(20261002)\nfor trial in 0..<300:\n    var text = newString(rng.rand(20))\n\
    \    for c in text.mitems:\n        c = char(rng.rand([1, 2, 25, 255][trial mod\
    \ 4]))\n    checkPrefixes(@text)\n\nvar allBytes = newString(256)\nfor i in 0..255:\n\
    \    allBytes[i] = char(i)\nlet bytesSam = initSuffixAutomatonTable(allBytes &\
    \ allBytes)\nfor i in 0..255:\n    doAssert bytesSam.contains($char(i))\n    doAssert\
    \ bytesSam.contains($char(i) & $char((i + 1) mod 256))\n\nfor n in [1, 2, 31,\
    \ 32, 33, 255, 256, 257, 4096, 10000]:\n    for alphabet in [1, 2, 26, 256]:\n\
    \        var text = newString(n)\n        for c in text.mitems:\n            c\
    \ = char(rng.rand(alphabet - 1))\n        let sam = initSuffixAutomatonTable(text)\n\
    \        var expected = int64(n) * int64(n + 1) div 2\n        for lcp in lcp_array(text,\
    \ suffix_array(text)):\n            expected -= int64(lcp)\n        doAssert sam.countDistinctSubstrings\
    \ == expected\n\nvar sam = initSuffixAutomatonTable(\"banana\")\nlet saved = sam\n\
    let savedNodeCount = sam.nodeCount\nfor trial in 0..<100:\n    doAssert sam.next(sam.root,\
    \ '\\0') == -1\n    doAssert sam.findNode(\"bananaz\") == -1\n    doAssert not\
    \ sam.contains(\"zzz\")\ndoAssert sam.nodeCount == savedNodeCount and sam.nodes\
    \ == saved.nodes\nvar other = sam\ndiscard other.extend('z')\ndoAssert not sam.contains(\"\
    z\") and sam.nodes == saved.nodes\ncheck(other, @\"bananaz\")\nsam = initSuffixAutomatonTable(char)\n\
    discard sam.extend('x')\ncheck(sam, @\"x\")\nvar defaultSam: SuffixAutomatonTable[int]\n\
    discard defaultSam.extend(5)\ncheck(defaultSam, @[5])\ndoAssert sawClone and checkedPrefixes\
    \ > 10000\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/suffix_automaton_table.nim
  - cplib/str/suffix_automaton_table.nim
  - cplib/str/suffix_array.nim
  - cplib/str/suffix_array.nim
  isVerificationFile: true
  path: verify/AI/suffix_automaton_table_test.nim
  requiredBy: []
  timestamp: '2026-10-04 16:38:19+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/suffix_automaton_table_test.nim
layout: document
redirect_from:
- /verify/verify/AI/suffix_automaton_table_test.nim
- /verify/verify/AI/suffix_automaton_table_test.nim.html
title: verify/AI/suffix_automaton_table_test.nim
---
