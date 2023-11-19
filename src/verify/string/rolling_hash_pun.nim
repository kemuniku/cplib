# verification-helper: PROBLEM https://atcoder.jp/contests/abc141/tasks/abc141_e
import strutils, tables
import cplib/str/rolling_hash
import cplib/utils/binary_search

var n = stdin.readLine.parseInt
var s = stdin.readLine
var rh = initRollingHash(s)

proc is_ok(x: int): bool =
    var seen = initTable[uint, int]()
    for i in 0..<n-x+1:
        var sh = rh.query(i..<i+x)
        if sh in seen:
            if seen[sh] + x <= i:
                return true
        else:
            seen[sh] = i
    return false
if not is_ok(1):
    echo 0
    quit()
echo meguru_bisect(1, n div 2 + 1, is_ok)
