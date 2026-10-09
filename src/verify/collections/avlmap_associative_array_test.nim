# verification-helper: PROBLEM https://judge.yosupo.jp/problem/associative_array
import strutils
import cplib/collections/avlmap
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

let q = ii()
var st = initAvlMap[int, int]()
var ans = newSeqOfCap[int](q)
for _ in 0..<q:
    let t = ii()
    if t == 0:
        let k, v = ii()
        st[k] = v
    else:
        let k = ii()
        ans.add(st.getOrDefault(k))
if ans.len > 0: echo ans.join("\n")
