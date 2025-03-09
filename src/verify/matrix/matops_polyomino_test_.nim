# verification-helper: PROBLEM https://atcoder.jp/contests/abc322/tasks/abc322_d
import sequtils
import cplib/matrix/matops

proc load(): seq[seq[int]] =
    result = newSeqWith(4, stdin.readLine.mapIt(if it == '.': 0 else: 1))
    result = result.trimmed(0)
var a = newSeqWith(3, load())
var s = newSeqWith(4, newSeqWith(4, 0))
proc dfs(d: int, s: seq[seq[int]]): bool =
    if d == 3: return s.mapIt(it.min).min == 1
    var a = a[d]
    var h = a.len
    var w = a[0].len
    for sx in 0..4-h:
        for sy in 0..4-w:
            var sn = s
            proc place(): bool =
                for i in 0..<h:
                    for j in 0..<w:
                        if s[sx+i][sy+j] == 1 and a[i][j] == 1: return false
                        sn[sx+i][sy+j] = sn[sx+i][sy+j] or a[i][j]
                return true
            if place():
                if dfs(d+1, sn): return true
    return false
for i in 0..<4:
    for j in 0..<4:
        for k in 0..<4:
            if dfs(0, s):
                echo "Yes"
                quit()
            a[2].rotate(-1)
        a[1].rotate(-1)
    a[0].rotate(-1)
echo "No"
