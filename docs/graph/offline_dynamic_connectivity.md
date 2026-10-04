# Offline dynamic connectivity（単一 log）

`cplib/graph/offline_dynamic_connectivity` は、固定された N 頂点の無向多重グラフに対する辺の追加・削除・連結性の質問を登録し、最後にまとめて回答する。操作数を Q として、登録は償却 O(1)、`run` は償却 O((N+Q) log(N+Q+2))、保持領域・実行時の追加領域は O(N+Q)。全操作を先読みできる場合に使う。

```nim
import cplib/graph/offline_dynamic_connectivity

let dc = initOfflineDynamicConnectivity(3)
let a = dc.add(0, 1)               # この追加固有の edgeId
let b = dc.add(1, 2)
let q0 = dc.connected(0, 2)       # 回答配列の添字 0。ここでは判定しない
dc.remove(a)
let q1 = dc.connected(0, 2)       # 添字 1
let c = dc.add(1, 0)              # 再追加は新しい ID
let answer = dc.run()             # @[true, false]
assert answer[q0] and not answer[q1]
```

## API と所有権

- `initOfflineDynamicConnectivity(n)`：辺のない操作列を作る。N=0 も許す。
- `add(u,v): int`：辺の追加を登録する。ID は 0 から連番で、再利用しない。同じ端点の辺を何本でも独立して追加でき、自己ループも許す。
- `remove(edgeId)`：その追加を削除する。既に登録された、生存中の ID だけを受け付ける。端点指定ではない。削除済み ID の復活はできず、再追加は `add` を呼ぶ。
- `connected(u,v): int`：この時点の連結性の質問を登録する。結果ではなく `run` の回答配列の添字を返す。範囲内の同一頂点は常に連結している。
- `run(): seq[bool]`：質問の登録順に回答する。質問がなければ空配列。

頂点は `0..<n`。負の N、N=`int.high`、範囲外の頂点・ID、二重削除、未初期化の `nil` に対する操作は、assert の有効・無効にかかわらず `ValueError`。追加時には N+追加回数+1 が int に収まることも確認する。失敗した入力検査は登録済み操作列を変更しない。実際に必要な配列を確保できることが別途必要で、巨大な N は初期化時でなく実行時にメモリを要求する。

型は `ref object`。`let copy = dc` は同じ操作列を共有し、deep copy や永続版ではない。`run` は操作列を変更せず、ローカルな森を毎回新しく作るので、`let` からも繰り返し実行できる。返された配列の変更は以後の結果に影響しない。実行後に追加の操作を登録して再実行すると、既存の質問の回答を含む新しい配列を返す。以前の回答は変わらない。並行して操作列を変更する利用には対応しない。

## 最大森で削除時の探索を省ける理由

各追加に、その辺の削除操作の位置を重みとして与える。削除されない辺は全操作の後の位置 Q を重みとする。同じ重み（主に未削除辺）では小さい辺 ID を重く扱い、順序を一意にする。未削除辺どうしの閉路への後からの追加で、同時刻の辺を交換する処理を避けられる。

現在の生存辺の最大重み全域森を維持する。辺を追加したとき、異なる木の端点ならそのまま結ぶ。同じ木なら既存パスと新辺が閉路を作る。その閉路で最小重みの辺を捨てれば最大森を維持できる。自己ループは森に不要なので登録と削除だけ行う。

削除時刻 t に森辺 e を削除したとする。切断面をまたぐ他の生存辺 f が存在するなら、f の削除時刻は t より後である（1 操作で削除する辺は 1 本）。したがって f は e より重く、e を f と交換した森の方が重い。これは削除直前の森の最大性に反する。よって代替辺は存在せず、e を切るだけでよい。森に入っていない辺の削除は森を変えない。過去に閉路から捨てた辺を再走査する必要もない。

公開 `LinkCutTree` API だけでこの森を表す。元の N 頂点に加え、各追加を辺用の頂点 1 個で表し、森辺 (u,v) を u—辺頂点—v の 2 本で結ぶ。辺頂点には (削除時刻,ID)、元頂点には最小値演算の単位元を持たせる。`pathProd` で交換対象を取得し、`cut` 2 回・`link` 2 回以内で更新する。逆元・部分木集約は使わない。

追加ごとにノードを確保するので、同時生存辺数ではなく**全追加回数**に比例する領域を使う。LCT のノード数は N+全追加回数、各操作は定数回の償却 O(log(N+Q+2)) の LCT 操作であり、単一 log の計算量となる。最悪 1 操作の時間が対数時間であるとは保証しない。

## 制約と速度の読み方

オンラインで即時回答する機能、成分サイズ・成分数・任意の成分集約、重み付き最適化の結果出力は対象外。公開 LCT を利用し、LCT 内部や I/O を変更しない。N・操作位置・ID は int。Linux x86_64 の C++ backend、Nim 1.6.20 / 2.2.4 で検証する。32bit・JS・並行利用は未検証。

単一 log は漸近的な保証であり、実行時間が常に segment tree + rollback DSU より短いことを意味しない。パス・最小値集約を持つ splay 木の定数倍、辺の寿命・密度・質問の割合、Nim のメモリ管理に依存する。測定条件・比較対象と結果は PR 本文に記載する。

## 検証

新設テストは `src/verify/graph/offline_dynamic_connectivity_test.nim` のみ。LCT や削除時刻を使わない、現在の生存辺を走査する BFS を独立 oracle にする。

- 3 頂点の自己ループを含む全無向辺の追加と、生存 ID の削除を深さ 4 まで列挙し、各操作の前後で全頂点対を比較。
- 固定 seed の 240 試行 × 140 更新、最大 9 頂点。辺の反転・多重辺・自己ループ・再追加・切断・再連結・未削除辺の同重みを含めて比較。
- 3,000 頂点の鎖に逆向き多重辺を重ね、最初の鎖を全削除、次の鎖を順に削除、最後に星を追加して検証。
- N=0、質問なし、同一頂点、不正引数、二重削除、nil、追加ノード数の overflow guard、操作列の共有、返却配列の変更、複数回の実行、実行後の追加登録。

各 Nim での基本コマンド：

```sh
nim cpp -r --hints:off --path:src src/verify/graph/offline_dynamic_connectivity_test.nim
nim cpp -r --hints:off -d:release --assertions:off --path:src src/verify/graph/offline_dynamic_connectivity_test.nim
nim cpp -r --hints:off --path:src src/verify/tree/link_cut_tree/link_cut_tree_test.nim
nim cpp -r --hints:off --path:src src/verify/tools/expander_test.nim
```

展開版は通常・single-line・compress・compress/original-source の 4 形式で、ライブラリ path 指定なしに実行する。既存の LCT の回帰と動的木 driver も検証する。追加の tools/helper/log/benchmark/独立 CI は公開しない。
