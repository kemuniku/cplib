# 厳密彩色数と色復元

```nim
import cplib/graph/graph
import cplib/graph/chromatic_number

var g = initUnWeightedUnDirectedGraph(5)
for u in 0..<5: g.add_edge(u, (u + 1) mod 5)
let number = g.chromatic_number() # 3
let coloring = g.chromatic_number_with_coloring()
# coloring.chromaticNumber == 3
# coloring.colors[u] は頂点 u の色（0以上3未満）
```

対象は `0 <= N <= MaxChromaticNumberVertices`（現在18）の一般無向グラフです。
動的・静的、重み付き・重みなしの4種類に対応します。静的グラフは事前に
`build()` が必要です。重みは無視し、多重辺は隣接ビットの OR によって同じ制約に
正規化します。入力グラフは変更しません。有向グラフは受け付けません。
頂点数が範囲外なら配列確保・ビットシフトの前に `ValueError` を送出します。

`chromatic_number()` は最小色数、`chromatic_number_with_coloring()` は
`tuple[chromaticNumber: int, colors: seq[int]]` を返します。正常時の色列は頂点数と
同じ長さで、隣接頂点の色は異なり、色番号は `0..<chromaticNumber` をすべて使います。
最適彩色が複数ある場合、どれを返すかは保証しません。
空グラフは0色と空列、非空の辺なしグラフは1色です。自己ループは適正彩色不可能なので
`-1` と空列を返します。

`independent[S]` は最下位の頂点 `v` を除いた集合が独立であり、`v` の隣接頂点を
含まないかで求めます。`dp[S]` を誘導部分グラフの最小色数とし、`dp[0] = 0`、
独立な非空集合なら `dp[S] = 1`、それ以外は
`dp[S] = min(dp[S \ I] + 1)` とします。`I` は `S` の最下位頂点を含む独立集合です。
任意の彩色にはこの頂点の色クラスが一つあるため、この制限で最適解を失いません。
`S \ I` は真部分集合なので、マスクの昇順で依存先は計算済みです。
採用した `I` を順に取り除くことで最小色数の彩色を復元します。

最下位頂点の隣接頂点を候補から除き、独立な `S` は即座に1色、非独立な `S` は
2色に到達した時点で探索を終了します。最悪時間は `O(3^N + E)`、追加領域は
`O(2^N + N)`、復元自体は `O(N)` です。上限18は指数時間の用途を固定する契約であり、
大規模グラフ向けの API ではありません。
DP は1 byte、独立集合表は1 byte、復元用選択表は4 bytesを各部分集合に使います。
N=18 の配列要素の合計は、数値のみなら512 KiB、復元付きなら1.5 MiBです。
これに隣接マスク・出力 `O(N)` と配列管理情報・アロケータの領域が加わります。
入力グラフ自身の保存領域はこの追加領域に含みません。

整数の最小値 DP なので確率的判定や法を使いません。単一の法による包除の
非零判定を厳密な彩色可能性とみなす方法には依存しません。
検証は `src/verify/graph/chromatic_number_test.nim` にあり、独立した頂点ごとの
バックトラッキング oracle との比較、境界条件、4種類のグラフと色復元を確認します。
