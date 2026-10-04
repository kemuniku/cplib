import strutils, sequtils
import cplib/math/crt

let cases = stdin.readLine.parseInt
for iteration in 0..<cases:
    let n = stdin.readLine.parseInt
    let r = stdin.readLine.splitWhitespace.map(parseInt)
    let m = stdin.readLine.splitWhitespace.map(parseInt)
    doAssert r.len == n and m.len == n
    try:
        let (residue, modulus) = crt(r, m)
        echo residue, " ", modulus
    except OverflowDefect:
        echo "overflow"
