# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

include cplib/tmpl/sheep
import cplib/str/static_string
import cplib/str/merged_static_string
import std/random
randomize()
for _ in 0..<1000:
    var rawstr = newseqwith(10,"ab"[rand(0..<2)]).join("")
    var X = rawstr.toStaticString()

    var tmp : seq[StaticString]
    var naive : string
    for i in range(30):
        var l = rand(0..<len(rawstr))
        var r = rand(l..<len(rawstr))
        tmp.add(X[l..r])
        naive &= rawstr[l..r]

    var A = tmp.initMergedStaticString()

    for l in range(len(A)):
        for r in range(l,len(A)):
            assert $(A[l..r]) == naive[l..r]

    assert len(A) == len(naive)

    for i in range(len(naive)):
        assert naive[i] == A[i]

    for i in range(100):
        var tmp2 : MergedStaticString
        var naive2 : string
        var tmp3 : MergedStaticString
        var naive3 : string

        for i in range(rand(0..50)):
            var l = rand(0..<len(rawstr))
            var r = rand(l..<len(rawstr))
            tmp2 &= X[l..r]
            naive2 &= rawstr[l..r]
        for i in range(rand(0..50)):
            var l = rand(0..<len(rawstr))
            var r = rand(l..<len(rawstr))
            tmp3 &= X[l..r]
            naive3 &= rawstr[l..r]
            
        assert cmp(tmp3,tmp2) == sgn(cmp(naive3,naive2))
        assert $tmp2 == naive2
        assert $tmp3 == naive3
        assert cmp(tmp2,tmp2) == 0



