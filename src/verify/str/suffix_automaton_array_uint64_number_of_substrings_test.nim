# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
import cplib/str/suffix_automaton_array

let s = stdin.readLine()
const first = high(uint64) - 25'u64
var symbols = newSeq[uint64](s.len)
for i, c in s:
    symbols[i] = first + uint64(ord(c) - ord('a'))
let sam: SuffixAutomatonArray[uint64, 26] = initSuffixAutomatonArray(symbols, first..high(uint64))
echo sam.countDistinctSubstrings()
