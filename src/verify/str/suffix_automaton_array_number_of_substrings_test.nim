# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings
import cplib/str/suffix_automaton_array

let s = stdin.readLine()
let sam = initSuffixAutomatonArray(s, 'a'..'z')
echo sam.countDistinctSubstrings()
