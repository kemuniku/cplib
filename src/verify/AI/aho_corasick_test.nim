# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/aho_corasick

block basicString:
    var ac = initAhoCorasick[char]()
    let he = ac.addPattern("he")
    let she = ac.addPattern("she")
    let his = ac.addPattern("his")
    let hers = ac.addPattern("hers")
    ac.build()

    assert ac.patternCount == 4
    assert ac.countOccurrences("ahishers") == @[1, 1, 1, 1]
    assert ac.findAll("ahishers") == @[
        (position: 3, patternId: his),
        (position: 5, patternId: she),
        (position: 5, patternId: he),
        (position: 7, patternId: hers)
    ]

block overlapDuplicateAndEmpty:
    var ac = initAhoCorasick[char]()
    discard ac.addPattern("a")
    discard ac.addPattern("aa")
    discard ac.addPattern("a")
    discard ac.addPattern("")
    ac.build()
    assert ac.countOccurrences("aaa") == @[3, 2, 3, 4]

block genericSymbolsAndRebuild:
    var ac = initAhoCorasick[int]()
    discard ac.addPattern([1, 2])
    ac.build()
    assert ac.countOccurrences([1, 2, 1, 2]) == @[2]
    discard ac.addPattern([2, 1])
    ac.build()
    assert ac.countOccurrences([1, 2, 1, 2]) == @[2, 1]

block compareWithBruteForce:
    let patterns = @["", "a", "b", "aa", "aba", "bab"]
    var ac = initAhoCorasick[char]()
    for pattern in patterns:
        discard ac.addPattern(pattern)
    ac.build()
    for n in 0..8:
        for mask in 0..<(1 shl n):
            var text = newString(n)
            for i in 0..<n:
                text[i] = "ab"[(mask shr i) and 1]
            var expected = newSeq[int](patterns.len)
            for id, pattern in patterns:
                if pattern.len == 0:
                    expected[id] = n + 1
                elif pattern.len <= n:
                    for i in 0..n - pattern.len:
                        if text[i..<i + pattern.len] == pattern:
                            inc expected[id]
            assert ac.countOccurrences(text) == expected

echo "ok"
