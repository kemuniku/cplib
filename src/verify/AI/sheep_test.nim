# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/tmpl/sheep
import cplib/modint/modint
import sequtils

assert (-3) % 5 == 2
assert (-3) // 2 == -2
assert @[1, 2, 3].join(",") == "1,2,3"
assert @[low(int), -1, 0, high(int)].join(",") ==
    "-9223372036854775808,-1,0,9223372036854775807"
assert @[0u32, high(uint32)].join(" ") == "0 4294967295"
assert @['a', 'b'].join("-") == "a-b"
let values = @[1, -2, 30]
assert (*values) == "1 -2 30"
let fixedValues = [4, 5, 6]
assert (*fixedValues) == "4 5 6"
let words = @["foo", "bar"]
assert (*words) == "foo bar"
let empty: seq[int] = @[]
assert (*empty) == ""
assert @[low(int32), high(int32)].join(" ") == "-2147483648 2147483647"
assert @[0u64, high(uint64)].join(" ") == "0 18446744073709551615"
let barrett = @[modint998244353_barrett(1),
    modint998244353_barrett(998244352)]
let montgomery = @[modint998244353_montgomery(1),
    modint998244353_montgomery(998244352)]
assert (*barrett) == "1 998244352"
assert (*montgomery) == "1 998244352"

doAssert compiles(print(1, 2, 3, sep = "\n"))
doAssert compiles(print("a", "b"))
doAssert compiles(print(*values, sep = "\n"))

block:
    doAssert (0..<5).mapIt(it * it) == @[0, 1, 4, 9, 16]
    doAssert (2..4).mapIt($it) == @["2", "3", "4"]
    doAssert (0..<6).filterIt(it mod 2 == 0) == @[0, 2, 4]
    doAssert (3..3).filterIt(it == 3) == @[3]
    doAssert (2..4).filterIt(false) == newSeq[int]()
    doAssert ('a'..'c').mapIt($it) == @["a", "b", "c"]
    doAssert ('a'..'c').filterIt(it != 'b') == @['a', 'c']
    doAssert (1'i64..3'i64).filterIt(it != 2) == @[1'i64, 3'i64]
    for bounds in [0..<0, 0..<(-3), 5..2]:
        doAssert bounds.mapIt(it * 2) == newSeq[int]()
        doAssert bounds.filterIt(true) == newSeq[int]()
    let closures = (2..4).mapIt(proc (x: int): int = it + x)
    doAssert closures[0](10) == 12
    doAssert closures[1](10) == 13
    doAssert closures[2](10) == 14
    doAssert (0..<3).mapIt((0..it).mapIt(it)) == @[@[0], @[0, 1], @[0, 1, 2]]
    var evaluations = 0
    proc bounds(): Slice[int] =
        inc evaluations
        2..4
    var visits: seq[int] = @[]
    doAssert bounds().mapIt((visits.add(it); it * 2)) == @[4, 6, 8]
    doAssert evaluations == 1
    doAssert visits == @[2, 3, 4]
    visits.setLen(0)
    doAssert bounds().filterIt((visits.add(it); it != 3)) == @[2, 4]
    doAssert evaluations == 2
    doAssert visits == @[2, 3, 4]
    doAssert @[1, 2, 3].mapIt(it * 2) == @[2, 4, 6]
    doAssert [1, 2, 3].filterIt(it != 2) == @[1, 3]
    doAssert (0..<5).countIt(it mod 2 == 0) == 3
    doAssert (0..<5).allIt(it >= 0)
    doAssert (0..<5).anyIt(it == 3)
