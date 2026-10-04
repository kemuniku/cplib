# 永続平衡列とmultiset

issue [#677](https://github.com/kemuniku/cplib/issues/677) の本文と全3コメントを確認し、モノイドなし列、モノイド列、遅延伝播、永続multisetを実装した。本文・コメントが参照する提出77411622 / 77449442 / 77472639 / 77473710は取得できなかったため、提出の実装やAPIを再現したとは主張しない。既存のmutableなrange_reverse系とは独立したAPIである。

## 採用原理

各要素を節点に持つimplicit AVL木を、更新経路のpath-copyで永続化する。左右の子、高さ、要素数、値、順方向・逆方向の積、遅延作用と保留フラグ、反転フラグを非公開で保持する。生成後の節点は公開APIから変更しない。根と演算設定を持つ値型のwrapperをコピーすれば、O(1)で過去版を保存できる。更新は常に新しいwrapperを返す。`s[k] = value`も変数sの差し替えだけを行う。

最初の候補だったpriority固定のtreapでは、同一・重複部分木の連結によって同じpriorityが繰り返され、通常の独立な乱数priorityの解析を適用できなくなる。AVLの高さ差に基づくjoinを採用し、`s.concat(s)`や過去版の部分木を連結する場合も平衡を保証する。木の高さは論理要素数Nに対してO(log(N+1))。共有された実体はDAGだが、左右への参照は別々の論理的な出現として数える。

`join(left,value,right)`は高さの大きい側をたどり、復路で新しい節点を作り回転する。回転前には遅延状態を複製した子にだけ伝播する。joinの時間・新規節点数はO(|高さ差|+1)。splitは境界経路に沿って分割しjoinで復元する。復元の高さ差の和は経路の高さにより制限され、split全体はO(log(N+1))。concatは右の最初の要素を取り出してjoinする。

反転では複製した節点の子と順逆の積を交換し、子に反映するフラグを反転する。遅延作用では複製した節点の値と順逆の積を更新し、作用を合成する。読み取りは祖先の作用と反転を引数で渡すだけで、節点を変更・複製しない。

## 列API

```nim
import cplib/collections/persistent_sequence

let original = initPersistentSequence(@[1, 2, 3],
    proc(a, b: int): int = a + b, 0)
let inserted = original.insert(1, 9)  # [1,9,2,3]
let reversed = inserted.reverse(0, 4)
let parts = reversed.split(2)
let restored = parts.left.concat(parts.right)
assert original.to_seq == @[1,2,3]
assert restored.prod(1, 3) == 11
let independentValues = original.from_seq(@[4, 5])
let joined = original.concat(independentValues)
assert joined.to_seq == @[1,2,3,4,5]
```

- `initPersistentSequence(values)`はモノイドなし。任意の値型に使え、prod/get_allはValueError。
- `initPersistentSequence(values,op,e)`は結合的なopと単位元eを持つ列。非可換opにも対応する。
- `initPersistentLazySequence(values,op,e,mapping,aggregateMapping,composition,id)`は遅延作用付き。
- `from_seq(values)`は同じ演算設定を共有する新しい列を構築する。入力の格納配列は保持しない。
- `len`、`get(k)` / `s[k]`、`update(k,value)` / `s[k]=value`、`insert(k,value)`、`erase(k)`、`erase(l,r)`、`split(k)`、`concat(other)`、`slice(l,r)`、`reverse(l,r)`、`apply(l,r,f)`、`prod(l,r)`、`get_all`、`to_seq`を提供する。
- 添字はint、0始まり。区間は半開[l,r)、空区間も可。insertは0<=k<=len、get/update/単点eraseは0<=k<len。
- concatは同じ演算設定オブジェクトから派生した版だけを受け付ける。別々のinit呼び出しは、同じcallbackを渡しても互換とは扱わない。新しい値からの木が必要ならfrom_seqを使う。設定の意味的な同値性を推測しない。
- `partition_point(predicate)`は要素に対する判定がtrueからfalseへ一度だけ変わる位置を返す。判定は純粋かつO(1)とする。単調性は呼び出し側の契約。

## 作用の契約

`mapping(f,x)`は一点への作用、`aggregateMapping(f,product,length)`はlength個の要素の積への同じ作用である。例えば区間和とaffine作用なら次のように構築する。

```nim
type Affine = tuple[a,b: int64]
let s = initPersistentLazySequence(@[1'i64,2,3],
    proc(a,b: int64): int64 = a+b, 0'i64,
    proc(f: Affine, x: int64): int64 = f.a*x+f.b,
    proc(f: Affine, x: int64, length: int): int64 = f.a*x+f.b*length.int64,
    proc(f,g: Affine): Affine = (f.a*g.a,f.a*g.b+f.b),
    (1'i64,0'i64))
let changed = s.apply(0,3,(2'i64,1'i64)).reverse(0,3)
assert changed.to_seq == @[7'i64,5,3]
assert s.to_seq == @[1'i64,2,3]
```

composition(f,g)はgの後にfを作用させる。idは恒等作用。aggregateMappingは個々のmappingとopによる積に一致し、積の結合と両立すること。作用は位置に依存せず、反転とも可換でなければならない。等差数列のように区間の位置を使う作用はこのAPIの対象外。Fの等値比較は不要。

すべてのcallbackは純粋で、引数や共有された参照先を変更しないこと。値T、作用F、単位元やcallbackが参照する状態に可変な参照・seq等を含めた場合、それらの外部からの変更まで隔離するdeep-copyは行わない。演算の法則と算術のoverflow/法の安定性は利用者が保証する。文字列連結などO(1)でない演算では、以下の計算量にcallbackの実際の費用を加える。

## multiset API

```nim
import cplib/collections/persistent_multiset

let original = initPersistentMultiset(@[3,1,2,1])
let added = original.insert(1)
assert added.count(1) == 3
assert original.count(1) == 2
assert added.lower_bound(2) == 3
let erased = added.erase(1)       # 最初の同値要素一個
let parts = erased.split(2)       # <2 と >=2
assert parts.left.concat(parts.right).to_seq == @[1,1,2,3]
```

- 初期化は標準cmp、または`compare(a,b): int`を受け取る。compareは純粋な厳密弱順序で、符号が順序を表し、0が同値を表す。標準浮動小数点cmpにNaNを含めるなど、この契約を満たさない比較は前提外。
- 一つの論理要素につき一節点を持ち、重複をすべて保持する。初期sortは同値要素の順序を保存する。insertは同値群の末尾、eraseは先頭を対象とする。等値比較は要求せず、同値性は比較の0で決める。
- `len`、`kth(k)` / `s[k]`、`lower_bound(value)`、`upper_bound(value)`、`count(value)`、`contains(value)`、`insert(value)`、`erase(value)`、`erase_all(value)`、`split(value)`、`concat(other)`、`to_seq`を提供する。lower/upper_boundはiteratorではなく重複込みのrankを返す。
- 不在のeraseは同じ版を返す。splitは比較順でvalue未満/以上に分ける。concatは同じ設定から派生した版に限定し、非空ならmax(left)<=min(right)が必要。同値のみの木の自己連結も可。任意の二集合のunionは提供しない。
- キーの変更、列のlazy/反転をmultisetに公開しないので、操作が比較順を破壊しない。

## 計算量・所有権・制約

演算・比較・T/FのコピーがO(1)の場合の計算量:

| 操作 | 時間 | 新規節点 / 結果以外の領域 |
|---|---|---|
| 列初期化・from_seq | O(N) | O(N)（一時的な入力コピーを含む） |
| multiset初期化 | O(N log(N+1)) | O(N) |
| wrapperのコピー、len、get_all | O(1) | O(1) |
| get、prod、partition_point、multiset照会 | O(log(N+1)) | 節点0、再帰領域高々O(log(N+1)) |
| insert/erase/update/split/concat/slice/apply/reverse | O(log(N+1)) | O(log(N+1))節点・再帰領域 |
| to_seq | O(N) | 返り値O(N)、再帰O(log(N+1)) |

concatのNは連結後の長さ。同一部分木を反復連結して論理Nが大きくなってもAVLの保証は変わらない。ただしto_seqは共有実体数ではなく論理Nに比例する。

節点はNimの管理参照で子を保持する。arenaの生ポインタや祖先wrapperの保持に依存せず、元wrapperの破棄後も派生版・split結果・concat結果が共有節点を保持する。参照の循環は作らない。最後の参照がなくなった節点は使用するGC/ARC/ORCに従って回収される。領域量は同時に生存する節点と演算設定に比例する。上表の操作時間は不要版の破棄・GCによる回収時間を含まない。大きな未共有部分の最後の参照を捨てる際は、その回収にO(K)かかり得る。

初期化前のwrapper、範囲外、逆区間、不適合なconcat、nil callback、intに収まらない連結/挿入はValueErrorで拒否し、release/dangerでも検査を維持する。長さは非負intで、追加前にoverflowを検査する。入力値やcallbackの計算で生じるoverflowは別の制約。並列操作に対する同期は提供しない。

Nim 1.6.20 / 2.2.4、Linux x86_64、C++ backendで検証。JS・32bitでの実行は未検証。

## 検証

テストはsrc/verify/collectionsのpersistent_sequence_test.nimとpersistent_multiset_test.nimのみ。標準seqの直接操作・総和・文字列連結・全走査で計算したrankを独立oracleとする。ライブラリのsplit/join/集約式をoracleとして流用しない。

永続列では固定seedの1,600操作を任意の過去版から分岐させ、各版の全要素・全半開区間積とAVL高さ/要素数を確認する。読み取りと更新の前後に元節点の全フィールドのsnapshotを照合し、共有子を変更していないことも検査する。別途、非可換な文字列積と非可換な文字置換の400分岐操作、affine合成順、遅延状態の反転・分割・連結・点更新を検査する。

multisetは1,800分岐操作をソート済みseqと照合する。重複・比較同値だがpayloadの異なる要素・逆順比較・全削除・不在削除・split/concat・整数上下限を含む。元wrapperの寿命終了とGC後の派生版を確認する。列の20,000末尾挿入と10,000先頭削除、同一部分木の自己連結で2^30要素の列/2^24要素のmultiset、int最大長付近とoverflow拒否も確認する。巨大な論理長の木は列挙せず、構造と境界照会を検査する。

再現（repo root、各版のNimと依存を用意）:

```sh
nim cpp --path:src -r src/verify/collections/persistent_sequence_test.nim
nim cpp --path:src -r src/verify/collections/persistent_multiset_test.nim
nim cpp --path:src -d:release --assertions:off -r src/verify/collections/persistent_sequence_test.nim
nim cpp --path:src -d:danger -r src/verify/collections/persistent_sequence_test.nim
```

検証は実装担当の自己検証であり、独立担当によるレビューではない。judgeへの提出は行わない。
