# Merge sort tree の実装・検証記録

2026-10-04、最新main `d2407cd46f00f401428888e5a8bff35fd90a4fd3` を基点に差分を載せ、ローカルで再検証しました。
使い方・共通API・計算量は [mergesorttree.md](../../src/cplib/collections/mergesorttree.md) にあります。

## 設計と既存実装の確認

- 静的版 `MergeSortTree[T]` は各位置セグメントにソート列を保持し、子を線形マージして構築します。
- 動的版 `DynamicMergeSortTree[T]` は既存 `AvlSortedMultiSet[T]` を再利用します。`avltreenode` の順位情報・探索・削除も確認しました。重複を1個だけ削除し、固定長列の要素をオンラインで上書きします。
- `tatyamset` はバケット内のseq挿入を使うため、最悪対数時間の更新を必要とする今回の内側の集合には採用していません。`raw_ptr_avlset` の代わりに通常の参照型AVLを使います。
- API名と前駆・後継の境界は `WaveletMatrix` に合わせました。`StaticRangeCount` は等値の個数、`CompressedSegmentTree2D` は事前登録した2次元座標のモノイド集約という別用途です。
- GitHubの公開open PR 40件をread-onlyで確認しました。同名・同用途のmerge sort tree追加はありませんでした。[#941](https://github.com/kemuniku/cplib/pull/941) の等差数列lazy segment treeは用途・APIが異なります。PRのコードは取り込んでいません。
- 根の全要素を候補に順位の添字で二分探索するk番目検索を両版に実装しました。任意のTに値域の算術二分探索を仮定せず、最悪O(log³ N)です。
- 既存コード・hookの変更はありません。AGENTS.mdを確認しました。checkoutの `.agents/skills` は存在しませんでした。

## 結果

Linux amd64、C++ backend、Nim **1.6.20 / 2.2.4** の両方で以下が成功しました。

| 検証 | 結果 |
| --- | --- |
| 新規Nim回帰、debug | 両版成功 |
| 新規Nim回帰、release・stress | 両版成功。N=65,537、2,000回の更新検索 |
| 新規Nim回帰の乱数部分 | 静的48 seeds × 200検索、動的48 seeds × 600更新検索 |
| Python独立oracle | 各版24 seeds × 2,000操作。静的・動的、全個数API、前駆・後継、k番目を比較 |
| Nim expanderの4形式 | 通常、single-line、compress、compress+original-source。各形式・各Nim版で同じPython oracleの48,000操作と一致 |
| 展開後の独自型・境界・乱数回帰 | 両版releaseで成功。cplibの検索パスなしでコンパイル |
| 既存expander回帰suite | 両版4テスト成功 |
| range_kth_smallestの新規verify driver | 両版debug/releaseでローカル入力例を確認 |
| ドキュメントのコード例・単独import | 両版でコード例を実行。静的版の単独importはverify driver、動的版の単独importは文字列で全APIを確認 |
| 既存依存・関連構造の回帰 | AVL set、AVL node、range set、convex hull trick、static range count、wavelet matrix、wavelet matrix fenwick、compressed segtree2d。両版debug/releaseで成功 |
| 新規ファイルの空白検査 | `git diff --no-index --check` で成功 |

固定ケースには空・単点・全同値・重複・負値・整数の最小最大・存在しない境界・全端区間・空区間・逆向きの値域・同値更新・繰り返し更新・初期列にない更新値・入力列のコピーを含めました。
generic型は文字列・int64・float・独自の比較を持つobjectと、静的版では `<` のみを定義したobjectを確認しました。
oracleは区間内の単純走査と独立ソートです。Python側はライブラリの探索・更新コードを再利用していません。

## 再現

リポジトリのルートから各バージョンのnimを指定します。生成物を別ディレクトリへ出す例です。

```sh
nim cpp -r --hints:off --path:src --nimcache:/tmp/mst-debug-cache --out:/tmp/mst-debug src/verify/collections/mergesorttree_test.nim
nim cpp -r --hints:off -d:release -d:mergeSortTreeStress --path:src --nimcache:/tmp/mst-stress-cache --out:/tmp/mst-stress src/verify/collections/mergesorttree_test.nim
python3 tools/mergesorttree/test_mergesorttree.py --nim /path/to/nim --expand
NIM=/path/to/nim python3 tools/expander/test_expander.py
```

関連回帰は `src/verify/AI/{avlset,avltreenode,rangeset,staticrangecount,waveletmatrix,waveletmatrix_fenwick,compressed_segtree2d}_test.nim` と `src/verify/collections/convex_hull_trick_test.nim` を、それぞれ `nim cpp -r --hints:off --path:src` および `-d:release` で実行します。

全ライブラリの全verify、32bit環境、judgeの公式全ケース・時間制限は未検証です。
judgeへの提出は行っていません。CIの結果はPR説明で確認してください。
