# verification-helper: https://atcoder.jp/contests/abc298/tasks/abc298_b
import cplib/matrix/matops
import strutils, sequtils, sugar
var n = stdin.readLine.parseInt
var a, b = collect(newSeq): (for i in 0..<n: stdin.readLine.split.map(parseInt))
for i in 0..<4:
    proc check(a, b: seq[seq[int]]): bool =
        for i in 0..<n:
            for j in 0..<n:
                if a[i][j] == 1 and b[i][j] == 0: return false
        return true
    if check(a.rotated(i), b):
        echo "Yes"
        quit()
echo "No"
