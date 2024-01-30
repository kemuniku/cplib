# verification-helper: PROBLEM https://atcoder.jp/contests/abc307/tasks/abc307_c
import strutils, sequtils
import cplib/matrix/matops
proc load(): (int, int, seq[seq[bool]]) =
    var h, w: int
    (h, w) = stdin.readLine.split.map(parseInt)
    var s = newSeqWith(h, stdin.readLine).mapIt(it.mapIt(if it == '.': false else: true))
    s.trim(false)
    return (s.len, s[0].len, s)
var (ha, wa, a) = load()
var (hb, wb, b) = load()
var (hx, wx, x) = load()
for ia in 0..hx-ha:
    for ja in 0..wx-wa:
        for ib in 0..hx-hb:
            for jb in 0..wx-wb:
                var ans = newSeqWith(hx, newSeqWith(wx, false))
                for i in 0..<ha:
                    for j in 0..<wa:
                        ans[ia+i][ja+j] = ans[ia+i][ja+j] or a[i][j]
                for i in 0..<hb:
                    for j in 0..<wb:
                        ans[ib+i][jb+j] = ans[ib+i][jb+j] or b[i][j]
                if ans == x:
                    echo "Yes"
                    quit()
echo "No"
