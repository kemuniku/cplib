# 素因数指数で持つ整数

`cplib/math/factorized_int` の `FactorizedInt` は、符号と昇順の `(素数, 指数)` の列で整数を保持します。指数は `int` の非負範囲、素数は `2..high(int)` です。内部には正指数だけを残し、0 は符号0・空列、±1は符号±1・空列とします。フィールドは非公開で、不変条件を保持します。既定初期化は0です。

```nim
import cplib/math/factorized_int

let a = initFactorizedInt(@[(2, 100), (3, 7)], -1)
let b = initFactorizedInt(12)
assert (a * b).primeFactors == @[(2, 102), (3, 8)]
assert gcd(a, b).toInt == 12
assert (a div b).primeFactors == @[(2, 98), (3, 6)]
assert a.pow(0).toInt == 1
```

## APIと契約

- `initFactorizedInt(x: int)` は既存 `primefactor_tuple` で絶対値を分解します。`low(int)` は絶対値を符号付き型に作らず、`-2^(sizeof(int)*8-1)` として構築します。
- `initFactorizedInt(factors: openArray[(int,int)], sign=1)` は各素数と非負指数を検査し、指数0を除き、並べ替えて重複素数の指数を加算します。合成数は指数0でも拒否します。符号は-1/0/1のみ。符号0に正指数を与えると失敗します。入力・返り値の指数列を共有して改変する API はありません。
- `sgn`、`isZero`、`primeFactors`（独立したコピー）、単項 `-`、`abs` を提供します。
- `*` は指数の和、`gcd` は指数の最小値、`lcm` は最大値です。gcd/lcmは非負。`gcd(0,0)=0`、`gcd(a,0)=abs(a)`、`lcm(a,0)=0`。
- `div` は完全除算だけです。各素数で被除数の指数が除数以上の場合に限り指数を引きます。符号は積と同じ規則。`0 div 非零=0`、除数0は常に失敗します。切り捨て除算・有理数・負指数は提供しません。
- `pow(exponent: int)` は非負整数乗です。`0^0=1`、`0^正数=0`。負数の偶数乗は正、奇数乗は負です。負指数は基数が0や±1でも拒否します。
- 不正な入力・0除算・不完全除算・負指数は `ValueError`。指数の加算・乗算と `toInt` の範囲超過は `OverflowDefect`。すべて明示検査し、release / assertions off / dangerでも有効です。途中で失敗しても入力は変更しません。
- `==` は正規化した表現を比較します。`cmp` / `<` / `<=` / `>` / `>=` は厳密な大小比較です。符号相違と等値は実整数化せず処理し、それ以外は `toBigInt` で比較します。対数や浮動小数点による近似比較は使いません。
- `toInt` は範囲を検査しながら繰り返し二乗法で変換します。`toBigInt` は既存 `BigInt` に実整数化し、`$` はその10進文字列を返します。任意のBigIntからの素因数分解は提供しません。

加減算は素因数指数から高速に計算できないため、この API には含めません。加減算が必要なら `toBigInt` を使い、通常の多倍長整数として処理してください。その結果を元の表現へ戻すための一般的な高速分解は保証しません。

## 正当性・計算量・限界

素因数分解の一意性から、正整数の積では同じ素数の指数を加算し、完全除算では減算、gcdでは最小値、lcmでは最大値を取れます。素数昇順の列を2本の添字で走査するので、片方にだけある素数の指数0も含め、各素数を一度ずつ処理します。0と符号は別途扱います。

`k,l` は入力の相異なる素因数数、`e` は各指数、`D` は実整数の桁数、`M(D)` は既存BigIntのD桁乗算の時間、`W(D)` はその作業領域です。

| API | 時間 | 追加領域（返り値を含む） |
| --- | --- | --- |
| 素数指数から構築 | O(k log k) + k回の既存isprime判定 | O(k) |
| intから構築 | 既存primefactorの分解時間（確率的Pollard rho、最悪時間保証なし） | 出力・既存分解の作業領域 |
| sgn / isZero | O(1) | O(1) |
| primeFactors / 単項- / abs | O(k) | O(k) |
| == | O(k+l)上界 | O(1) |
| * / div / gcd / lcm | O(k+l) | O(k+l) |
| pow | O(k)、指数0/基数0はO(1) | O(k) |
| toInt | O(k + Σ log(e+1))上界、範囲超過時は早期終了 | O(1) |
| toBigInt | O(M(D) (k + Σ log(e+1)))上界 | O(D + W(D)) |
| cmp / < / <= | 符号相違O(1)、等値O(k+l)、その他は両辺の実整数化 + O(D) | O(D + W(D)) |
| $ | toBigInt + O(D) | O(D + W(D)) |

`D = Θ(1 + Σ e log(p))` です。既存BigIntは適用範囲内のC++/amd64でNTTを用い、その他では筆算を使います。`M(D)` を常に O(D log D) と仮定しません。素数判定・分解には既存ライブラリのC++ / Int128依存も引き継ぎます。Linux x86_64 / GCC / C++ backend の Nim 1.6.20 と 2.2.4 で検証し、32bit・JS・VM・MSVCでの実行は未検証です。

例えば `2^high(int)` の指数表現と乗除・gcd/lcm・等値は小さく保持できますが、実整数化には現実的でない桁数のメモリが必要です。同符号の異なる巨大値の大小比較や10進表示も同じ制約があります。実整数化前のサイズ上限やメモリ失敗の回復 API は提供しません。必要な資源を確保できる値だけを変換してください。指数の範囲超過は自動的にBigInt指数へ拡張せず失敗します。

## 検証の再現

repo rootで対応するNimとNim-ACLを利用します。新設テストは `src/verify/math/factorized_int_test.nim` だけです。コンパイル時にPython 3の任意精度整数・math.gcd/lcmを使い、小整数の全組合せと固定seedの素数指数列から独立した期待値を生成します。検証専用helperや独立CIは追加しません。

```sh
nim cpp --hints:off --path:src -r src/verify/math/factorized_int_test.nim
nim cpp --hints:off --path:src -d:release --assertions:off -r src/verify/math/factorized_int_test.nim
nim cpp --hints:off --path:src -d:danger -r src/verify/math/factorized_int_test.nim
```
