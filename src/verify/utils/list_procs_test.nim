# verification-helper: PROBLEM https://atcoder.jp/contests/abc237/tasks/abc237_d
import sequtils, algorithm
import cplib/utils/lis
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

import lists
import cplib/utils/list_procs
import strutils

var N = ii()
var S = stdin.readLine()
var list = initDoublyLinkedList[int]()
var bef = newDoublyLinkedNode[int](0)
list.add(bef)
for i in 0..<N:
    var tmp = newDoublyLinkedNode[int](i+1)
    if S[i] == 'R':
        list.insert(bef,tmp)
    else:
        list.insertPrev(bef,tmp)
    bef = tmp
echo list.toseq().join(" ")