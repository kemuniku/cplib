# verification-helper: PROBLEM https://judge.yosupo.jp/problem/aho_corasick
import strutils
import cplib/str/aho_corasick
let n = parseInt(stdin.readLine())
var words = newSeq[string](n)
for i in 0..<n: words[i] = stdin.readLine()
let ac = initAhoCorasick(words, 'a'..'z')
echo ac.nodeCount
for node in 1..<ac.nodeCount: echo ac.getParent(node), " ", ac.failure(node)
for i in 0..<n:
    if i > 0: stdout.write(" ")
    stdout.write(ac.patternNode(i))
stdout.write("\n")
