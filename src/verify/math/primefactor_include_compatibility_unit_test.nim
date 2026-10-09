# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
include cplib/math/primefactor

doAssert mul(9, 9, 19) == 5
doAssert add(4, 18, 19) == 3
doAssert primefactor(84) == @[2, 2, 3, 7]
echo "Hello World"
