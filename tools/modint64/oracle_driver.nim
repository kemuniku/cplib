import cplib/modint/modint64
import strutils

proc check[T](parts: seq[string]) =
    let a = T.init(parseBiggestUInt(parts[1]).uint64)
    let b = T.init(parseBiggestUInt(parts[2]).uint64)
    let exponent = parseBiggestUInt(parts[3]).uint64
    let signed = parseBiggestInt(parts[4]).int64
    let parsed = T.parseModint64(parts[5])
    var sum = a
    var difference = a
    var product = a
    sum += b
    difference -= b
    product *= b
    let inverse = if a.val == 0: "zero" else: $a.inv
    let quotient = if b.val == 0: "zero" else: $(a / b)
    echo $a, " ", $b, " ", $(a + b), " ", $(a - b), " ", $(a * b),
        " ", $a.pow(exponent), " ", inverse, " ", quotient,
        " ", $T.init(signed), " ", $parsed, " ", $(-a),
        " ", $sum, " ", $difference, " ", $product,
        " ", $(a + signed), " ", $(signed - a), " ", $(signed * a)

for line in stdin.lines:
    let parts = line.splitWhitespace
    case parseBiggestUInt(parts[0]).uint64
    of 2u64: check[StaticModint64[2u64]](parts)
    of 3u64: check[StaticModint64[3u64]](parts)
    of 17u64: check[StaticModint64[17u64]](parts)
    of 998244353u64: check[StaticModint64[998244353u64]](parts)
    of 1000000007u64: check[StaticModint64[1000000007u64]](parts)
    of 2305843009213693951u64: check[StaticModint64[2305843009213693951u64]](parts)
    of 9223372036854775783u64: check[StaticModint64[9223372036854775783u64]](parts)
    of 9223372036854775837u64: check[StaticModint64[9223372036854775837u64]](parts)
    of 18446744073709551533u64: check[StaticModint64[18446744073709551533u64]](parts)
    of 18446744073709551557u64: check[StaticModint64[18446744073709551557u64]](parts)
    else: raise newException(ValueError, "unknown modulus")
