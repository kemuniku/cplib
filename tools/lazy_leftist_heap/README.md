# 遅延加算付き左偏ヒープ

`import cplib/collections/lazy_leftist_heap` で `LazyLeftistHeapPool[K, V]` を利用できます。
Directed MST から抽出した、配列で管理する破壊的な最小ヒープです。
`k_shortest_walk` の永続ヒープは構造を共有する契約が異なるため別実装のままです。

```nim
import cplib/collections/lazy_leftist_heap
var pool = initLazyLeftistHeapPool[int64, string]()
var a = pool.singleton(7'i64, "a")
var b = pool.singleton(2'i64, "b")
pool.addAll(a, -6'i64)
a = pool.meld(a, b)
b = -1
assert pool.top(a) == (1'i64, "a")
a = pool.pop(a)
assert pool.top(a) == (2'i64, "b")
a = pool.pop(a)
assert a == -1
```

- `initLazyLeftistHeapPool[K, V](capacity = 0, zero = default(K))` はノードの初期容量を予約します。
  一つのプールで複数のヒープを扱い、空の根を整数 `-1` で表します。
- `singleton(key, value)` は一要素の根を作ります。`value` の比較演算は不要です。
  同じキーの要素は、併合の順序によらずプール全体での挿入順に取り出します。
- `meld(a, b)` は同じプールの**互いに素な**ヒープを消費し、新しい根を返します。
  以後は返された根だけを使い、入力の根やそのコピーを別ヒープとして使わないでください。
  同じヒープ同士の併合や、異なるプールの根は使用できません。
- `addAll(root, delta)` はそのヒープの全キーへ加算します。空の根には何もしません。
  加算後に挿入・併合した要素へ、過去の加算が適用されることはありません。
- `top(root)` は `(key: K, value: V)` を返します。
  `pop(root)` は最小要素を削除した根を返すので、必ず根を更新します。
  いずれも空では呼べません。削除した根は再利用できません。

`K` は `<`、`==`、`+=` に対応し、`zero` に加法の単位元を指定する必要があります。
通常の整数なら既定値で利用できます。`Int128` など外部型には `zero = to_Int128(0)` を明示します。
加算は大小関係を保存し、キーと遅延値の全演算が型の範囲内に収まることが前提です。
Directed MST では `Int128` を使いますが、モジュール自体は通常の整数と C backend でも利用できます。
プールや生きた根のコピーは独立したスナップショットとして扱えません。

`singleton` は償却 O(1)、`addAll` / `top` は O(1)、`meld` / `pop` は O(log N)。
再帰深さも O(log N) です（N は操作対象の要素数）。プールは削除済みノードも保持するため、
領域は作成した全要素数に比例します。解放にはプール自体を破棄してください。

`src/verify/AI/lazy_leftist_heap_test.nim` で、複数ヒープの配列 oracle と比較して
負の加算、同値、空との併合、遅延加算後の挿入・併合・削除を検証します。

`src/verify/AI/lazy_leftist_heap_int128_test.nim` では int64 範囲外のキーで同様の独立 oracle を使い、
明示的なゼロと遅延値のリセットを両 Nim 版で検証します。
