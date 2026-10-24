# オンライン二項係数 prefix sum

`import cplib/math/online_combination_prefix_sum`

```nim
import cplib/modint/modint
import cplib/math/online_combination_prefix_sum

let sums = initOnlineCombinationPrefixSum[modint998244353_barrett](100000)
assert sums.prefixSum(4, 2).val == 11 # 1 + 4 + 6
assert sums.rangeSum(4, 1, 3).val == 10 # 4 + 6
assert sums.prefixSum(0, 0).val == 1
assert sums.prefixSum(4, -1).val == 0
```

## API・制約

- `initOnlineCombinationPrefixSum[ModInt](maxN)` は `OnlineCombinationPrefixSum[ModInt]` を返す。`N = maxN` は非負。
- `prefixSum(n, k)` は **右端を含む** `sum(i=0..k, C(n,i))`。`k < 0` は 0、`k >= n` は `2^n`。
- `rangeSum(n, l, r)` は **右端を含まない** `sum(i=l..<r, C(n,i))`。`[0,n]` 外の項を 0 とし、`l >= r` は 0。
- `0 <= n <= N < p`、法 `p` は **素数**。既存の `initCombination` と同じ階乗・逆階乗方式を使う。素数性の判定はしないので呼び出し側で保証する。
- cplib の static/dynamic Barrett・Montgomery modint に対応。dynamic の法は構築前に設定し、使用中は変更しない。法 2 は Barrett で `N <= 1` の場合に対応する。
- 上限が負、上限が法以上、照会の `n` が範囲外、照会時の法が構築時と異なる場合は `ValueError`。空区間でも `n` と法を検査する。assertions を無効にしても有効。
- `k,l,r` は任意の `int`（`low(int)` / `high(int)` を含む）。`n` が負の場合を 0 とする規約ではない。
- コンストラクタで生成したオブジェクトを使う。デフォルト初期化したオブジェクトは使わない。

クエリ列の事前取得・整列・状態更新は不要。直前の答えに依存するクエリも受け取れる。
既存の `combination_prefix_sum.nim` は Mo 法によるオフライン版で、本モジュールとは独立して共存する。

## 計算量と仕組み

`S(n,k) = sum(i=0..k, C(n,i))` とする。
`B = floor(sqrt(N)) + 1`、`m = floor(N/B) + 1` とし、
`S(aB,bB)`（`0 <= b <= a < m`）だけを保存する。
各行 `aB` の二項係数を順番に足すことで、前計算時間は
`O(N + sum(aB+1)) = O(N + N^2/B)`。
表は **m(m+1)/2 要素**、階乗・逆階乗・2 の累乗は各 `N+1` 要素なので、
構築中の補助配列を含めて **O(N+1) 空間**。全行の prefix を保存しない。

照会は `n0 = floor(n/B)B`, `k0 = floor(k/B)B` に対し、保存した `S(n0,k0)` から

```
S(x+1,k0) = 2*S(x,k0) - C(x,k0)
S(n,y+1)  = S(n,y) + C(n,y+1)
```

で移動する。最初に n 座標を動かし、次に k 座標を動かす。
各方向は最大 `B-1` 回、各更新は O(1)。従って prefix/range とも
**O(sqrt(N+1)) 時間、O(1) 補助空間**。
`N >= 1` では要求通り **前計算 O(N sqrt(N))、空間 O(N)、クエリ O(sqrt(N))**。
除算による逆向き移動は不要。

[Issue #1085](https://github.com/kemuniku/cplib/issues/1085) と
[リンク先解説](https://atcoder.jp/contests/abc384/editorial/11567) の間引き・差分計算の考え方を参考にした。
リンク先は Abs Sum のオフライン差分計算であり、二項係数専用のオンライン実装そのものではない。
本実装では二方向を間引き、上記の二項係数の恒等式を利用してオンライン照会と線形空間を両立する。

## 検証

`src/verify/math/online_combination_prefix_sum_test.nim` は、独立に加算だけで作った
Pascal 三角形との全探索比較、固定 seed 1085 のオンライン乱数照会、
空区間・整数上下限・平方数前後のブロック境界・不正入力・小素数・法の変更を検査する。
static 2 法 × Barrett/Montgomery、dynamic Barrett/Montgomery、Barrett の法 2 を使用する。
既存オフライン版との照合も行う。

```sh
nim cpp --path:src -r src/verify/math/online_combination_prefix_sum_test.nim
nim cpp --path:src -d:release --assertions:off -r src/verify/math/online_combination_prefix_sum_test.nim
nim cpp --path:src -d:release -o:/tmp/bench-online-prefix tools/bench_online_combination_prefix_sum.nim
/usr/bin/time -f 'peak_RSS_KiB=%M' /tmp/bench-online-prefix 160000 100000
```

ベンチマークは構築・照会 CPU 秒、表の要素数、checksum を出力する。
時間計測後に大きな座標で対称性と Pascal の恒等式も検査する。
N を 4 倍ずつ（10000, 40000, 160000, 640000）増やすと、
理論上は構築が約 8 倍、同数クエリが約 2 倍、表の要素数が約 4 倍になる。
実時間/RSS はコンパイラ・メモリ管理・環境に依存する。

### VM101 での測定例

2026-10-24、Nim 2.2.4 / C++ / `-d:release`、各プロセス 100000 クエリ。
RSS は入力クエリ配列・ランタイム・前計算の一時配列を含むプロセス全体の最大値。

| N | 保存したサンプル数 | 構築 CPU 秒 | 照会 CPU 秒 | 最大 RSS (KiB) |
|---:|---:|---:|---:|---:|
| 10000 | 5050 | 0.0103 | 0.0879 | 3588 |
| 40000 | 20100 | 0.0659 | 0.1648 | 3940 |
| 160000 | 80200 | 0.4956 | 0.3301 | 6244 |
| 640000 | 320400 | 3.9623 | 0.6625 | 15080 |

Nim 1.6.20 / 2.2.4 それぞれ debug と release（`--assertions:off`）の回帰を通過。
Nim 2.2.4 の UBSan 付き実行、および expander で展開した回帰コードのコンパイル・実行も通過。
