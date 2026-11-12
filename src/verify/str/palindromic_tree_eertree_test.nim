# verification-helper: PROBLEM https://judge.yosupo.jp/problem/eertree
import cplib/str/palindromic_tree
import strutils

let s = stdin.readLine()
var pt = initPalindromicTree('a'..'z', capacity = s.len)
for c in s:
    pt.add(c)
var output = newStringOfCap(s.len * 28)
output.addInt(pt.nodes.len - 2)
output.add('\n')
for i in 2..<pt.nodes.len:
    let node = pt.nodes[i]
    output.addInt(node.parent.id - 1)
    output.add(' ')
    output.addInt(node.suffix_link.id - 1)
    output.add('\n')
for i, node in pt.prefix_nodes:
    if i != 0: output.add(' ')
    output.addInt(node.id - 1)
output.add('\n')
stdout.write(output)
