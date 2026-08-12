# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/kth_root_integer

assert kth_root_integer(0'u64, 1) == 0
assert kth_root_integer(0'u64, 64) == 0
assert kth_root_integer(1'u64, 64) == 1
assert kth_root_integer(15'u64, 2) == 3
assert kth_root_integer(16'u64, 2) == 4
assert kth_root_integer(26'u64, 3) == 2
assert kth_root_integer(27'u64, 3) == 3
assert kth_root_integer(1'u64 shl 63, 63) == 2
assert kth_root_integer((1'u64 shl 63) - 1, 63) == 1
assert kth_root_integer(uint64.high, 1) == uint64.high
assert kth_root_integer(uint64.high, 2) == 4_294_967_295'u64
assert kth_root_integer(uint64.high, 64) == 1
