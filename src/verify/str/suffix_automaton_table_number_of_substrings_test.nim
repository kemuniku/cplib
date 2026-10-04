# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
import cplib/str/suffix_automaton_table

let s = stdin.readLine()
let sam = initSuffixAutomatonTable(s)
echo sam.countDistinctSubstrings()
