# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import unittest
import cplib/modint/modint

addOutputFormatter(newConsoleOutputFormatter(OutputLevel.PRINT_FAILURES))

test "Dynamic Montogomery Zero Division Test":
    type mint = modint_montgomery
    mint.setMod(998244353)
    expect(Defect):
        discard mint(0).inv
test "Static Montogomery Zero Division Test":
    type mint = modint998244353_montgomery
    expect(Defect):
        discard mint(0).inv
test "Dynamic Barrett Zero Division Test":
    type mint = modint_barrett
    mint.setMod(998244353)
    expect(Defect):
        discard mint(0).inv
test "Static Barrett Zero Division Test":
    type mint = modint998244353_barrett
    expect(Defect):
        discard mint(0).inv

