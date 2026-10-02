# 多角形の境界と包含

`Polygon[T]` は頂点列をそのまま保持します。`on_edge(poly, p)` は境界上、`contains(poly, p)` は境界を含む内部、`contains(poly, p, strict = true)` は境界を除く内部を判定します。いずれも O(N) 時間・O(1) 追加領域です。包含は自己交差のない頂点列を前提とします。

始点を末尾に重ねる必要はありません。重ねた場合や、連続して同じ頂点を入力した場合も、境界・包含判定では受け付けます。入力の頂点列は変更しません。

| 頂点列 | `on_edge` | `contains` | `contains(..., true)` |
| --- | --- | --- | --- |
| 空列 | false | false | false |
| 単点・同じ点の繰り返し | その点との一致 | その点との一致 | false |
| 2点 | 2点間の線分上 | 2点間の線分上 | false |
| 全点共線 | 各辺のいずれかの線分上 | 各辺のいずれかの線分上 | false |
| 面積を持つ単純多角形 | 辺上 | 内部または辺上 | 内部 |

```nim
import cplib/geometry/base
import cplib/geometry/polygon

let p = initPoint(1, 2)
let single = initPolygon([p])
assert single.on_edge(p)
assert single.contains(p)
assert not single.contains(p, true)

let square = initPolygon([initPoint(0, 0), initPoint(2, 0),
    initPoint(2, 0), initPoint(2, 2), initPoint(0, 2), initPoint(0, 0)])
assert square.contains(initPoint(1, 1), true)
assert square.on_edge(initPoint(1, 0))
```

浮動小数点では既存の `Point.==` と `ccw` の許容誤差を使用します。端点が `==` で同一視される辺は、直線を生成せず、問い合わせ点といずれかの端点との `==` で判定します。近い別の頂点も同一視される場合があるため、極小の辺に厳密な境界判定を保証するものではありません。EPSの規則はこの処理で変更しません。

回帰では `int`・`int32`・`int64`・`float32`・`float64`・`Fraction[int]` を検証しています。座標差・内積・外積などの中間値が型の範囲内に収まることが前提です。Fractionの全整数型での対応は保証しません。`is_convex` / `is_convex_ccw` は別の関数であり、この境界・包含の退化ケース契約は適用しません。
