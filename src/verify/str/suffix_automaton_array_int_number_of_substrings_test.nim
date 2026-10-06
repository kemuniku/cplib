# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
import cplib/str/suffix_automaton_array

let s = stdin.readLine()
var symbols = newSeq[int](s.len)
for i, c in s:
    symbols[i] = ord(c) - ord('a') - 13
let sam: SuffixAutomatonArray[int, 26] = initSuffixAutomatonArray(symbols, -13..12)
echo sam.countDistinctSubstrings()
