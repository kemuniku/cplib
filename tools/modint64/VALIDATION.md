# modint64 ローカル検証結果

検証日: 2026-10-04。すべての対象検証が成功しました。

基準commit: `d2407cd46f00f401428888e5a8bff35fd90a4fd3`。独立worktree `/workspace/cplib-modint64`、local branch `local/modint64`。
元の `/workspace/cplib` と他のbranchは変更していません。このローカル検証時点ではcommit/push/PR/judge送信を行っていません。
Draft PR準備時にも最新mainが同じ基準commitであることを確認し、別の公開用branchへ同一の実装差分を移しました。

## 環境

- Linux x86_64 / AMD EPYC 9V74 80-Core Processor。
- GCC/G++ 14.2.0 (Debian 14.2.0-19)。Python 3.12.14。
- Nim 1.6.20 / 2.2.4、C / C++ backend。
- 原本のAGENTS.mdを読み、checkoutの `.agents/skills` は存在せず、親の `/workspace/.agents` は空であることを確認しました。
- 新規保証はこの環境のみです。MSVC/Windows、Clang、32bit、JSは対象外です。

## 確認結果

| 検証 | 件数・条件 | 結果 |
|---|---|---|
| Python多倍長oracle | 10素数、16,297ケース×17出力、各環境 | 成功 |
| 実行設定 | 2 Nim × 2 backend × debug/release/danger = 12設定 | 成功 |
| UBSan | 両Nim・両backendで全16,297ケース | 成功 |
| Nim VM演算oracle | 471比較、両Nim・両backend | 成功 |
| 素数判定oracle | 2,115値、VMとnative、両Nim・両backend | 成功 |
| 不正法（宣言マクロ） | 0, 1, 4, 9, 341, 561, 3215031751, 3825123056546413051, uint64最大、danger | コンパイル時拒否 |
| 不正法（直接定義） | 0, 1, 4, 3825123056546413051, uint64最大、danger | API具体化時に拒否 |
| 既存modint比較 | 998244353 / 1000000007、Montgomery/Barrett、各10,000乱数ペア、C++両Nim | 成功 |
| 既存modint回帰 | modint_arithmetic_test / AI/modint_test、C++両Nim | 成功 |
| combination | max_N=100のPascal等式、上位64bit法/小法/法2、既存型max_N=200との比較 | 成功 |
| Nim expander | normal/single-line/compress/original-source、両Nim・両backend | 成功 |
| Python expander | normal/single-line、両Nim・両backend | 成功 |
| ABI | 複数translation unit、8byte、uint64と同alignment、両Nim・両backend | 成功 |

法には2、3、17、998244353、1000000007、2305843009213693951、9223372036854775783、
9223372036854775837、18446744073709551533、18446744073709551557を使用しました。
法近傍・uint64最大・signed最小/最大、carry/borrow、ゼロ、uint64最大指数、負の指数、
0の逆元と除算、任意桁decimal（1024bitまで）、先頭ゼロと±、不正な文字列、hash/table/setを確認しました。
UBSan付きの例外系coreテストもNim 2.2.4 Cで成功しました。

実装中に確認したNimの互換性差は最終コードで対処しています。全整数型converterは整数の`$`を変えてしまうためintだけに限定。
generic型の単純別名はNim 2.2.4で型制約に使えないためconceptにし、hashは具体的なgeneric型を引数にしています。
負数parseの単項演算呼び出し経路はNim 2.2.4 C + GCC UBSanで例外フラグのnull参照を検出したため、
正規化値を直接符号反転する形にしました。最終コードでは全oracleケースをUBSan付きで通しています。

## 性能

`nim cpp -d:danger --opt:speed`。加算と連鎖乗算各3,000,000回、逆元3,000回。
チェックサムを出力して演算の削除を防ぎ、7回のCPU時間の中央値を使用しています。単位はns/operation。
法998244353で既存32bit型と比較し、2^63以上と最大の64bit素数でも同じ実装を測定しました。

| 型・法 | Nim | 加算 | 乗算 | 逆元 |
|---|---|---:|---:|---:|
| StaticModint64, 998244353 | 1.6.20 | 0.581 | 5.090 | 198.529 |
| 既存Montgomery32, 998244353 | 1.6.20 | 2.563 | 3.388 | 67.507 |
| 既存Barrett32, 998244353 | 1.6.20 | 2.750 | 3.492 | 65.461 |
| StaticModint64, 9223372036854775837 | 1.6.20 | 0.440 | 6.689 | 444.169 |
| StaticModint64, 18446744073709551557 | 1.6.20 | 0.915 | 6.806 | 632.756 |
| StaticModint64, 998244353 | 2.2.4 | 0.591 | 5.118 | 198.639 |
| 既存Montgomery32, 998244353 | 2.2.4 | 2.519 | 3.395 | 67.390 |
| 既存Barrett32, 998244353 | 2.2.4 | 2.599 | 3.434 | 65.725 |
| StaticModint64, 9223372036854775837 | 2.2.4 | 0.558 | 6.583 | 419.862 |
| StaticModint64, 18446744073709551557 | 2.2.4 | 0.853 | 6.876 | 609.107 |

小さい法では64bit版の乗算は既存32bit版の約1.5倍、逆元は約3倍の時間がかかりました。
全64bit素数を一つの正規化表現で扱うため、乗算にはunsigned 128bit剰余、逆元にはFermat累乗を使っています。
法2も扱え、Montgomeryの制約・補助定数・表現変換を持ちません。保持サイズは8byteです。
今回の加算は64bit版が速い結果ですが、定数の反復加算という特定のworkloadと、基準commitのinline状況を含む測定です。
既存modintに別途inline最適化が入ると比較値は変わり得ます。他の実装・workloadへの速度保証はしません。
繰り返し同じ値で除算する場合は `const inverse = Mint.init(denominator).inv` として乗算にできます。

## 成果と再現

- 実装: `src/cplib/modint/modint64.nim`。static型のみ。
- generic対応: `src/cplib/math/combination.nim` の逆元漸化式にuint64分岐を追加。
- 永続coreテスト: `src/verify/modint/modint64_test.nim`。
- API・契約・使用例: `tools/modint64/README.md`。
- 再現用スクリプト: `tools/modint64/validate.py` / `check_compiletime.py`。
- 要約と全benchmark標本: `tools/modint64/results.json` / `compiletime-results.json`。
- 全ログ・oracle原本・期待値・生成C/C++・実行ファイル: `/workspace/modint64-results`。
- 適用可能な差分パッチ: `/workspace/modint64-results/modint64.patch`（基準commit向け）。

残るブロッカーはありません。法変更を持つdynamic型は今回実装していません。
