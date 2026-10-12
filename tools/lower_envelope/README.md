# 線分・半直線の下側／上側包絡線

`import cplib/geometry/lower_envelope` で、連続した実数のx座標全体に対して
最小／最大のyを取る部分を求めます。入力の線分・半直線は混在できます。

```nim
import options
import cplib/geometry/base
import cplib/geometry/lower_envelope

let curves = [
    initEnvelopeSegment(initPoint(-1.0, 1.0), initPoint(1.0, 1.0)),
    initEnvelopeSegment(initPoint(0.0, 0.0), initPoint(0.0, 2.0)),
    initEnvelopeRay(initPoint(2.0, 0.0), initPoint(3.0, 1.0))]
let lower = lower_envelope(curves)
let upper = upper_envelope(curves)
assert lower.value_at(0.0).get == 0.0
assert upper.value_at(0.0).get == 2.0
assert lower.source_at(0.0) == 1
assert lower.value_at(1.5).isNone
assert lower.source_at(1.5) == -1
```

## 入力と境界の契約

- `initEnvelopeSegment(s, t)` は既存の `Point[T]` 2点を受け取り、
  両端を含む線分を返します。xの逆順、垂直線分、同一点を許します。
  既存の `Segment[T]` を受け取る同名オーバーロードもあります。
- `initEnvelopeRay(s, t)` は始点sを含み、sからtの方向へ伸びる半直線です。
  左向き・右向きともに扱います。sとtが同一点なら `ValueError`。
- `lower_envelope(curves)` / `upper_envelope(curves)` は
  `openArray[EnvelopeCurve[T]]` または `openArray[Segment[T]]` を受け取ります。
  入力を変更せず、入力順の0始まり番号を保ちます。
- 同率の最小／最大を取る入力が複数ある場合、最小番号を一つだけ返します。
  すべての同率入力を列挙する機能ではありません。
- 下側では垂直線分の下端、上側では上端を一点として扱います。
  下側で上向きの垂直半直線、上側で下向きの垂直半直線は始点が極値です。
  下側で下向きの垂直半直線、上側で上向きの垂直半直線は極値が存在しないため、
  構築時に `ValueError` を送出します。黙って取り除くことはありません。
- 入力は閉線分・始点を含む半直線です。開いた入力端点や、人工的な空の入力区間を
  指定するAPIは設けていません。空入力と、入力が覆わないxの区間は扱います。
- 入力座標は有限値に限ります。NaN、±∞、分母0のFractionは `ValueError`。
  無限端は内部のフラグで扱い、巨大有限値や `a * Inf + b` に置き換えません。
  これらの例外検査は `-d:release` / `--assertions:off` でも有効です。

## 出力と使い方

返り値は `Envelope[T]`。`envelope.diagram` は次の配列を持ちます。
Kを `xs.len` とすると、`xs` は狭義昇順です。

| フィールド | 長さ | 意味 |
| --- | --- | --- |
| `xs` | K | 有限の境界x座標 |
| `point_sources` | K | x = xs[i] での代表入力番号 |
| `interval_sources` | K+1 | 境界の間の**開区間**での代表入力番号 |

`interval_sources[0]` は `(-∞, xs[0])`、末尾は `(xs[^1], +∞)`、
中間のi番目は `(xs[i-1], xs[i])` に対応します。`-1` は入力が覆わない空区間／点です。
K=0なら唯一の区間が実数全体を表し、空入力の結果は `xs = @[]`、
`point_sources = @[]`、`interval_sources = @[-1]` です。

境界の点と開区間は独立です。例えば y=1 on [-1,1] と垂直線分 (0,0)–(0,2) の下側は、
`xs = @[-1,0,1]`、`point_sources = @[0,1,0]`、
`interval_sources = @[-1,0,0,-1]` となります。
左右の代表が同じでも、x=0を含む閉線分に結合してはいけません。
同一直線の入力も、左区間・点・右区間の代表番号がすべて同じ場合だけ境界を除きます。

- `source_at(x): int` は有限のxでの代表番号。空なら `-1`。O(log(K+1))。
- `value_at(x): Option[T]` は包絡線の値。空なら `none(T)`。O(log(K+1))。
- `source_value(source, x): T` は指定入力の支持直線の値。O(1)。
  **定義域外にも外挿**します。垂直入力は選択した極値の定数関数として評価します。
  開区間の端の片側極限を求めるときに使えます。上の例では
  `lower.source_value(0, 0.0) == 1.0` ですが、`lower.value_at(0.0).get == 0.0` です。
  番号が範囲外なら `ValueError`。

結果の公開配列は参照・走査用です。整合性を崩す書き換えや、未構築の
`default(Envelope[T])` へのクエリはサポートしません。

## 数値型

`float` / `float32` と既存の `cplib/math/fractions` の `Fraction[T]` に対応します。
整数のままの入力はコンパイル時に拒否します。座標から一次関数の傾きと交点を求めるため、
整数座標を使う場合も `float` または `initFraction` で明示的に変換してください。

通常の高速用途には `float` を使います。**浮動小数点の近似計算**であり、
丸め誤差のある交点座標や、その近傍・ほぼ同一直線での代表番号の厳密性は保証しません。
傾き計算、差分、支持直線の評価、交点などの中間計算も有限である必要があります。
非有限の計算結果を検出した場合は `ValueError` です。
桁落ち・underflowや、元座標を浮動小数点に変換した時点の精度損失は検出しません。

`GEOMETRY_EPS` は使用しません。境界の順序は通常の `<`、同率・平行は通常の `==` です。
EPSによる非推移的な順序や、極小の傾き差を平行と見なして遠方の交点を落とす処理を避けます。
例として y=0 と y=1−10^-12 x の右半直線は x=10^12 で切り替わります。
元の支持直線を保持し、切断済みの浮動小数点端点から直線を再生成しません。
上側も大小比較を切り替えるだけで、座標や値の一括符号反転は行いません。

厳密計算には `Fraction[int]` / `Fraction[int64]` などを使えますが、
**Fractionの加減乗除・比較・約分を含む全中間整数が、その基底型の範囲に収まること**が前提です。
既存Fractionは比較にも交差積を使い、乗算前に必ず約分するわけではありません。
入力座標が64bit内というだけでは足りず、座標が10^9以下でも64bitや128bitで十分とは限りません。
このモジュールは多倍長化やoverflowの包括的な検出を追加しません。
範囲内であれば交点、同率、境界の開閉、孤立点を厳密に扱います。
Fractionは `initFraction` などで初期化した、分母が正の有効な分数を使用してください。

## アルゴリズムと計算量

入力を番号順に半分に分割して、それぞれの包絡図を再帰的に構築します。
2つの図の境界を同時走査し、各共通開区間の2つの一次関数を比較します。
内部交点がある場合だけ一度分割し、境界点はその点の有効な入力同士で別に比較します。
両端の無限区間では傾きと有限の交点の順序で代表を決めます。

マージは O(|A|+|B|)。一般の線分の包絡線は最悪 Θ(N α(N)) の出力を持つため、
出力が常にO(N)とは仮定しません。平衡分割統治全体は
**最悪 O(N α(N) log N) 時間、O(N α(N)) 領域、再帰深さ O(log N)** です。
αは逆Ackermann関数で、算術演算をO(1)と数えています。
中間図の合計に依存するため、最終出力サイズKだけで O(N log N + K) とも主張しません。
Hershbergerの最適 O(N log N) アルゴリズムの実装ではありません。

点と開区間に分ける包絡図・線形マージの参考:
[CGAL Envelopes of Curves in 2D](https://doc.cgal.org/Manual/latest/doc_html/cgal_manual/Envelope_2/Chapter_main.html)。
CGALのコードや依存関係は取り込んでいません。

## 検証とベンチマーク

`src/verify/geometry/lower_envelope_test.nim` の独立オラクルは、小さい整数入力の
全端点と定義域内の全ペア交点を有理数で列挙し、各点と隣接区間の代表で全入力を走査します。
最小番号を含めて図全体をFraction実装と照合し、float版も値・空区間を照合します。
二乗交点列挙はこの小ケース用オラクルに限り、本体では使いません。

- 固定seedの混在線分・左右半直線 1,800 ケースを上下とも照合。
- 有効な垂直半直線 150 ケースずつを上下で照合。
- 空、長さ0、逆向き、重複、同一直線、端点交差、多重交差、定義域外交点、
  不連続点、孤立点、空の区間、極短区間、遠方で交わるほぼ平行な半直線。
- 不正な垂直半直線、無方向の半直線、NaN／∞、非有限な中間結果の例外。
- 20万線分から境界40万個を出力する構造入力と各端点・隙間のクエリ。

```sh
nim cpp -r --path:src --nimcache:/tmp/envelope-debug --out:/tmp/envelope-test src/verify/geometry/lower_envelope_test.nim
nim cpp -r -d:release --path:src --nimcache:/tmp/envelope-release --out:/tmp/envelope-test-release src/verify/geometry/lower_envelope_test.nim
nim cpp -d:release --path:src --nimcache:/tmp/envelope-bench --out:/tmp/envelope-bench tools/lower_envelope/benchmark.nim
python3 tools/lower_envelope/run_benchmarks.py /tmp/envelope-bench 200000
```

計測結果は同ディレクトリのCSVに記録します。Linux上の固定seed、float、N=200000。
構築部分のみの `cpuTime()` を独立プロセス3回の中央値で集計し、生成と表示を除外します。
RSSはPythonの `os.wait4` による各プロセス全体の最大値のうち3回の最大値です。
1プロセスは下側・上側を順番に構築するので、RSSを片側単独の使用量とは解釈できません。

2026-10-12に Linux x86_64 / AMD EPYC 9V74（KVM、5 vCPU）/ g++ 14.2.0 で計測しました。
NimのC++ backend、`-d:release`、標準のメモリ管理（2.2.4: ORC、1.6.20: refc）、
単一スレッドです。`-d:danger` や `-ffast-math` は使用していません。

| N=200000の入力 | 2.2.4 下側 / 上側 秒 | 1.6.20 下側 / 上側 秒 | 下側 / 上側 境界数 |
| --- | ---: | ---: | ---: |
| ランダム線分 | 0.0761 / 0.0729 | 0.1172 / 0.1184 | 747 / 1114 |
| ランダム左右半直線 | 0.0436 / 0.0405 | 0.0765 / 0.0778 | 2 / 4 |
| 分離した線分 | 0.1406 / 0.1338 | 0.2495 / 0.2311 | 400000 / 400000 |
| 入れ子の水平線分 | 0.2167 / 0.0256 | 0.3015 / 0.0587 | 400000 / 2 |
| 長い線分と短い島状線分 | 0.1573 / 0.1351 | 0.2330 / 0.2055 | 400000 / 2 |
| 垂直線分の一点極値 | 0.0926 / 0.0841 | 0.1397 / 0.1362 | 200000 / 200000 |
| 同じ始点xを持つ平行半直線 | 0.0255 / 0.0224 | 0.0470 / 0.0472 | 1 / 1 |
| 多数の交点が包絡線上に現れる線分 | 0.0869 / 0.0260 | 0.1365 / 0.0579 | 100002 / 3 |

各ケースの最大RSSはCSV参照。全ケース中の最大は2.2.4で53120 KiB（約51.9 MiB）、
1.6.20で68120 KiB（約66.5 MiB）でした。これらは最悪出力を達成する理論構成の計測ではなく、
記載したランダム・構造入力の実測です。

Nim 1.6.20 / 2.2.4の両方でデバッグ実行とrelease実行を確認しました。
既存expanderで単一ファイルへ展開した版も、両Nim版の `-d:release --assertions:off` で
全 `doAssert` テストと例外検査が成功しています。
