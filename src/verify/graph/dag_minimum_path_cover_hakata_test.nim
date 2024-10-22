# verification-helper: PROBLEM https://atcoder.jp/contests/abc237/tasks/abc237_ex
import cplib/graph/graph
import cplib/graph/dag_minimum_path_cover
import sets
import sequtils
import strutils
import algorithm

var S = stdin.readLine()
var N = len(S)
var tmp = initHashSet[string]()
for i in 0..<(N):
    for x in 1..(N-i):
        if S[i..<(i+x)] == S[i..<(i+x)].reversed().join(""):
            tmp.incl(S[i..<(i+x)])

var palindromes = tmp.toseq()
var G = initUnWeightedDirectedGraph(len(palindromes))

for i in 0..<(len(palindromes)):
    for j in 0..<(len(palindromes)):
        if i != j:
            if palindromes[i] in palindromes[j]:
                G.add_edge(i,j)

echo G.dag_minimum_path_cover()