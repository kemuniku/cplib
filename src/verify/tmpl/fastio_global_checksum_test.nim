# verification-helper: PROBLEM https://yukicoder.me/problems/no/3677

include cplib/tmpl/fastio

let height = input(int)
let width = input(int)
var sums = newSeq[uint32](height)
var total = 0'u32
for row in 0 ..< height:
    var rowSum = 0'u32
    for column in 0 ..< width:
        rowSum += input(uint32)
    sums[row] = rowSum
    total += rowSum
for row in 0 ..< height:
    sums[row] += total
print(*sums, sep = "\n")
