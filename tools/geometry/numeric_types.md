# 幾何演算の数値型

`Point[T]` のスカラー除算 `p /= x` と `p / x` は座標型 `T` を保持します。浮動小数点のオーバーロードは、各座標とスカラーを `float`（float64）へ変換して除算し、結果を元の座標型へ変換します。`float32` の点に `float64` のスカラーを渡しても、スカラーを先にfloat32へ丸めません。これは従来のfloat64経由の演算を保ち、Nim 1.6でもfloat32の除算代入を使用できるようにする処理です。

```nim
import cplib/geometry/base

var p = initPoint(3.0'f32, -2.0'f32)
p /= 2
assert p.x == 1.5'f32
assert p.y == -1.0'f32
let q = p / 0.5
# q の型は Point[float32]
```

二乗距離 `norm(p, q)`・`norm(p, line)`・`norm(p, segment)`・`norm(segment1, segment2)` の返り値は座標型です。`Fraction[int]` の点・直線・線分では分数のまま返します。線分が交差する場合の線分間二乗距離は、分母1の正規形 `0/1` です。

```nim
import cplib/geometry/base
import cplib/geometry/distance
import cplib/math/fractions

let a = initPoint(initFraction(0), initFraction(0))
let b = initPoint(initFraction(2), initFraction(2))
let c = initPoint(initFraction(0), initFraction(2))
let d = initPoint(initFraction(2), initFraction(0))
let squared = norm(initSegment(a, b), initSegment(c, d))
assert squared.num == 0 and squared.den == 1
```

平方根を取る `distance` は浮動小数点のAPIです。整数の点同士の二乗距離は整数で計算できますが、直線・線分との距離には除算を要するため、整数座標型での一般的な距離計算を保証しません。分数型も全整数型での対応は保証せず、回帰は `Fraction[int]` を検証しています。`Fraction[int32]` の `ccw` のゼロ比較など、既存の非対応箇所は別途扱う必要があります。

直線・線分のコンストラクタは、既存の点比較で異なる端点を要求します。この距離APIの回帰は非退化線分を対象に、包含・同一・端点反転・端点接触・交差・離れた共線線分を含みます。EPSの判定規則は変更していません。座標差・積・分母など、すべての中間値が型の計算範囲内であることが前提です。
