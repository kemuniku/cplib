# Dynamic Li Chao Tree

`cplib/collections/dynamic_lichaotree` は整数領域の最小値を求める、座標登録不要の Li Chao Tree です。全直線と半開区間の線分を任意の順序で追加できます。

```nim
import options
import cplib/collections/dynamic_lichaotree

let tree = initDynamicLiChaoTree(-10, 11) # -10 <= x < 11
assert tree.get_min(0).isNone
tree.add_line(2, 3)
tree.add_segment(-1, -5, -2, 4) # -2 <= x < 4 のみ
assert tree.get_min(0) == some(-5)
assert tree.get_min(4) == some(11)
```

## API・制約

- `initDynamicLiChaoTree(l, r)` は `l < r` を要求します。領域・線分とも `[l,r)` で、inclusive slice は受け取りません。`r+1` を内部で計算しません。
- `add_line(a, b)` は領域全体に `a*x+b` を追加します。
- `add_segment(a, b, l, r)` は領域と `[l,r)` の共通部分に追加します。空・逆転・非交差区間は無操作です。
- `get_min(x): Option[int]` は領域内の任意の整数座標を受け付けます。被覆する直線がなければ `none(int)`、あれば `some(最小値)` です。`INF64`・`high(int)`・`low(int)` も通常の値として空と区別します。
- 領域外クエリ、不正な初期領域、nil の木、最小値が `int` に収まらないクエリは `ValueError` です。assertions を無効にしても検査します。最小でない候補の値は `int` の範囲を越えていても構いません。
- 座標・傾き・切片は `int` です。既存 `cplib/math/int128` に依存し、C++ backend と `__int128_t` 対応環境を要求します。Nim 1.6.20 / 2.2.4、Linux amd64 の 64bit `int` で検証しています。32bit 実行は検証していません。
- `int` は最大64bitを前提とします。積と和を最初から128bitで評価するので、積が `int` を越えても加算後の最小値が収まれば返せます。64bit同士の積と64bitの切片の和は符号付き128bitに収まります。中点も `l+(r-l)/2` を128bitで計算し、負領域での丸めや `l+r` / `r-l` のoverflowを避けます。
- `high(int)` は領域の右端には使えますが、半開区間であるためその座標自身は問い合わせられません。
- 木は mutable な `ref object` です。代入は同じ木を共有し、一方の追加は他方にも見えます。別々の初期化は独立です。永続版・削除・並列更新には対応しません。
- `node_count` は現在のノード数を返す読み取りAPIです。子indexを `int32` で保存するため、ノード数は最大 `high(int32)` 個です。これを越える生成は `ValueError` です。メモリ不足・容量上限で中断した追加の原子的ロールバックは保証しません。

## 正しさ

各ノードは整数区間 `[l,r)` と、その区間で有効な高々1本の直線を持ちます。空ノードは `hasLine=false` で表し、数値sentinelを使いません。

直線追加は両端 `l, r-1` で比較します。差は一次式なので、両端で新直線が小さければ全域で置換でき、両端で小さくなければ全域で不要です。大小が異なるときは中点で小さい直線をノードに残します。残った直線がさらに小さくなり得るのは片側だけなので、その子へ進みます。単点では両端が同じなので必ず停止します。子の既存直線は置換時にも保持します。

線分追加は交差する子だけをたどり、完全に被覆した区間で通常の直線追加を行います。これにより、各格納直線はそのノードの区間全体で有効です。問い合わせは座標を含む根から葉への経路上の直線だけを比較します。この経路がその座標に関係するすべての被覆区間を通るため、最小値を取りこぼしません。

ノードは連続poolのindexで接続します。pool拡張を跨いだ要素の参照・ポインタを保持せず、追加後にindexから子を設定します。queryはpoolを変更しません。

## 計算量・領域

`U = r-l` を数学的な整数として扱い、`h = ceil(log2 U)` とします。単点も含めて `O(1+h)` と読んでください。

初期化は時間・領域 O(1)、queryは最悪 O(1+h)。全直線追加は O(1+h) で、新規ノードは高々1個です。空ノードに到着した時点で直線を格納して停止するため、1本で経路全体を生成しません。端点で優劣を判定できる場合も早期終了します。

線分は高々 O(1+h) 個の被覆区間に分解されます。それぞれの直線追加は O(1+h) なので時間 O((1+h)²)。被覆区間への経路で生成するノードと、各直線追加が高々1個生成するノードを合わせ、新規ノード数は1線分あたり O(1+h) です。時間に比例する O(h²) 個のノードを作るわけではありません。

全直線追加 `F` 回、線分追加 `S` 回の使用領域は `O(1+F+S(1+h))`。さらに区間の二分木全体が U 個の葉・U-1 個の内部ノードしか持たないので、ノード数は常に `2U-1` 以下です。これらは数学的な上界で、`U` や `2U-1` を `int` で計算する必要はありません。

poolはNimのseqです。容量拡張で一時的に O(ノード数) のコピーと余剰容量が発生するので、追加の時間上界はpool拡張を含めて償却計算量です。queryにはこの留保がありません。今回の64bit環境のノード本体は32 bytes、初期ノードは1個です。seq容量・管理情報・GC等は別に必要です。巨大領域を初期化しても全域分のノードを確保しません。

## 検証の再現

各Nim版で、出力・nimcacheをリポジトリ外に置いて実行できます。

```sh
nim cpp -r --path:src --nimcache:/tmp/dynamic-lichao-debug-cache --out:/tmp/dynamic-lichao-debug src/verify/collections/dynamic_lichaotree_test.nim
nim cpp -r -d:release --assertions:off --path:src --nimcache:/tmp/dynamic-lichao-release-cache --out:/tmp/dynamic-lichao-release src/verify/collections/dynamic_lichaotree_test.nim
```

新設verifyは独立した全直線走査oracle、小領域の傾き・切片の全組合せ、固定seedの混合操作、空・重複・同傾き・負領域・単点・半開区間・clipping・領域外拒否を確認します。64bit最小/最大端点、INF衝突、128bitの積による相殺、最小値の範囲外拒否、nil、参照共有と独立初期化も検査します。1万本の直線と1万点の疎な線分でノード上界・再配置後の接続・queryの非変更性を確認します。

別途、Library Checkerの `line_add_get_min` / `segment_add_get_min` 用verify、既存LiChaoTree / ConvexHullTrick / Int128の関連回帰、expanderの既存verifyと新設verifyの通常・single-line・圧縮・原文付き圧縮展開を確認します。judgeへの提出は行いません。テストは `src/verify` に置き、独立テストtoolsやCIは追加しません。
