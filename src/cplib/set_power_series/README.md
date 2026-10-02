# 集合冪級数

`cplib/set_power_series/set_power_series` は
`R[x_0,…,x_{n-1}]/(x_0²,…,x_{n-1}²)` の演算を扱います。
添字の立っているbitが変数の集合を表し、係数列の長さは正の `2^n` です。
長さ1は変数がない定数です。集合冪級数の空入力・非2冪長はassertで拒否します。
普通のFPSと区別するため、関数名には `set` を付けています。

| API | 定義・条件 |
|---|---|
| `setExp(s)` | `Σ_{k=0}^n s^k/k!`。`s[0]=0`、素数法がnより大きいこと |
| `setLog(s)` | `Σ_{k=1}^n (-1)^(k-1)(s-1)^k/k`。`s[0]=1`、素数法がnより大きいこと |
| `setInv(s)` | subset積での逆元。定数項が単元であること |
| `setPow(s, exponent: int)` | 整数冪。0乗は恒等元、非負指数は非単元にも対応、負指数は単元のみ。`low(int)`にも対応 |
| `setSqrt(s, constantRoot)` | 指定した定数項を持つ平方根。`constantRoot²=s[0]`、2とs[0]が単元であること。全零入力とroot=0は全零を返す |
| `polynomialCompositeSetPowerSeries(f, s)` | 普通の多項式 `f` を集合冪級数 `s` に合成。s[0]は任意、fは空（零多項式）や高次数でもよい |
| `setPowerProjection(s, weights, m)` | 長さmの列 `ans[k]=Σ_S weights[S]*(s^k)[S]`、`k=0..<m`。s[0]は任意、m≥0、重みはsと同長 |

係数型はcplibのstatic/dynamic Barrett・Montgomery modintです。
inv/pow/composition/projectionは小標数と合成数法にも対応します。
単元は「逆元が存在する要素」です。合成数法の非零定数項でも単元とは限りません。
sqrtは2の可逆性を要求するため標数2には対応しません。
定数項0で非零の集合冪級数のsqrtはassertで未対応として拒否します。
これは根の不存在判定ではありません。例えばx₀x₁は奇標数で根を持ちますが一意ではありません。
通常FPSのvaluationによる係数シフトは集合冪級数には適用できません。

基本演算は `O(n² 2^n)` 時間・`O(n 2^n)` 追加領域です。
powはさらに `O(n log(|exponent|+1))`、合成は `O(n f.len)`、冪射影は `O(n m)` 時間です。
合成は `f^(k)(s[0])` と変数ごとのsubset積で計算し、冪射影はその線形写像を転置します。
階乗の逆元を使わないため、合成・冪射影はnを超える小標数でも計算できます。
全APIは入力の係数列を変更しません。前提条件のassertは `--assertions:off` 等では無効になるため、呼び出し側が条件を守る必要があります。

## 集合変換と畳み込み

- `cplib/convolution/set_transform`: `subsetZetaTransform` / `subsetMobiusTransform`、`supersetZetaTransform` / `supersetMobiusTransform`。`var seq[T]` をその場で変換、`O(n 2^n)` 時間・`O(1)` 追加領域。
- `cplib/convolution/bitwise_or_convolution`: `bitwiseOrConvolution(a,b)` は `c[S]=Σ_{U or V=S}a[U]b[V]`。`O(n 2^n)` 時間・`O(2^n)` 追加領域。
- `cplib/convolution/subset_convolution`: `subsetConvolution(a,b)` は `c[S]=Σ_{U⊆S}a[U]b[S xor U]`。`O(n² 2^n)` 時間・`O(n 2^n)` 追加領域。

変換は加減算、畳み込みは加減乗算が使える係数型を対象とし、整数も利用できます。
演算途中の値は係数型で表現できる必要があります。
上記の変換と畳み込みは空列を許容します。畳み込みの2入力は同長で、空でなければ2冪長です。

n=20ではrank表1本が `(n+1)*2^n` 個の係数（4byteのmodintで84MiB）、subset積では2本必要です。
配列のコピー・メモリ管理・入出力領域も使うので、実際のpeak RSSはこれより大きくなります。
2冪サイズの制限を越えてnを増やす際は、指数的な時間・領域の増加に注意してください。

## ローカル最大規模の確認

Library CheckerのPR本文に記載した生成器commitを使い、
全公式ケースをNim 1.6.20 / 2.2.4のC++ releaseで参照出力と比較しています。
AMD EPYC 9V74 / Linux x86_64、コンパイラ既定のメモリ管理とC++最適化で、
公式n=20のmax_random各3入力のend-to-end実測は次の範囲でした。
並行した検証中の単発測定なので、速度保証・コンパイラ間の性能比較には使えません。

| 演算 | Nim 1.6.20 wall秒 / peak MiB | Nim 2.2.4 wall秒 / peak MiB |
|---|---|---|
| subset convolution | 1.80–2.80 / 182.0–182.3 | 2.03–3.08 / 181.5–181.6 |
| exp | 1.58–2.13 / 147.1–147.4 | 1.72–2.10 / 99.8 |
| log | 2.89–2.99 / 162.5–162.6 | 2.78–2.92 / 119.1–119.9 |
| composition | 2.78–2.91 / 162.9 | 2.81–3.08 / 144.2–144.5 |
| power projection | 3.15–3.32 / 160.5 | 2.75–2.93 / 104.4–111.5 |

inv/pow/sqrtもn=20の閉形式に両版で一致しました。
公式規模で最大約183MiBを使用しており、メモリ上限を決める際は実測値に余裕を持たせてください。

## 仕様・アルゴリズムの参考資料

- [Library Checkerの集合冪級数問題](https://github.com/yosupo06/library-checker-problems/tree/master/set_power_series)
- [Elegia: Optimal Algorithm on Polynomial Composite Set Power Series](https://codeforces.com/blog/entry/92183) の変数ごとの微分・subset積と転置原理

上記の数学的な定義とアルゴリズムに基づいてNim実装を新規に記述しています。
外部C++実装を移植・同梱していません。外部の公式生成器・参照解はローカル検証用で、PRには含めません。
