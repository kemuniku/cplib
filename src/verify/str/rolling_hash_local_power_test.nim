# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/str/rolling_hash

const Modulus = (1u shl 61)-1
proc oracleMul(a,b:uint):uint =
    var x=a mod Modulus
    var y=b mod Modulus
    while y>0:
        if (y and 1)!=0:
            result=(result+x) mod Modulus
        x=(x+x) mod Modulus
        y=y shr 1

var seeded:RollingHash[seq[int]]
seeded.build(seed=20261005)
let oracleBase=initRollingHash([0,1]).query(0..1) mod Modulus

proc check[T](a:openArray[T]) =
    var rh=initRollingHash(a)
    var powers=newSeq[uint](a.len+1)
    powers[0]=1
    for i in 0..<a.len:
        powers[i+1]=oracleMul(powers[i],oracleBase)
    for l in 0..a.len:
        doAssert rh.query(l..<l) mod Modulus==0
        var expected=0u
        for r in l..<a.len:
            expected=(expected+oracleMul(uint(a[r]),powers[r-l])) mod Modulus
            doAssert rh.query(l..r) mod Modulus==expected
    let before=rh.query(0..<a.len)
    rh.build(seed=7)
    doAssert rh.query(0..<a.len)==before

check(newSeq[int]())
check([0,0,0,0])
check([1,2,3,1,2,3])
check([0u,1000000000u,1u])
check([0'i64,1000000000'i64,7'i64])
check([0'u8,255'u8,1'u8])
check(['\0','\xff','a','\0'])
var rng=initRand(20261005)
for trial in 0..<200:
    var a=newSeq[int](rng.rand(0..40))
    for x in a.mitems:
        x=rng.rand(0..1000000000)
    check(a)
let fixed=[1,2,3,4,5]
check(fixed.toOpenArray(1,3))
for s in ["","\0\xffab\0","abcabc","aaaa"]:
    let rh=initRollingHash(s)
    let arrayRh=initRollingHash(s.toOpenArray(0,s.len-1))
    for l in 0..s.len:
        for r in l..s.len:
            doAssert rh.query(l..<r)==arrayRh.query(l..<r)
echo "Hello World"
