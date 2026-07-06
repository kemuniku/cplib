# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/convolution/xor_convolution

var f = @[1, 2, 3, 4]
FastHadamardTransForm(f)
assert f == @[10, -2, -4, 0]
FastHadamardTransForm(f)
assert f == @[4, 8, 12, 16]

assert xorConvolution(@[1, 2], @[3, 4]) == @[11, 10]
assert xorConvolution(@[1, 0, 2, 1], @[0, 3, 1, 2]) == @[4, 8, 4, 8]
