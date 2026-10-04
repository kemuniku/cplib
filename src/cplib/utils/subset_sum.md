# 部分和の判定

```nim
import cplib/utils/subset_sum

assert solve_subset_sum([6, 4], 4)
assert not solve_subset_sum([6, 4], 5)
assert solve_subset_sum([0, 3, 3], 6)
assert solve_subset_sum(newSeq[int](), 0)
```

`solve_subset_sum(a: openArray[int], target: int): bool` は、非負整数列の各要素を
高々1回選んで和を `target` にできるか返す。重複する値も別々の要素として扱う。
空集合を許し、空列や0だけの列でもtarget=0ならtrue。負のtargetと利用可能な
総和を超えるtargetはfalse。負の要素は、target=0や負のtargetの場合も
`ValueError`。入力を変更しない。単一targetの判定のみを提供し、全和の列挙や
選択した添字の復元は行わない。

Nを入力長、Dをtarget以下の正の要素の最大値（なければ0）とすると、
時間はO(N(D+1)+1)、追加領域はO(D+1)。正の要素がある通常の場合は
O(ND)時間・O(D)領域で、D <= max(a)なので要求のO(N max(a))を満たす。
target=0、利用可能な総和不足、利用可能な正の要素が全同値の場合などはO(N)。
0やtarget超の要素は選ぶ必要がないため、コピーを作らず読み飛ばす。
複数のtargetを問い合わせると、この計算を問い合わせごとに行う。

総和はtargetで飽和させ、加算前に残量を比較する。総和・N*D・target+Dを
intで表せることは要求しない。DPの添字はtargetからの差だけで計算する。
長さ2Dのint配列2本の合計バイト数をintで表せない場合は、
配列を作る前に `ValueError`。各配列のバイト数をint上限の半分以下に抑え、
配列ヘッダなどの加算にも余裕を持たせる。このサイズ検査は利用可能メモリの保証ではない。
DPに入る場合は2配列で `4 * D * sizeof(int)` bytesの要素領域が必要になり、
allocatorなどの領域が別途必要。Dが非常に大きい用途では他の手法を検討する。

## アルゴリズムと正しさ

Pisingerのbalanced fillingによるDPを、判定用に実装している。
以下では0とtarget超の要素を除いた正整数列を考える（実装では元の添字を使う）。

最初に、先頭から足して次の要素でtargetを超える直前のprefix Pを選ぶ。
途中でtargetになればtrue。総和が足りない場合は先にfalseを返しているため、
それ以外では境目 `split` が存在し、Pの和はtarget-Dより大きくtarget未満になる。
以降、和がtarget未満ならsuffixの要素を追加し、targetより大きければ
prefixの要素を除去する。各要素がD以下なので、これらの操作の途中の和は
`[target-D, target+D)` に収まる。

targetを作る部分集合Tが存在するとき、PからTへは、Tに含まれるsuffixの
要素を添字の昇順に追加し、Tに含まれないprefixの要素を添字の降順に除去する
ことで到達できる。現在の和がtarget未満なのに追加すべき要素がなければ、
残りの除去だけでtargetへ到達することはできず、Tの存在と矛盾する。
targetより大きいときの除去についても同様。したがってこの順序と狭い和の
範囲だけを探索しても、targetが作れるなら必ず見つかる。

`dp[j]` は和 `target-D+j` に到達した状態で、まだ除去していないprefixの
先頭区間の排他的上限を表す。-1は未到達。同じ和なら上限が大きい状態ほど
以後に除去できる要素が多いため、最大の上限だけを残せばよい。
suffixの1要素につき旧行をコピーして、target未満の状態からその要素を
高々1回追加する。target超の状態を和の降順に走査してprefixを除去するため、
同じ行で複数回の除去も処理できる。除去後の上限を除去した添字に下げるため、
同じprefix要素を再度除去することはない。全ての到達状態は実際の部分集合を
表すので、targetに到達した場合にfalse positiveはない。

## O(ND)の根拠

コピー・追加・上側の走査は1行O(D)、行数は高々N。
除去は旧行の上限から新しい上限までの増分だけを調べる。
旧行の上限より小さい添字からの除去結果は既に計算されて保持されている。
各和の上限は行を進めても減らず、-1から高々splitまでしか増えない。
よって各上側の和について各prefix添字を調べるのは高々1回で、
除去ループの総反復数もO(ND)。三重ループの最悪時間がO(N²D)になることはない。

## 検証

各Nim executableで、リポジトリのルートから実行する。

```sh
nim cpp -r --path:src --out:/tmp/subset_sum_debug --nimcache:/tmp/subset_sum_debug_cache src/verify/utils/subset_sum_test.nim
nim cpp -r -d:release --path:src --out:/tmp/subset_sum_release --nimcache:/tmp/subset_sum_release_cache src/verify/utils/subset_sum_test.nim
nim cpp -d:release --path:src --out:/tmp/subset_sum_aoj --nimcache:/tmp/subset_sum_aoj_cache src/verify/utils/subset_sum_aoj_test.nim
```

回帰テストでは小さい列の全部分集合列挙と通常のO(N sum(a)) DPを独立oracleとして
用い、全target、固定seed乱数、順序変更、0/target超の要素の挿入、非破壊、空、
重複、全同値、整数境界、配列サイズの拒否を確認する。大きい偶数列と奇数targetで、
早期成功せずに最後までDPを実行するケースも含む。
AOJ ALDS1_5_Aの入出力用driverは複数問い合わせに対して1回ずつ判定する。

ABC221 Gについては、[公式解説](https://atcoder.jp/contests/abc221/editorial/2724)の
45度回転の帰着を使い、2つのtarget `(sum(D)+A+B)/2` と
`(sum(D)+A-B)/2` の整数性・範囲を確認してそれぞれ本APIを呼ぶことで
到達可能性を判定できる。ただし同問題の出力には移動列の復元も必要であり、
本APIだけで提出用の解答にはならない。判定部分のサンプルとローカルoracleを
検証するに留める。

## 実測例

2026-10-04、Linux x86_64 / AMD EPYC 9V74 / g++ 14.2.0、C++ backendの
`-d:release`、既定のメモリ管理で測定した。全要素を偶数、targetを総和の半分付近の
奇数とし、全同値の早期終了も避けて最後までDPを実行する。uniformはDがN-1個と
D-2が1個、denseは2..Dの偶数を決定的に分散させた列。表は各3回のCPU時間の中央値。
入力生成を除き、本API内のallocationを含む。共有VMでCPU固定はしていない。

| N / D | Nim 1.6.20 uniform / dense (秒) | Nim 2.2.4 uniform / dense (秒) |
|---|---:|---:|
| 2000 / 1800 | 0.0077 / 0.0093 | 0.0086 / 0.0104 |
| 5000 / 5000 | 0.0543 / 0.0656 | 0.0636 / 0.0702 |
| 100000 / 10 | 0.0026 / 0.0030 | 0.0026 / 0.0029 |

N=5000,D=5000の2配列の要素領域は160000 bytes。この測定の入力とruntimeを含む
プロセスのpeak RSSは1.6.20で約2.08 MiB、2.2.4で約1.95 MiB
（実行後に `/proc/self/status` のVmHWMを取得）。計算量の証明とは別の実測であり、
他の環境やjudgeでの時間・メモリを保証するものではない。

## 参考

- David Pisinger, *Linear time algorithms for knapsack problems with bounded weights*,
  Journal of Algorithms 33, 1–14 (1999).
  [著者の書誌](https://hjemmesider.diku.dk/~pisinger/publications/sort_date.html#1999)
- [Pisinger の Subset Sum](https://qiita.com/lowking/items/a9393f6afb9a4e662c38)
- [ABC221 GのPisinger法によるユーザー解説](https://atcoder.jp/contests/abc221/editorial/2741)

参照資料のコードは移植・同梱せず、状態と遷移の説明から実装した。
