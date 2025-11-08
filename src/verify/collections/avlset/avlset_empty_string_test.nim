# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import cplib/collections/avlset

# Test empty AVLSortedSet string conversion
var emptySet = initAvlSortedSet[int]()
assert $emptySet == ""
assert emptySet.len == 0

# Test empty AvlSortedMultiSet string conversion
var emptyMultiSet = initAvlSortedMultiSet[int]()
assert $emptyMultiSet == ""
assert emptyMultiSet.len == 0

# Test non-empty AVLSortedSet string conversion
var nonEmptySet = initAvlSortedSet(@[3, 1, 2])
assert nonEmptySet.len == 3
var nonEmptySetStr = $nonEmptySet
assert nonEmptySetStr == "1 2 3"

# Test non-empty AvlSortedMultiSet string conversion
var nonEmptyMultiSet = initAvlSortedMultiSet(@[3, 1, 2, 2])
assert nonEmptyMultiSet.len == 4
var nonEmptyMultiSetStr = $nonEmptyMultiSet
assert nonEmptyMultiSetStr == "1 2 2 3"

# Test set becoming empty after removal
var setWithItem = initAvlSortedSet(@[42])
assert setWithItem.len == 1
assert $setWithItem == "42"
discard setWithItem.excl(42)
assert setWithItem.len == 0
assert $setWithItem == ""
