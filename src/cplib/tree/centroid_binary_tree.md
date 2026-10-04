# 重心分解二分木

`centroid_binary_tree` は、無重み無向木の重心分解を二分マージ木に変換する。
元の頂点からの距離が半開区間 `[l,r)` に入る頂点集合を、重複しない
O(log(N+1)) 個の配列区間で表現する。

## API・所有権

```nim
import cplib/graph/graph
import cplib/tree/centroid_binary_tree

var g = initUnWeightedUnDirectedGraph(4)
g.add_edge(0, 1)
g.add_edge(1, 2)
g.add_edge(1, 3)
let t = initCentroidBinaryTree(g)
for interval in t.distance_ranges(0, 1, 3):
    for i in interval.first..<interval.past:
        let u = t.entry_at(interval.node, i).vertex
        # u は頂点 1,2,3 のいずれかで、各頂点はちょうど一回現れる。
        discard u
```

- `initCentroidBinaryTree(g)` は動的・静的の重みなし無向グラフに対応する。
  非空の静的グラフは `build()` が必要。重み付き木には対応しない。
- `len` は元の頂点数 N、`node_count` は N>0 なら 2N-1、空なら0。
  葉の番号 `0..<N` は元の頂点番号と一致し、内部ノードは `N..<2N-1`。
  `root` は空木で -1、それ以外で 2N-2。
- `node_info(node)` は `(parent,left,right,center,size)` の値を返す。
  根の親・葉の子は -1、`size` は配下の葉数。
  内部ノードの `center` は二成分をマージした重心、葉では自身の頂点。
- `distance_order(node)` は `(vertex,distance)` の距離昇順配列を返す。
  **距離の基準はそのノードの親の `center`**。根だけは自身の `center`。
  重心分解の子成分の根を上位のマージへ接続するときも、この基準に置き換える。
  同距離の頂点順や、同じ木を異なる辺追加順で構築した際の内部番号は保証しない。
- `entry_at(node,index)` はその配列の一要素を O(1) で返す。
- `point_path(v)` は v の全出現位置 `(node,index)` を葉から根の順に返す。
- `distance_ranges(v,l,r)` は `(node,first,past)` の列を返す。
  各要素は `distance_order(node)[first..<past]` の頂点を表す。
  空区間は返さず、l>=r は空列。負の端点を許し、int の最小・最大値も安全。

構築後は不変で、入力グラフを保持しない。入力の変更・破棄の影響を受けない。
返す配列は独立したコピー、返す tuple は値であり、変更しても内部に影響しない。
ref の代入は同じ不変オブジェクトを共有する。
未初期化値、範囲外の頂点・ノード・添字は ValueError。
空木は構築できるが、頂点を指定する操作はできない。

通常のグラフ API で構築した無向連結木を入力とする。閉路・自己ループ・多重辺・
非連結・未 build の非空静的グラフは、assertion の有無によらず ValueError で拒否する。
グラフの公開内部配列・メタデータを直接壊した場合の整合性は保証しない。
同時に入力を変更しながらの構築は行わないこと。
頂点数は `high(int) div 2` 以下で、O(N log(N+1)) の確保が利用可能メモリに収まる必要がある。
Linux x86_64、Nim 1.6.20 / 2.2.4、C++ backend で検証する。

## 構築と区間分解の根拠

[原 issue の参照記事](https://www.mathenachia.blog/mergetech-and-logn/) の
「重心分解との融合」に従う。既存 `initCentroidDecomposition` で成分を分割し、
各重心で、その頂点の単点成分と子成分の根を、葉数が小さい二つからヒープでマージする。
元の木の走査・二分木構築とも再帰しない。

局所的なサイズ優先マージでは、ある成分のサイズが a になった後の二回先のサイズは
少なくとも 2a となる。したがってサイズ x の成分をサイズ S へ統合する際の
マージ回数は O(1+log(S/x))。重心分解では次の子成分が半分以下なので段数は O(log N)、
各段の log(S/x) の和は望遠和で O(log N)。二分木全体の高さも O(log N) になる。
各頂点の出現回数・全配列長も、それぞれ O(log N)・O(N log N)。

重心を起点に BFS し、元の木の枝ごとに距離昇順の列を得る。
子成分の根の配列をこの列に置き換え、同じ重心の下での二分マージは線形マージで構築する。
各配列を個別に sort せず、構築に余分な log N を掛けない。
最後に配列の全要素を走査して `point_path` の位置を記録する。

v の葉から根までのパスに接する兄弟部分木は、v 以外の全葉を互いに素に分割する。
兄弟に属する u は、v と異なる重心分解成分にあるため、元の木の v-u パスは
親マージの重心 c を通る。よって `dist(v,u)=dist(v,c)+dist(c,u)`。
兄弟の距離順配列で `[l-dist(v,c),r-dist(v,c))` を二分探索し、
0 が `[l,r)` に属するときだけ v の葉を加える。
減算前に端点を `[0,N]` に絞るので整数の溢れを避けられる。

## 計算量と集約への利用

| 操作 | 時間 | 追加領域・出力 |
|---|---|---|
| 構築・全内部データ | O(N log(N+1)) | O(N log(N+1)) |
| len / root / node_count / node_info / entry_at | O(1) | O(1) |
| distance_order(node) | O(size) | O(size) の独立コピー |
| point_path(v) | O(log(N+1)) | O(log(N+1)) |
| distance_ranges(v,l,r) | O(log²(N+1)) | O(log(N+1)) 個の区間 |

距離帯に含まれる全頂点の実列挙は、その頂点数 K の O(K) が別途必要。
頂点の値・集約データ構造・更新演算は利用側が管理する。
各配列に Fenwick tree / segment tree を置けば、点更新は `point_path` の全位置へ、
距離帯集約は `distance_ranges` の各配列区間へアクセスできる。
各配列上の操作が O(log N) なら、全体は O(log² N)。
逆に、距離帯への加算と点取得も、区間更新・点取得用の構造を同じ配列へ置いて処理できる。
列挙順は元の頂点番号順ではないため、集合の総和など可換な集約に使う。
普通の順序付き集合としての検索・挿入・削除 API は提供しない。

## 検証の再現

```sh
nim cpp -r --hints:off --path:src --nimcache:/tmp/cbt-debug -o:/tmp/cbt-debug-run src/verify/AI/centroid_binary_tree_test.nim
nim cpp -r -d:release --hints:off --path:src --nimcache:/tmp/cbt-release -o:/tmp/cbt-release-run src/verify/AI/centroid_binary_tree_test.nim
```

verify は独立した隣接列からの BFS を oracle とし、全小規模ラベル付き木、
境界・不正入力、入力・返却値の独立性、点更新と距離帯更新、深い木と高次数の木を検査する。
検証用の追加ファイルは `src/verify/AI/centroid_binary_tree_test.nim` のみ。
