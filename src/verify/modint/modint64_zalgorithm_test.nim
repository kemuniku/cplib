# verification-helper: PROBLEM https://judge.yosupo.jp/problem/zalgorithm
import cplib/modint/modint64
import random, strutils

type HashMint = StaticModint64[18446744073709551557u64]

# 最大uint64素数の単一hashで比較する。衝突の可能性がある確率的解法。
proc hashZ(s: string, baseValue: uint64): seq[int] =
    let base = HashMint.init(baseValue)
    var prefix = newSeq[HashMint](s.len + 1)
    var powers = newSeq[HashMint](s.len + 1)
    powers[0] = HashMint.init(1)
    for i in 0..<s.len:
        prefix[i + 1] = prefix[i] * base + HashMint.init(ord(s[i]))
        powers[i + 1] = powers[i] * base
    result = newSeq[int](s.len)
    for i in 0..<s.len:
        var ok = 0
        var ng = s.len - i + 1
        while ng - ok > 1:
            let mid = (ok + ng) div 2
            let substring = prefix[i + mid] - prefix[i] * powers[mid]
            if substring == prefix[mid]:
                ok = mid
            else:
                ng = mid
        result[i] = ok

when defined(modint64ZOracle):
    # 文字の直接比較による独立oracle。追加検査もverify内だけに置く。
    proc naiveZ(s: string): seq[int] =
        result = newSeq[int](s.len)
        for i in 0..<s.len:
            while i + result[i] < s.len and s[result[i]] == s[i + result[i]]:
                inc result[i]

    var oracleRng = initRand(979)
    for length in 1..8:
        for mask in 0..<(1 shl length):
            var s = newString(length)
            for i in 0..<length:
                s[i] = char(ord('a') + ((mask shr i) and 1))
            let base = oracleRng.rand(257u64..HashMint.umod - 257u64)
            doAssert hashZ(s, base) == naiveZ(s)
    for _ in 0..<1000:
        var s = newString(oracleRng.rand(1..128))
        for c in s.mitems:
            c = char(ord('a') + oracleRng.rand(0..25))
        let base = oracleRng.rand(257u64..HashMint.umod - 257u64)
        doAssert hashZ(s, base) == naiveZ(s)
    for s in ["a", "aaaaaaa", "ababababa", "abcabcabc", "abcdefghijklmnopqrstuvwxyz"]:
        for base in [911382323u64, 9223372036854775837u64, HashMint.umod - 911382323u64]:
            doAssert hashZ(s, base) == naiveZ(s)
    block:
        let z = hashZ("a".repeat(500000), HashMint.umod - 911382323u64)
        for i in 0..<z.len:
            doAssert z[i] == z.len - i
    block:
        let z = hashZ("ab".repeat(250000), 9223372036854775837u64)
        for i in 0..<z.len:
            doAssert z[i] == (if i mod 2 == 0: z.len - i else: 0)

let s = stdin.readLine()
var rng = initRand()
let base = rng.rand(257u64..HashMint.umod - 257u64)
echo hashZ(s, base).join(" ")
