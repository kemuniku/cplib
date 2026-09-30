# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import sequtils, algorithm
import cplib/utils/bititers

for bits in 0..<256:
    var expected: seq[int] = @[]
    for mask in 0..bits:
        if (mask and bits) == mask:
            expected.add(mask)
    doAssert toSeq(bitsubseteq(bits)) == expected
    var proper = expected
    proper.setLen(proper.len - 1)
    doAssert toSeq(bitsubset(bits)) == proper
    expected.reverse()
    proper.reverse()
    doAssert toSeq(bitsubseteq_descending(bits)) == expected
    doAssert toSeq(bitsubset_descending(bits)) == proper

echo "Hello World"
