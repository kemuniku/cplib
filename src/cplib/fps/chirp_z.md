# 等比数列上の多点評価（Chirp Z変換）

```nim
import cplib/fps/chirp_z
import cplib/modint/modint

type Mint = modint998244353_barrett
let f = @[Mint(1), Mint(2), Mint(3)] # 1 + 2x + 3x^2
let values = multipointEvaluationGeometric(f, Mint(2), Mint(3), 4)
# f(2), f(6), f(18), f(54): @[17, 121, 1009, 8857]
let same = chirpZ(f, Mint(3), 4, Mint(2))
let fromOne = chirpZ(f, Mint(3), 4) # f(1), f(3), f(9), f(27)
```

`multipointEvaluationGeometric(f, a, r, m)` は係数を低次から並べた `f` に対して、
`f(a*r^i)`（`0 <= i < m`）を返します。第0評価点は `a` です。
`chirpZ(f, r, m, a = 1)` は同じ計算の別名です。`include cplib/fps/fps` からも使えます。
入力の係数列は変更しません。静的・動的の Barrett/Montgomery modint に対応し、
動的な法は入力の構築から計算の終了まで固定してください。

`m >= 0` が必要です。`m = 0` の結果は空、空の `f` は零多項式として扱います。
定数多項式、`a = 0`、`r = 0, 1, -1`、1点だけの評価は直接処理します。
とくに `r = 0` の評価点は `a, 0, 0, ...` なので結果は `f(a), f(0), f(0), ...` です。
点数と係数数が異なっても、2冪でなくても使えます。末尾の零係数も許容します。

`n = f.len` として、法に対して `r` が可逆な場合は既存の `convolution` を1回使い、
時間 `O(M(n+m))`、追加空間 `O(n+m)` です（`M(k)` は長さ `O(k)` の畳み込みの計算量）。
小さい入力では畳み込み自身が素朴法を選びます。
特殊ケースの時間は `O(n+m)`、空・定数・`a=0` は `O(m)` です。
合成数法で `gcd(r, mod) != 1` のときは逆元を使わず Horner 法に切り替え、
時間 `O(n*m)`、出力以外の追加空間 `O(1)` で計算します。

高速経路では `r^(k*(k-1)/2)` とその逆数を逐次乗算で生成します。
指数の二乗や三角数を整数として計算せず、平方根・階乗の逆数・評価点の相異性も要求しません。
係数列の長さは `n`、畳み込み相手は `n+m-1`、積の長さは `2n+m-2` です。
配列長とその和は `int` に収まる必要があります。

法と最大長の条件は既存の畳み込みに従います。NTTが使えればその法の根の容量以内、
それ以外のCRT経路は `1 <= mod < 2^31`、積の長さを切り上げた2冪が `2^24` 以下です。
Montgomery modint は既存の奇数法 `mod < 2^30` の制約にも従います。
法 `998244353` の直接NTT容量は `2^23` で、公式問題の `n,m <= 524288` を満たします。
整数の `a,r` は呼び出す前に `init(Mint, value)` 等で正規化してください。

三角指数による畳み込みへの帰着は
[NyaanNyaan/library の chirp-z.hpp](https://github.com/NyaanNyaan/library/blob/master/ntt/chirp-z.hpp)
（[CC0-1.0](https://github.com/NyaanNyaan/library/blob/master/LICENSE)）を参考にしています。
公式検証先は [Multipoint Evaluation (Geometric Sequence)](https://judge.yosupo.jp/problem/multipoint_evaluation_on_geometric_sequence) です。
