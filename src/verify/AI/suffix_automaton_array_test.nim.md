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
    path: cplib/str/suffix_automaton_array.nim
    title: cplib/str/suffix_automaton_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_automaton_array.nim
    title: cplib/str/suffix_automaton_array.nim
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
    import tables, sets, random\nimport cplib/str/suffix_automaton_array\nimport cplib/str/suffix_automaton_table\n\
    import cplib/str/suffix_array\n\nvar checkedPrefixes = 0\nvar sawClone = false\n\
    \nproc check[chars](sam: SuffixAutomatonArray[chars], s: seq[char]) =\n    inc\
    \ checkedPrefixes\n    doAssert sam.root == 0\n    doAssert sam.nodes[0].len ==\
    \ 0 and sam.nodes[0].link == -1\n    doAssert sam.nodeCount <= max(1, 2 * s.len)\n\
    \    doAssert sam.nodes[sam.last].len == s.len\n    doAssert sam.findNode(s) ==\
    \ sam.last\n    doAssert sam.contains(newSeq[char]())\n    var oracle = initTable[seq[char],\
    \ seq[int]]()\n    for l in 0..<s.len:\n        for r in l..<s.len:\n        \
    \    oracle.mgetOrPut(s[l..r], @[]).add(r)\n    doAssert sam.countDistinctSubstrings\
    \ == int64(oracle.len)\n    var endings = newSeq[seq[int]](sam.nodeCount)\n  \
    \  var lengths = newSeq[HashSet[int]](sam.nodeCount)\n    for word, positions\
    \ in oracle:\n        let v = sam.findNode(word)\n        doAssert v > 0 and v\
    \ < sam.nodeCount\n        doAssert sam.contains(word)\n        if endings[v].len\
    \ == 0:\n            endings[v] = positions\n        doAssert endings[v] == positions\n\
    \        lengths[v].incl(word.len)\n        let link = sam.nodes[v].link\n   \
    \     let suffixLen = sam.nodes[link].len\n        let suffix = if suffixLen ==\
    \ 0: newSeq[char]() else: word[word.len - suffixLen..word.high]\n        doAssert\
    \ sam.findNode(suffix) == link\n    for v in 1..<sam.nodeCount:\n        let parent\
    \ = sam.nodes[v].link\n        doAssert parent >= 0 and parent < sam.nodeCount\n\
    \        doAssert sam.nodes[parent].len < sam.nodes[v].len\n        doAssert lengths[v].len\
    \ == sam.nodes[v].len - sam.nodes[parent].len\n        for length in sam.nodes[parent].len\
    \ + 1..sam.nodes[v].len:\n            doAssert length in lengths[v]\n    var accepted\
    \ = initHashSet[seq[char]]()\n    proc walk(v: int, word: seq[char]) =\n     \
    \   for c in chars.a..chars.b:\n            let dest = sam.nodes[v].next[c]\n\
    \            if dest == -1:\n                continue\n            doAssert dest\
    \ > 0 and dest < sam.nodeCount\n            doAssert sam.nodes[dest].len > sam.nodes[v].len\n\
    \            let nextWord = word & @[c]\n            doAssert oracle.hasKey(nextWord)\n\
    \            doAssert nextWord notin accepted\n            accepted.incl(nextWord)\n\
    \            walk(dest, nextWord)\n    walk(0, @[])\n    doAssert accepted.len\
    \ == oracle.len\n    var suffixStates = initHashSet[int]()\n    var v = sam.last\n\
    \    while v != -1:\n        suffixStates.incl(v)\n        v = sam.nodes[v].link\n\
    \    for l in 0..s.len:\n        let suffix = if l == s.len: newSeq[char]() else:\
    \ s[l..s.high]\n        doAssert sam.findNode(suffix) in suffixStates\n    for\
    \ word, positions in oracle:\n        doAssert (sam.findNode(word) in suffixStates)\
    \ == (positions[^1] == s.high)\n\nproc compare[chars](sam: SuffixAutomatonArray[chars],\
    \ tableSam: SuffixAutomatonTable[char]) =\n    doAssert sam.nodeCount == tableSam.nodeCount\
    \ and sam.last == tableSam.last\n    for v in 0..<sam.nodeCount:\n        doAssert\
    \ sam.nodes[v].len == tableSam.nodes[v].len\n        doAssert sam.nodes[v].link\
    \ == tableSam.nodes[v].link\n        for i in 0..255:\n            let c = char(i)\n\
    \            doAssert sam.next(v, c) == tableSam.next(v, c)\n\nproc checkPrefixes(s:\
    \ string, chars: static[HSlice[char, char]]) =\n    var sam = initSuffixAutomatonArray(chars)\n\
    \    var tableSam = initSuffixAutomatonTable(char)\n    check(sam, @[])\n    compare(sam,\
    \ tableSam)\n    for i, c in s:\n        let before = sam.nodeCount\n        doAssert\
    \ sam.extend(c) == before\n        discard tableSam.extend(c)\n        if sam.nodeCount\
    \ > before + 1:\n            sawClone = true\n        check(sam, @(s[0..i]))\n\
    \        compare(sam, tableSam)\n    let built = initSuffixAutomatonArray(s, chars)\n\
    \    let builtChars = initSuffixAutomatonArray(@s, chars)\n    doAssert sam.nodes\
    \ == built.nodes and sam.last == built.last\n    doAssert sam.nodes == builtChars.nodes\
    \ and sam.last == builtChars.last\n\nproc exhaustive(s: var string, i: int, chars:\
    \ static[HSlice[char, char]]) =\n    if i == s.len:\n        checkPrefixes(s,\
    \ chars)\n    else:\n        for c in chars.a..chars.b:\n            s[i] = c\n\
    \            exhaustive(s, i + 1, chars)\n\nfor n in 0..8:\n    var s = newString(n)\n\
    \    exhaustive(s, 0, 'x'..'y')\nfor n in 0..6:\n    var s = newString(n)\n  \
    \  exhaustive(s, 0, '3'..'5')\nfor text in [\"\", \"a\", \"aaaaaaaaaaaa\", \"\
    abababababab\", \"banana\", \"mississippi\", \"abcbc\", \"abbbab\"]:\n    checkPrefixes(text,\
    \ 'a'..'z')\ncheckPrefixes(\"000000000000\", '0'..'0')\ncheckPrefixes(\"\", '0'..'0')\n\
    checkPrefixes(\"XYZXXYZZYX\", 'X'..'Z')\ncheckPrefixes(\"\\x80\\xff\\x80\\x81\\\
    xff\", '\\x80'..'\\xff')\ncheckPrefixes(\"\\0\\xff\\x80\\0\\x7f\\xff\", '\\0'..'\\\
    xff')\n\nvar rng = initRand(20261004)\nfor trial in 0..<300:\n    var text = newString(rng.rand(20))\n\
    \    for c in text.mitems:\n        c = char(rng.rand([1, 2, 25, 255][trial mod\
    \ 4]))\n    checkPrefixes(text, '\\0'..'\\xff')\n\nvar allBytes = newString(256)\n\
    for i in 0..255:\n    allBytes[i] = char(i)\nlet bytesSam = initSuffixAutomatonArray(allBytes\
    \ & allBytes, '\\0'..'\\xff')\ncompare(bytesSam, initSuffixAutomatonTable(allBytes\
    \ & allBytes))\nfor i in 0..255:\n    doAssert bytesSam.contains($char(i))\n \
    \   doAssert bytesSam.contains($char(i) & $char((i + 1) mod 256))\n\nproc checkLarge(text:\
    \ string, chars: static[HSlice[char, char]]) =\n    let sam = initSuffixAutomatonArray(text,\
    \ chars)\n    let tableSam = initSuffixAutomatonTable(text)\n    compare(sam,\
    \ tableSam)\n    var expected = int64(text.len) * int64(text.len + 1) div 2\n\
    \    for lcp in lcp_array(text, suffix_array(text)):\n        expected -= int64(lcp)\n\
    \    doAssert sam.countDistinctSubstrings == expected\n\nfor n in [1, 2, 31, 32,\
    \ 33, 255, 256, 257, 4096, 10000]:\n    for alphabet in [1, 2, 26, 256]:\n   \
    \     var text = newString(n)\n        for c in text.mitems:\n            c =\
    \ char(rng.rand(alphabet - 1))\n        checkLarge(text, '\\0'..'\\xff')\nfor\
    \ kind in 0..2:\n    var text = newString(10000)\n    for i in 0..<text.len:\n\
    \        text[i] = (if kind == 0: 'a' else: char(ord('a') + i mod 2))\n    if\
    \ kind == 2:\n        text[0] = 'a'\n        for i in 1..<text.len:\n        \
    \    text[i] = 'b'\n    checkLarge(text, 'a'..'b')\n\nvar sam = initSuffixAutomatonArray(\"\
    banana\", 'a'..'z')\nlet saved = sam\nfor trial in 0..<100:\n    doAssert sam.next(sam.root,\
    \ '\\0') == -1\n    doAssert sam.findNode(\"bananaz\") == -1\n    doAssert not\
    \ sam.contains(\"zzz\")\n    doAssert not sam.contains(\"banana{\")\ndoAssert\
    \ sam.nodes == saved.nodes and sam.last == saved.last\nfor c in ['`', '{', '\\\
    0', '\\xff']:\n    var rejected = false\n    try:\n        discard sam.extend(c)\n\
    \    except ValueError:\n        rejected = true\n    doAssert rejected\n    doAssert\
    \ sam.nodes == saved.nodes and sam.last == saved.last\n    rejected = false\n\
    \    try:\n        discard initSuffixAutomatonArray(\"banana\" & c, 'a'..'z')\n\
    \    except ValueError:\n        rejected = true\n    doAssert rejected\n\nvar\
    \ other = sam\ndiscard other.extend('z')\ndoAssert not sam.contains(\"z\") and\
    \ sam.nodes == saved.nodes\ncheck(other, @\"bananaz\")\nsam = initSuffixAutomatonArray('a'..'z')\n\
    discard sam.extend('x')\ncheck(sam, @\"x\")\nvar defaultSam: SuffixAutomatonArray['m'..'o']\n\
    doAssert defaultSam.nodeCount == 0 and defaultSam.findNode(\"\") == -1\ndoAssert\
    \ defaultSam.countDistinctSubstrings == 0\nvar rejected = false\ntry:\n    discard\
    \ defaultSam.extend('a')\nexcept ValueError:\n    rejected = true\ndoAssert rejected\
    \ and defaultSam.nodeCount == 0\ndiscard defaultSam.extend('n')\ncheck(defaultSam,\
    \ @\"n\")\n\n# q\u3068clone\u304C\u540C\u3058\u914D\u5217\u5024\u3092\u6301\u3064\
    \u77AC\u9593\u304B\u3089\u3001\u53CC\u65B9\u3078\u306E\u5F8C\u7D9A\u66F4\u65B0\
    \u3092\u691C\u67FB\u3059\u308B\u3002\nvar clones = initSuffixAutomatonArray('a'..'c')\n\
    for c in \"abcbc\":\n    let before = clones.nodeCount\n    discard clones.extend(c)\n\
    \    if clones.nodeCount == before + 2:\n        let clone = before + 1\n    \
    \    var found = false\n        for q in 1..<before:\n            if clones.nodes[q].link\
    \ == clone and clones.nodes[q].next == clones.nodes[clone].next:\n           \
    \     found = true\n                var copy = clones\n                let original\
    \ = copy.nodes[q].next\n                copy.nodes[clone].next['a'] = int32(clone)\n\
    \                doAssert copy.nodes[q].next == original\n                doAssert\
    \ copy.nodes != clones.nodes\n        doAssert found\nfor c in \"cabcbac\":\n\
    \    discard clones.extend(c)\ncheck(clones, @\"abcbccabcbac\")\ndoAssert sawClone\
    \ and checkedPrefixes > 10000\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/suffix_array.nim
  - cplib/str/suffix_automaton_table.nim
  - cplib/str/suffix_automaton_array.nim
  - cplib/str/suffix_automaton_table.nim
  - cplib/str/suffix_array.nim
  - cplib/str/suffix_automaton_array.nim
  isVerificationFile: true
  path: verify/AI/suffix_automaton_array_test.nim
  requiredBy: []
  timestamp: '2026-10-04 16:38:19+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/suffix_automaton_array_test.nim
layout: document
redirect_from:
- /verify/verify/AI/suffix_automaton_array_test.nim
- /verify/verify/AI/suffix_automaton_array_test.nim.html
title: verify/AI/suffix_automaton_array_test.nim
---
