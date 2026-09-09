# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/tmpl/sheep
import cplib/modint/modint

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
