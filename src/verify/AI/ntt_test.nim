# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/convolution/ntt
import cplib/modint/modint

block static_barrett_ntt:
  type Mint = modint998244353_barrett
  var f = @[Mint(1), Mint(2), Mint(3), Mint(4)]
  ntt(f)
  intt(f)
  assert f.mapIt(it.val) == @[1, 2, 3, 4]

block static_montgomery_ntt:
  type Mint = modint998244353_montgomery
  var f = @[Mint(5), Mint(6), Mint(7), Mint(8)]
  ntt(f)
  intt(f)
  assert f.mapIt(it.val) == @[5, 6, 7, 8]

block dynamic_barrett_ntt:
  type Mint = modint_barrett
  Mint.setMod(998244353)
  var f = @[Mint(9), Mint(10)]
  ntt(f)
  intt(f)
  assert f.mapIt(it.val) == @[9, 10]
