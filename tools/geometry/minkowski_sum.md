# 凸多角形のMinkowski和

`cplib/geometry/minkowski_sum` は #945 の `ConvexPolygon` 正規化を再利用します。
この変更は `codex/convex-polygon-operations` をbaseにしたstacked PRです。

```nim
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/geometry/convex_polygon
import cplib/geometry/minkowski_sum

let a = initPolygon(@[initPoint(0, 0), initPoint(2, 0), initPoint(0, 2)])
let b = initPolygon(@[initPoint(1, 1), initPoint(3, 1)])
let sum = minkowski_sum(a, b) # ConvexPolygon[int]
let vertices = sum.toPolygon.v
assert vertices == @[initPoint(1, 1), initPoint(5, 1),
    initPoint(3, 3), initPoint(1, 3)]
```

## APIと入力契約

`minkowski_sum(a, b)` は同じ座標型の `ConvexPolygon[T]` 同士、
`Polygon[T]` 同士、または `openArray[Point[T]]` 同士を受け取り、
`ConvexPolygon[T]` を返します。数学的には `{p+q | p∈a, q∈b}` の凸多角形です。
入力・出力は塗りつぶした凸集合として扱い、元の頂点列は変更しません。
型の異なる座標や入力形式は、呼出側で明示的に変換してください。

頂点列とPolygonは凸多角形の境界の周回順で渡してください。CW/CCW、開始点の回転、
連続する同一座標、末尾の閉じ点、辺途中の共線点を許します。#945と同じく凸性の検査や
点群の凸包生成は行いません。凹多角形、自己交差、境界の往復、複数周回、非連続の
重複頂点は契約外です。ただし全点共線なら入力順序によらず両端点へ縮約します。

片方でも空なら空、一点同士はその和、一点と図形は平行移動、線分同士は線分または
平行四辺形になります。同方向の辺は一緒に進め、逆方向の平行辺は別の偏角として
扱います。出力は辞書順最小頂点から始まるCCWで、重複・閉じ点・辺途中の共線点を
除きます。退化結果は0/1/2頂点になります。`len`、`items`、`toPolygon` で参照できます。

## 計算量と数値の前提

最下点（同じ高さなら最左点）から始まる辺列を、半平面と外積で偏角順に線形マージ
します。正規化・結果のコピーを含めO(N+M)時間・O(N+M)追加領域です。
全点対の列挙やソートは行いません。各出力座標は元の頂点同士の和を直接計算するため、
辺ベクトルの累積加算による誤差の蓄積を避けます。Fractionの計算量は算術・比較を
定数時間とみなしたものです。

対応型は符号付き整数、`float32` / `float64`、有限の
`Fraction[符号付き整数型]` です。加算・減算・外積・Fraction比較や分母成長を含め、
すべての中間演算が型の範囲に収まることを前提とします。自動拡張は行いません。
Fractionの座標は `initFraction` で構成し、0/0のdefault値や無限大を渡さないでください。
符号なし整数は減算の負値を表現できないためコンパイル時に拒否します。

正規化、向き、偏角、重複の比較にはすべてEPSなしの座標演算を使います。
既存PointのEPS付き比較・ソートや全体の `GEOMETRY_EPS` は変更しません。
floatは有限の座標と中間値が前提です。ほぼ共線な辺、極端なスケール、外積の桁落ち、
座標の和で異なる頂点が同じ値に丸められる入力について厳密な幾何結果を保証しません。
EPS以内でも表現可能な微小辺は区別します。厳密な結果には、範囲内の整数または
有限Fractionを使用してください。
