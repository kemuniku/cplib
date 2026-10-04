# modint64

`cplib/modint/modint64` は、`2 <= p < 2^64` の素数を法にするstatic modintです。
最大の64bit素数 `18446744073709551557`、`2^63` 以上、法2を扱えます。
既存の32bit modintとは独立したモジュールです。dynamic型、`setMod`、float変換は追加していません。

```nim
import cplib/modint/modint64
import cplib/math/combination

declarStaticModint64(Mint, 18446744073709551557u64)
let a = Mint.init(low(int64))
let b = Mint.init(high(uint64))
echo a.val                 # 9223372036854775749
echo b                    # 58
echo (Mint.init(-1) + Mint.init(-1)).val  # 18446744073709551555
echo (a / b * b) == a      # true
echo Mint.init(2).pow(64u64)
let c = Mint.parseModint64("-123456789012345678901234567890")
echo c
let combinations = initCombination[Mint](100)
echo combinations.ncr(10, 3)  # 120
```

## APIと契約

- `StaticModint64[M: static[uint64]]` が本体です。`Modint64` はこの型に一致するconcept（型制約）です。
  `type Mint = StaticModint64[17u64]` と直接定義する場合は `Mint.init(1)` を使います。
- `declarStaticModint64(Mint, 17u64)` は既存の `declarStatic…Modint` の命名に合わせたマクロです。
  型と `int` のconverterを宣言します。`var x: Mint = 1` や既存 `initCombination[Mint]` の利用にはこのマクロが便利です。
  unsigned型を含む全整数型は `Mint.init(x)` で変換できます。converterを全整数型へ拡張すると、
  Nim 1.6の `$uint` 等で整数がmodintへ暗黙変換されることを確認したため、既存Barrettと同じ `int` に限定しています。
- `Mint.init(SomeInteger)`、`Mint.init(Mint)`、`Mint.init(string)`、`Mint.parseModint64(string)`。
  符号付きの最小値、`high(uint64)` も正規化できます。文字列の形式は `[+-]?[0-9]+`、桁数に上限はありません。
  空文字、符号のみ、空白、区切り文字、非ASCII数字等は `ValueError` です。
- `val`、`umod`、`mod`、`get_M` は `uint64` を返します。既存32bit版の `mod`/`val` と戻り値の型が異なります。
  `int` への変換は `high(int)` 以下であると分かる場合だけ行ってください。
- `+ - * /`、`+= -= *= /=`、単項 `-`。二項演算は同じ法の値どうしと、左右いずれかの整数に対応します。
  異なる法の型の混在には対応しません。
- `pow(SomeInteger)` は非負の指数を扱い、`high(uint64)` も利用できます。`0^0 = 1`。負の指数は `ValueError`。
- `inv` は素数法でFermatの小定理を使います。`inv(0)`、0での除算は常に `ValueError`。
  `-d:danger` や `--assertions:off` でもこの検査は消えません。
- `==`、`hash`、`$` に対応します。`$` は `[0,p)` の十進文字列です。
  `const inverse = Mint.init(2).inv` のようなコンパイル時計算もできます。
- 法は決定的Miller–Rabin（64bit用の7基底）でコンパイル時に検査します。
  マクロは宣言時、直接定義した型は `init`/`val`/算術/法取得等のAPIを具体化した時に検査します。
  0、1、合成数はコンパイルエラーです。使われない直接定義の型名だけには検査が走りません。
  64bitを超える法は型引数の範囲外です。
- 内部値は非公開で常に `[0,p)`。default初期化値は0です。法は型の一部なので実行中に変わりません。
  dynamic型の法変更後に古い値を使う契約は今回不要です。

`combination.nim` の逆元漸化式のみ、`umod` の型が `uint64` の場合にunsignedで商・余りを求めるようにしました。
既存の32bit型は従来の計算経路を使います。`initCombination` の利用範囲は従来どおり `0 <= max_N < p` です。

## 数値処理とbackend

加算はuint64の和 `s` のcarryを `s < a` で検出し、carryまたは `s >= p` なら `s - p` にします。
正規化値の和は `2p` 未満なので減算は1回だけで十分です。carryがあったときの減算のwrapも意図した処理です。
減算は大小比較でborrowを処理します。signed最小値の絶対値は `0u64 - cast[uint64](x.int64)` で求めます。
Nimのunsigned演算のwrapは仕様上の動作であり、signed overflowを利用していません。

乗算は `(unsigned __int128)a * b % p`。積は最大でも `(2^64-1)^2 < 2^128` です。
Montgomery表現を使わないため `p < 2^63` や奇数の暗黙制約はありません。
Nim VMでの乗算だけ二進法の加算に切り替えます。実行時の加減乗算は固定幅のO(1)、
累乗・逆元・除算はO(log指数)/O(log p)回の乗算、parse/formatはO(桁数)です。

C/C++の生成されたNim関数本体に乗算式をemitします。128bit型をNimのobjectとしてimportせず、
128bit値がFFI境界を通ることもありません。入出力はNim `uint64` の生成型 `NU64` なので、
Cの `unsigned long` と `unsigned long long` のtypedef差に依存したポインタABIは使いません。
複数translation unit、サイズ8byte・uint64と同じalignmentも検証しています。C ABIへの型の公開は保証しません。

`unsigned __int128` を提供するC/C++コンパイラが必要です。非C/C++ backendと
`__SIZEOF_INT128__` がないコンパイラはエラーにします。確認済み環境はLinux amd64、GCC/G++ 14.2.0、
Nim 1.6.20/2.2.4のみです。Windows/MSVC、Clang、32bit、JSには新規保証をしていません。

参考: [Nim unsigned整数の仕様](https://nim-lang.org/docs/manual.html#types-unsigned-integers)、
[GCC unsigned __int128](https://gcc.gnu.org/onlinedocs/gcc/_005f_005fint128.html)、
[64bit Miller–Rabin基底表](https://miller-rabin.appspot.com/)。Nimの仕様はローカルの両バージョンのmanualでも確認しました。

## verify

回帰は `src/verify/modint` のverifyファイルだけに置いています。
すべて既存 `verification-helper: PROBLEM` のHello World問題に対応し、
既存の `verify.yml` が実行する `oj-verify run` で検出されます。専用CIや外部runnerはありません。

- `modint64_test.nim`: 整数型・例外・hash/set/table・generic combination・サイズ/alignment。
- `modint64_oracle_test.nim`: Python多倍長整数で事前に求めた1,617ケースを埋め込み、
  10素数の全境界ペアと各32乱数ペアで加減乗除・pow・inv・入出力を検査します。
  実行時にPythonや外部入力・期待値ファイルを使いません。
- `modint64_compiletime_test.nim`: コンパイル時演算471比較と素数判定2,115値をVM/nativeで確認。
  不正法のコンパイル拒否も `compiles` でverify内から確認します。
- `modint64_existing_test.nim`: 既存Montgomery/Barrettの2法と各10,000乱数ペアを比較し、
  max_N=200のbinomialも照合します。既存型がC++専用なのでこのverifyもC++向けです。

ローカルで個別に確認する場合も、同じverifyファイルをコンパイル・実行します。

```sh
nim cpp -r -d:release --path:src src/verify/modint/modint64_test.nim
nim cpp -r -d:release --path:src src/verify/modint/modint64_oracle_test.nim
nim cpp -r -d:release --path:src src/verify/modint/modint64_compiletime_test.nim
nim cpp -r -d:release --path:src src/verify/modint/modint64_existing_test.nim
```

確認済み環境と以前の性能測定値は `VALIDATION.md` に記録しています。
