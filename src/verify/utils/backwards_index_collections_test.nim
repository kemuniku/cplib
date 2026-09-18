# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/segtree
import cplib/collections/segtree_static_op
import cplib/collections/segtree_var
import cplib/collections/fenwick
import cplib/collections/bitset
import cplib/collections/staticbitset
import cplib/collections/lazysegtree
import cplib/collections/lazysegtree_static_op
import cplib/collections/segtree_beats_template
import cplib/collections/dynamic_segtree
import cplib/collections/root_rangesum
import cplib/collections/tatyamset
import cplib/collections/SWAG
import cplib/collections/QSWAG
import cplib/tree/link_cut_tree
import cplib/str/static_string
import cplib/str/merged_static_string
import cplib/str/fixedlength_merged_static_string
import cplib/str/repeated_static_string

proc sum(a, b: int): int = a + b
proc mapping(f, x: int): int = f + x
proc minimum(a, b: int): int = min(a, b)

template checkAccess(container: untyped) =
    block:
        var x = container
        for i in 1..x.len:
            doAssert x[^i] == x[x.len - i]
        x[^1] = 99
        doAssert x[x.len - 1] == 99
        x[^x.len] = -5
        doAssert x[0] == -5

checkAccess(segtree.initSegmentTree(@[1, 2, 3], sum, 0))
checkAccess(segtree_static_op.initSegmentTree(@[1, 2, 3], sum, 0))
checkAccess(fenwick.initFenwickTree(@[1, 2, 3]))
checkAccess(initLinkCutTree(@[1, 2, 3], sum, 0))
checkAccess(root_rangesum.initrangesum(@[1, 2, 3]))
checkAccess(dynamic_segtree.initDynamicSegmentTree(3, sum, 0))
checkAccess(lazysegtree.initLazySegmentTree[int, int](@[1, 2, 3], minimum, high(int), mapping, sum, 0))
checkAccess(lazysegtree_static_op.initLazySegmentTree[int, int](@[1, 2, 3], minimum, high(int), mapping, sum, 0))

block:
    var st = segtree_var.initSegmentTree(@[1, 2, 3], sum, 0)
    st[^1] += 7
    doAssert int(st[2]) == 10
    doAssert st.get(0..2) == 13
block:
    var st = initRangeChminChmaxRangeSumMaxMin(@[1, 2, 3])
    st.add(0..2, 10)
    doAssert st[^1].sum == 13
    st[^2] = 5
    doAssert st[1].sum == 5
    doAssert st[0..2].sum == 29
block:
    var bits = bitset.initBitSet(130)
    bits[^1] = true
    bits[^65] = 1
    doAssert bits[129] and bits[65]
    doAssert bits[^1] and bits[^65]
block:
    var bits = staticbitset.initBitSet(130)
    bits[^1] = 1
    bits[^130] = true
    doAssert bits[129] and bits[0]
    doAssert bits[^1] and bits[^130]
block:
    let s = initSortedMultiset(@[3, 1, 2, 2])
    doAssert s[^1] == 3
    doAssert s[^s.len] == 1
block:
    let s = SWAG.initSWAG(sum, 0)
    s.addLast(1)
    s.addLast(2)
    s.addFirst(3)
    doAssert s[^1] == 2
    doAssert s[^3] == 3
block:
    let s = QSWAG.initSWAG(sum, 0)
    s.push(1)
    s.push(2)
    doAssert s[^1] == 2
    doAssert s[^2] == 1
block:
    let base = "abcde".toStaticString()
    let s = base[1..3]
    doAssert s[^1] == 'd'
    doAssert s[^3] == 'b'
    let merged = initMergedStaticString([s, base])
    doAssert merged[^1] == 'e'
    doAssert merged[^merged.len] == 'b'
    let fixed = initFixedLengthMergedStaticString([s, base])
    doAssert fixed[^1] == 'e'
    doAssert fixed[^fixed.len] == 'b'
    let repeated = initRepeatedStaticString(s, 3)
    doAssert repeated[^1] == 'd'
    doAssert repeated[^repeated.len] == 'b'

echo "Hello World"
