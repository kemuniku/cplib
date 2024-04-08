# verification-helper: PROBLEM https://atcoder.jp/contests/abc227/tasks/abc227_g
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import sequtils, algorithm, tables
import cplib/math/isqrt
import cplib/modint/modint
type mint = mint_barrett
mint.setMod(998244353)

var n, k = ii()
if k == 0:
    echo 1
    quit()
var mf = newSeqWith(k+1, -1)
for i in 2..k:
    if mf[i] == -1:
        mf[i] = i
        for j in countup(i*2, k, i):
            if mf[j] == -1: mf[j] = i

var small = newSeqWith(max(k+1, isqrt(n)+1), -1)
var sp = newSeq[int]()
for i in 2..<small.len:
    if small[i] == -1:
        small[i] = i
        sp.add(i)
        for j in countup(i*2, small.len-1, i):
            if small[j] == -1: small[j] = i

var upper = ((n - k + 1)..(n)).toSeq

var count = newSeqWith(sp.len, 0)
var pos = 0
for p in sp:
    var s = if (n - k + 1) mod p == 0: 0 else: p - (n - k + 1) mod p
    for i in countup(s, upper.len-1, p):
        while upper[i] mod p == 0:
            upper[i] = upper[i] div p
            count[pos] += 1
    pos += 1

for i in 2..k:
    var pos = i
    while mf[pos] != -1:
        var nx = mf[pos]
        count[sp.lowerbound(nx)] -= 1
        pos = pos div nx

var uc = initCountTable[int]()
for i in upper:
    if i != 1: uc.inc(i)
var ans = mint(1)
for i in count:
    ans *= mint(i + 1)
for k, v in uc:
    ans *= mint(v + 1)
echo ans
