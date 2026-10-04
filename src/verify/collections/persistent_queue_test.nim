# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_queue

import cplib/collections/persistent_queue

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)

let q = ii()
var versions = newSeq[PersistentQueue[int]](q + 1)
for i in 0..<q:
    let kind = ii()
    let parent = ii() + 1
    if kind == 0:
        versions[i + 1] = versions[parent].push(ii())
    else:
        echo versions[parent].front()
        versions[i + 1] = versions[parent].pop()
