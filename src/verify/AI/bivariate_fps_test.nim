# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import options, random
import cplib/fps/bivariate_formal_power_series
import cplib/modint/modint

proc same[T](a, b: BivariateFPS[T]) =
  doAssert a.shape == b.shape, $a.shape & " != " & $b.shape
  for i in 0..<a.len:
    doAssert a[i].len == b[i].len
    for j in 0..<a[i].len:
      doAssert a[i][j].val == b[i][j].val,
        $T & " (" & $i & ", " & $j & "): " & $a[i][j].val & " != " & $b[i][j].val

proc naiveMul[T](a, b: BivariateFPS[T], n, m: int): BivariateFPS[T] =
  result = initBivariateFPS[T](n, m)
  if n <= 0 or m <= 0: return
  for i in 0..<min(a.len, n):
    for j in 0..<min(a[i].len, m):
      for k in 0..<min(b.len, n - i):
        for l in 0..<min(b[k].len, m - j):
          result[i + k][j + l] += a[i][j] * b[k][l]

proc naiveInv[T](f: BivariateFPS[T], n, m: int): BivariateFPS[T] =
  result = initBivariateFPS[T](n, m)
  let c = f[0][0].inv
  result[0][0] = c
  for i in 0..<n:
    for j in 0..<m:
      if i == 0 and j == 0: continue
      var v = init(T, 0)
      for k in 0..i:
        for l in 0..j:
          if k == 0 and l == 0: continue
          v += f.coefficient(k, l) * result[i - k][j - l]
      result[i][j] = -v * c

proc naiveExp[T](f: BivariateFPS[T], n, m: int): BivariateFPS[T] =
  result = initBivariateFPS[T](n, m)
  result[0][0] = init(T, 1)
  var term = result
  for k in 1..n + m - 2:
    let product = naiveMul(term, f, n, m)
    term = product / init(T, k)
    result = result + term

proc naiveLog[T](f: BivariateFPS[T], n, m: int): BivariateFPS[T] =
  result = initBivariateFPS[T](n, m)
  var h = f.prefix(n, m)
  h[0][0] -= 1
  var term = initBivariateFPS[T](n, m)
  term[0][0] = init(T, 1)
  for k in 1..n + m - 2:
    term = naiveMul(term, h, n, m)
    if (k and 1) == 1: result = result + term / init(T, k)
    else: result = result - term / init(T, k)

var rng = initRand(20260926)

proc randomFPS[T](n, m: int, ragged = false): BivariateFPS[T] =
  result = initBivariateFPS[T](n, m)
  for i in 0..<result.len:
    if ragged: result[i].setLen(rng.rand(m))
    for j in 0..<result[i].len: result[i][j] = init(T, rng.rand(1_000_000))

proc check[T: BarrettModint or MontgomeryModint](n, m: int) =
  var f = randomFPS[T](n, m)
  let g = randomFPS[T](n + 1, m + 2, true)
  f[0][0] = init(T, 1)
  let saved = f.prefix(n, m)
  same(f.mulPrefix(g, n + 2, m + 1), naiveMul(f, g, n + 2, m + 1))
  let s = g.shape
  same(f * g, naiveMul(f, g, n + s.n - 1, m + s.m - 1))
  same(f.inv(n + 1, m + 1), naiveInv(f, n + 1, m + 1))
  same(f.inv, f.inv(n, m))
  var one = initBivariateFPS[T](n, m)
  one[0][0] = init(T, 1)
  same(naiveMul(f, f.inv, n, m), one)
  same(f.divPrefix(f, n, m), one)
  same(f / f, one)
  same((g / f).mulPrefix(f, n + 1, max(m, s.m)), g.prefix(n + 1, max(m, s.m)))
  same((f * init(T, 7)) / init(T, 7), f)
  same(init(T, 3) * f, f * init(T, 3))
  same((f + g) - g, f.prefix(n + 1, max(m, s.m)))
  same(-(-f), f)
  same(f.integralX.derivativeX, f)
  same(f.integralY.derivativeY, f)
  same(f.derivativeX.transpose, f.transpose.derivativeY)
  same(f.transpose.transpose, f)
  same(g.transpose.transpose, g.prefix(s.n, s.m))
  let x = init(T, 5)
  let y = init(T, 8)
  var value = init(T, 0)
  for i in 0..<n:
    for j in 0..<m: value += f[i][j] * x.pow(i) * y.pow(j)
  doAssert f.eval(x, y) == value
  same(f.log, naiveLog(f, n, m))
  same(f.log.exp, f)
  same(f.log.transpose, f.transpose.log)
  same(f.log(n, m).derivativeY, f.derivativeY.mulPrefix(f.inv(n, m), n, m - 1))
  same(f, saved)
  f[0][0] = init(T, 0)
  same(f.exp, naiveExp(f, n, m))
  same(f.exp.log, f)
  same(f.exp.transpose, f.transpose.exp)
  for constant in [0, 3]:
    f[0][0] = init(T, constant)
    var power = one
    for k in 0..5:
      same(f.pow(k), power)
      power = naiveMul(power, f, n, m)
  f[0][0] = init(T, 3)
  let square = naiveMul(f, f, n, m)
  let root = square.sqrtUnit
  doAssert root.isSome
  same(naiveMul(root.get, root.get, n, m), square)

block smallRandomCases:
  for n in 1..5:
    for m in 1..5: check[modint998244353_barrett](n, m)
  check[modint998244353_montgomery](7, 6)
  check[modint1000000007_barrett](7, 6)
  check[modint1000000007_montgomery](7, 6)
  for modulus in [998244353, 1000000007, 101, 998244353]:
    modint_barrett.setMod(modulus)
    modint_montgomery.setMod(modulus)
    check[modint_barrett](4, 5)
    check[modint_montgomery](4, 5)

proc checkLarge[T: BarrettModint or MontgomeryModint](n, m: int) =
  var f = randomFPS[T](n, m)
  var g = randomFPS[T](n - n div 3, m - m div 3)
  f[0][0] = init(T, 1)
  g[0][0] = init(T, 1)
  same(f.mulPrefix(g, n, m), naiveMul(f, g, n, m))
  var one = initBivariateFPS[T](n, m)
  one[0][0] = init(T, 1)
  same(naiveMul(f, f.inv, n, m), one)
  same(f.log.exp, f)
  same(f.log.transpose, f.transpose.log)
  same((f.mulPrefix(g, n, m)).log, f.log(n, m) + g.log(n, m))
  let root = f.sqrtUnit
  doAssert root.isSome
  same(naiveMul(root.get, root.get, n, m), f)

block nttAndCrtCases:
  for size in [(1, 130), (130, 1), (17, 19), (33, 7), (7, 65)]:
    checkLarge[modint998244353_barrett](size[0], size[1])
  checkLarge[modint998244353_montgomery](17, 19)
  checkLarge[modint1000000007_barrett](17, 19)
  checkLarge[modint1000000007_montgomery](17, 19)
  modint_barrett.setMod(1000000007)
  modint_montgomery.setMod(998244353)
  checkLarge[modint_barrett](17, 19)
  checkLarge[modint_montgomery](17, 19)

block emptyAndRagged:
  type M = modint998244353_barrett
  let empty: BivariateFPS[M] = @[]
  let blank: BivariateFPS[M] = @[@[], @[], @[]]
  let f: BivariateFPS[M] = @[@[M(1), M(2)], @[], @[M(3)]]
  doAssert f.shape == (3, 2)
  for pos in [(-1, 0), (0, -1), (3, 0), (1, 0), (2, 1)]:
    doAssert f.coefficient(pos[0], pos[1]).val == 0
  doAssert f.coefficient(2, 0).val == 3
  same(f + empty, f.prefix(3, 2))
  same(blank + f, f.prefix(3, 2))
  same(-blank, empty)
  same(blank * M(3), empty)
  same(blank.transpose, empty)
  same(blank.derivativeX, empty)
  same(blank.derivativeY, empty)
  same(blank.integralX, empty)
  same(blank.integralY, empty)
  same(f * empty, empty)
  same(f * blank, empty)
  same(f.mulPrefix(empty, 4, 5), initBivariateFPS[M](4, 5))
  same(empty.pow(0, 3, 4), empty.exp(3, 4))
  same(empty.pow(7, 3, 4), initBivariateFPS[M](3, 4))
  same(f.log(2, 1).exp(2, 1), f.prefix(2, 1))
  same(f.inv(6, 7), naiveInv(f, 6, 7))
  same(f.integralX.derivativeX, f.prefix(3, 2))
  same(f.integralY.derivativeY, f.prefix(3, 2))
  for dims in [(0, 4), (4, 0), (-2, 4), (4, -2)]:
    let (n, m) = dims
    same(f.prefix(n, m), empty)
    same(empty.inv(n, m), empty)
    same(empty.log(n, m), empty)
    same(f.exp(n, m), empty)
    same(f.pow(2, n, m), empty)
    same(f.mulPrefix(f, n, m), empty)
    same(f.divPrefix(empty, n, m), empty)
    doAssert empty.sqrtUnit(n, m).isSome
  var copied = f.prefix(3, 2)
  copied[0][0] = M(9)
  doAssert f[0][0].val == 1
  var calculated = f + f
  calculated[0][0] = M(17)
  doAssert f[0][0].val == 1

proc checkComposite[T: BarrettModint or MontgomeryModint]() =
  var f = randomFPS[T](7, 11)
  f[0][0] = init(T, 2)
  same(f.inv, naiveInv(f, 7, 11))
  var power = initBivariateFPS[T](7, 11)
  power[0][0] = init(T, 1)
  for k in 0..5:
    same(f.pow(k), power)
    power = naiveMul(power, f, 7, 11)
  f[0][0] = init(T, 3)
  same(f.pow(3), naiveMul(naiveMul(f, f, 7, 11), f, 7, 11))

block compositeModuli:
  type CB = StaticBarrettModint[15u32]
  type CM = StaticMontgomeryModint[15u32]
  checkComposite[CB]()
  checkComposite[CM]()
  modint_barrett.setMod(15)
  modint_montgomery.setMod(15)
  checkComposite[modint_barrett]()
  checkComposite[modint_montgomery]()

proc checkCharacteristic[T: BarrettModint or MontgomeryModint]() =
  let p = T.umod.int
  var f = randomFPS[T](p, p)
  f[0][0] = init(T, 1)
  same(f.log.exp, f)
  same(f.log.transpose, f.transpose.log)
  var power = initBivariateFPS[T](p, p)
  power[0][0] = init(T, 1)
  for k in 0..p + 1:
    same(f.pow(k), power)
    power = naiveMul(power, f, p, p)
  f[0][0] = init(T, 0)
  same(f.exp.log, f)
  same(f.exp.transpose, f.transpose.exp)

block characteristicBoundary:
  checkCharacteristic[StaticBarrettModint[2u32]]()
  checkCharacteristic[StaticBarrettModint[3u32]]()
  checkCharacteristic[StaticBarrettModint[5u32]]()
  type M = StaticBarrettModint[5u32]
  let nonsquare: BivariateFPS[M] = @[@[init(M, 2)]]
  doAssert nonsquare.sqrtUnit(3, 4).isNone
  let longUnit: BivariateFPS[M] = @[@[init(M, 1), init(M, 1)], @[init(M, 2)]]
  same(longUnit.pow(7, 8, 9), naiveMul(longUnit.pow(3, 8, 9), longUnit.pow(4, 8, 9), 8, 9))
  let square = naiveMul(longUnit, longUnit, 8, 9)
  doAssert square.sqrtUnit.isSome
  same(naiveMul(square.sqrtUnit.get, square.sqrtUnit.get, 8, 9), square)

when compileOption("assertions"):
  template rejects(body: untyped) =
    block:
      var rejected = false
      try: body
      except AssertionDefect: rejected = true
      doAssert rejected
  type M = modint998244353_barrett
  let zero = initBivariateFPS[M](2, 3)
  rejects: discard zero.inv
  rejects: discard zero.log
  rejects: discard zero.sqrtUnit
  rejects: discard zero.pow(-1)
  let one: BivariateFPS[M] = @[@[M(1)]]
  rejects: discard one.exp
  type C = StaticBarrettModint[15u32]
  let nonunit: BivariateFPS[C] = @[@[init(C, 3)]]
  rejects: discard nonunit.inv
  rejects: discard nonunit / init(C, 3)
  let unit: BivariateFPS[C] = @[@[init(C, 1)]]
  rejects: discard unit.log
  rejects: discard unit.integralX
  type S = StaticBarrettModint[3u32]
  let small: BivariateFPS[S] = @[@[init(S, 1)]]
  rejects: discard small.log(4, 1)
  rejects: discard small.prefix(1, 3).integralY

echo "Hello World"
