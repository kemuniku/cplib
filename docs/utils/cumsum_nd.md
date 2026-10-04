# 静的多次元累積和

`cplib/utils/cumsum_nd` は小さい固定次元の密な配列に対する累積和です。
`CumSumND[T, D]` の `D` はコンパイル時定数で、
`1 <= D < sizeof(int) * 8 - 1` を要求します。
問い合わせは次元に対して指数的なので、実用上は数次元程度を想定します。
動的更新・疎な座標・実行時に変わる次元は扱いません。

```nim
import cplib/utils/cumsum_nd

let sums = initCumSumND([2, 3], [1, 2, 3, 4, 5, 6])
assert sums.shape == [2, 3]
assert sums.query([0, 0], [2, 3]) == 21
assert sums.query([1, 1], [2, 3]) == 11
let cube = initCumSumND[int64, 3]([1, 2, 2], [1'i64, -2, 3, 4])
assert cube.query([0, 0, 0], [1, 2, 2]) == 6
```

## APIと入力形式

- `initCumSumND[T, D](shape: array[D, int], values: openArray[T], zero = default(T))`
  は入力をコピーして構築します。各軸の長さは非負で、値の個数は
  `N = Π shape[i]` です。末尾軸が最速で、2Dなら行順、
  3Dなら `(i * shape[1] + j) * shape[2] + k` の順です。
- `shape` は各軸の長さを値で返します。
- `query(lower, upper: array[D, int]): T` は各軸の半開区間
  `[lower[i], upper[i])` の直積に入る要素を合計します。
  全軸で `0 <= lower[i] <= upper[i] <= shape[i]` を要求します。
- 一つでも幅0の区間があれば `zero` を返します。
  shapeに0の軸がある場合、入力は空で、すべての有効なqueryは `zero` です。
  その場合もほかの軸の境界を検査します。

内部配列は非公開で、更新APIや可変参照はありません。入力の変更や取得したshapeの
変更は累積和に影響しません。`CumSumND` は値型です。
`default(CumSumND[T, D])` は未初期化であり、queryは拒否します。

負の軸、軸長+1のoverflow、shape積・バイト数のoverflow、値の個数の不一致、
不正区間、未初期化queryは `ValueError` です。これらはassertに依存せず
release/dangerでも検査します。0の軸があってもpaddingの積は検査・確保します。
表現可能なサイズでも実メモリが不足する構築は保証しません。

## 型の条件

`T` は値型で、二項の `+` と `-` を持ち、加法が可換群の法則に従う必要があります。
単位元は既定では `default(T)` です。それが加法の単位元でない独自型は
明示的に `zero` を渡します。`+=`、単項マイナス、整数からの変換、乗算は不要です。
加減算・代入をO(1)とする型を想定します。
整数では構築・包除原理の**全中間値**が型の範囲内である必要があります。
最終的な総和だけが表現可能でも十分とは限りません。
ModIntは同じ法の加法群として使えますが、dynamic型の法は構築後に変えてはいけません。
浮動小数点では丸め誤差があり、直接総和との厳密一致や誤差上限は保証しません。

## 根拠と計算量

各軸に0境界を一つ加えた配列を、末尾軸が最速の一次元配列で保存します。
入力の座標 `x` はpadding座標 `x + 1` に置き、境界は `zero` です。
軸を一つずつ走査して、その軸の直前の値を加えます。
処理した軸ではprefix、未処理の軸では一点を表す、という不変条件を保つので、
最後の配列 `B[u]` は全軸の `[0, u[i])` の総和です。

queryでは各軸の上限/下限を選ぶ `2^D` 個の角を読み、
下限を選んだ軸数が偶数なら加算、奇数なら減算します。
各軸の `[0, upper) - [0, lower)` の積を展開する包除原理により、
求める直積の総和になります。

`P = Π(shape[i] + 1)` として、構築は `O(DP)`、保存領域は `O(P + D)`、
queryは添字を毎回D軸から計算するため `O(D 2^D)`、追加領域は `O(1)` です。
shape取得は `O(D)` です。構築の加算回数は正確に
`Σ_i P * shape[i] / (shape[i] + 1)`、非空queryは正確に `2^D` 回の加減算です。
6軸がすべて長さ10なら、入力1,000,000要素に対してpaddingは1,771,561要素です。
int64では内部配列だけで約13.5 MiBを使い、入力の領域は別途必要です。

## 検証の再現

Nim 1.6.20 / 2.2.4、Linux x86_64、C++ backendを対象に、
`src/verify/utils/cumsum_nd_test.nim` 内で検査します。

```sh
nim cpp -r --path:src --nimcache:/tmp/cumsum-nd-cache -o:/tmp/cumsum-nd src/verify/utils/cumsum_nd_test.nim
nim cpp -r -d:release --assertions:off --path:src --nimcache:/tmp/cumsum-nd-release-cache -o:/tmp/cumsum-nd-release src/verify/utils/cumsum_nd_test.nim
nim cpp -r -d:danger --path:src --nimcache:/tmp/cumsum-nd-danger-cache -o:/tmp/cumsum-nd-danger src/verify/utils/cumsum_nd_test.nim
```

独立oracleはpaddingやprefixを使わず、各入力要素の座標を割り算で復元して
区間内の値を直接合計します。1〜3Dの小shape、4/5/6/8Dの全区間、
固定seedの4/6D、長さ100,000の1Dを比較します。
独立oracleとの比較は合計197,946区間です。
空軸の位置、全域・一点・空区間、負値、int64上下限付近、int8/float64、
静的/動的Montgomery・Barrett、独自Pair型、既定値が単位元でない型、
入力保持、shape保持、不正入力、積overflowも確認します。
演算を数える独自型で構築とqueryの上記加減算回数を確認し、
6Dの入力1,000,000要素も構築します。
既存2D実装との全区間比較は補助回帰で、独立oracleとは別に行います。
既存の2D/Fenwick/平方分割/ModInt回帰とexpander回帰も両Nimで実行します。
新設テストはこのverifyのみで、toolsや独立CIは追加しません。

issue #646の本文はAtCoder提出77230184へのリンクのみ、コメント0件でした。
調査時に提出ページが403で取得できず、参照コードとのAPI一致や追加機能の有無は
確認できていません。この実装は確認済みscopeの固定次元・静的・密な多次元累積和です。
