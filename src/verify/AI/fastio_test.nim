# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

include cplib/tmpl/fastio

const compileTimeJoined = [1, 2, 3].join(",")
const compileTimeSignedBounds = [low(int64), high(int64)].join(",")
const compileTimeUnsignedBound = [high(uint64)].join
static:
    doAssert compileTimeJoined == "1,2,3"
    doAssert compileTimeSignedBounds ==
        "-9223372036854775808,9223372036854775807"
    doAssert compileTimeUnsignedBound == "18446744073709551615"

doAssert compiles(ii())
doAssert compiles(lii(3))
doAssert compiles(si())
doAssert typeof(input(string)) is string
doAssert typeof(input(3, string)) is seq[string]
doAssert not compiles(input(seq[char]))
type FastioTestRange = range[0 .. 10]
doAssert not compiles(input(FastioTestRange))
doAssert not compiles(input(3, FastioTestRange))
doAssert typeof(input(int)) is int
doAssert typeof(input(int8)) is int8
doAssert typeof(input(int16)) is int16
doAssert typeof(input(int32)) is int32
doAssert typeof(input(int64)) is int64
doAssert typeof(input(uint8)) is uint8
doAssert typeof(input(uint16)) is uint16
doAssert typeof(input(uint32)) is uint32
doAssert typeof(input(uint)) is uint
doAssert typeof(input(uint64)) is uint64
doAssert typeof(input(3, int)) is seq[int]
doAssert typeof(input(3, int8)) is seq[int8]
doAssert typeof(input(3, int16)) is seq[int16]
doAssert typeof(input(3, int32)) is seq[int32]
doAssert typeof(input(3, int64)) is seq[int64]
doAssert typeof(input(3, uint8)) is seq[uint8]
doAssert typeof(input(3, uint16)) is seq[uint16]
doAssert typeof(input(3, uint32)) is seq[uint32]
doAssert typeof(input(3, uint)) is seq[uint]
doAssert typeof(input(3, uint64)) is seq[uint64]

assert @[low(int), -1, 0, high(int)].join(",") ==
    "-9223372036854775808,-1,0,9223372036854775807"
assert @[0u32, high(uint32)].join(" ") == "0 4294967295"
assert @[0u64, high(uint64)].join(" ") == "0 18446744073709551615"
assert @['a', 'b'].join("-") == "a-b"

type FastioNamedFields = object
    umod: int
    val: uint64

proc `$`(value: FastioNamedFields): string =
    "custom:" & system.`$`(value.val)

assert @[FastioNamedFields(umod: 1, val: uint64(high(uint32)) + 1)].join ==
    "custom:4294967296"

let values = @[1, -2, 30]
assert (*values) == "1 -2 30"
doAssert compiles(print(1, 2, 3, sep = "\n"))
doAssert compiles(print(*values, sep = "\n"))
