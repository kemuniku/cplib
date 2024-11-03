# verification-helper: PROBLEM https://atcoder.jp/contests/abc378/tasks/abc378_e
import cplib/collections/rotate_segtree
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N,M = ii()
var A = newseqwith(N,ii())
var tmp = newseqwith(M,0)

var now = 0
var sm = 0
for i in 0..<(N):
    now += A[i]
    now = now mod M
    tmp[now] += 1
    sm += now
var cnt = newrotatesegwith(tmp,l+r,0)
var r = 0

var ans = 0
for i in 0..<(N):
    ans += sm
    var x = A[i] mod M
    cnt[x] = cnt[x] - 1
    sm += (cnt[0..<x])*(M-x)
    sm += (N-i-cnt[0..<x])*(-x)
    cnt.rotate(x)
echo ans