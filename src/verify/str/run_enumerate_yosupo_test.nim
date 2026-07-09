# verification-helper: PROBLEM https://judge.yosupo.jp/problem/runenumerate

import cplib/str/run_enumerate

let s = stdin.readLine
let ans = run_enumerate(s)
echo ans.len
for (p, l, r) in ans:
    echo p, " ", l, " ", r
