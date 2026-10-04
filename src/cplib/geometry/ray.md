# 閉半直線 Ray

`import cplib/geometry/base` と `import cplib/geometry/ray` で使用します。
issue #84 の半直線部分を実装します。円・最近点対・Delaunay・Voronoi は含みません。

```nim
let r = initRay(initPoint(1, 2), initPoint(3, 0))
# 原点 (1,2)、方向 (3,0)。第2引数は終点ではありません。
doAssert r.contains(initPoint(4, 2))
doAssert distance(initPoint(0, 2), r) == 1
let q = initRay(initPoint(4, 2), initPoint(-1, 0))
let common = intersection(r, q)
doAssert common.kind == rikSegment # (1,2)〜(4,2)
```

## API

- `initRay(origin, direction)` は `Point[SomeNumber]` を受け取り、座標を演算前に float64 へ変換します。Ray は float64 を保持する非generic型です。原点を含む集合 `origin + t * direction, t >= 0` を表します。
- `origin(r)`、`direction(r)` はコピーを返します。方向の最大絶対成分を1に揃えて保持します。長さ1の単位方向ではありません。成分は非公開です。零方向は debug/release/danger のいずれでも `ValueError` です。`Ray()` の既定値も有効な半直線ではなく、幾何演算で拒否します。
- `contains(r, p, eps = 0)` は点包含です。既定では支持直線上かつ原点より前方の点を許します。明示的な `eps > 0` は閉半直線からのユークリッド距離が eps 以下の点を許し、原点の後方にも半径 eps の円形領域が付きます。eps は有限・非負が必要です。
- `intersection(r, q/l/s)` と逆順のオーバーロードは Ray、既存 `Line[T]`、既存 `Segment[T]`（T は SomeNumber）との共通部分を返します。`intersect` は結果が空でないかを返します。端点接触を含み、strict オプションはありません。
- `distance` と `norm` は点・Ray・直線・線分との最短距離と二乗距離を float64 で返します。引数の両順序に対応します。

`RayIntersection` はタグ付き型です。対応する kind のフィールドのみを読みます。

| kind | フィールド | 内容 |
| --- | --- | --- |
| `rikEmpty` | なし | 共通部分なし |
| `rikPoint` | `point: Point[float64]` | 1点（原点・端点の接触を含む） |
| `rikSegment` | `segment: Segment[float64]` | 異なる2端点間の閉線分 |
| `rikRay` | `ray: Ray` | 閉半直線 |

同方向の共線 Ray は後方側を切り落とした Ray、逆方向なら空・点・線分です。
共線直線との結果は元の Ray です。線分の端点順を反転しても同じ集合を返します。
結果線分の端点順は未規定です。
零長線分も点として扱います（既存 initSegment はこれを許さないので、必要なら `Segment[T](s: p, t: p)` を直接構築します）。零方向の直線は拒否します。

## 計算方法と計算量

支持直線の外積が非零なら交点の2つのパラメータを求め、それぞれの許される区間へ入るか判定します。
平行なら共線性を調べ、一方のパラメータ区間をもう一方へ写して共通区間を取ります。
Ray の区間は `[0, infinity)`、直線は両方向無限、線分は有限閉区間です。
少なくとも一方が Ray なので全直線という結果は生じません。

点距離は直交射影を許される区間へ制限します。交差しない2集合間の最短点対は有限端点を少なくとも一方に含むため、Ray の原点・線分の両端の距離の最小値を取ります。
方向を最大成分で揃え、方向の二乗ノルムを `[1,2]` に保つことで、大きい／微小な方向の二乗による overflow/underflow を避けます。
全公開操作は **時間 O(1)、補助領域 O(1)** です。入力、既存 Point 比較、GEOMETRY_EPS、他の幾何モジュールや I/O は変更しません。

## 数値制約

- float32/float64 と整数を対象とし、Fraction は対象外です。整数座標・方向は各成分の絶対値が **2^53 以下**の場合に限ります。変換前に検査し、範囲外は ValueError にします。範囲内の変換は正確ですが、交点や距離計算は浮動小数点です。
- float の入力は有限であることが必要です。座標差、外積・内積、交点パラメータ、復元座標、距離などの中間値も float64 で表現できることが前提です。非有限値を検出した場合は ValueError にします。方向の正規化で非零成分が0になる成分比も拒否します。
- `norm` は距離の二乗の overflow と非零距離の二乗が0になる underflow を拒否します。`distance` は二乗を作らず、極小・極大の距離を扱える場合があります。
- その他の積・差の underflow、相殺、通常の丸め、近平行な交点の精度低下を完全には検出・保証しません。非零の必要な中間値が0へ丸められない入力を対象としてください。厳密な整数／有理数述語、adaptive predicate、正しい丸めは実装しません。
- 交差の次元分類に EPS は使わず、float64 の外積の `== 0`、パラメータの大小で判定します。ほぼ平行・ほぼ共線は、丸めによって分類が変わり得ます。浅い角度を一律に平行扱いする角度閾値はありません。`contains` の明示的な eps は点距離の許容に限り、intersection や distance に影響しません。

## 検証

`src/verify/geometry/ray_test.nim` に自己完結した検証を置きます。
正規化や区間写像を使わない整数外積の独立 oracle で、交点のパラメータ符号と共線時の包含端点を調べます。
3×3格子の72本の Ray に対し、Ray 72本・直線72本・点を含む線分81本との全16,200組、点包含・距離648組、固定 seed の乱数2,000回を検査します。
空・点・線分・Ray の分類、引数交換、線分／直線の端点反転、境界、明示 eps、GEOMETRY_EPS への非依存、float32、整数境界、極小／極大尺度、零方向・非有限値などの拒否も含みます。
