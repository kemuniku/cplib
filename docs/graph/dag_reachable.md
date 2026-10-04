# DAG の到達可能性クエリ

`import cplib/graph/dag_reachable` の
`dag_reachable(g, queries: openArray[(int, int)]): seq[bool]` は、
各 `(a, b)` について a から b に到達できるかを入力順に返します。
頂点番号は 0 始まりです。0 辺の経路を含み、`(v, v)` は常に true です。
重みあり・なしの動的/静的有向グラフに対応し、重みは無視します。
重複辺、孤立点、任意の頂点番号順、重複クエリ、空グラフと空クエリを許します。
入力グラフとクエリは変更しません。

静的グラフは最後の辺追加後に `build()` してください。
未構築の静的グラフ、範囲外のクエリ頂点、循環（自己ループを含む）は
debug/release ともに `ValueError` です。クエリが空でも DAG を検査します。
グラフ自体の辺・頂点情報は graph モジュールの通常の有効な状態を前提とし、
nil グラフや公開配列を直接破壊した状態は対象外です。

```nim
import cplib/graph/graph
import cplib/graph/dag_reachable
var g = initUnWeightedDirectedGraph(3)
g.add_edge(0, 1)
g.add_edge(1, 2)
let answer = g.dag_reachable(@[(0, 2), (2, 0), (1, 1)])
# @[true, false, true]
```

## アルゴリズムと計算量

Kahn 法でトポロジカル順序を一度求めます。64 クエリを一つの batch にし、
各クエリの終点の uint64 の対応ビットを立てます。
逆トポロジカル順に各辺 v→u で `bits[v] |= bits[u]` を行い、
各クエリの始点のビットを読みます。次の batch では全頂点のワードを初期化します。

頂点 v の処理時、すべての後続頂点 u は処理済みです。
v が終点自身である場合の初期ビットと、各 u に到達できる終点の和集合が、
ちょうど v から到達できる終点集合です。逆順に帰納することで正しさが従います。
同じ終点のクエリも別ビットを持つので、入力順と重複を維持します。

N 頂点、M 辺、Q クエリ、w=64 とすると、前処理 O(N+M)、
batch ごとに O(N+M)、答えの抽出に合計 O(Q) で、
**O(N+M+(N+M)ceil(Q/w)+Q)** です。
Q>0 では **O((N+M)ceil(Q/w)+Q)** にまとめられますが、
Q=0 でも DAG 検査の O(N+M) は必要です。
全頂点対の bitset は保存せず、作業領域と返り値の合計は **O(N+Q)** です。
入力グラフの O(N+M) とクエリの O(Q) の領域は別です。
この API の DAG 処理は再帰を使いません。
非常に多いクエリは batch 数に比例して時間が増えます。

## 一般有向グラフ

`import cplib/graph/directed_reachable` の `directed_reachable(g, queries)` は
既存の `SCCG()` で縮約し、成分番号へ変換したクエリを `dag_reachable` へ渡します。
重みなしの動的/静的有向グラフに対応し、自己到達を含む同じ契約です。
循環と自己ループを許し、同一 SCC 内の二頂点は true になります。
未 build の静的グラフと範囲外クエリは `ValueError` です。

縮約後を K 頂点・L 辺（成分間の重複辺も数える）として、
時間 **O(N+M+(K+L)ceil(Q/64)+Q)**、追加領域 **O(N+M+Q)** です。
既存 SCCG の再帰 DFS を使用するため、深いグラフでは実行環境のスタック上限が制約です。
大きい DAG には再帰のない DAG 専用 API を使ってください。
推移閉包の辺を列挙・保存する API ではありません。Issue #438 への依存はありません。

## 検証

`src/verify/AI/dag_reachable_test.nim` は独立な頂点ごとの BFS と照合します。
5 頂点までの順序付き DAG の全列挙、頂点番号をシャッフルした固定 seed の乱数 DAG、
3 頂点一般有向グラフの全列挙、重複辺、孤立点、自己到達、空入力、
63/64/65/127/128/129/257 クエリ、拒否契約と入力保持を検証します。
重みあり・なし、動的/静的の四種を比較し、DAG では 10 万頂点の長いパスも実行します。

公式仕様で DAG が保証される
[AtCoder 典型90 059](https://atcoder.jp/contests/typical90/tasks/typical90_bg)
の verify driver も追加しています。最大制約は N,M,Q が各 10 万です。
[Issue #437](https://github.com/kemuniku/cplib/issues/437) の全1コメントにある
AOJ 0275 は、公式問題文の取得が環境から 403 となったためローカルの問題対応検証は未実施です。

Nim 1.6.20 / 2.2.4、C++ backend の debug/release で回帰が成功し、
各実行で 314,871 件の BFS oracle 照合を行いました。
既存の graph/storage/edge-id/weight-type、SCC、topologicalsort、DAG path cover、
expander 回帰も両 Nim で成功しました。新規回帰と driver の通常・single-line・compress・
compress+original-source 展開版が両 Nim release で成功し、driver は各版で公式3サンプルに一致しました。
Nim 2.2.4 release の UBSan でも回帰が成功しました。

N=Q=100,000、M が約100,000 の長いパス・スター・非連結な二つのパスを、
各形状で解析的に決まる期待値と照合しました。Linux x86_64、g++ 14.2.0、
C++ release、既存と同じ scanf/echo driver のプロセス wall time（各1回）は、
Nim 1.6.20 が 0.906/0.777/0.841 秒、2.2.4 が 1.414/1.380/1.417 秒でした。
共有 VM で他のコンパイルと並行した実測で、性能保証や処理系間の速度比較の根拠ではありません。
I/O モジュールは変更していません。公式全ケースのローカル取得、32bit 実行、judge 提出は未実施です。

両 Nim での再現例:

```sh
nim cpp -r --path:src src/verify/AI/dag_reachable_test.nim
nim cpp -r -d:release --path:src src/verify/AI/dag_reachable_test.nim
nim cpp -d:release --path:src src/verify/graph/static/dag_reachable_typical90_bg_static_test_.nim
nim cpp -r -d:release --path:src src/verify/tools/expander_test.nim
```
