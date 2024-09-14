# verification-helper: PROBLEM https://judge.yosupo.jp/problem/set_xor_min
import cplib/collections/binary_trie
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var Q = ii()
var S = initBineryTrie(30)
for i in 0..<(Q):
    var t,x = ii()
    if t == 0:
        if S.count(x) == 0:
            S.add(x)
    elif t == 1:
        if S.count(x) != 0:
            S.del(x)
    else:
        stdout.writeLine S.get_kth(0,x) xor x
