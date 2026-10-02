# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
import cplib/str/suffix_automaton

let s = stdin.readLine()
let sam = initSuffixAutomaton(s)
echo sam.countDistinctSubstrings()
