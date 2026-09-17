# verification-helper: PROBLEM https://judge.yosupo.jp/problem/longest_common_substring
import cplib/str/static_string

let RS = stdin.readLine()
let RT = stdin.readLine()
let tmp = @[RS, RT].toStaticStrings()
let S = tmp[0]
let T = tmp[1]

var X: seq[StaticString[char]]
for i in 0..<len(S):
    X.add(S[i..<len(S)])
for i in 0..<len(T):
    X.add(T[i..<len(T)])

X.sortStaticStrings()

var a, b, c, d: int
var l = 0
for i in 0..<(len(X)-1):
    if X[i].r != X[i+1].r:
        let common = lcp(X[i], X[i+1])
        if l < common:
            l = common
            a = X[i].l
            b = a + l
            c = X[i+1].l
            d = c + l
            if X[i].r == T.r:
                swap(a, c)
                swap(b, d)
            c -= T.l
            d -= T.l

echo a, " ", b, " ", c, " ", d
