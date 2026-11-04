# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/binary_search

doAssert meguru_bisect(high(int)-2, high(int), proc(x: int): bool = x < high(int)-1) == high(int)-2
doAssert meguru_bisect(low(int), low(int)+2, proc(x: int): bool = x < low(int)+1) == low(int)
doAssert meguru_bisect(low(int), high(int), proc(x: int): bool = x < 0) == -1
doAssert meguru_bisect(high(int), low(int), proc(x: int): bool = x >= 0) == 0
doAssert meguru_bisect(low(int), high(int), proc(x: int): bool = x < high(int)) == high(int)-1
doAssert meguru_bisect(high(int), low(int), proc(x: int): bool = x > low(int)) == low(int)+1

proc unexpected(x: int): bool =
    doAssert false
    return false

for value in [low(int), -1, 0, 1, high(int)]:
    doAssert meguru_bisect(value, value, unexpected) == value
for left in [low(int), -1, 0, high(int)-1]:
    doAssert meguru_bisect(left, left+1, unexpected) == left
    doAssert meguru_bisect(left+1, left, unexpected) == left+1

for left in -20..20:
    for right in left+1..21:
        for boundary in left+1..right:
            doAssert meguru_bisect(left, right, proc(x: int): bool = x < boundary) == boundary-1
            doAssert meguru_bisect(right, left, proc(x: int): bool = x >= boundary) == boundary
echo "Hello World"
