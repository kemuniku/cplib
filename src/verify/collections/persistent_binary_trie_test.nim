# verification-helper: PROBLEM https://judge.yosupo.jp/problem/set_xor_min
import cplib/collections/persistent_binary_trie
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var Q = ii()
var S = initPersistentBineryTrie(30)
for i in 0..<(Q):
    var t,x = ii()
    if t == 0:
        if x notin S:
            S = S.incl(x)
    elif t == 1:
        if x in S:
            S = S.excl(x)
    else:
        stdout.writeLine S.get_kth(0,x) xor x
