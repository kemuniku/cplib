# ThreeSidedRangeTree

オンラインの点集合について、三方有界矩形に含まれる点を一つ取得します。
点の追加・削除・両座標の一点更新・検索はすべて **最悪 O(log(N+1))**、
格納領域は有効な点数 N に対して O(N)。事前の座標登録・座標圧縮は不要です。

```nim
import cplib/collections/three_sided_range_tree
import options

let points = initThreeSidedRangeTree[int, int]()
let a = points.add(2, 7)
let b = points.add(2, 7) # 同じ座標でも別のID
let found = points.findBelow(1, 3, 7) # 1 <= x < 3, y <= 7
assert found.isSome and found.get.id == a
points.update(a, 5, -1) # xとyを変更してもIDは同じ
points.erase(b)        # bだけを削除
assert points.findAbove(1, 3, 0).isNone
assert points.findRight(-2, 0, 5).get.id == a
```

## API・境界・点ID

| API | 動作 |
| --- | --- |
| `initThreeSidedRangeTree[X,Y]()` | 空の集合を作る |
| `add(x,y)` | 点を追加し `ThreeSidedPointId[X,Y]` を返す |
| `erase(id)` | その点だけを削除しIDを無効にする |
| `update(id,x,y)` | 点の両座標を更新し、IDと追加順を保つ |
| `get(id)` | 現在の座標のコピー `(id,x,y)` を返す |
| `contains(id)` | この集合の有効なIDか判定する |
| `len` | 有効な点数を返す |
| `findBelow(xLower,xUpper,yUpper)` | `xLower <= x < xUpper, y <= yUpper` |
| `findAbove(xLower,xUpper,yLower)` | `xLower <= x < xUpper, yLower <= y` |
| `findLeft(yLower,yUpper,xUpper)` | `yLower <= y < yUpper, x <= xUpper` |
| `findRight(yLower,yUpper,xLower)` | `yLower <= y < yUpper, xLower <= x` |

検索の返り値は `Option[ThreeSidedPoint[X,Y]]`。該当点がなければ `none`、
あれば `(id,x,y)` のコピーです。存在判定は `.isSome` で行えます。
有限の二辺は半開区間、残る有限辺は包含します。空・逆区間は `none`。
Below/Above は指定x区間のy最小/最大、Left/Right は指定y区間のx最小/最大の点を選び、
その極値が条件を満たすか判定します。同値の極値は追加順が早い有効な点を返します。

IDは参照同一性で区別する**不透明なハンドル**で、整数添字ではありません。
座標の重複を許し、削除後も再利用しません。削除済み・別集合・nilのIDを
`get`/`erase`/`update` に渡すと、debug/release/dangerのいずれでも `ValueError`。
`contains` はこれらに `false` を返します。累積追加回数が `high(int)` に達した場合、
次の `add` は変更前に `ValueError` を送出します。削除では累積追加回数を戻しません。

集合自体は参照型です。代入した別名からの変更は同じ集合に反映されます。
`initThreeSidedRangeTree` を通さない未初期化集合（nilを含む）の `len` は0、
`contains` はfalse、その他の操作は `ValueError`。
検索/getで取得した座標は取得時のコピーで、後の更新に追従しません。
削除後のハンドルを呼び出し側が保持することはできますが、操作には使用できません。

## 計算量の根拠

x主キーとy主キーの **二つのAVL木** を保持します。
各節点のキーは `(主座標, 追加番号)` の辞書順で、重複座標も別節点です。
部分木の高さ、他方の座標の最小・最大、およびその点IDを保持します。
AVLの高さ差は1以下なので高さは O(log(N+1))。
追加・削除は各木で一つの探索経路を辿り、各祖先で一定回数の回転と集約再計算を行います。
一点更新は両木から旧キーを削除して新キーを追加するため同じ最悪計算量です。

検索は半開区間をAVL上の完全包含部分木と境界経路へ分解して極値を集約します。
完全包含部分木は保存した極値だけを O(1) で使います。
分岐後の左側は下端の経路だけ、右側は上端の経路だけを辿り、
訪問数は高さに比例します。各部分木内で改めて検索しないので **O(log²N) ではありません**。
極値が上限/下限を満たせばその点が存在し、満たさなければ区間内の全点が不適合です。

`get`/`contains`/`len`/初期化は O(1)。点ごとに二節点と一ハンドルを保持し、
検索・更新の再帰補助領域は O(log(N+1))。削除した点の節点は集合から到達不能となります。
呼び出し側が残すハンドル・座標の参照先の領域と、GC/解放の費用は別です。

## 型と制約

XとYは異なる型でもよく、それぞれ一貫した厳密弱順序 `<` と通常のコピーが必要です。
比較とコピーが O(1) の場合に上記の時間・領域となります。
順序同値（どちらも `<` でない）な座標は同じ境界位置として扱います。
座標の `==`/`<=`/加減算/符号反転/hash、無限大のsentinelは不要です。
整数の最小値・最大値も通常の点座標および包含する上限/下限にできます。
半開区間の上端に最大整数を指定すれば、契約どおり最大整数自身は含みません。
最大整数に1を足して閉区間へ変換する操作は行いません。

NaNや、外部から参照先を書き換えて順序を変える座標には対応しません。
比較は例外を送出せず、操作中にその結果を変えないことが必要です。
参照型の座標はdeep-copyされません。並行更新には対応しません。
四辺とも有限な矩形の報告・計数、永続版は提供しません。
Nim 1.6.20/2.2.4のC++ backend、64bitで検証し、32bit/JSは未検証です。

## 検証

新設テストは `src/verify/collections/three_sided_range_tree_test.nim` と
`three_sided_range_tree_invariant_test.nim` のみです。
前者は24 seeds × 800混合操作を独立した全点走査と比較し、四方向の存在と返却ID/座標を検査します。
整数上下限の全境界組合せ、重複・tie・空・逆区間・削除と再追加、無効/別集合ID、
異なるX/Y型、文字列・独自の `<` のみの型、uint64/int64、float32/float64も扱います。
後者はAVL回転・削除後の高さ差と両軸の節点集合・極値/tieを独立したsortと比較し、
追加番号の枯渇を検証します。65,537点の単調追加・削除と2,000更新・8,000検索では、
比較回数が実際の木の高さの定数倍以内であることも検査します。

repo rootで、対象バージョンのnimをPATHに置いて実行します。

```sh
nim cpp --path:src -r src/verify/collections/three_sided_range_tree_test.nim
nim cpp --path:src -d:release -r src/verify/collections/three_sided_range_tree_invariant_test.nim
nim cpp --path:src -r src/verify/tools/expander_test.nim
```

両Nimのdebug/release/dangerと、追加のORC実行、既存AVL関連回帰、
expanderの通常/single-line/compress/compress+original-sourceによる展開後の実行を確認しました。
公式ジャッジへの提出は行いません。
