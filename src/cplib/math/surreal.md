# 有限超現実数（dyadic rational）

`import cplib/math/surreal`。有限の日数で生成される超現実数（short number）を
`numerator / 2^denominatorExponent` として厳密に扱います。分子は既存の
`cplib/math/bigint` の `BigInt`、分母指数は非負の `int` です。
実数として有限な超現実数すべてを表すという意味ではありません。
1/3 等の非 dyadic 有理数、無理数、ω、無限小、無限集合の cut、一般のゲームは扱いません。
浮動小数点へ変換せず、比較・加減算・符号判定を行います。

## API

```nim
import cplib/math/surreal
import cplib/math/bigint # 大きな分子を使う場合に明示 import

let a = initSurreal(-12, 4) # -12/16 = -3/4
assert $a == "-3/2^2"
assert a.numerator == initBigInt(-3)
assert a.denominatorExponent == 2
assert a + initSurreal(1) == initSurreal(1, 2)
assert a.sgn == -1
let huge = initSurreal(parseBigInt("123456789012345678901234567890"))
assert huge > initSurreal(high(int))

let zero = surrealCut([], [])
let one = surrealCut([zero], [])
let half = surrealCut([zero], [one])
assert half == initSurreal(1, 1)
assert surrealCut([initSurreal(1)], [initSurreal(2)]) == initSurreal(3, 1)
assert surrealCut([initSurreal(-2)], [initSurreal(-1)]) == initSurreal(-3, 1)
```

`initSurreal(numerator, denominatorExponent=0)` は BigInt と組み込み整数型に対応します。
分子を奇数まで約分し（指数0の整数を除く）、0 は必ず分子0・指数0にします。
default(Surreal) も0です。内部フィールドは非公開で、取得値・代入した値の操作から
元の正規化表現は壊せません。組み込み整数からの暗黙 converter はありません。
`numerator`、`denominatorExponent`、`isZero`、`sgn`、`abs`、単項 `+` / `-`、
`cmp`、`==` / `<` / `<=` / `>` / `>=`、二項 `+` / `-`、`+=` / `-=` を提供します。
`$` は整数なら十進分子、それ以外は `-3/2^2` のような正確な表記です。
分母自体を取得したければ `initBigInt(1) shl x.denominatorExponent` で作れますが、
大きな指数では巨大なメモリが必要です。乗除算・parser・浮動近似は提供しません。

`surrealCut(left, right: openArray[Surreal])` は、すべての左要素より厳密に大きく、
すべての右要素より厳密に小さい数のうち、誕生日が最小のものを返します。
入力の順序・重複は無関係で、入力は変更しません。空の側は制約なしです。
両側空なら0、片側空でも単なる端点±1とは限りません。
例えば `{ -1/2 | } = 0`、`{ 1/2 | } = 1`、`{ | -1/2 } = -1` です。
左最大値 >= 右最小値は `ValueError`、負の分母指数も `ValueError` です。
結果に `high(int)` を超える指数が必要な cut は `OverflowDefect` です。
これらは release / assertions off / danger でも検査します。

## ゲーム値としての使い方

有限・非循環の二人零和 normal-play ゲームで、各左手の子局面・右手の子局面が
すでに数であり、全左値 < 全右値が成り立つ局面には `surrealCut` を適用できます。
終端の値は0で、子から親へ評価します。独立したゲームの和は値の加算、
左右を入れ替えたゲームは符号反転です。

```nim
let zero = surrealCut([], [])
let one = surrealCut([zero], [])
let half = surrealCut([zero], [one])
let quarter = surrealCut([zero], [half])
let sum = one - half - quarter
assert sum.sgn == 1
```

数のゲームは、正なら Left、負なら Right が先手・後手によらず勝ち、0なら後手勝ちです。
これは normal-play・数のゲームという前提のもとでの判定です。
`{0 | 0}`（star）等は数ではなく `ValueError` になります。
一般の short game がすべて dyadic rational になるわけではなく、本 API は
数でない子を扱ったり、ゲーム木そのものを解析・memoize したりはしません。

## 正当性と計算量

Conway の simplicity theorem は、cut を「左右の間の最も古い数」として一意に定めます。
一次資料として [Rubinstein-Salzedo / Swaminathan, Analysis on Surreal Numbers,
§2.1 Definition 2・Theorem 4・有限日の構成](https://arxiv.org/html/1307.7392v3#S2.SS1)
を確認しました。同論文は Conway, *On Numbers and Games* の定理を明示しています。
外部のライブラリコードは参照・コピーしていません。

有限集合では左最大値 L と右最小値 R だけが制約を決めます。
0が間にあれば最初の日の数0が答えです。負の区間は左右を入れ替えて符号反転し、
0以上の L を持つ区間にします。整数 `floor(L)+1` が入れば、それが最も0に近い整数です。
整数が入らない場合、区間は同じ隣接整数間にあります。この中では分母指数が
小さいほど誕生日が早く、最小指数の格子点は一意です。
指数 e の候補を `(floor(L * 2^e)+1) / 2^e` とし、候補 < R の最初の e を二分探索します。
格子は入れ子なので存在判定は単調です。端点の最大指数 E の格子が入らない場合も
E+1 には中点が入るため、探索上限は E+1 です。

比較では分母を巨大整数として作らず、細かい格子側の分子を算術右シフトして比較します。
床値と粗い側の分子が等しいとき、正規化された細かい側の分子は奇数なので
必ず正の剰余があり、大小が確定します。負値でも床除算なので同じ理由が成立します。
加減算は共通分母へシフトしてから BigInt の演算を使います。
約分は割り切れる2冪の最大指数を二分探索し、machine int の分子は使いません。

以下で B はその操作の**最大中間 BigInt のビット長**（最低1）、E は最大の分母指数、
K は左右の要素数の合計です。既存 BigInt の十進↔二進変換付きシフトは保守的に
時間 O(B²)、領域 O(B) と評価します。

| 操作 | 時間の保守的上限 | 補助領域 |
| --- | --- | --- |
| 構築・約分 | O(B² log(E+2)) | O(B) |
| 比較 cmp・順序 | O(B²) | O(B) |
| 表現の等値比較 | O(B) | O(1) |
| 加減算 | O(B² log(E+2)) | O(B) |
| cut | O(K B² + B² log²(E+2)) | O(B) |
| 指数取得・符号・0判定 | O(1) | O(1) |

cut の候補構築に約分も含めた保守的上限です。単なる machine int の O(1) 演算ではありません。
分子に固定ビット幅の上限はなく、指数は `0..high(int)` ですが、メモリ・実行時間の制約があります。
特に異なる指数の加算で共通分母へ揃えると B が入力分子より指数差だけ大きくなり得ます。
`1 + 1/2^high(int)` 等を実体化できるという保証はしません。
必要な配列長・文字列長が int に収まり、メモリ確保と BigInt 演算が実行できることが前提です。
比較・0・同じ指数同士の演算など、巨大指数でも分母を作らない操作は可能です。
Linux x86_64 / GCC の Nim 1.6.20 / 2.2.4 C++ backend で検証します。
JS・32bit・他コンパイラは未検証で、依存 BigInt / convolution の backend 制約に従います。

## 検証の再現

新規テストは `src/verify/math/surreal_test.nim` のみです。
整数格子による算術 oracle と、0から日ごとに端点±1・隣接数の中点を作る
独立した誕生日順の cut oracle を含みます。多倍長分子、2冪境界、最大 int 指数、
不正入力、入力保持・値コピー、ゲーム値の例も検査します。

```sh
nim cpp -r --path:src --nimcache:/tmp/surreal-debug-cache -o:/tmp/surreal-debug src/verify/math/surreal_test.nim
nim cpp -r --path:src -d:release --assertions:off --nimcache:/tmp/surreal-release-cache -o:/tmp/surreal-release src/verify/math/surreal_test.nim
nim cpp -r --path:src -d:danger --nimcache:/tmp/surreal-danger-cache -o:/tmp/surreal-danger src/verify/math/surreal_test.nim
```

同じコマンドを両 Nim 版で実行します。既存関連回帰は
`src/verify/math/{bigint_unit,bigint_parse_unit,bigint_bitops_unit}_test.nim`、
expander の既存回帰は `src/verify/tools/expander_test.nim` です。
専用 CI や tools のテスト・helper・log・benchmark は追加しません。
