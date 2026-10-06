# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/modint/modint
proc checkUnsigned[T: BarrettModint, U: SomeUnsignedInt](values: openArray[U]) =
  for value in values:
    let expected = int(uint64(value) mod uint64(T.umod))
    let x = init(T, value)
    doAssert x.val == expected
    var y = init(T, 0)
    y += value
    doAssert y == x
    y -= value
    doAssert y.val == 0
    y = init(T, 1)
    y *= value
    doAssert y == x
    doAssert (init(T, 0) + value).val == expected
    doAssert (value + init(T, 0)).val == expected
proc check[T: BarrettModint]() =
  checkUnsigned[T, uint8]([0u8, 1u8, high(uint8)])
  checkUnsigned[T, uint16]([0u16, 1u16, high(uint16)])
  checkUnsigned[T, uint32]([0u32, 1u32, high(uint32)])
  checkUnsigned[T, uint]([0u, 1u, high(uint)])
  checkUnsigned[T, uint64]([0u64, 1u64, high(int).uint64, high(int).uint64 + 1, high(uint64)])
  for value in [low(int), -1, 0, 1, high(int)]:
    var expected = value mod T.umod.int
    if expected < 0: expected += T.umod.int
    doAssert init(T, value).val == expected
check[modint998244353_barrett]()
check[modint1000000007_barrett]()
for modulus in [1, 2, 41, 998244353, 2147483647]:
  modint_barrett.setMod(modulus)
  check[modint_barrett]()
echo "Hello World"
