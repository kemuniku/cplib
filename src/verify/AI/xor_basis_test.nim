# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/xor_basis

var xb = initXorBasis(@[1, 2, 3])
assert xb.len_basis == 2
assert xb.can_make(3)
assert not xb.can_make(4)
xb.incl(4)
assert xb.len_basis == 3
assert xb.kth_smallest(0) == 0
assert xb.kth_smallest(5) == 5
assert xb.kth_smallest(8) == -1
assert xb.lt(4) == 3
assert xb.le(4) == 4
assert xb.index(6) == 6
assert xb.xor_min(5) == 5
assert xb.xor_kth(2, 0) == 2
assert xb.xor_kth(2, 3) == 1
assert xb.xor_kth(2, 8) == -1

import algorithm

for a in 0..7:
    for b in 0..7:
        for c in 0..7:
            let inputs = [a, b, c]
            let basis = initXorBasis(inputs)
            let incremental = initXorBasis()
            for value in inputs:
                incremental.incl(value)
            var seen: array[8, bool]
            for mask in 0..<8:
                var value = 0
                for i in 0..<3:
                    if (mask and (1 shl i)) != 0:
                        value = value xor inputs[i]
                seen[value] = true
            var values: seq[int]
            for value in 0..7:
                if seen[value]:
                    values.add(value)
            for candidate in [basis, incremental]:
                for k, value in values:
                    doAssert candidate.kth_smallest(k) == value
                for k in [-1, low(int), values.len, high(int)]:
                    doAssert candidate.kth_smallest(k) == -1
                for x in 0..15:
                    var ordered: seq[int]
                    for value in values:
                        ordered.add(value xor x)
                    ordered.sort()
                    for k, value in ordered:
                        doAssert candidate.xor_kth(x, k) == (value xor x)
                    for k in [-1, low(int), values.len, high(int)]:
                        doAssert candidate.xor_kth(x, k) == -1

block:
    let empty = initXorBasis()
    doAssert empty.kth_smallest(0) == 0
    doAssert empty.kth_smallest(1) == -1
    doAssert empty.kth_smallest(-1) == -1
    doAssert empty.xor_kth(high(int), 0) == 0
    doAssert empty.xor_kth(high(int), 1) == -1
    doAssert empty.xor_kth(high(int), -1) == -1

block:
    let singleton = initXorBasis([high(int)])
    doAssert singleton.kth_smallest(0) == 0
    doAssert singleton.kth_smallest(1) == high(int)
    doAssert singleton.kth_smallest(2) == -1
    doAssert singleton.xor_kth(high(int), 0) == high(int)
    doAssert singleton.xor_kth(high(int), 1) == 0

block:
    const rank = sizeof(int) * 8 - 1
    var powers: seq[int]
    let incremental = initXorBasis()
    for bit in 0..<rank:
        powers.add(1 shl bit)
        incremental.incl(1 shl bit)
    let full = initXorBasis(powers)
    for basis in [full, incremental]:
        doAssert basis.len_basis == rank
        for k in [0, 1, 2, high(int) div 2, high(int) - 1, high(int)]:
            doAssert basis.kth_smallest(k) == k
            for x in [0, 1, high(int) div 2, high(int)]:
                doAssert basis.xor_kth(x, k) == (x xor k)
        for k in [-1, low(int)]:
            doAssert basis.kth_smallest(k) == -1
            doAssert basis.xor_kth(0, k) == -1

    let smaller = initXorBasis(powers[0..<rank - 1])
    let count = 1 shl (rank - 1)
    doAssert smaller.kth_smallest(count - 1) == count - 1
    doAssert smaller.kth_smallest(count) == -1
    doAssert smaller.xor_kth(0, count - 1) == count - 1
    doAssert smaller.xor_kth(0, count) == -1
