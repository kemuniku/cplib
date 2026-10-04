# 最小有向全域木

`import cplib/graph/directed_mst` で `g.directedMST(root)` を利用できます。
Chu–Liu/Edmonds 法で、根から全頂点へ到達できる最小コストの有向全域木を求めます。

```nim
import cplib/graph/graph
import cplib/graph/directed_mst
import options
var g = initWeightedDirectedGraph(3, int64)
g.add_edge(0, 1, 5)
g.add_edge(1, 2, -2)
g.add_edge(0, 2, 8)
let answer = g.directedMST(0)
if answer.isSome:
    let tree = answer.get()
    echo tree.cost       # 3
    echo tree.inEdge     # @[-1, 0, 1]
```

## 戻り値と入力

重み型は `SomeSignedInt`（int8/int16/int32/int64/int）。動的・静的な重み付き有向グラフを受け取ります。
`Option[DirectedMSTResult]` の `none` は解なし、`some` はコスト `cost: int64` と
各頂点への採用辺 `inEdge: seq[int]` を持ちます。辺IDは `g.add_edge` の戻り値／`g.edge_info` の添字です。
`inEdge[root] = -1`、他の頂点は必ず元の辺IDであり、縮約後の番号ではありません。
各非根の入次数は1、根は0で、採用辺は合計 V-1 本です。コストが同じ解が複数あればいずれかを返します。
元の辺IDを保つので、多重辺にも対応します。自己ループと根への入辺は無視し、負辺も許容します。

入力は変更しません。静的グラフでも `edge_info` だけを使用し、`build()` は不要です。
一頂点ならコスト0・`@[-1]`。空グラフには根がないため `ValueError` です。
不正な根・辺端点・頂点数 V > high(int32)/2 も `ValueError`。
これらの検査は release/assertions:off でも有効です。

64ビット環境の Nim C++ backend が必要です（既存 `Int128` を利用）。
内部の縮約重み・遅延差・合計は符号付き128ビット整数で計算するので、int64の最小値や
中間差がint64を超える入力も扱えます。頂点数の上限により中間演算は128ビットの範囲に収まります。
最終的な最適コストがint64の範囲外なら `OverflowDefect` を送出します。
途中のコストが範囲外でも、最終値がint64内に収まれば返します。

## 実装と計算量

各非根の最小入辺を選び、選択した辺が作る閉路を縮約します。残る入辺から選択済みの重みを引き、
縮約成分の入辺ヒープを併合します。代表の経路圧縮と縮約履歴は別配列で保持します。
最後に縮約の逆順で元の辺IDを復元し、閉路へ入る辺の到着頂点で元の選択辺を置き換えます。

`cplib/collections/lazy_leftist_heap` の配列形式の遅延加算付き左偏ヒープを使用し、ヒープ併合の再帰深さは O(log E) です。
縮約・展開・経路圧縮は反復処理なので、深い入れ子や長い経路でも頂点数に比例する再帰はありません。
時間 O((V+E) log(V+E))、追加領域 O(V+E)。ヒープノードは重み・遅延差を各16bytesで持ちます。
最大制約でのメモリ実測はPR本文に記載します。

アルゴリズムの参考:
[NyaanNyaan/library minimum-cost-arborescence.hpp](https://github.com/NyaanNyaan/library/blob/master/graph/minimum-cost-arborescence.hpp)
（CC0-1.0）および
[Library Checker Directed MST](https://github.com/yosupo06/library-checker-problems/tree/1814c4e5205517e368bb57a8d1127eb961cfeaae/graph/directedmst)
（Apache-2.0）。C++実装のコピー・同梱はなく、ヒープと復元をNimで記述しています。

## 検証

`src/verify/AI/directed_mst_test.nim` は、非根ごとに入辺を選ぶ全列挙と根からの到達性で最適コストを
独立に求めます。小さな全有向グラフ・固定seed乱数・負辺・同重み・辺順の反転・重複追加を確認し、
採用辺ID・根の入次数・各非根の入次数・到達性・元の辺コストとの一致も検査します。
静的グラフのbuild前後、複数整数型、入力保持、再利用、解なし、一頂点、不正入力、int64上下限、
差がint64を超える閉路、最終合計overflow、20万頂点での入れ子縮約も含みます。

```sh
nim cpp -r --path:src --nimcache:/tmp/dmst-debug src/verify/AI/directed_mst_test.nim
nim cpp -r -d:release --path:src --nimcache:/tmp/dmst-release src/verify/AI/directed_mst_test.nim
nim cpp -d:release --path:src --out:/tmp/dmst src/verify/graph/directed_mst_test.nim
```

公式driverは問題名 `directedmst`。入力 N M S と有向辺を読み、コストと親配列を返します。
根の親は根自身です。同コスト解は一意でないため、出力bytes比較ではなく公式checkerで復元を検査します。
公式問題は非負辺・単純グラフ・根から全頂点到達可能ですが、ライブラリの回帰ではそれ以外も扱います。
