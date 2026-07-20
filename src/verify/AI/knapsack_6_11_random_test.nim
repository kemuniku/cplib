import std/random
import cplib/utils/knapsack

proc brute(items:seq[tuple[v:int,w:int,m:int]], z:int):int =
  var dp = newSeq[int](z+1)
  for x in items:
    for _ in 0..<x.m:
      for i in countdown(z-x.w,0): dp[i+x.w] = max(dp[i+x.w],dp[i]+x.v)
  dp.max

randomize(20260713)
for _ in 0..<300:
  let n = rand(1..7)
  let z = rand(1..35)
  var xs:seq[tuple[v:int,w:int,m:int]]
  for _ in 0..<n: xs.add((rand(1..20),rand(1..8),rand(1..5)))
  let want = brute(xs,z)
  doAssert solve_FewWeightsKnapsack(xs,z) == want
  let got10 = solve_SmallWeightKnapsack(xs,z)
  doAssert got10 == want, $xs & " z=" & $z & " got=" & $got10 & " want=" & $want
  let got11 = solve_SmallValueKnapsack(xs,z)
  doAssert got11 == want, $xs & " z=" & $z & " got=" & $got11 & " want=" & $want

for _ in 0..<200:
  let n = rand(1..8)
  let z = rand(20..45)
  var xs:seq[tuple[v:int,w:int,m:int]]
  var ys:seq[tuple[v:int,w:int]]
  for _ in 0..<n:
    let x = (v:rand(1..20),w:rand(1..4),m:z)
    xs.add(x); ys.add((x.v,x.w))
  let got8 = solve_LargeUnboundedKnapsack(ys,z)
  let want8 = brute(xs,z)
  doAssert got8 == want8, $ys & " z=" & $z & " got=" & $got8 & " want=" & $want8

for _ in 0..<200:
  let n = rand(1..8)
  let z = rand(1..40)
  var xs:seq[tuple[v:int,w:int,m:int]]
  var ys:seq[tuple[v:int,s:int,t:int,m:int]]
  for _ in 0..<n:
    let t = rand(0..3)
    let s = rand(1..4)
    let x = (v:rand(1..20),w:s*(1 shl t),m:rand(1..5))
    xs.add(x); ys.add((x.v,s,t,x.m))
  let got7 = solve_SmallCoefficientPowerKnapsack(ys,z)
  let want7 = brute(xs,z)
  doAssert got7 == want7, $ys & " z=" & $z & " got=" & $got7 & " want=" & $want7

for _ in 0..<200:
  let n = rand(1..10)
  let z = rand(1..50)
  var xs:seq[tuple[v:int,w:int,m:int]]
  var ys:seq[tuple[v:int,t:int]]
  for _ in 0..<n:
    let t = rand(0..4)
    var w = 1
    for _ in 0..<t: w *= 3
    let x = (v:rand(1..20),w:w,m:1)
    xs.add(x); ys.add((x.v,t))
  doAssert solve_PowerKnapsack(ys,z,3) == brute(xs,z)
