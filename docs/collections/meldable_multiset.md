# MeldableMultiSet

`cplib/collections/meldable_multiset` は、任意に重なる値域を併合できる可変の順序付き multiset です。既存の AVLset・SortedMultiSet・leftist heap を変更せず、独立した treap として実装しています。

```nim
import cplib/collections/meldable_multiset

let a = initMeldableMultiSet([1, 3, 3])
let b = initMeldableMultiSet([2, 3])
a.meld(b)
assert a.len == 5 and b.len == 0
assert a.count(3) == 3
assert a.lowerBound(3) == 2 and a.upperBound(3) == 5
assert a.kth(2) == 3
assert a.excl(3) and a.count(3) == 2
```

## API と順序

| API | 契約 |
| --- | --- |
| `initMeldableMultiSet[T](values = [])` | 新しい独立した集合を作る |
| `len` | 重複を含む要素数 |
| `incl(x)` | 一要素を挿入する。同値でも保持する |
| `excl(x): bool` | 順序同値な一要素を削除。なければ false。どの同値要素を削除するかは未指定 |
| `count(x): int` / `contains(x): bool` | 順序同値な要素数 / 存在判定 |
| `lowerBound(x): int` | x 未満の要素数。挿入位置の左端 |
| `upperBound(x): int` | x 以下の要素数。挿入位置の右端 |
| `kth(k): T` / `[k]: T` | 0 始まりの順位。負数・k >= len は IndexDefect |
| `items` | 重複込みの昇順列挙。早期 break に対応 |
| `a.meld(b)` | 全要素を a へ移し、b を空にする。値域の前提なし |

キー T には `<` の厳密弱順序が必要です。`==`・hash・キーの加減算は使いません。`not(a < b) and not(b < a)` を順序同値とします。順序同値でも異なる payload を持つ値はそれぞれ保持し、列挙・kth は実際に挿入した値を返します。同値要素の列挙順は、このモジュールへの挿入順です（meld の左右の順番に依存しません）。NaN を含む通常の浮動小数点 `<` のように厳密弱順序にならない入力は対象外です。

## 所有権と変更

集合は `ref object` です。`let alias = a` は同じ可変集合を参照します。alias 経由の変更は a からも見えます。`a.meld(alias)` を含む同一参照の meld は何もしません。要素を倍化しません。異なる集合の meld 後は、source の全 alias が空集合を参照し、その後 source へ再挿入しても destination に影響しません。新しい集合は常に独立した節点を所有し、節点や root は非公開です。

独立したスナップショットが必要な場合は `initMeldableMultiSet(toSeq(a.items))` とします（`sequtils` を import）。永続データ構造・暗黙の深いコピーは提供しません。キー値そのものは Nim の代入規則で保存するため、T が参照型ならその参照先は共有されます。集合内にあるキーや参照先の順序を変更しないでください。items の反復中に、その集合または alias を変更しないでください。

nil（未初期化）への全公開操作は ValueError です。`initMeldableMultiSet[T]()` で空集合を初期化してください。要素数は int に収まる必要があり、incl / meld の容量超過は節点変更前に ValueError で拒否します。一意な uint64 挿入番号はモジュール全体で共有し、型をまたぐ累計挿入が `high(uint64)` に達した後の incl も拒否します。比較が例外を投げる場合の変更途中の復旧は保証しません。

## アルゴリズム・計算量

一要素ごとに一節点を使います。節点の検索キーは `(値の順序, 一意な挿入番号)`、heap 順序は `(ランダム uint64 優先度, 挿入番号)` です。同値キーも検索キーが異なるため、meld で重複をまとめたり捨てたりしません。圧縮した重複数の最大優先度を選ぶ方式と異なり、過去の同値キー併合回数で優先度分布を偏らせません。

union は二つの根のうち優先度の高い根 a を採用し、もう一方の木 b を a の検索キーで二分します。左右を再帰的に union し、`size = 1 + left.size + right.size` を再計算します。これで検索順序・heap 順序・部分木サイズを保持します。excl は一節点の左右の木を、全左キー < 全右キーの条件で join します。bounds は条件を満たす左部分木のサイズを足し、kth は左部分木サイズで分岐します。

N は重複を含む現在の要素数です。比較・キーコピーを O(1) とした計算量は次の通りです。

| 操作 | 時間 | 補助領域 |
| --- | --- | --- |
| len | O(1) | O(1) |
| incl / excl / count / contains / bounds / kth | 期待 O(log(N+1)) | 検索は O(1)、変更の再帰は期待 O(log(N+1)) |
| 初期化（入力 N 個） | 期待 O(N log(N+1)) | 節点 O(N) |
| items | O(N) | 木の高さ分、期待 O(log(N+1)) |
| meld（0 < m <= n、両方の要素数） | 期待 O(m log(n/m+1)) | 再帰の期待 O(log(n+m+1)) |
| 片方が空の meld / self-meld | O(1) | O(1) |

meld の期待計算量は、二つのランダム treap を split/union する解析に基づきます。ランダムに割り当てた優先度に対して、小さい側の各要素周辺の大きい側の区間探索を合計すると O(m log(n/m+1)) となります。任意に重なる値域で O(log N) meld は保証しません。保持領域は常に O(N)、meld は節点を再利用して新たな節点を作りません。

期待値は、優先度と独立した操作列と一様なランダム優先度モデルに対するものです。実装は Nim 標準 random の既定 RNG を使い、ライブラリ内で randomize しません。必要なら呼び出し側で一度 seed を設定してください。有限 64bit 優先度の衝突は挿入番号で解決します。既定 seed を知る入力、途中の seed 再設定、優先度と相関した操作列に対する敵対的な高さ保証はありません。最悪の木の高さ・再帰深さは O(N)、検索・単一変更は O(N)、union の保守的な最悪時間上界は O(mn)。極端に偏った木では再帰 stack が不足し得ます。RNG と挿入番号は共有可変状態のため並行利用には外部同期が必要です。C/C++ backend・Linux x86_64 で検証し、JS・32bit は未検証です。

## 検証の再現

Nim 1.6.20 / 2.2.4 の各 executable で、repo root から実行します。

```sh
nim cpp -r --path:src --nimcache:/tmp/meldable-debug -o:/tmp/meldable-debug-run src/verify/collections/meldable_multiset_test.nim
nim cpp -r -d:release --assertions:off --path:src --nimcache:/tmp/meldable-release -o:/tmp/meldable-release-run src/verify/collections/meldable_multiset_test.nim
```

新設テストはこの verify ファイルのみです。長さ 0..3・値 -1..1 の全40列の全組合せを両方向で meld し、独立した平坦配列のソート・線形カウントと照合します。固定 seed の18,000操作で挿入・一要素削除・任意の重なり・self-meld・独立コピーを照合します。nil、空、範囲外、整数上下限、uint64 全域、空文字・NUL、tuple、`<` のみの payload 付き順序同値キー、alias・source 再利用、優先度を衝突させた256節点、40,000個の交互キー・全同値キー、大小非対称 meld、1,500回の連鎖 meld も検査します。

既存 AVLset・SortedMultiSet・leftist heap と expander の回帰、および新 verify の通常 / single-line / compress / compress+original-source 展開を両 Nim で確認します。judge への提出は行いません。
