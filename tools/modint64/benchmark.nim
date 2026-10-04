import cplib/modint/modint64
import cplib/modint/modint
import times, os, strutils

proc bench[T](name: string, count: int) =
    var x = T.init(1234567)
    let factor = T.init(-12345)
    var started = cpuTime()
    for _ in 0..<count:
        x *= factor
    let mulTime = cpuTime() - started
    echo name, " mul ", mulTime, " ", x.val
    started = cpuTime()
    for _ in 0..<count:
        x += factor
    echo name, " add ", cpuTime() - started, " ", x.val
    started = cpuTime()
    for _ in 0..<max(1, count div 1000):
        x += 1
        if x.val == 0: x += 1
        x = x.inv
    echo name, " inv ", cpuTime() - started, " ", x.val
let count = parseInt(paramStr(1))
bench[StaticModint64[998244353u64]]("static64_small", count)
bench[modint998244353_montgomery]("montgomery32", count)
bench[modint998244353_barrett]("barrett32", count)
bench[StaticModint64[9223372036854775837u64]]("static64_above63", count)
bench[StaticModint64[18446744073709551557u64]]("static64_top", count)
