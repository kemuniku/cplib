# 写像12相

`cplib/math/twelvefold_way` は n 個の球を m 個の箱に入れる方法を、球と箱の区別の有無、箱の容量制限で数えます。空箱も含めて箱数は m 個です。

```nim
import atcoder/modint
import cplib/math/twelvefold_way

let c = initTwelvefoldWay[modint998244353](400, 400)
echo c.count(3, 2, distinctBalls, distinctBoxes).val # 8
echo c.count(3, 2, identicalBalls, identicalBoxes, surjective).val # 1
let all = c.countAll(3, 2)
echo all[distinctBalls][identicalBoxes][unrestricted].val # 4
echo c.stirlingSecond(3, 2).val # 3
echo c.partitionCount(3, 2).val # 1
```

`injective` は各箱高々1球、`surjective` はすべての箱が非空、`unrestricted` は制限なしです。区別を消した場合は、球・箱の置換で移り合う配置を同じ方法とみなします。

S(n,k) を第二種Stirling数、P(n,k) を n のちょうど k 個の正整数への分割数とすると、n,m > 0 での各値は次の通りです。

| 球 | 箱 | unrestricted | injective | surjective |
|---|---|---|---|---|
| distinctBalls | distinctBoxes | m^n | m!/(m-n)!（n≤m）、それ以外0 | m! S(n,m) |
| identicalBalls | distinctBoxes | C(n+m-1,n) | C(m,n) | C(n-1,m-1) |
| distinctBalls | identicalBoxes | Σ(k=0..m) S(n,k) | n≤mなら1、それ以外0 | S(n,m) |
| identicalBalls | identicalBoxes | Σ(k=0..m) P(n,k) | n≤mなら1、それ以外0 | P(n,m) |

空の配置は一通りです。n=0 では unrestricted/injective は任意の m で1、surjective は m=0 のときだけ1です。n>0,m=0 はすべて0です。S(0,0)=P(0,0)=1、n<m なら S(n,m)=P(n,m)=0 とします。

## 前計算と制約

`initTwelvefoldWay[ModInt](maxN,maxM)` の時間・領域は O((maxN+1)(maxM+1))、`count` / `countAll` / `stirlingSecond` / `partitionCount` は O(1) です。32bit法の演算を定数時間として扱います。3枚の表と階乗・逆階乗を保存するため、4byte modint で maxN=maxM=2000 なら表本体だけで約46MiBです。seq の管理領域と構築中の作業領域も必要です。中規模入力のDP版で、巨大 n やFPSによる高速版は対象外です。

- C++ backend 用です。ModInt は32bit素数法、整数からの変換、`umod()`、加減乗算に対応する型です。既存 `combination` の前計算を利用します。cplib の static/dynamic Barrett/Montgomery、Nim-ACL の static/dynamic modint を確認しています。
- maxN,maxM は非負、maxN+maxM < 法が必要です。階乗逆元を正しく扱うための制約で、法の素数性も構築時に検査します。
- クエリは 0≤n≤maxN, 0≤m≤maxM の範囲です。n<m や0箱を計算する場合も前計算範囲内で呼び出してください。
- 不正な上限・法、未初期化、範囲外クエリ、構築時と異なるdynamic法は `ValueError` です。assertを無効にしても検査します。dynamic法は使用中に変更しないでください。

Stirling数は S(n,k)=k S(n-1,k)+S(n-1,k-1) を1行の作業配列で計算し、累積和を保存します。整数分割は Q(n,k)=Q(n,k-1)+Q(n-k,k)（n≥k）のDPです。Q(n,k) は各部分の大きさが高々 k の分割数で、分割図の転置により部分数が高々 k の分割数でもあります。各部分から1を引く全単射から P(n,k)=Q(n-k,k) です。累乗表は m^n=m^(n-1) m、残りは二項係数と階乗で計算します。

## 検証

新設の回帰は `src/verify/math/twelvefold_way_test.nim` と `twelvefold_way_acl_test.nim` のみです。前者はcplib型、後者は同じoracleをNim-ACL型で実行します。n,m=0..6 の全配置を列挙し、球・箱の置換を正規化した同値類を各制限別に数えるoracleと12相すべてを比較します。n,m=0..40 の全射を包除原理で、n=0..20 の分割数を正整数の直接列挙で照合します。素数2/3/5/7/13の上限直前、法101での剰余、400×400の表、範囲拒否、合成数法、dynamic法変更も検査します。

```sh
for test in src/verify/math/twelvefold_way{,_acl}_test.nim; do
    nim cpp -r --path:src "$test"
    nim cpp -r -d:release --assertions:off --path:src "$test"
done
```

Nim 1.6.20 / 2.2.4 の両方で実行します。検証中の実行比較には `doAssert` を使い、ライブラリ本体は例外で契約を検査します。
