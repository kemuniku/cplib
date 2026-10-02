# 凸多角形の切断・直径・包含

`cplib/geometry/convex_polygon` は既存の `Point[T]`、`Line[T]`、
`Polygon[T]` を使う追加モジュールです。既存のAPIは変更しません。

```nim
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/geometry/convex_polygon
import options

let polygon = initPolygon(@[
    initPoint(0, 0), initPoint(4, 0), initPoint(4, 3), initPoint(0, 3)])
let convex = initConvexPolygon(polygon)
assert convex.contains(initPoint(2, 1))
assert convex.on_edge(initPoint(2, 0))
assert not convex.contains(initPoint(2, 0), strict = true)
let farthest = convex.diameter.get
assert farthest.distance_sq == 25
# farthest.endpoints[0], farthest.endpoints[1] が直径の端点。
```

## 入力と前処理

`initConvexPolygon(vertices)` / `initConvexPolygon(polygon)` はO(N)時間・
O(N)追加領域で独立した頂点列を作ります。入力は凸多角形の境界の周回順
（CW/CCWどちらも可）で渡してください。点群からの凸包生成や、凸性の検査は
行いません。自己交差・凹多角形・境界の往復・複数周回は契約外です。

連続する同一座標、先頭と末尾の重複、辺の途中の共線点を除き、辞書順最小頂点を
先頭にしてCCWに揃えます。全点共線なら両端点、同一座標のみなら1頂点、空なら
0頂点です。全点共線の場合は順序に依存しません。正規化は座標と外積をEPSなしで
比較します。既存Pointの近似一致・ソート・ハッシュの仕様には変更を加えません。

`len` と `items` で正規化後の頂点を参照できます。`toPolygon` は独立したコピーを
返します。前処理済み型の内部頂点は非公開なので、入力・コピーの変更でクエリの
前提を壊しません。

## 点包含

`convex.contains(point, strict = false)` と `convex.on_edge(point)` は1クエリ
O(log N)、追加領域O(1)です。各クエリで正規化や全頂点走査は行いません。
`strict = false` は境界を含み、`true` は境界を除きます。扇形の内部対角線は境界
にはなりません。空はすべてfalse、1頂点はその点、2頂点は両端を含む線分が境界で、
これらに対するstrict包含は常にfalseです。

## 直径

`convex.diameter` / `polygon.diameter` は
`Option[ConvexDiameter[T]]` を返します。`distance_sq: T` は最大二乗距離、
`endpoints: array[2, Point[T]]` はその端点です。平方根を使わないので符号付き整数、
float系、有限Fraction系で使えます。空は`none`、1頂点は二乗距離0で両端ともその点、
2頂点・全点共線は両端点です。同距離の組が複数ある場合はそのうち1組を返し、
端点の順序や同距離時の選択は保証しません。

回転calipersでO(N)時間・O(1)追加領域です。`Polygon`を直接渡す場合は内部で
O(N)前処理・追加領域を使います。最大値の比較にEPSを使いません。

## 左半平面への切断

`convex_cut(polygon, line)` / `convex_cut(convex, line)` は
O(N)時間・O(N)追加領域で`Polygon[T]`を返します。有向直線`line.s -> line.t`
の左側と直線上を残します。元の頂点列は変更しません。`Polygon`版は周回方向を
維持し、凸性の検査は行いません。全排除なら空、接するだけなら1点または線分に
なる場合があります。連続する重複と末尾の閉じ点重複は除きます（floatでは既存Pointの近似一致を使用）。
共線点の除去は必要なら`initConvexPolygon`で行ってください。

対応型は`float32` / `float64`と`Fraction[符号付き整数型]`です。交点には割算が
必要なので整数座標はコンパイル時に拒否します。floatまたはFractionへ明示的に
変換してから渡してください。Fractionの零値は`initFraction(0)`等で構成し、
`default(Fraction[T])`（0/0）は使わないでください。Lineは異なる2点から作れます。
分数係数からのLine生成など、別PRの修正はこの機能の依存ではありません。

```nim
let polygon = initPolygon(@[
    initPoint(0.0, 0.0), initPoint(4.0, 0.0),
    initPoint(4.0, 3.0), initPoint(0.0, 3.0)])
let line = initLine(initPoint(2.0, -1.0), initPoint(2.0, 4.0))
let left = convex_cut(polygon, line) # x <= 2 の長方形。
assert left.area == 6.0
```

## 数値の前提

有限座標、正の`GEOMETRY_EPS`、型の範囲に収まるすべての中間演算を前提とします。
整数・Fractionでも乗算や分母の成長によるオーバーフローは呼出側で避けてください。
Fractionの時間計算量は算術・比較を定数時間とみなしたものです。

floatの包含と切断では既存`geometry_eq/lt/gt/le`によるEPS境界判定を使います。
切断後の点が丸め誤差やEPSの幅だけ右側になる場合があります。EPS以下の辺や、
ほぼ共線な頂点・クエリ、極端なスケール、外積の桁落ちについて線形包含との一致や
厳密な幾何結果は保証しません。特に、前処理の厳密比較とEPS境界判定は異なるため、
微小な辺を含む入力のクエリは十分な距離を境界から取って使ってください。
floatの直径も通常の浮動小数点演算に基づき、丸め誤差に対する厳密保証はありません。
厳密な結果が必要な場合は、有限のFractionと中間値が収まる整数型を使用してください。
