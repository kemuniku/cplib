# modint64 verifyへの回帰整理

基準main: `d2407cd46f00f401428888e5a8bff35fd90a4fd3`。
実装は `src/cplib/modint/modint64.nim`、static型のみです。

verify外のテストscript/helperと結果JSONを削除しました。
テストの実行元は `src/verify/modint` のPROBLEM指定付きverifyファイルのみです。
既存 `verify.yml` の `oj-verify run` を使い、専用workflowは追加しません。

## verifyファイル

| ファイル | 内容 |
|---|---|
| modint64_test.nim | 整数の上下限、例外、hash/set/table、binomial、サイズ/alignment |
| modint64_oracle_test.nim | 10素数、全境界ペアと各32乱数ペア、1,617ケース×17出力の固定oracle |
| modint64_compiletime_test.nim | VM演算471比較、素数判定2,115値（VM/native）、不正法9種のcompiles拒否 |
| modint64_existing_test.nim | 既存32bit型2法×2表現との各10,000ペア、binomial max_N=200 |

固定oracleは以前Python多倍長整数で計算した期待値をverifyソース内に埋め込んだものです。
実行時のPython依存、独自runner、外部の入力・期待値ファイルはありません。
既存型比較はC++専用、ほか3ファイルはC/C++向けです。

法2、3、17、998244353、1000000007、2305843009213693951、9223372036854775783、
9223372036854775837、18446744073709551533、18446744073709551557を確認します。
法近傍、carry/borrow、signed最小/最大・uint64最大、uint64最大指数、0の逆元と除算、
先頭ゼロと±、1024bitまでのdecimal、不正入力を含みます。

## 確認済み環境

Linux x86_64 / AMD EPYC 9V74、GCC/G++ 14.2.0、Nim 1.6.20 / 2.2.4。
今回、上記4verifyファイルをdebug/release/dangerでコンパイル・実行しました。
core/oracle/compiletimeは両NimのC/C++（36設定）、既存型比較は両NimのC++（6設定）、
計42設定すべてで検査が成功し、出力は `Hello World` でした。

既存 `oj-verify run` も4ファイルを検出しましたが、公式Hello Worldのsystem test取得が
`https://judgedat.u-aizu.ac.jp/testcases/ITP1_1_A/header` のproxy接続時に403 Forbiddenで停止しました。
これはコンパイル前のデータ取得失敗です。oj-verify全体やGitHub CIの成功は未確認です。
独自workflowの追加、judge提出は行っていません。

MSVC/Windows、Clang、32bit、JSには新規保証をしていません。
以前の実装検証では16,297ケースの比較と複数translation unitも確認しましたが、
その検証script/helperは今回除去しています。現在の再現対象は上記verifyファイルです。

## 以前の性能測定記録

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
