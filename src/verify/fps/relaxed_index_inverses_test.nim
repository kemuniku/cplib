# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import cplib/modint/modint
import cplib/convolution/relaxed_convolution
declarStaticBarrettModint(InverseTestBarrett17, 17u32)
declarStaticBarrettModint(InverseTestBarrett2, 2u32)
declarStaticBarrettModint(InverseTestBarrett35, 35u32)
declarStaticMontgomeryModint(InverseTestMontgomery17, 17u32)
declarStaticMontgomeryModint(InverseTestMontgomery35, 35u32)
declarStaticBarrettModint(InverseTestBarrett67, 67u32)
declarStaticMontgomeryModint(InverseTestMontgomery67, 67u32)
declarStaticBarrettModint(InverseTestBarrett97, 97u32)
declarStaticMontgomeryModint(InverseTestMontgomery97, 97u32)
proc oracleInverse(a, p: int): int =
    var x = a; var y = p; var u = 1; var v = 0
    while y != 0:
        let q = x div y
        (x,y) = (y,x-q*y)
        (u,v) = (v,u-q*v)
    result = ((u mod p) + p) mod p
proc run[M: BarrettModint or MontgomeryModint](ns: seq[int]) =
    let p = M.umod.int
    for n in ns:
        var f = newSeq[int](n)
        for shape in 0..3:
            if n > 0: f[0] = 0
            for i in 1..<n: f[i] = (if shape == 0: 0 elif shape == 1: (i*48271+101) mod p elif shape == 2: (if i mod 7 == 1: p-1 else: 0) else: p-1)
            var e = initRelaxedExp[M](n)
            var g = newSeq[int](n)
            if n > 0: g[0] = 1
            for k in 0..<n:
                if k > 0:
                    var sum = 0
                    for i in 1..k: sum = (sum + ((f[i] * i) mod p) * g[k-i]) mod p
                    g[k] = sum * oracleInverse(k,p) mod p
                let actual = (if k mod 3 == 0: e.add(init(M,f[k])) elif k mod 3 == 1: e.append(init(M,f[k])) else: e.get(init(M,f[k])))
                doAssert actual.val == g[k]
                doAssert e.len == k+1
                if k in [0,1,15,16,31,32,63,64,n-1]:
                    let snapshot = e.coefficients
                    doAssert snapshot.len == k+1
                    for j in 0..k: doAssert snapshot[j].val == g[j]
            if n > 0: f[0] = 1
            var l = initRelaxedLog[M](n)
            var inverse = newSeq[int](n)
            var expected = newSeq[int](n)
            if n > 0: inverse[0] = 1
            for k in 0..<n:
                if k > 0:
                    var s = 0
                    for i in 1..k: s = (s + f[i]*inverse[k-i]) mod p
                    inverse[k] = (p-s) mod p
                    s = 0
                    for i in 1..k: s = (s + ((f[i]*i) mod p)*inverse[k-i]) mod p
                    expected[k] = s * oracleInverse(k,p) mod p
                let actual = (if k mod 3 == 0: l.add(init(M,f[k])) elif k mod 3 == 1: l.append(init(M,f[k])) else: l.get(init(M,f[k])))
                doAssert actual.val == expected[k]
                doAssert l.len == k+1
            let snapshot = l.coefficients
            for j in 0..<n: doAssert snapshot[j].val == expected[j]
run[InverseTestBarrett67](@[0,1,2,63,64,65,67])
run[InverseTestMontgomery67](@[0,1,2,63,64,65,67])
run[InverseTestBarrett97](@[0,1,2,63,64,65,97])
run[InverseTestMontgomery97](@[0,1,2,63,64,65,97])
run[StaticBarrettModint[1000000007u32]](@[0,1,2,63,64,65,97,98,129,257,513])
run[StaticBarrettModint[998244353u32]](@[0,1,2,3,15,16,17,31,32,33,63,64,65,95,96,97,98,99,127,128,129,257])
run[StaticMontgomeryModint[998244353u32]](@[0,1,2,16,17,64,65,129,257])
run[InverseTestBarrett17](@[0,1,2,16,17])
run[InverseTestMontgomery17](@[0,1,2,16,17])
run[InverseTestBarrett2](@[0,1,2])
run[InverseTestBarrett35](@[0,1,2,3,4,5,16,17,34,35])
run[InverseTestMontgomery35](@[0,1,2,3,4,5,16,17,34,35])
declarDynamicBarrettModint(InverseTestDynamicBarrett, 991u32)
declarDynamicMontgomeryModint(InverseTestDynamicMontgomery, 991u32)
for p in [17,35,998244353,1000000007]:
    InverseTestDynamicBarrett.setMod(p); InverseTestDynamicMontgomery.setMod(p)
    let ns = if p == 35: @[0,1,2,3,4,5,16,17,34,35] elif p == 17: @[0,1,2,16,17] else: @[0,1,2,16,17,65,129]
    run[InverseTestDynamicBarrett](ns); run[InverseTestDynamicMontgomery](ns)
echo "Hello World"
