# Merge sort tree

`mergesorttree` は静的列の各セグメントにソート済み列を保持します。
`dynamic_mergesorttree` は固定長列の各セグメントに既存の `AvlSortedMultiSet` を保持し、オンラインの点代入に対応します。更新値を事前登録する必要はありません。

```nim
import cplib/collections/mergesorttree
import cplib/collections/dynamic_mergesorttree
import options

let st = initMergeSortTree(@[3, -1, 3, 8])
echo st.range_lowerbound(0, 4, 3) # 1
echo st.range_upperbound(0, 4, 3) # 3
echo st.range_freq(1, 4, -1, 8) # 2
echo st.count(0, 4, 3) # 2
echo st.prev_value(0, 4, 3).get # -1
echo st.next_value(0, 4, 3).get # 3
echo st.kth_smallest(0, 4, 2) # 3

let dt = initDynamicMergeSortTree(@["b", "a", "b"])
dt[0] = "z" # 初期列にない値も使える
dt.update(2, "a")
echo dt.count(0, 3, "a") # 2
echo dt.get(0) # z
echo dt.kth_largest(0, 3, 0) # z
```

添字は0-indexed、位置区間はすべて半開区間 `[l,r)` です。`0 <= l <= r <= len` を満たしてください。
値の区間も `[low,high)` で、`low >= high` なら個数は0です。境界値が列に存在する必要はありません。
空区間の個数は0、前駆・後継は `none(T)` です。

| 共通API | 意味 |
| --- | --- |
| `len` | 列の長さ |
| `[i]` / `get(i)` | 要素の取得 |
| `range_lowerbound(l,r,x)` | x未満の個数 |
| `range_upperbound(l,r,x)` | x以下の個数 |
| `count(l,r,x)` | xの出現回数 |
| `range_freq(l,r,low,high)` | 値が `[low,high)` に入る個数 |
| `prev_value(l,r,x)` | x未満の最大値を `Option[T]` で返す |
| `next_value(l,r,x)` | x以上の最小値を `Option[T]` で返す |
| `kth_smallest(l,r,k)` / `kth_largest(l,r,k)` | 小さい順/大きい順のk番目。重複を含む0-indexedの順位 |

k番目には `0 <= k < r-l` が必要です。空区間のk番目は取得できません。
動的版だけが `[i] = value` / `update(i,value)` を提供します。列自体の挿入・削除はありません。
同じ値への代入はO(1)で終了します。異なる値への代入では、各祖先の多重集合から旧値を1個だけ削除し、新値を1個追加します。

静的版は `<` による全順序、動的版は既存AVLの要件である一貫した `<`、`<=`、`==` を必要とします。
整数、文字列、独自型を扱えます。浮動小数点ではNaNなど全順序を満たさない値を使わないでください。
参照型のキーを外側から変更して比較順序を変えることはできません。
入力列はコピーします。木は `ref object` なので、木そのものの代入は同じ木への参照を共有します。

## 計算量

Nを列長、Lを `1 + ceil(log2(max(1,N)))` とします。比較・キーのコピーをO(1)とした構造上の最悪計算量です。乱択には依存しません。

| 操作 | 静的版 | 動的版 |
| --- | --- | --- |
| 初期構築 | O(NL + 1) | O(NL² + 1) |
| 記憶領域 | O(NL + 1) | O(NL + 1) |
| `len`, 要素取得 | O(1) | O(1) |
| 個数、前駆・後継 | O(L²) | O(L²) |
| 点代入 | 提供なし | O(L²)、同値ならO(1) |
| k番目 | O(L³) | O(L³) |

静的版は子のソート列を線形マージして構築します。
動的版は各要素を葉から根まで既存AVLへ挿入する構築なので、構築はO(NL²)です。
重複を含めて各要素をL個のノードに保持し、更新履歴や過去の値域を保存しません。動的版では1要素のコピーにつきAVLノードを1個使います。
キーが文字列などなら比較・コピーの費用、実行時のGCの費用は別途かかります。

k番目は根の全要素を候補にして**順位の整数添字**を二分探索し、各候補について区間内の「以下の個数」を調べます。
静的版の候補取得はO(1)、動的版はAVLの順位検索でO(L)、個数検索はO(L²)です。
値そのものの中点や算術演算を使わないため、任意の比較可能型と未登録値への点代入に対応します。

## 既存構造との使い分け

- 比較可能な型の静的な個数・前駆・後継検索なら `MergeSortTree`。
- 未知の値へ点代入しながら検索する固定長列なら `DynamicMergeSortTree`。
- 非負整数の静的列でk番目や和も頻繁に求めるなら既存 `WaveletMatrix`。構築O(NH)、検索O(H)（Hはビット数）で、k番目はこちらの方が速いです。
- 等しい値の個数だけなら既存 `StaticRangeCount`。値ごとの位置列を使い、ハッシュ可能な型に対応します。
- 登録済み2次元点の可換モノイド集約なら `CompressedSegmentTree2D`。更新座標の事前登録が必要です。
- 順序付き多重集合全体の操作なら `AvlSortedMultiSet`。merge sort treeはさらに位置区間で限定する用途です。

## ローカル検証

各Nimバージョンの `nim` でリポジトリのルートから実行します。外部judgeへの提出は行いません。

```sh
nim cpp -r --hints:off --path:src src/verify/collections/mergesorttree_test.nim
nim cpp -r --hints:off -d:release --path:src src/verify/collections/mergesorttree_test.nim
nim cpp -r --hints:off -d:release -d:mergeSortTreeStress --path:src src/verify/collections/mergesorttree_test.nim
python3 tools/mergesorttree/test_mergesorttree.py --nim /path/to/nim
python3 tools/mergesorttree/test_mergesorttree.py --nim /path/to/nim --expand
```

Nimテストは愚直な走査・独立ソートと比較します。空列、単点、重複、負値、全同値、最小・最大整数、存在しない境界、全端区間、同値・繰り返し更新、文字列・int64・float・独自型を含みます。
48 seedsの小規模ランダムテストとN=4,097の大きめのケースを常時実行し、`mergeSortTreeStress` ではN=65,537・2,000回の更新検索を使います。
Pythonテストは24 seeds × 2,000操作で、静的列と更新後の動的列を別々のoracleで比較します。
`--expand` はNim版expanderの通常・single-line・compress・compress+original-sourceの4形式を展開し、cplibの検索パスなしでコンパイルして同じPython oracleと比較します。さらに独自型を含むNimの回帰テストも展開後に実行します。
`mergesorttree_kth_smallest_test.nim` はLibrary Checkerの `range_kth_smallest` 用driverです。
