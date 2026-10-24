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
各行 `n=aB` の前半だけで `invFact[k] * invFact[n-k]` を累積し、
保存時にだけ `fact[n]` を掛ける。`C(n,k)=fact[n]*invFact[k]*invFact[n-k]` なので
同じ prefix が得られ、訪問ごとの法乗算は1回になる。
`S(n,k)=2^n-S(n,n-k-1)` により、後半の保存値も前半から復元する。
保存点 `k=bB` の反射元は `(a-b)B-1` であり、次の保存位置と列番号を持てば
内側ループで剰余・除算を行う必要もない。
前計算時間は `O(N + sum(floor(aB/2)+1)) = O(N + N^2/B)`。
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

2026-10-24、Nim 2.2.4 / C++ (GCC 13) / `-d:release`、型は `modint998244353_barrett`。
最終統合版を各 N で3回、固定 seed 1085 の100000クエリで測定した。
CPU 秒は3回の中央値、RSS は3回の最大値。`-d:danger`、`-march=native`、LTO は使っていない。
構築はコンストラクタ全体、照会は prefixSum 100000回を別々に計測し、
クエリ生成と計測後の恒等式検査は時間に含めない。
RSS は入力クエリ配列・ランタイム・前計算の一時配列を含むプロセス全体の最大値。

| N | 保存したサンプル数 | 構築 CPU 秒 | 照会 CPU 秒 | 最大 RSS (KiB) |
|---:|---:|---:|---:|---:|
| 10000 | 5050 | 0.0022 | 0.0847 | 3564 |
| 40000 | 20100 | 0.0090 | 0.1642 | 3948 |
| 160000 | 80200 | 0.0571 | 0.3297 | 6244 |
| 200000 | 100128 | 0.0781 | 0.3714 | 7048 |
| 640000 | 320400 | 0.4244 | 0.6635 | 15084 |

同じ条件・同じ測定セットで高速化前の実装（9ba1546）も比較した。
N=200000 の構築は 0.6867 秒から 0.0781 秒（約 8.8 倍高速）になった。
N=640000 の構築は 3.9514 秒から 0.4244 秒（約 9.3 倍高速）になった。
照会コードは変更していない。N=640000 の係数訪問数は256000400から128000400へ半減し、
訪問ごとの法乗算も2回から1回になり、内側ループの剰余・除算を除去した。

Nim 1.6.20 / 2.2.4 それぞれ debug と release（`--assertions:off`）の回帰を通過。
構築上限0〜64を全探索し、行と幅の奇偶、中央の反射点を含めて検査する。
Nim 2.2.4 の UBSan 付き実行、および expander で展開した回帰コードのコンパイル・実行も通過。
さらに N=200000 / 640000 で各20000件の prefix と range を高速化前の実装と直接比較し、一致を確認した。
