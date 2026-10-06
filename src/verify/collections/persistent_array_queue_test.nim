# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_queue

import cplib/collections/persistent_array

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type QueueState = object
    data: PersistentArray[5, int]
    head, tail: int

let Q = ii()
var versions = newSeq[QueueState](Q+1)
versions[0].data = initPersistentArray(newSeq[int](Q))
for i in 0..<Q:
    let kind = ii()
    let t = ii()
    let parent = versions[t+1]
    if kind == 0:
        let value = ii()
        versions[i+1] = QueueState(
            data: parent.data.change_value(parent.tail, value),
            head: parent.head, tail: parent.tail+1)
    else:
        echo parent.data[parent.head]
        versions[i+1] = QueueState(
            data: parent.data, head: parent.head+1, tail: parent.tail)
