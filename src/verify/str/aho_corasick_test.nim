# verification-helper: PROBLEM https://judge.yosupo.jp/problem/aho_corasick
import strutils
import cplib/str/aho_corasick
let n = parseInt(stdin.readLine())
var words = newSeq[string](n)
for i in 0..<n: words[i] = stdin.readLine()
let ac = initAhoCorasick(words, 'a'..'z')
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
var output = newStringOfCap(ac.nodeCount*14)
output.appendInt(ac.nodeCount)
output.add('\n')
for node in 1..<ac.nodeCount:
    output.appendInt(ac.getParent(node))
    output.add(' ')
    output.appendInt(ac.failure(node))
    output.add('\n')
for i in 0..<n:
    if i > 0: output.add(' ')
    output.appendInt(ac.patternNode(i))
output.add('\n')
stdout.write(output)
