# Trie上の文字列ハンドル

`import cplib/str/trie_string`。既存の多重集合 `Trie` とは別の構造で、
各節点が根からの列そのものを表す。文字列のコピーを作らず、任意の過去の節点から分岐できる。
削除は親ハンドルを返すだけで、過去の節点や辺は破棄しない。

```nim
import cplib/str/trie_string

var a = initTrieStringArray('a'..'z')
let x = a.add(a.root, 'a')
let xy = a.add(x, 'b')
assert a.compare(x, xy) == -1
assert a.lcp(x, xy) == 1
assert a.lcp(xy, xy) == 2
assert a.toString(xy) == "ab"
assert a.toSeq(xy) == @['a', 'b']
assert a[xy, 1] == 'b'
assert a.prefix(xy, 1) == x
assert a.lcpNode(x, xy) == x
assert a.pop(xy) == x
assert a.add(x, 'b') == xy

var d = initTrieStringTable(int)
let p = d.add(d.root, -100)
let q = d.add(d.root, 100)
assert d.compare(p, q) == -1
assert d.toSeq(p) == @[-100]
assert d[p, 0] == -100
```

## APIと契約

| API | 内容 |
|---|---|
| `initTrieStringArray(chars)` | `TrieStringArray[chars]` を作る。既存Trie同様、空でないstaticな `HSlice[char,char]` |
| `initTrieStringTable(T)` | `TrieStringTable[T]` を作る。辞書（標準 `Table`）版 |
| `initTrieString()` / `TrieString` | `Table[char]` 版の短縮名 |
| `root()` | 空列のID `0` |
| `add(node, c)` | 1要素追加。同一 `(node,c)` は常に同じID |
| `pop(node)` | 親ID。根に対しては `0`（既存Trieの `-1` と異なる） |
| `toString(node)` | char版の列をstringに復元（Array / Table[char]） |
| `toSeq(node)` | Array版はseq[char]、Table[T]版はseq[T]に復元 |
| `self[node,index]` | 0始まりの位置の要素（Arrayはchar、Table[T]はT） |
| `prefix(node,length)` | 先頭length要素の既存節点ID |
| `lcpNode(a,b)` | 最長共通接頭辞の既存節点ID（LCA） |
| `lcp(a,b)` | 最長共通接頭辞の要素数（char版はbyte数）を厳密に返す |
| `compare(a,b)` | 辞書順の比較を厳密に `-1,0,1` で返す |
| `length(node)` | 要素数 |
| `nodeCount()` | 根を含む作成済みの異なる節点数 |

IDは同一インスタンス内だけで有効な `int`。再利用・無効化しない。
別インスタンスの同じ番号は識別できないので混ぜないこと。
未初期化のdefault値は `nodeCount()==0`。それ以外の操作は初期化必須。
負数・節点数以上のID、Array版の範囲外文字は `ValueError`（releaseでも検査）。
`lcp(a,a)` は `length(a)`、一方が接頭辞なら短い方の長さ、根とのLCPは0。
両引数を検査し、不正ID・未初期化では同一ID同士でも `ValueError`。
`lcpNode(a,a)==a`、一方が接頭辞ならその短い方のID、根とのLCP節点は根。
`prefix(node,0)` は根、`prefix(node,length(node))` はnode自身を返す。
`[]` は `0 <= index < length(node)`、`prefix` は `0 <= length <= length(node)` が必要。
負数・範囲外は `ValueError` とし、切り詰めない。空列の `[]` は常に範囲外。
新しいAPIも全て不正ハンドル・未初期化を `ValueError` とする。
変換結果は独立した列の値であり、変更してもTrieの要素は変わらない（要素T自身のコピー規則は通常のNimと同じ）。
根の変換は空string / 空seq。`[]`・`prefix`・`lcpNode` は変換や節点追加を行わない。
内部のseqや辺は非公開。構造全体のコピーのコストは以下の操作計算量に含めない。
同一式の引数評価中に構造を変更せず、`add` の戻り値を変数に受けてから比較する。

`char` はNULと非ASCIIを含む0..255のbyteで、UTF-8コードポイント単位でも言語別照合順でもない。
Table版のTは、定数サイズで `hash`・`==`・`<`・コピーが O(1) の値を想定する。
`==` と厳密な全順序 `<` は整合し、等しい値のhashは等しく、挿入済みの値の意味が変わってはいけない。
整数・enum等を利用できる。可変長string等の要素や高価な比較ではそのコストを別途掛ける。

## 計算量

Nは根を含む異なる作成済み節点数、σはArray版のアルファベットサイズ。
機械語整数の演算・配列アクセスを定数時間とする。

| 操作 | Array版 | Table版 |
|---|---|---|
| 初期化 | O(σ) | O(1) |
| 既存辺のadd | 最悪 O(1) | 期待 O(1) |
| 新規辺のadd | 償却 O(σ) | 期待償却 O(1) |
| pop | 最悪 O(1) | 最悪 O(1) |
| compare / lcp / lcpNode / [] / prefix | 最悪 O(log(N+1)) | 最悪 O(log(N+1)) |
| toString / toSeq | O(長さ+1) | O(長さ+1) |
| root / length / nodeCount | 最悪 O(1) | 最悪 O(1) |
| 全体の空間 | O(Nσ) | O(N) |

σ固定ならArray版の追加は**償却 O(1)**、空間は O(N)。新節点の子配列ゼロ初期化は O(σ)。
ジャンプ情報の作成そのものは両版とも**最悪 O(1)**。
seq拡張の再確保があるので新規追加全体を最悪 O(1) とは主張しない。
標準Tableのhashに無条件の確率保証はない。「期待」は通常の良好なhash分布を仮定したもの。
悪意ある衝突では辞書操作は O(N)、再確保時にも単一追加が線形時間になり得る。
比較は辞書に触らないため、この影響を受けない。
ローリングハッシュは使用せず、hash衝突でも `==` で辺を識別するので比較の答えは変わらない。
各節点に親・深さ・**1本だけ**のjump・最後の要素を持つ。二分累乗表は持たない。
比較・LCP・一点取得・prefix取得の追加作業領域は O(1)、再帰も使用しない。
変換は親をたどり、出力を末尾から埋める。時間・出力空間 O(長さ+1)、出力以外 O(1)。

## 正しさと最悪対数時間の根拠

根の深さは0、親とjumpは根自身。新節点vの親をp、j=jump(p)、jj=jump(j)とする。
`depth(p)-depth(j) == depth(j)-depth(jj)` なら `jump(v)=jj`、そうでなければ `jump(v)=p`。
読み書きする節点数は定数で、既存節点は更新しない。

深さdからjumpを反復すると、根までの経路を長さ `2^k-1` のブロックに分割する。
長さは非減少で、等長ブロックが許されるのは先頭の2個だけ（skew binary表現）。
新節点の追加は、先頭の2個が同長なら新節点と合体して `1+2(2^k-1)=2^(k+1)-1`、
異なれば長さ1を先頭に追加するので、帰納的にこの性質が成立する。
根での0長比較は最初の長さ1を作る特例として同じ式で処理できる。

深さhの祖先を探すには、jump先がh以上ならjump、そうでなければ親をたどる。
目的位置より前のブロックを丸ごと飛ばす回数は O(log d)。
目的位置を含む長さ `2^k-1` のブロックでは、親を1回たどると
残りが長さ `2^(k-1)-1` の2ブロックになる。
各段階で片方を高々1回飛ばし、残りの段階数はk以下なので O(log d)。
これは各問い合わせの最悪時間であり、更新列全体への償却ではない。

辞書順比較では、まず深い方を浅い方と同じ深さにそろえる。
IDが等しければ片方は他方の接頭辞なので、元の深さで比較できる。
異なれば親が等しくなるまで2節点を同時に上る。
jumpの長さは深さだけから決まるため、同じ深さの2節点のjump先も同じ深さである。
LCAの深さをlとすると、jump先が異なることはその深さがlより大きいことと同値。
したがって異なる場合だけjumpし、それ以外は親へ進めば、深さl+1の2節点で停止する。
これは先の祖先探索（目標深さl+1）と同じ歩みで、最悪 O(log N)。
停止した節点の最後の要素が最初に異なる要素であり、それを比較すればよい。
`lcpNode` も同じ深さ合わせと同時上昇を行い、その親（LCA）のIDを返す。
`lcp` はその節点の深さを返す。
深さ合わせ後にIDが一致する場合、`lcpNode` はそのIDを返す。
したがって厳密なLCP節点と長さを最悪 O(log N)、追加空間 O(1) で求められる。
`prefix` は指定深さの祖先、`[]` は深さindex+1の祖先の最後の要素を返す。
いずれも同じ祖先探索を使うので、最悪 O(log N)、追加空間 O(1)。

このLCAと最長共通接頭辞の対応には、辺 `(親,要素)` の正規化が必要。
両版とも同じ辺を再作成せず、同じ列は同じIDになるため、この対応と等値比較が成立する。
追加は既存経路を変更せず、削除は親を返すだけなので、任意の過去のハンドルでも成立する。

背景: [Okasaki, Purely Functional Data Structures](https://www.cs.cmu.edu/~rwh/students/okasaki.pdf)
のskew-binary random-access list。ここでは上記の経路ブロック不変条件から必要な境界を直接示した。

## 検証

`src/verify/str/trie_string_test.nim` は、完全二分Trieの全組合せ、3 seedの乱択、
同じ組のbrute文字列LCP、byte全256値、重複、接頭辞、根、不正ID、26万段の2本の鎖と途中分岐、
全深さのskew不変条件、小深さの全祖先問い合わせ、Array/Tableの一致、整数と強制hash衝突を検査する。
変換・一点取得・prefix/LCP節点は、全256byteと汎用整数のbrute列、長い鎖、分岐、
同一ID・接頭辞・根、負数・上限外の引数でも検証する。
`src/verify/str/trie_string_benchmark.nim` は別プロセスでサイズと形状を指定して測定する。
`-d:array2` / `-d:array26` / `-d:array256` でArray版、それ以外はTable版。
実測値と再実行方法は `tools/trie_string/RESULTS.md` を参照。
