# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

include cplib/math/osa_k

var values = @[3, 1, 2]
values.sort()
doAssert values == @[1, 2, 3]
values.reverse()
doAssert values == @[3, 2, 1]

let includedTable = initPrimeFactorTable(100)
doAssert includedTable.table.len == 101
doAssert includedTable.table[0] == 0
doAssert includedTable.table[1] == 0
doAssert includedTable.table[84] == 7
let includedCallback: proc(t: PrimeFactorTable, x: int): seq[int] {.nimcall.} = primefactor
doAssert includedCallback(includedTable, 84) == @[2, 2, 3, 7]
var counts = initTable[int, int]()
counts[2] = 2
counts[3] = 1
counts[7] = 1
doAssert includedTable.primefactor_table(84) == counts
