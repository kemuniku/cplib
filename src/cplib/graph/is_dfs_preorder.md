# DFS の発見順の判定

`is_dfs_preorder(g, order, forest = false)` は、各頂点の隣接辺の走査順を
選ぶことで `order` を DFS の**発見順**にできるかを返す。
帰りがけ順や、既存の隣接辺の追加順に固定した DFS の判定ではない。

```nim
import cplib/graph/graph
import cplib/graph/is_dfs_preorder

var g = initUnWeightedDirectedGraph(4)
g.add_edge(0, 2)
g.add_edge(0, 1)
g.add_edge(1, 3)
assert g.is_dfs_preorder([0, 1, 3, 2])
assert not g.is_dfs_preorder([0, 1, 2, 3])
```

## 契約

- `order: openArray[int]` は全頂点 `0..<g.len` の順列。長さ違い、重複、
  負の頂点、範囲外の頂点を含むと `false`。
- `forest = false` は `order[0]` だけを根にする。その根から全頂点に
  到達できない場合は `false`。根は頂点 0 に固定しない。
- `forest = true` は一つの DFS が完了した時点で、`order` 中の最初の
  未訪問頂点を次の根にする。DFS の途中で別の根へ移ることはできない。
  有向グラフでは、弱連結成分や SCC を先に分解する方式ではない。
- 空グラフと空順列の組は両モードで `true`。非空グラフに空順列を
  与えると `false`。
- 動的・静的、有向・無向、重み付き・重みなしの 8 種類に対応。
  重みを利用せず、重み型に算術・比較の要件を追加しない。
  自己ループと多重辺も扱う。ラベル付き TableGraph は対象外。
- 入力グラフと順列を変更しない。通常の graph API で構築した非 nil の
  グラフを対象とし、格納配列の破壊的な直接編集は対象外。
  頂点・辺番号の既存の int32 容量制約を引き継ぐ。
- 静的グラフは `build()` 済みであること。辺の追加後は再 build する。
  正しい順列を渡しても未 build の場合は `ValueError`（release/danger
  でも有効）。順列の検査は build の検査より先に行う。

## 判定の根拠

各頂点の順位を `rank[order[i]] = i` とする。隣接頂点をこの順位の昇順で
走査する DFS が `order` と一致することが、必要十分条件になる。

十分性は、この走査自体が実現例になることによる。必要性は、目的の順序を
実現する DFS があるとして、その発見済みの接頭辞に沿って考える。
現在の頂点に未訪問の隣接頂点が残るなら、それをすべて訪ね終わる前に
現在の頂点から戻ることはできない。次に発見する頂点は、その時点の
未訪問の隣接頂点のうち目的の順序で最も早い頂点でなければならない。
したがって順位で整列した走査も同じ頂点を選ぶ。未訪問の隣接頂点が
なければ両方とも親へ戻る。この帰納法は有向・無向、多重辺・自己ループ
にも適用できる。forest の次の根も目的の順序で一意に決まる。

実装では隣接頂点を順位に変換した独立の配列を整列し、明示的な stack と
各頂点の次の隣接位置で DFS を再現する。再帰の深さに依存しない。
発見する順位が接頭辞長と異なれば、その場で `false` を返す。

## 計算量

N を頂点数、A を隣接要素数、deg(v) を各頂点の隣接要素数とする。
時間は **O(N + A + Σ deg(v) log(deg(v)+1))**、追加領域は **O(N+A)**。
有向グラフでは A=M、無向グラフでは自己ループも含め A=2M。
隣接配列を複製する領域と stack を含めた上限である。

## 検証

自己完結の `src/verify/graph/is_dfs_preorder_test.nim` に判定を集約する。
oracle は順位整列を使わず、各頂点の隣接順を全列挙し、それぞれ通常の
再帰 DFS を実行して得られる発見順の集合を作る。forest の根順も全列挙
する。次の 727 グラフについて全頂点順列を、各方向の動的・静的／
重み付き・重みなしの 4 表現、両モードで照合する。

- 1～3 頂点の全有向グラフ（自己ループを含む）530 件。
- 1～4 頂点の全単純無向グラフ 75 件。
- 固定 seed の有向・無向グラフ各 60 件（自己ループ・多重辺を含む）。
- 空グラフの有向・無向 2 件。

不正な順列、非 0 根、順序の組替え、forest でも途中で戻れない例、
入力の不変性、算術を持たない重み型、未 build／再 build、10 万頂点の
鎖と星も確認する。出力は verify-helper 用の `Hello World` のみ。

Nim 1.6.20 / 2.2.4 の C++ backend で debug、release（assertions off）、
danger を検証する。再現例（対象 Nim を PATH に設定して repo root で）:

```sh
nim cpp --path:src -r src/verify/graph/is_dfs_preorder_test.nim
nim cpp --path:src -d:release --assertions:off -r src/verify/graph/is_dfs_preorder_test.nim
nim cpp --path:src -d:danger -r src/verify/graph/is_dfs_preorder_test.nim
```

これは新 API の正当性検証であり、既存実装に対する速度比較や judge 上の
実行時間の保証ではない。
