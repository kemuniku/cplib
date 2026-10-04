# 牛ゲー（差分制約）

`x - y <= c` を辺 `y -> x`、重み `c` として扱う整数差分制約ライブラリです。
ユーザーの演算子DSLを残し、非負辺専用のDijkstra版と、負辺を許すBellman–Ford版を提供します。

```nim
import cplib/utils/cow_game

let p = makeProblem() # initCowGame() と同じ、Dijkstra版
let x = p.get_Variable()
let y = p.getVariable()
p += x <= 3
p += y <= x + 2
p += x <= y
let upper = p.maximize(y - x)
if upper.status == cowFinite:
    echo upper.value # 2
if p.maximizeVariables() == cowFinite:
    echo x.get_value(), " ", y.getValue() # 3 5
```

Nimでは `get_Variable` と `getVariable`、`get_value` と `getValue` は同じ識別子です。
変数は初期状態で自由な整数です。暗黙の `x >= 0` はありません。

```nim
let p = initCowGameBellmanFord() # initCowGame(cowBellmanFord) と同じ
let x = p.getVariable()
let y = p.getVariable()
p += x <= -3
p += y - x >= 2
p += y <= x + 7
p.addEquality(x, -3)
echo p.maximize(y).value # 4
echo p.minimize(y).value # -1
if p.solve():
    echo x.getValue(), " ", y.getValue() # 実行可能解。最適解とは限らない
```

## API

| 操作 | 意味 |
| --- | --- |
| `initCowGame()` / `makeProblem()` | 非負辺専用。負の制約を追加すると `ValueError` |
| `initCowGameBellmanFord()` | 負辺を許す |
| `p.origin()` | 値0に正規化する基準変数 |
| `p.getVariable()` | 新しい変数を追加 |
| `p += x - y <= c` / `>= c` | 差の上限／下限を追加 |
| `p += x <= y` / `>= y` | 大小関係を追加 |
| `p += x <= y + c` / `>= y + c` | 定数差つき大小関係。`y - c`、`c + y` も可 |
| `p += x <= c` / `>= c` | 原点に対する定数上限／下限。`c <= x`、`c >= x` も可 |
| `p.addEquality(x, y)` / `(x, y + c)` / `(x, c)` | 二本の制約で等式を追加 |
| `p.maximize(x - y)` / `p.minimize(x - y)` | 差の最大値／最小値を `CowResult` で返す |
| `p.maximize(x)` / `p.minimize(x)` | 原点に対する最大値／最小値を返す |
| `p.solve()` | 全制約を満たす一つの解を保存。矛盾なら `false` |
| `p.maximizeVariables()` | 全変数の同時最大解を保存し `CowStatus` を返す |
| `p.minimizeVariables()` | 全変数の同時最小解を保存し `CowStatus` を返す |
| `x.getValue()` | 最後に保存した解の値。未計算・変更後・保存失敗後は `ValueError` |

`CowResult.status` は `cowFinite`（有限）、`cowUnbounded`（非有界）、
`cowInfeasible`（問題全体が矛盾）のいずれかです。`value` は `cowFinite` のときだけ読み出せます。
非有界の向きは最大化なら上方、最小化なら下方です。INFは公開結果として返しません。
目的値を問い合わせるだけでは解を保存しません。保存済み解はそのままです。
変数・制約の追加は実行可能性キャッシュと保存済み解を無効にします。
異なる問題の変数、初期化されていないハンドル、負辺のDijkstra版への追加は、
`release` や `danger`、`--assertions:off` でも `ValueError` で拒否します。
追加時の検査で拒否された制約／等式は追加せず、保存済み解も変更しません。

`==` は制約DSLではありません。等式には `addEquality` を使ってください。
非零の定数等式や非零の差の等式は片側が負辺になるためBellman–Ford版が必要です。
任意の線形和、厳密不等号、実数、削除操作は対象外です。

## 原点・平行移動・有界性

差分制約は全頂点の値を同じ量だけ移動しても変わりません。
定数制約 `x <= c` は `x - origin <= c` と解釈し、返す解では `origin = 0` に正規化します。
`origin` に両向きの余分な固定辺を追加する必要はありません。
変数同士の制約だけでは、差が有限でも、原点に対する個々の値は非有界になりえます。

実行可能なら、`max(x-y)` は `y` から `x` の最短路長です。到達不能なら上方非有界です。
`min(x-y)` は `-max(y-x)` です。整数重みなので、有限な端点は整数解で達成できます。
全変数の同時最大解が存在する必要十分条件は、問題全体が実行可能かつ原点から全変数へ到達可能なことです。
その場合、原点からの距離列自体が全制約を満たし、各変数の最大値を同時に達成します。
同時最小解の条件は逆向きの到達可能性で、反転グラフの距離の符号を反転します。
一変数でも非有界なら、`maximizeVariables` / `minimizeVariables` は解を保存しません。
この場合も `solve()` は実行可能解を保存できます。空問題は原点だけを持ち、有限です。

Bellman–Ford版は、まず全頂点を初期距離0とする同期更新で全成分の負閉路を検出します。
これは超始点から全頂点へ重み0の辺を張った実行可能性判定と同じです。
目的のsourceから到達不能な成分の矛盾も `cowInfeasible` とします。
その後、実行可能なグラフにだけ既存の `graph/bellmanford` を適用します。
Dijkstra版は全重みが非負なので、全頂点0が常に実行可能解です。
既存の `graph/dijkstra`、`graph/graph` も再利用します。既存graphの挙動は変更しません。

## 数値範囲と計算量

対応数値型は **64bit環境の `int` のみ**です。float、符号なし整数、任意精度整数の汎用APIは提供しません。
`V` は原点を含む頂点数、`W` は全制約の辺重みの絶対値の最大値です。
計算前に `W <= (high(int)-1) div V div 2` を要求します。
範囲外なら結果を有限／矛盾に分類せず `ValueError` を返します。
`low(int)` は絶対値・符号反転ができないので制約追加／反転時に拒否します。
変数追加で上限が小さくなる場合も、次の計算時に再検査します。
これは保守的な制限なので、数学的には値が表現可能でも拒否する入力があります。

実行可能性判定は同期更新のため、負閉路があっても計算する経路長は最大 `V` 本です。
実行可能な問題の最短距離は単純路で達成できるため絶対値は `(V-1)W` 以下です。
辺の加算、原点0への正規化、最小化の符号反転もこの制限内で安全です。
内部INFには `high(int)` を使い、到達不能からは緩和せず、INFを解の演算に使いません。
全体の実行可能性を先に確認するので、既存Bellman–Fordの `-INF` 伝播段階には入りません。

| 操作 | Dijkstra版 | Bellman–Ford版 |
| --- | --- | --- |
| 初回の `solve` / 実行可能性判定 | `O(V)` | `O(VE+V)` |
| 最大化・最小化・同時最適化 | `O((V+E)log(V+1))` | `O(VE+V)` |
| 同じ問題への実行可能性再判定 | `O(1)` | `O(1)` |
| 保存済み解の読み出し | `O(1)` | `O(1)` |

目的値問い合わせには未判定なら実行可能性判定も含まれます。最短路は問い合わせごとに再計算します。
追加空間は `O(V+E)`。変数／制約の追加は償却 `O(1)` です。

## 元の01列の例

累積和 `B` は **0の個数**を数えます。`[L,R)` に1がX個以上ある条件は
`B[R]-B[L] <= R-L-X` です。隣接差は0か1なので、答えはその反転です。
`B[0] <= 0` と全変数最大化により `B[0]=0` を達成できます。

```nim
import sequtils
import cplib/utils/cow_game

let n = 6
let p = makeProblem()
let b = newSeqWith(n + 1, p.get_Variable())
for i in 0..<n:
    p += b[i] <= b[i+1]
    p += b[i+1] <= b[i] + 1
p += b[0] <= 0
for (l, r, x) in [(0, 4, 3), (1, 2, 1), (3, 6, 2)]:
    p += b[r] - b[l] <= r - l - x
if p.maximizeVariables() == cowFinite:
    var answer: seq[int]
    for i in 0..<n:
        answer.add((b[i+1].get_value() - b[i].get_value()) xor 1)
    echo answer
```

元例の `N+2` 個では末尾の `B[N+1]` が孤立し、その変数の最大値は非有界になります。
必要な変数は `N+1` 個です。使わない変数があってもINFを保存する元実装との意図的な違いです。
このモデルは [ABC216 G - 01Sequence](https://atcoder.jp/contests/abc216/tasks/abc216_g) の公式サンプルと、
小さい01列の全列挙で検証しています。構築問題なので正解例との文字列一致ではなく、制約と最小1数を検査します。
`src/verify/utils/cow_game_abc216g_test.nim` は
`-d:cowGameAbc216gStandalone` で標準入力から動く提出形式にもなります。judgeへの提出は行っていません。
