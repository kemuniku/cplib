# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import cplib/utils/oeis
import net

static:
    doAssert declared(newContext)

let context = newContext()
context.destroyContext()
doAssert searchOEIS(newSeq[int]()).len == 0

echo "Hello World"
