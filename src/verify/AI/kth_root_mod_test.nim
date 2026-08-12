# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/sequtils
import cplib/math/[kth_root_mod, powmod]

for p in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,
          53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109]:
    for k in 0..2 * p:
        for a in 0..<p:
            let x = kthRootMod(a, k, p)
            let exists = (0..<p).anyIt(powmod(it, k, p) == a)
            assert (x != -1) == exists
            if x != -1: assert powmod(x, k, p) == a

assert kth_root_mod(-1, 2, 5) in [2, 3]
assert kthRootMod(3, 2, 7) == -1

for p in [998_244_353, 1_000_000_007]:
    for k in [2, 3, 4, 7, 16, 1_000_000_000]:
        for x in [0, 1, 2, 123_456_789, p - 1]:
            let a = powmod(x mod p, k, p)
            let root = kthRootMod(a, k, p)
            assert root != -1
            assert powmod(root, k, p) == a
