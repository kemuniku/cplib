# XOR基底の元要素復元

`import cplib/math/xor_basis` と `import options` を使います。
既存の `XorBasis` は変更せず、復元を使う場合に `XorBasisWithRestore` を選びます。

```nim
var basis = initXorBasisWithRestore([3, 5, 6, 0])
basis.incl(8) # 添字4
let answer = basis.restore(14)
if answer.isSome:
    for id in answer.get:
        echo id # この添字の元要素のXORが14
```

- `initXorBasisWithRestore()` または `initXorBasisWithRestore(openArray[int])` で初期化します。default値も空の基底として使えます。
- `incl(x)` の添字は0から始まる挿入順です。0、重複、従属要素の追加も添字を1つ消費します。配列から初期化した場合は元の配列添字と一致します。呼出側のIDは、この添字から別途対応付けてください。
- `restore(x): Option[seq[int]]` は元要素の部分集合を返します。作れない場合は `none(seq[int])`、0の場合は `some(@[])` です。成功時の添字は昇順、重複なしで、高々rank個です。最短・辞書順最小は保証しません。
- `can_make(x)` はspan判定、`len_basis` はrank、`len` は挿入回数です。
- 値型なので代入コピー後の追加は独立です。問い合わせは非破壊で、返したseqの変更も基底に影響しません。内部配列は非公開です。
- `int` の全ビットを符号に関係なくGF(2)上のベクトルとして扱い、負値・最上位bit・`low(int)` も扱います。整数の加減算は使わず、ビットパターンを `uint` へcastして消去します。32bit環境では32bit幅、64bit環境では64bit幅です。

W=`sizeof(int)*8` として、追加・判定・復元はO(W)、構築はO(NW)、保持領域はO(W)です。独立要素の元添字を最大W個だけ保存し、witnessのWビットはこの独立要素への係数です。元添字を直接ビット位置にしていないので、元要素数が64を超えても復元できます。挿入回数が `high(int)` に達した場合の追加は、変更前に `OverflowDefect` を送出します（releaseでも検査）。

既存 `XorBasis` の型・基底配列・順序統計・性能は維持します。復元型には順序統計や基底間mergeは提供しません。複数入力をまとめたい場合は同じ復元型へ元要素を順番に追加してください。既存型からは元要素の情報を取得できないため変換は提供しません。

## 検証

自己完結回帰は `src/verify/AI/xor_basis_restore_test.nim`。3bitの長さ0..4の全入力列・各prefix・全targetを全subset oracleと比較し、固定seedの符号付き列、整数境界、全rank、64超の挿入数、コピー、返却値の変更、非破壊問い合わせも検査します。既存基底の回帰も別途実行します。外部実装の転用はありません。

```sh
nim cpp -r --path:src src/verify/AI/xor_basis_restore_test.nim
nim cpp -r -d:release --path:src src/verify/AI/xor_basis_restore_test.nim
```

CIでNim1.6.20/2.2.4のdebug/release、Nim2.2.4のUBSan、expanderの回帰および展開済み新規回帰を検証します。ローカル環境ではNim未導入かつ公式配布取得がHTTP403のため、Nimの実行結果はCIを根拠とします。32bit実行は未検証です。
