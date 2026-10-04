# 添字XORセグメントツリー

`import cplib/collections/xor_segtree` で使用する。

`get(l, r, mask)` は元の配列 `a` に対して、半開区間 `[l,r)` の
`a[l xor mask], a[(l+1) xor mask], ..., a[(r-1) xor mask]` をこの順番で
`merge` する。値そのもののXOR集約とは異なる。`mask` の省略値は0で、
空区間の結果は単位元 `default` になる。

```nim
import cplib/collections/xor_segtree

proc add(x, y: int): int = x + y
let seg = initXORSegmentTree(@[1, 2, 3, 4], add, 0)
assert seg.get(0, 2, 1) == 3 # 元の添字1, 0
seg[0] = 10
assert seg.get(0, 2, 1) == 12

proc join(x, y: string): string = x & y
let ordered = initStaticXORSegmentTree(@["a", "b", "c", "d"], join, "")
assert ordered.get(0, 3, 1) == "bad" # 元の添字1, 0, 3
assert ordered.get_all(3) == "dcba"
```

## APIと制約

| 型 / API | 用途 / 計算量 |
| --- | --- |
| `initXORSegmentTree(v, merge, default)` | 可換モノイド。構築O(N)、領域O(N) |
| `initXORSegmentTree(n, merge, default)` | N個の単位元で可換版を構築 |
| `initStaticXORSegmentTree(v, merge, default)` | 可換性を要求しない静的版。構築・領域O(N(1+log N)) |
| `get(l, r, mask = 0)` | 両型でO(1+log N) |
| `get_all(mask = 0)` | 両型でO(1) |
| `len`, `seg[i]` | 元の長さ、元の添字の値。O(1) |
| `update(i, value)`, `seg[i] = value` | 可換版のみ、元の添字への点代入。O(1+log N) |

- Nは正の2冪で、`2*N <= high(int)` を満たす必要がある。空列や非2冪長は
  自動でパディングせず拒否する。N=1、`[0,0)`、`[N,N)` は利用できる。
- `0 <= l <= r <= N`、`0 <= mask < N`、`0 <= i < N` を要求する。
  違反はassertの設定にかかわらず `ValueError` になる。
- `merge` は結合則、`default` は左右の単位元を満たす必要がある。
  可換版ではさらに可換性を要求する。これらの代数的性質は実行時には検査しない。
  `merge` は入力を変更せず、構築後に意味が変わらない演算を指定する。
- 静的版は点更新を提供しない。非可換の点更新をO(log N)にする保証はしない。
  添字XORによる並べ替えはqueryごとの引数で指定し、元の配列は変更しない。
- 計算量は要素のコピー・`merge` がO(1)のときのもの。文字列連結の例は順序の
  説明用で、連結長に比例する時間・領域が別途必要になる。機械整数の中間値の
  オーバーフローを避けることと、必要領域を確保できることは利用側の前提となる。

## 計算量と順序の根拠

通常のセグ木と同じく、query区間を各高さで高々2個の整列した2冪区間に分解する。
高さhのノード番号をpとすると、元配列上の対応ノードは `p xor (mask shr h)`。
低いhビットはそのノード内の順列だけを変更する。可換版ではノードの集合としての
積は変わらないため、通常のセグ木と同じ2N要素で十分となる。点代入も元の添字の
祖先だけを再計算する。

静的版では高さhごとにN要素を持つ。各長さ `2^h` のブロックについて、低いhビットの
全maskの積を保存する。下位maskが同じ2つの子の積を、最高ビットが0なら左・右、
1なら右・左の順に合成する。各高さでN回の合成なので構築はN log N回、保存は
N(1+log N)要素となる。queryでは上位ビットで対応ブロックを求め、下位ビットで
保存済みの積を選ぶ。左右の累積結果を別々に保持して合成順序を保つため、非可換でも
O(log N)個のブロック参照・合成で結果を得られる。全区間の全maskの積は最上段にある。

## 検証

`src/verify/AI/xor_segtree_test.nim` は、元配列を `i xor mask` で直接参照する
独立oracleと比較する。N=1..16の全mask・全半開区間、可換版の繰り返し点更新、
既存通常セグ木とのmask=0での一致、文字列による完全な順序比較、アフィン関数を
一点ずつ評価した非可換oracle、固定seedのランダム更新/query、全区間、空区間、
無効な長さ・区間・mask・添字を検査する。N=32768で構築・更新・query・全区間queryの
合成回数も確認する。テストは既存verify CIのC++ release構成で実行される。

## 参照

- [issue #577と実装対象のコメント](https://github.com/kemuniku/cplib/issues/577)
- [XOR Segment Treeの原解説](https://codeforces.com/blog/entry/105723)
- [issueが挙げたyukicoder解説](https://yukicoder.me/problems/no/2265/editorial)

issueの全2コメントで提案された「可換＋更新可能」「非可換＋static」を実装する。
yukicoder No.2265の非可換かつ更新付きの問題全体を汎用O(log N)更新で解くものではない。
その解説本文は調査環境から取得できず、構造・計算量の確認は原解説とissueコメントに基づく。
