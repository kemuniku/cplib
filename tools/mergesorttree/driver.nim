import cplib/collections/mergesorttree
import cplib/collections/dynamic_mergesorttree
import strutils, options

let tokens = stdin.readAll.splitWhitespace()
var cursor = 0
proc readInt(): int =
    result = tokens[cursor].parseInt()
    inc cursor

proc formatOption(x: Option[int]): string =
    if x.isSome: $x.get else: "none"

let n = readInt()
let q = readInt()
var a = newSeq[int](n)
for i in 0..<n: a[i] = readInt()
let st = initMergeSortTree(a)
let dt = initDynamicMergeSortTree(a)

template query(tree: untyped) =
    let l = readInt()
    let r = readInt()
    let x = readInt()
    let low = readInt()
    let high = readInt()
    let k = readInt()
    let smallest = if l < r: $tree.kth_smallest(l, r, k) else: "none"
    let largest = if l < r: $tree.kth_largest(l, r, k) else: "none"
    echo tree.range_lowerbound(l, r, x), " ", tree.range_upperbound(l, r, x), " ",
        tree.count(l, r, x), " ", tree.range_freq(l, r, low, high), " ",
        formatOption(tree.prev_value(l, r, x)), " ", formatOption(tree.next_value(l, r, x)),
        " ", smallest, " ", largest

for _ in 0..<q:
    case readInt()
    of 0:
        let i = readInt()
        let value = readInt()
        dt[i] = value
        doAssert dt.get(i) == value
    of 1: query(dt)
    of 2: query(st)
    else: raise newException(ValueError, "unknown operation")
