# 点の比較と凸包

`Point[T]` の `==` は各座標を `geometry_eq` で比較する近似一致です。従来どおり `p == q` と書けます。`almost_equal(p, q)` も同じ判定を返します。浮動小数点以外の整数・分数は、それぞれの座標型の等値判定を使います。

ソート用の大小比較と `cmp` は、EPSを使わない x、y の順の辞書順です。`exact_equal(p, q)` は各座標の厳密一致を判定します。近い別の点では **`p == q` が真でも `cmp(p, q)` が0とは限りません**。`<=`・`>=` も厳密な辞書順です。近似一致は推移律を満たさないため、ソートの同順位判定や重複除去には `==` を使わず `exact_equal` を使ってください。ソートする座標にNaNを含めないでください。

```nim
import cplib/geometry/base

let p = initPoint(1.0, 2.0)
let q = initPoint(1.0 + 1e-12, 2.0)
echo p == q             # true（既定のEPS）
echo almost_equal(p, q)  # true
echo exact_equal(p, q)  # false
echo cmp(p, q)          # -1
```

Nim標準の `sort` / `sorted` は、比較関数を省略すると `system.cmp` を使い、近似一致の `==` を参照します。点をソートするときはPoint用の比較関数を明示してください。凸包内部でも明示しています。

```nim
import algorithm
import cplib/geometry/base

var points = @[initPoint(1e-12, 0.0), initPoint(0.0, 0.0)]
points.sort(proc(a, b: Point[float]): int = cmp(a, b))
```

ハッシュ用には厳密比較する `PointKey[T]` と変換関数 `toPointKey` を使います。変換時の座標値を保持し、EPSを変更しても等値判定・ハッシュ値は変わりません。浮動小数点の正負のゼロは等しく、ハッシュも一致します。キーにNaNは含めないでください。

```nim
import sets, tables
import cplib/geometry/base

let p = initPoint(1.0, 2.0)
let q = initPoint(1.0 + 1e-12, 2.0)
var seen = initHashSet[PointKey[float]]()
seen.incl(p.toPointKey)
seen.incl(q.toPointKey)
echo seen.len            # 2
var ids = initTable[PointKey[float], int]()
ids[p.toPointKey] = 7
echo ids[p.toPointKey]    # 7
```

`Point[float32/float64]` を直接ハッシュ化する操作はコンパイルエラーになり、`toPointKey` への変換を案内します。既存の `HashSet[Point[float]]` / `Table[Point[float], V]` はキー型を `PointKey[float]` に変更し、追加・検索時に変換してください。近似一致による近傍検索を提供するキーではありません。整数・分数のPointは直接キーにすることも引き続き可能です。独自の座標型では、その型の比較・ハッシュが整合し、Pointの等値判定も厳密一致になることが前提です。

`geometry_eq(x, y)` はまず厳密一致を認め、それ以外では差の絶対値が `GEOMETRY_EPS` または `GEOMETRY_EPS * max(abs(x), abs(y))` **未満**なら真になります。EPSは非負を指定し、0なら厳密一致のみになります。同符号の無限大同士は一致し、NaNや有限値と無限大の比較は不一致です。浮動小数点演算自身の丸めは残ります。

`initLine(p, q)` と `initSegment(p, q)` の端点検査には従来どおり `p != q` を使います。近似一致する端点はアサーションで拒否します。凸包はこのコンストラクタを使わず、厳密な重複除去と外積によって近い別の点も扱います。

`convex_hull(points, strict = true)` は入力を変更せず、厳密に重複する点を除いて、辞書順最小点から反時計回りに返します。始点は末尾に重ねません。計算量は O(N log N)、追加領域は O(N) です。

- 空入力は空、ユニーク点が1個ならその点、2個なら辞書順に返します。
- `strict=true` は辺の途中の点を除き、`strict=false` は残します。
- 全点共線なら `strict=true` は両端だけ、`strict=false` は全ユニーク点を辞書順に一度ずつ返します。
- 凸包内ではソート・重複除去・向き・共線性のすべてにEPSを使いません。近い別の点も入力点として扱います。従来のEPS付きの向き判定から変更しています。浮動小数点は有限座標を使用し、中間演算のオーバーフロー・アンダーフローを避けてください。外積は通常の浮動小数点演算なので、丸め誤差に対する厳密な幾何判定を保証するものではありません。
- 整数・分数は座標差、積、内積・外積などの中間値がその型の計算範囲に収まることが前提です。

以前の凸包と先頭頂点が変わる場合があります。出力順に依存するコードでは上記の規約に合わせてください。
