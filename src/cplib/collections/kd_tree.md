# 静的 kd-tree

`import cplib/collections/kd_tree` で `KDTree[K, T]` を利用できます。
`K` は正の `static[int]`、`T` は Nim の組み込み整数・浮動小数点型 (`SomeNumber`) です。
入力点は `array[K, T]`、または既存の 2D `Point[T]` で指定できます。
更新・削除は扱わず、構築後は読み取りだけを行います。

```nim
import algorithm
import cplib/collections/kd_tree

# K = 2, T = int64 を推論します。
let tree = initKDTree(@[[3'i64, 2'i64], [-1'i64, 5'i64], [3'i64, 2'i64]])
var indices = tree.rangeSearch([-1'i64, 2'i64], [3'i64, 5'i64])
indices.sort()
assert indices == @[0, 1, 2]
assert tree.rangeCount([3'i64, 2'i64], [3'i64, 2'i64]) == 2
assert tree.nearestNeighbor([3'i64, 2'i64]) == 0

let threeD = initKDTree(@[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
assert threeD.nearestNeighbor([1.5, 2.0, 3.0]) == 0
```

2D の `Point` では `import cplib/geometry/base` も指定します。
`initKDTree(@[initPoint(3, 2), initPoint(-1, 5)])` と構築し、
`nearestNeighbor(initPoint(3, 2))`、
`rangeCount(initPoint(-1, 2), initPoint(3, 5))` のように問い合わせできます。
配列と Point の構築・問い合わせは相互に組み合わせられます。


## API と境界

- `initKDTree(points: openArray[array[K, T]])` は入力を複製して構築します。
  `openArray[Point[T]]` 用のオーバーロードもあります。入力の順序・座標を変更せず、
  後から入力を変更しても木には影響しません。
- `len` は入力点数です。重複点も個別に保持します。
- `rangeSearch(lower, upper): seq[int]` は、全軸で **lower[a] <= p[a] <= upper[a]** を満たす点の
  入力時の 0-based index を返します。結果の順序は未規定です。必要なら呼び出し側でソートします。
- `rangeCount(lower, upper): int` は同じ閉区間内の点数です。
  一つでも端点が逆転していれば結果は空／0、全軸で端点が等しければその座標の点を検索します。
- `nearestNeighbor(query): int` はユークリッド距離二乗が最小の点の元 index を返します。
  同距離なら **元 index が最小の点**、空の木なら **-1** を返します。
  完全に同じ座標の点もこの規約で扱います。

空の型付き配列から構築できます。`default(KDTree[K, T])` も空の木として問い合わせできます。
構築後に公開された変更操作はありません。

## 座標と距離の契約

座標の比較には通常の `<` と `==` を使い、`GEOMETRY_EPS` や `Point` の近似比較は使いません。
浮動小数点の NaN・正負 Inf は構築時と各問い合わせの端点検証で `ValueError` にします。
この検証は release／danger でも実行し、空の木への問い合わせにも適用します。

範囲検索は座標の減算・距離計算を行わないため、整数の最小値・最大値や大きな有限 float を使えます。
最近傍は座標型 **T のまま**、大きい座標から小さい座標を引き、差の二乗を足して計算します。
自動で float やより広い整数へ変換しません。点との距離、box との距離を含め、
**全ての差・積・累積和が T に収まり、浮動小数点では中間値も有限になること**が前提です。
この前提を外れた整数のオーバーフロー・浮動小数点の Inf 化は検査・補正しません。

例えば 2D `int64` で入力と問い合わせの全座標を [-10^9, 10^9] に制限すれば、
距離二乗は最大 8×10^18 となりこの前提を満たします。int32 や高次元では同じ範囲を使えません。
符号なし整数も使えますが、差の二乗と累積和がその型に収まる必要があります。
int64 の両端値をまたぐ最近傍検索など、無制限の座標で正確な距離を保証する実装ではありません。

float は T で丸めた距離二乗の順位と同値で最近傍を決めます。
丸めやアンダーフローによって数学的には異なる距離が同値になる場合も、最小 index を選びます。
非常に小さな距離二乗が 0 になる場合もあります。実数としての厳密な最近傍は保証しません。

## 計算量

N は点数、M は範囲検索の出力数です。座標の比較・算術を O(1) とします。
分割軸は深さごとに循環し、(軸の座標, 元 index) の点数中央値で分割します。
median of medians による最悪線形時間の選択を使うため、整列済み・全同一点でも木の高さは O(log(N+1)) です。
各部分木の bounding box と最小 index を持ち、box の非交差・包含、距離の下界で枝刈りします。

| 操作 | 保守的な最悪計算量 |
| --- | --- |
| 構築 | O(N log(N+1) + KN) 時間、O(KN) 領域 |
| `len` | O(1) |
| `rangeSearch` | O(K(N+1) + M) 時間、結果 O(M) 領域 |
| `rangeCount` | O(K(N+1)) 時間、出力列を確保しない |
| `nearestNeighbor` | O(K(N+1)) 時間 |

構築と探索の再帰スタックは O(log(N+1)) です。問い合わせの座標検証だけでも O(K) かかります。
固定 K なら構築は O(N log N)、領域は O(N)、最近傍は最悪 **O(N)** です。
木の高さが対数でも、最近傍の訪問点数に O(log N) の保証はありません。

次元を固定し、各軸の分割座標が重ならない標準的な非退化 kd-tree の直交範囲探索では、
K >= 2 で O(N^(1-1/K) + M)（個数のみなら M の項なし）が典型的な理論上限です。
2D では O(sqrt(N) + M)、3D では O(N^(2/3) + M) となり、次元が上がるほど N に近づきます。
1D では O(log N + M) です。この API は重複や退化した点集合も受け付けるため、上表の保守的な上限を契約とします。
各ノードの box 比較・距離計算には K 軸分の処理が必要です。
