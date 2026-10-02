# verification-helper: PROBLEM https://judge.yosupo.jp/problem/wildcard_pattern_matching
import cplib/str/wildcard_matching
let s = stdin.readLine()
let t = stdin.readLine()
let matches = wildcard_match(s, t, '*')
var output = newString(matches.len)
for i, matches in matches:
    output[i] = if matches: '1' else: '0'
echo output
