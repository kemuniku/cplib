# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_palindromes
import cplib/str/manacher

var s = stdin.readLine
var interleaved = newString(max(0, 2*s.len-1))
for i,c in s:
    interleaved[2*i] = c
    if 2*i+1 < interleaved.len: interleaved[2*i+1] = '$'
s = move(interleaved)
var ans = manacher(s)
for i in 0..<ans.len:
    if i mod 2 != 0: ans[i] = ans[i] div 2 * 2
    else: ans[i] = (ans[i] + 1) div 2 * 2 - 1
proc appendInt(output: var string, value: int) =
    var x = value
    var digits: array[20, char]
    var count = 0
    while true:
        digits[count] = char(ord('0') + x mod 10)
        inc count
        x = x div 10
        if x == 0: break
    for i in countdown(count-1,0): output.add(digits[i])
var output = newStringOfCap(ans.len*7)
for i,value in ans:
    if i > 0: output.add(' ')
    output.appendInt(value)
echo output
