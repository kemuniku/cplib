# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/modint/modint
import cplib/fps/bostan_mori

var checks = 0
var rng = initRand(9382026)
proc mul(a,b,m: int): int = int((a.int64*b.int64) mod m.int64)
proc power(a,e,m: int): int =
  result = 1
  var b=a
  var n=e
  while n>0:
    if (n and 1)!=0: result=mul(result,b,m)
    b=mul(b,b,m)
    n=n shr 1
proc series(p,q: seq[int], k,m: int): int =
  var a=newSeq[int](k+1)
  let iq=(m+1) div 2
  for i in 0..k:
    var v=if i<p.len: p[i] else: 0
    for j in 1..min(i,q.high):
      v=(v-mul(q[j],a[i-j],m)+m) mod m
    a[i]=mul(v,iq,m)
  a[k]
proc check[T](p,q: seq[int], k,want:int, label:string) =
  var pp=newSeq[T](p.len)
  var qq=newSeq[T](q.len)
  for i,v in p: pp[i]=init(T,v)
  for i,v in q: qq[i]=init(T,v)
  let savedP = pp
  let savedQ = qq
  let got=bostanMori(pp,qq,k).val
  doAssert pp == savedP and qq == savedQ
  doAssert got==want, label & " k=" & $k & " p=" & $p.len & " q=" & $q.len & " got=" & $got & " want=" & $want
  inc checks
proc suite[T](label:string) =
  let m=T.umod.int
  for n in [1,2,31,32,63,64,65,127,128,129,255,256,257]:
    var p=newSeq[int](n+7)
    var q=newSeq[int](n)
    q[0]=2
    for i in 0..<p.len: p[i]=rng.rand(m-1)
    for i in 1..<q.len: q[i]=rng.rand(m-1)
    for k in [0,1,30,31,32,62,63,64,65,126,127,128,129,254,255,256,257,349]:
      check[T](p,q,k,series(p,q,k,m),label & " dense")
    for i in 0..<min(p.len,65): p[i]=0
    q.add(0);q.add(0);p.add(0)
    for k in [0,64,128,350]:
      check[T](p,q,k,series(p,q,k,m),label & " zero edges")
    var sparse=newSeq[int](n+1)
    sparse[0]=2
    sparse[n]=m-6 mod m
    for k in [high(int),high(int)-1,int(1_000_000_000_000_000_000)]:
      var want=0
      for j,v in p:
        if j<=k and (k-j) mod n==0:
          want=(want+mul(v,power(3,(k-j) div n,m),m)) mod m
      want=mul(want,(m+1) div 2,m)
      check[T](p,sparse,k,want,label & " sparse high")
    var qq = @[2]
    for k in [0,31,64,257,high(int)]:
      let want=if k<p.len:mul(p[k],(m+1) div 2,m) else:0
      check[T](p,qq,k,want,label & " constant")
    check[T](@[],q,high(int),0,label & " empty")
    check[T](@[0,0,0],q,high(int),0,label & " zero")
    var initial=newSeq[T](n)
    var coefficient=newSeq[T](n)
    var seqOracle=newSeq[int](n+80)
    for i in 0..<n:
      seqOracle[i]=rng.rand(m-1)
      initial[i]=init(T,seqOracle[i])
      coefficient[i]=init(T,rng.rand(m-1))
    for i in n..<seqOracle.len:
      for j in 0..<n:
        seqOracle[i]=(seqOracle[i]+mul(coefficient[j].val,seqOracle[i-j-1],m)) mod m
    for k in [0,n-1,n,n+1,n+79]:
      doAssert linearRecurrenceKth(initial,coefficient,k).val==seqOracle[k], label & " recurrence " & $n & " " & $k
      inc checks
  for degree in [64,128,256]:
    for plen in [degree-1,degree,degree+1]:
      var p=newSeq[int](plen)
      var q=newSeq[int](degree+1)
      q[0]=2
      for i in 0..<p.len: p[i]=rng.rand(m-1)
      for i in 1..<q.len: q[i]=rng.rand(m-1)
      for k in [degree-1,degree,degree+1,degree*2-2,degree*2-1,degree*2,degree*2+1,degree*3+17]:
        check[T](p,q,k,series(p,q,k,m),label & " alias dense")
      for i in 1..<degree: q[i]=0
      q[degree]=(m-6 mod m) mod m
      for k in [high(int),high(int)-1,int(1_000_000_000_000_000_000)]:
        var want=0
        for j,v in p:
          if j<=k and (k-j) mod degree==0:
            want=(want+mul(v,power(3,(k-j) div degree,m),m)) mod m
        want=mul(want,(m+1) div 2,m)
        check[T](p,q,k,want,label & " alias sparse high")
suite[modint998244353_barrett]("static Barrett 998")
suite[modint998244353_montgomery]("static Montgomery 998")
suite[modint1000000007_barrett]("static Barrett 1e9+7")
for m in [998244353,1000000007,15,998244353]:
  modint_barrett.setMod(m)
  suite[modint_barrett]("dynamic Barrett " & $m)
for m in [998244353,15,998244353]:
  modint_montgomery.setMod(m)
  suite[modint_montgomery]("dynamic Montgomery " & $m)
doAssert checks == 5800
echo "Hello World"
