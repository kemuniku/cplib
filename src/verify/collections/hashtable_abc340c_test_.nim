# verification-helper: PROBLEM https://atcoder.jp/contests/abc340/tasks/abc340_c
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/collections/hashtable

var n = ii()
var dp = initHashTable[int, int](100)
proc dfs(x: int): int =
    if x < 2: return 0
    if x in dp: return dp[x]
    dp[x] = x
    dp[x] += dfs(x div 2)
    dp[x] += dfs((x+1) div 2)
    return dp[x]
echo dfs(n)
