# verification-helper: PROBLEM https://yukicoder.me/problems/no/2606
import strutils, sequtils, algorithm
import cplib/collections/palindromic_tree

var s = stdin.readLine.reversed.join("")
var pt = initPalindromicTree(s)
pt.update_count

var score = newSeqWith(pt.nodes.len, 0)
for i in 1..<pt.nodes.len:
    var node = pt.nodes[i]
    score[i] = score[node[].suffix_link[].id] + node[].count * node[].len
echo score.max
