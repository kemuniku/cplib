# O(1) 照会の平方分割 rangesum

`root_rangesum_query` は加減算型の配列に対する点代入と区間和を扱います。
既存 `RootRangeSum` の更新 O(1)・照会 O(√N) と逆の使い分けです。

```nim
import cplib/collections/root_rangesum_query
let rs = initRootRangeSumQuery([1, 2, 3, 4, 5])
assert rs.prefix(3) == 6
assert rs.get(1, 4) == 9
assert rs[1..<4] == 9
rs.update(2, 10)
rs[^1] = rs[^1] + 2
assert rs.get(0, rs.len) == 24
```

## API と制約

- `initRootRangeSumQuery(v: openArray[T], bsize = 0, e: T = 0)` は入力をコピーした累積和を構築します。元の配列と更新を共有しません。
- `len`、一点の `rs[i]` / `rs[^i]`、`prefix(r)`、`get(l,r)`、`get(l..r)` / `rs[l..r]` を提供します。
- `prefix(r)` は [0,r)、`get(l,r)` は [l,r)、slice は両端を含みます。`l..<r`、空区間、空配列の `prefix(0)` / `get(0,0)` に対応します。
- `update(i,val)` / `rs[i]=val` / `rs[^i]=val` は点代入です。点加算は `rs[i]=rs[i]+delta` とします。
- `bsize=0` は `max(floor(sqrt(N)),1)`。正の指定幅は `max(N,1)` 以下に制限します。負の幅、範囲外の添字・区間は assert の前提違反です。assertions off / danger では不正入力を検査しません。
- `T` の `+` / `-` は O(1) の可換群演算、`e` は加法単位元が必要です。独自型や ModInt は単位元を明示できます。比較、乗算、整数からの変換は必須ではありません。
- 整数では構築時の各累積和、一点を取り出す差、更新差分、更新途中の累積和、prefix の和、区間差のすべてが型の表現範囲内である必要があります。最終的な回答だけが収まる条件では不十分です。任意精度型では以下の演算回数にその演算コストが掛かります。
- 浮動小数点は結合則が厳密には成立せず、直接総和との一致や更新を繰り返したときの誤差保証はありません。
- ref object なので、ライブラリオブジェクト自身の別名は更新を共有します。

## 計算量と正当性

幅 B の各ブロックで、先頭から各要素までの `localPrefix` を保持します。
`blockPrefix[b]` は b 個のブロック全体の和です。
`prefix(r)` は `blockPrefix[r div B]` と、端数がある場合だけ
`localPrefix[r-1]` を加えます。最大1加算です。
区間和は `prefix(r)-prefix(l)` なので最大2加算・1減算、O(1) です。
ブロック境界、最終端 N、最後の不完全ブロックでも同じ式が成立します。

点代入は元の一点をブロック内の差から求め、差分をそのブロック内の
更新位置以降と、そのブロックを含む `blockPrefix` の全 suffix に加えます。
更新位置を含む累積和だけが変わるため、不変条件が保存されます。
処理要素数は最大 B+ceil(N/B)、時間 O(B+ceil(N/B))。
既定 B≈√N で更新 O(√N)、構築 O(N)、保存領域 O(N)、更新の補助領域 O(1) です。
指定幅が1またはNなら更新は O(N) になります。

## 検証の再現

回帰は `src/verify/collections/root_rangesum_query_test.nim` です。
固定 seed の配列を直接総和する独立 oracle と全区間を比較し、
空配列、平方数の前後、幅1・N超・int上限、負の値、同値代入、点加算、
slice・末尾添字、入力保持、int64上下限、独自型、ModInt を検査します。
演算を数える型で、N が100000まで増えても照会の演算回数が一定であることと
更新の演算数上限を確認します。時間測定には依存しません。
Library Checker 用 verify は `root_rangesum_query_yosupo_test.nim` です。

Nim 1.6.20 と 2.2.4 それぞれで以下を実行します。

```sh
nim cpp --path:src --nimcache:/tmp/rsq-debug-cache -o:/tmp/rsq-debug -r src/verify/collections/root_rangesum_query_test.nim
nim cpp --path:src -d:release --assertions:off --nimcache:/tmp/rsq-release-cache -o:/tmp/rsq-release -r src/verify/collections/root_rangesum_query_test.nim
```

既存の RootRangeSum / Fenwick / backwards_index / ModInt 回帰と
Nim expander の通常・single-line・compress・compress/original-source 展開も確認します。
新設テストは verify ファイルのみで、専用 CI・helper・benchmark は追加しません。
