# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/convolution/convolution
import cplib/modint/modint

assert convolution_ll(@[1, 2, 3], @[4, 5]) == @[4, 13, 22, 15]

type Mint = modint998244353_barrett
let f = @[Mint(1), Mint(2), Mint(3)]
let g = @[Mint(4), Mint(5)]
assert convolution_naive(f, g).mapIt(it.val) == @[4, 13, 22, 15]
assert convolution(f, g).mapIt(it.val) == @[4, 13, 22, 15]
