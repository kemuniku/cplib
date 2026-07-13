import std/unittest
import cplib/modint/[modint, modfast]

suite "modfast":
  type Mint = modint998244353_barrett
  let fast = initModFast(Mint)

  test "inv, log and pow":
    for x in [1, 2, 3, 42, 123456789, 998244352]:
      let a = init(Mint, x)
      check fast.inv(a) == a.inv
      check fast.root.pow(fast.log(a)) == a
      for e in [0, 1, 2, 123456789, -1]:
        check fast.pow(a, e) == (if e < 0: a.inv.pow(-e) else: a.pow(e))

  test "many values":
    var x = 1
    for _ in 0..<1000:
      x = (x * 48271) mod 998244353
      let a = init(Mint, x)
      check fast.inv(a) == a.inv
      check fast.root.pow(fast.log(a)) == a
      check fast.pow(a, x) == a.pow(x)

  test "zero":
    check fast.pow(init(Mint, 0), 0) == init(Mint, 1)
    check fast.pow(init(Mint, 0), 10) == init(Mint, 0)
