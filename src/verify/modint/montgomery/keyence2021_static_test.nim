# verification-helper: PROBLEM https://atcoder.jp/contests/keyence2021/tasks/keyence2021_c
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
proc getchar(): char {.importc: "getchar_unlocked", header: "<stdio.h>", discardable.}
import sequtils, strutils
import cplib/modint/modint
type mint = mint998244353_montgomery

var h, w, k = ii()
var s = newSeqWith(h, "?".repeat(w).join(""))
for i in 0..<k:
    var x, y = ii()-1
    var c = getchar()
    s[x][y] = c

var dp = newSeqWith(h, newseqwith(w, mint(0)))
dp[0][0] = mint(3).pow(h*w - k)
var mul = mint(2) * mint(3).inv
for i in 0..<h:
    for j in 0..<w:
        if s[i][j] == 'D':
            if i+1 in 0..<h: dp[i+1][j] += dp[i][j]
        elif s[i][j] == 'R':
            if j+1 in 0..<w: dp[i][j+1] += dp[i][j]
        elif s[i][j] == 'X':
            if i+1 in 0..<h: dp[i+1][j] += dp[i][j]
            if j+1 in 0..<w: dp[i][j+1] += dp[i][j]
        else:
            if i+1 in 0..<h: dp[i+1][j] += dp[i][j] * mul
            if j+1 in 0..<w: dp[i][j+1] += dp[i][j] * mul
echo dp[h-1][w-1].val
