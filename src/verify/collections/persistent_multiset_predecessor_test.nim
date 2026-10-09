# verification-helper: PROBLEM https://judge.yosupo.jp/problem/predecessor_problem
import cplib/collections/persistent_multiset

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

let n = ii()
let q = ii()
let bits = stdin.readline()
var values: seq[int]
for k in 0..<n:
    if bits[k] == '1': values.add(k)
var keys = initPersistentMultiset(values)
for unused in 0..<q:
    let t = ii()
    let k = ii()
    if t == 0:
        if not keys.contains(k): keys = keys.insert(k)
    elif t == 1:
        keys = keys.erase(k)
    elif t == 2:
        echo int(keys.contains(k))
    elif t == 3:
        let rank = keys.lower_bound(k)
        echo (if rank == keys.len: -1 else: keys.kth(rank))
    else:
        let rank = keys.upper_bound(k)
        echo (if rank == 0: -1 else: keys.kth(rank - 1))
