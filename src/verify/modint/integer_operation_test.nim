# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import unittest
import cplib/modint/modint

addOutputFormatter(newConsoleOutputFormatter(OutputLevel.PRINT_FAILURES))

test "Dynamic Montgomery Integer Operation Test":
    type mint = modint_montgomery
    mint.setMod(998244353)
    for x in 1..10:
        for y in 1..10:
            assert (x + mint(y)).val == (mint(x) + mint(y)).val
            assert (mint(x) + y).val == (mint(x) + mint(y)).val
test "Static Montogomery Integer Operation Test":
    type mint = modint998244353_montgomery
    for x in 1..10:
        for y in 1..10:
            assert (x + mint(y)).val == (mint(x) + mint(y)).val
            assert (mint(x) + y).val == (mint(x) + mint(y)).val
test "Dynamic Barrett Integer Operation Test":
    type mint = modint_barrett
    mint.setMod(998244353)
    for x in 1..10:
        for y in 1..10:
            assert (x + mint(y)).val == (mint(x) + mint(y)).val
            assert (mint(x) + y).val == (mint(x) + mint(y)).val
test "Static Barrett Integer Operation Test":
    type mint = modint998244353_barrett
    for x in 1..10:
        for y in 1..10:
            assert (x + mint(y)).val == (mint(x) + mint(y)).val
            assert (mint(x) + y).val == (mint(x) + mint(y)).val
