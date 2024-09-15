# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_kth_smallest
import sequtils,algorithm,sugar,strutils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/utils/mo
import cplib/collections/root_rangesum

var N,Q = ii()
var A = newseqwith(N,ii())
var cmp = A.sorted().deduplicate(true)
var X = A.mapit(cmp.lowerBound(it))
var M = initMo(N,Q)
var querys : seq[int]
for i in 0..<Q:
    var l,r,k = ii()
    M.insert(l,r)
    querys.add(k)
var ans = newseq[int](Q)
var st = initrangesum(newseqwith(len(cmp),0))

proc ad(i:int)=
    st[X[i]] = st[X[i]] + 1

proc dl(i:int)=
    st[X[i]] = st[X[i]] - 1

proc mem(idx:int)=
    var k = querys[idx]
    var tmp = st.max_right(0,(x:int) => (x <= k))
    ans[idx] = cmp[tmp]

M.run(ad,ad,dl,dl,mem)

echo ans.join("\n")