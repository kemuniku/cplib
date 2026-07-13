import std/sets
import cplib/str/suffix_automaton

block basicString:
    let sam = initSuffixAutomaton("ababa")
    assert sam.contains("aba")
    assert sam.contains("")
    assert not sam.contains("abb")
    assert sam.findState("bab") >= 0
    assert sam.findState("ac") == -1
    assert sam.countOccurrences("aba") == 2
    assert sam.countOccurrences("ba") == 2
    assert sam.countOccurrences("ababa") == 1
    assert sam.countOccurrences("x") == 0
    assert sam.countOccurrences("") == 6
    assert sam.distinctSubstringCount() == 9

block genericSymbols:
    var sam = initSuffixAutomaton[int]()
    for x in [1, 2, 1, 2, 1]:
        discard sam.extend(x)
    assert sam.contains([2, 1, 2])
    assert sam.countOccurrences([1, 2, 1]) == 2
    assert not sam.contains([2, 2])

block compareWithBruteForce:
    for n in 0..8:
        let cases = 1 shl n
        for mask in 0..<cases:
            var s = newString(n)
            for i in 0..<n:
                s[i] = "ab"[(mask shr i) and 1]
            let sam = initSuffixAutomaton(s)
            var substrings = initHashSet[string]()
            for l in 0..<n:
                for r in l + 1..n:
                    substrings.incl(s[l..<r])
            assert sam.distinctSubstringCount() == substrings.len
            for pattern in ["", "a", "b", "aa", "ab", "ba", "bb", "aba"]:
                var expected = 0
                if pattern.len == 0:
                    expected = n + 1
                elif pattern.len <= n:
                    for i in 0..n - pattern.len:
                        if s[i..<i + pattern.len] == pattern:
                            inc expected
                assert sam.contains(pattern) == (expected > 0)
                assert sam.countOccurrences(pattern) == expected

echo "ok"
