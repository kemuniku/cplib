# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/utils/bititers

assert toSeq(bitcomb(4, 2)) == @[0b0011, 0b0101, 0b0110, 0b1001, 0b1010, 0b1100]
assert toSeq(bitcomb(3, 0)) == @[0]
assert toSeq(bitsubseteq(0b101)) == @[0, 1, 4, 5]
assert toSeq(bitsubset(0b101)) == @[0, 1, 4]
assert toSeq(bitsubseteq_descending(0b101)) == @[5, 4, 1, 0]
assert toSeq(bitsubset_descending(0b101)) == @[4, 1, 0]
assert toSeq(bitsuperseteq(0b001, 3)) == @[1, 3, 5, 7]
assert toSeq(bitsuperset(0b001, 3)) == @[3, 5, 7]
assert toSeq(bitsingleton(0b10110)) == @[0b10, 0b100, 0b10000]
assert toSeq(standingbits(0b10110)) == @[1, 2, 4]
