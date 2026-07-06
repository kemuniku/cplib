# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/graph/graph
import cplib/math/isprime
import cplib/utils/random_helper

proc edgeCount(g: UnWeightedUnDirectedGraph): int =
  for i in 0..<g.len:
    for j in g[i]:
      if i < j:
        result += 1

let xs = randomseq(5, 1..3)
assert xs.len == 5
assert xs.allIt(it in 1..3)
let uniq = randomseq(3, 1..5, true)
assert uniq.len == 3
assert uniq.deduplicate.len == 3
assert uniq.allIt(it in 1..5)

let parts = randomseq_from_sum(4, 7)
assert parts.len == 4
assert parts.foldl(a + b, 0) == 7
assert parts.allIt(it >= 0)

let ps = random_parenthesis_sequence(6)
assert ps.len == 6
assert ps.foldl(a + b, 0) == 0
var bal = 0
for x in ps:
  bal += x
  assert bal >= 0
assert random_parenthesis_string(4).len == 4

let bt = make_binary_tree_from_sequence(@[1, 1, -1, -1])
assert bt.len == 2
assert bt.edgeCount == 1
assert random_binary_tree(3).len == 3
assert random_tree(1).len == 1
assert random_tree(2).edgeCount == 1

let p = random_prime(10..20)
assert p in 10..20
assert p.isprime
let primes = random_prime_sequence(3, 2..13, true)
assert primes.len == 3
assert primes.deduplicate.len == 3
assert primes.allIt(it.isprime)

let sg = random_simple_graph(4, 3)
assert sg.len == 4
assert sg.edgeCount == 3
let cg = random_connected_graph(4, 3)
assert cg.len == 4
assert cg.edgeCount == 3

let bits = random_01sequence(5, 2)
assert bits.len == 5
assert bits.foldl(a + b, 0) == 2
assert random_string(4, 'a'..'c').allIt(it in 'a'..'c')
assert random_string(4, "xyz").allIt(it in {'x', 'y', 'z'})
