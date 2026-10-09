# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import strutils, random
include cplib/str/edit_distance

proc oracle(s,t:string):int =
    var dp=newSeq[int](t.len+1)
    for j in 0..t.len:
        dp[j]=j
    for i in 0..<s.len:
        var diagonal=dp[0]
        dp[0]=i+1
        for j in 0..<t.len:
            let previous=dp[j+1]
            dp[j+1]=min(min(dp[j]+1,previous+1),diagonal+ord(s[i]!=t[j]))
            diagonal=previous
    result=dp[^1]

let words=["", "a", "aaa", "abab", "\0\xff\0", "kitten", "sitting"]
for s in words:
    for t in words:
        let distance=oracle(s,t)
        for k in [0,1,2,3,10,high(int)]:
            doAssert editDistance(s,t,k)==(if distance<=k:distance else: -1)
for a in words:
    for b in words:
        if a.len == 0 or b.len == 0:
            continue
        let joined = a & b
        let sa = suffix_array(joined)
        let d = oracle(a, b)
        for k in [1, 2, 3, 10]:
            let expected = (if d <= k: d else: -1)
            doAssert editDistanceImpl[int](a, b, joined, sa, k) == expected
            doAssert editDistanceImpl[int32](a, b, joined, sa, k) == expected
let s=repeat("ab\0\xff",25000)
for k in [0,1,2,100,high(int)]:
    doAssert editDistance(s,s,k)==0
var middle=s
middle[s.len div 2]='z'
var last=s
last[^1]='z'
var first=s
first[0]='z'
for t in [first,middle,last]:
    doAssert editDistance(s,t,0) == -1
    doAssert editDistance(s,t,1)==1
    doAssert editDistance(s,t,2)==1
doAssert editDistance(s,s & "\0",1)==1
var rng = initRand(20261005)
for trial in 0..<1000:
    var a = newString(rng.rand(40))
    var b = newString(rng.rand(40))
    for i in 0..<a.len:
        a[i] = char(rng.rand(255))
    for i in 0..<b.len:
        b[i] = char(rng.rand(255))
    let d = oracle(a, b)
    for k in [0, 1, 2, max(0, d - 1), d, d + 1, high(int)]:
        doAssert editDistance(a, b, k) == (if d <= k: d else: -1)
var binaryWords = @[""]
for length in 1..5:
    for bits in 0..<(1 shl length):
        var word = newString(length)
        for i in 0..<length:
            word[i] = char(ord('a') + ((bits shr i) and 1))
        binaryWords.add(word)
for a in binaryWords:
    for b in binaryWords:
        let d = oracle(a, b)
        for k in 0..max(a.len, b.len):
            doAssert editDistance(a, b, k) == (if d <= k: d else: -1)
echo "Hello World"
