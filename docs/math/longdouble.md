# long double

`import cplib/math/longdouble` で C/C++ の `long double` を保持・演算する `LongDouble` を使えます。既存の `float128` / `Int128` と同じく、数値からの converter、四則演算、複合代入、比較、`to_float` / `to_int` を提供します。C バックエンドにも対応しています。

```nim
import cplib/math/longdouble

let info = longDoubleInfo()
echo info
let x = parseLongDouble("1.0000000000000000001")
let y: LongDouble = 2
let z = sqrt(x + y)
echo z                         # long doubleのまま整形
let n = to_integer(x, int64)    # 0方向に丸め、範囲を検査
let f = z.to_float             # ここで初めてdoubleに丸める
var total: LongDouble = 0
total += x
echo formatLongDouble(total, 10)
```

```sh
nim c --path:src example.nim
nim cpp --path:src example.nim
```

小数リテラルを `LongDouble` に代入しても、Nim が既に double に丸めた値からの変換です。十進の精度が必要な入力には `parseLongDouble("...")` を使ってください。整数は整数のまま直接変換しますが、利用環境の仮数精度を超える整数は丸められます。

## 型と利用環境

型は `{.importc: "long double", nodecl, bycopy.} = object` です。Nim が通常の浮動小数点数として演算・定数畳み込みすることを避け、実際の生成 C/C++ 型にサイズ、アラインメント、配列ストライド、引数と返値の ABI を委ねます。演算の C/C++ 式も `long double` 同士です。バイト配列による偽装、固定の `size` pragma、`float64` による中間計算はありません。

Nim 1.6.20 と 2.2.4 の `clongdouble` は `BiggestFloat` の別名です。この環境では `sizeof(clongdouble)` が Nim 側で8となる一方、生成された `long double` 引数は16バイトで、加算結果は `NF` (double) となりました。したがってこのモジュールの型に `clongdouble` は使いません。

`longDoubleInfo()` の値は実行時に C/C++ の `sizeof(long double)` と `<float.h>` から取得します。

| フィールド | 由来・意味 |
| --- | --- |
| `size` | `sizeof(long double)`、保存サイズ（バイト） |
| `radix` | `FLT_RADIX`、仮数の基数 |
| `mantissaDigits` | `LDBL_MANT_DIG`、基数 `radix` での仮数桁数 |
| `digits` | `LDBL_DIG`、十進→型→十進の保存に使える十進桁数 |
| `decimalDigits` | `DECIMAL_DIG`、型→十進→型に十分な十進有効桁数 |
| `minExponent`, `maxExponent` | `LDBL_MIN_EXP`, `LDBL_MAX_EXP` |

`DECIMAL_DIG` は C 実装の最も広い浮動小数点型を往復するための値なので、`LDBL_DECIMAL_DIG` のない C99/C++14 ヘッダーでも使えます。long double 単体に必要な桁数より多い場合があります。

`epsilonLongDouble()` は `LDBL_EPSILON`、`minPositiveLongDouble()` は `LDBL_MIN`（正の最小**正規化**値）、`maxLongDouble()` は `LDBL_MAX` です。最小非正規化値は、対応環境で `nextAfter(to_longdouble(0), to_longdouble(1))` から取得できます。

保存サイズ16バイトでも128ビット精度とは限りません。仮数53、64、113ビットなど環境ごとの差があります。80ビットの拡張精度や float128 相当の精度を一律には保証しません。

この実装は実行時の C/C++ FFI 用です。Nim VM、`static` での演算・parse・format、コンパイル時の型サイズを必要とする用途、JavaScript バックエンドは対応外です。ユーザー側で `LongDouble` のレイアウトやサイズを固定しないでください。

## 演算・比較・数学関数

- `+ - * /`、単項 `-`、`+= -= *= /=` は native long double 演算です。IEEE 対応環境では overflow、underflow、0除算、NaN/Inf の伝播は C/C++ の規則に従います。Nim の float64 用演算を経由しません。
- `== != < <= > >=` は C の部分順序です。NaN を含む `== < <= > >=` は偽、`!=` は真です。`+0 == -0` は真です。
- `cmp` は -1 / 0 / 1 を返します。NaN を含む場合は `ValueError` を発生させます。NaN を任意の大小関係に置く total order ではありません。
- `abs` は `fabsl` で、`abs(-0)` は `+0` です。`isNaN`, `isInf`, `signbit` を利用でき、`signbit(-0)` は真です。NaN の payload、NaN の符号、signaling NaN の保存は保証しません。
- 数学関数はすべて `<math.h>` の `l` 接尾辞付き関数を直接呼びます。`sqrt`, `cbrt`, `exp`, `exp2`, `expm1`, `ln`, `ln1p`, `log2`, `log10`, `sin`, `cos`, `tan`, `arcsin`, `arccos`, `arctan`, `arctan2`, `pow`, `hypot`, `fmod`, `copySign`, `nextAfter`, `fma`, `floor`, `ceil`, `trunc`, `round` を提供します。
- `floor` は負の無限大、`ceil` は正の無限大、`trunc` は0方向です。`round` は最も近い整数、中間は0から遠い側へ丸めます。これらの返値も `LongDouble` です。`fma` は積和を一度の丸めで計算します。

数学関数の domain / pole / range エラーは libc/libm の返値と浮動小数点環境に従い、Nim の例外には変換しません。通常の IEEE 環境では `sqrt(-1)` は NaN、正数/0 は Inf です。正しい丸めを全数学関数で独自に保証するものではありません。`errno` / 浮動小数点例外の取得 API は提供しません。

演算と text 変換は native の丸めモードに従います。標準の round-to-nearest と C locale で text 往復を検証しています。`-ffast-math` 等で NaN、符号付き0、丸め規則を変更する設定は保証対象外です。

## 数値変換

`to_longdouble(SomeInteger/SomeFloat)` は converter です。float 入力の NaN、Inf、符号付き0は IEEE 対応環境で保持します。

`to_float(x)` は明示的に double へ丸めます。有限値の絶対値が `DBL_MAX` を超えると符号付き Inf を返します（丸めモードにかかわらず、この API で決めた挙動です）。表現範囲内の丸め、underflow、NaN/Inf の変換は native double キャストに従います。double への変換による情報損失は意図されたものです。

`to_integer(x, T)` は Nim の組み込み整数型 `int8/16/32/64/int` と `uint8/16/32/64/uint` に対応します。`truncl` で0方向に丸めた結果を検査し、NaN、Inf、範囲外の場合には明示的に `RangeDefect` を発生させます。チェックを無効にしても不正な C の整数キャストは実行しません。`to_int` は `to_integer(x, int)` と同じです。

検査は整数最大値を不正確な long double に変換して比較する方式ではなく、signed の最小値と上側の排他的境界、unsigned の `2^bits` による境界を使います。たとえば64ビット signed では `[-2^63, 2^63)`、unsigned では `[0, 2^64)` です。`-0.9` を unsigned へ変換すると、切り捨て後の値が0なので0です。精度の低い環境では text parse 時に境界外の値が境界値へ丸められうるため、検査の対象は元の文字列ではなく保持された値です。

既存 `Int128` は別の imported object で、このモジュールからの128ビット整数 converter は提供しません。必要なら十進文字列を経由し、環境の精度による丸めを考慮してください。

## 文字列・入出力

`parseLongDouble(s)` は double の parser を経由せず、`strtold` へ直接渡します。十進、C の16進浮動小数点表現、`inf/infinity/nan`（libc の対応する payload 表記を含む）を受け付けます。前後の空白を許し、空文字列、数値のない文字列、末尾の余分な文字、埋め込み NUL は `ValueError` です。

parse の overflow / underflow は `strtold` の値をそのまま返し、範囲エラーを例外にはしません。この検証環境では巨大な指数は符号付き Inf、十分小さい指数は符号付き0となりました。実装や丸めモードによって境界の結果は変わります。

`formatLongDouble(x, precision = 0)` は `%.*Lg` を使い、`0` の場合は `DECIMAL_DIG` 桁、正の場合は指定した十進有効桁数で出力します。負の precision や `cint` の範囲外は `ValueError` です。短い `%g` の形式なので末尾の0は省略され、必要なら指数表記になります。`$x` はデフォルト整形です。`snprintf` で必要長を求め、呼び出しごとの Nim string に書き込むため、固定長の共有バッファは使いません。`long double` を variadic 引数として渡し、`L` 指定子との ABI を合わせています。

locale は libc の現在の `LC_NUMERIC` に従い、このモジュールから変更しません。同じ locale と標準の丸めで、有限値と符号付き0の parse / format 往復を検証しています。最短表記、NaN payload の往復は保証しません。locale や丸め環境を他のスレッドで同時に変更する使い方は保証しません。

`read_and_parse_longdouble()` は標準入力から空白区切りの token を読み、`parseLongDouble` へ渡します。値のない EOF では `EOFError`、不正 token では `ValueError` です。`put(x)` は `$x` と改行を標準出力へ出力します。`scanf` に double のポインタを渡す方法は使いません。

## 検証と一次資料

回帰は `src/verify/AI/longdouble_test.nim` と
`src/verify/AI/longdouble_contract_test.nim` に集約しています。
contract verifyはNimラッパーを使わないnativeの演算・変換・ABI参照を
ファイル内のemitで定義し、精度、整数境界、丸めモード、入出力を照合します。
既存のverify CIがNim 1.6.20 / 2.2.4のC++ backendで実行します。

```sh
nim cpp --path:src --nimcache:/tmp/longdouble-debug-cache -o:/tmp/longdouble-debug -r src/verify/AI/longdouble_contract_test.nim
nim cpp --path:src -d:release --nimcache:/tmp/longdouble-release-cache -o:/tmp/longdouble-release -r src/verify/AI/longdouble_contract_test.nim
```

C backendを確認する場合は `cpp` を `c` に置き換えて実行できます。
異なるOS・コンパイラ・long double ABIでの対応範囲は、実環境の
`longDoubleInfo()` と上記verifyで確認してください。
