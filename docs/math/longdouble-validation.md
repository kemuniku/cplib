# long double ローカル検証結果

2026-10-04 に `/workspace/cplib` で初回のローカル実装・検証を実施しました。この文書はその検証時点の記録です。初回検証では commit / push / PR 公開 / judge 提出は行っておらず、Git 設定・hook も変更していません。

## 実測環境

- Linux x86_64、GCC / G++ 14.2.0 (Debian 14.2.0-19)、glibc 2.41。
- Nim 1.6.20 (`19fdbfc173bfccb64cb64e0a963e69f52f71fc73`)。
- Nim 2.2.4 (`f7145dd26efeeeb6eeae6fff649db244d81b212d`)。
- `sizeof(long double)=16`、`FLT_RADIX=2`、`LDBL_MANT_DIG=64`、`LDBL_DIG=18`、`DECIMAL_DIG=21`。
- `LDBL_MIN_EXP=-16381`、`LDBL_MAX_EXP=16384`。
- C の独立参照は `-std=c11`、C++ の独立参照は `-std=c++14` で別々にコンパイル。両方 `-O2 -frounding-math -Wall -Wextra -Werror`。Nim 側も `-frounding-math` を指定。
- Nim 1.6.20 の標準 C++14、Nim 2.2.4 の標準 C++17 で検証。Nim の標準メモリ管理設定を使用。

| Nim | backend | 通常 / release | native参照・ABI・precision | 入出力 | Nim expander 4形式 | Python expander 通常/単行 |
| --- | --- | --- | --- | --- | --- | --- |
| 1.6.20 | C | 両方成功 | 成功 | 成功 | 成功 | 成功 |
| 1.6.20 | C++ | 両方成功 | 成功 | 成功 | 成功 | 成功 |
| 2.2.4 | C | 両方成功 | 成功 | 成功 | 成功 | 成功 |
| 2.2.4 | C++ | 両方成功 | 成功 | 成功 | 成功 | 成功 |

検証スクリプトは各 Nim 版で40個のグループチェック、合計80個が成功しました。これは assertion 数ではなく、contract・verify・入出力・回帰・展開プログラム等の実行単位です。

## 保存した実装とテスト

- `src/cplib/math/longdouble.nim`: native long double 型、変換、演算、数学関数、環境情報、文字列と標準入出力。
- `src/verify/AI/longdouble_test.nim`: 既存 verify と同じ Hello World 形式のテスト。ローカル実行のみ。
- `src/verify/local/longdouble_reference.c`, `.h`: Nim やこのラッパーを使わない native の参照。独立 executable と FFI object の双方を生成。
- `src/verify/local/longdouble_contract.nim`: native 参照と値・符号・分類・整形結果・ABI を照合。
- `src/verify/local/longdouble_abi_peer.nim`: 別の Nim translation unit での値受け渡し、openArray、generic。
- `src/verify/local/longdouble_io.nim`: 精度の高い token、最終改行のない入力、読了後 EOF、標準出力を検証。
- `src/verify/local/clongdouble_codegen.nim`: Nim 標準 `clongdouble` の問題を再現。
- `src/verify/local/test_longdouble.py`: オンライン提出を行わない再現用スクリプト。

## 検証した内容

`1.0000000000000000001` は `1.00000000000000000011` と整形され、1と異なります。`1 + epsilon - 1 == epsilon`、double に変換すると1になること、double で保持できない `9007199254740993` の整数往復、64ビット signed/unsigned の最小・最大値の直接変換と往復を確認しました。

parse / format は native `strtold` / `%.*Lg` と照合しました。十進・16進・0.1・非常に大きい/小さい指数・`LDBL_MIN`・`LDBL_MAX`・最小非正規化値・Inf・NaN・符号付き0を確認しています。NaN は分類を照合し、payload 保存は契約に含めません。不正 token と NUL は `ValueError` でした。

基本演算・複合代入、全27個の数学関数を native 参照と照合しました。`fma((1+epsilon), (1-epsilon), -1)` が別々の乗算・減算と異なることも確認しました。NaN 比較、`cmp` の NaN 拒否、0除算、負数の平方根、overflow、`abs(-0)`、符号付き0の text 往復を確認しました。

各8/16/32/64ビットと native 幅の signed/unsigned 整数の境界、負の小数の0方向の丸め、NaN/Inf/範囲外の `RangeDefect` を検証しました。範囲外で native 整数キャストを行いません。Nim 2.2.4/C の `-d:danger` でも contract が成功し、通常の範囲チェックを切った設定でも独自の変換チェックが働きました。

`FE_TONEAREST` / `FE_DOWNWARD` / `FE_UPWARD` / `FE_TOWARDZERO` の4モードで、parse・加算・平方根を同じモードの native 参照と照合し、`round` と整数変換の規則も確認しました。text 往復の保証・実測は標準の nearest モードと C locale を対象とします。

固定配列の stride と C/C++ 側での読み書き、Nim の返値、native の返値、cdecl callback、別 Nim モジュール、generic、openArray、seq の確保・追加・コピー、ref の確保、default 値を検証しました。native 参照は実際の `long double` / `long double*` / 関数ポインタを使います。生成コードにも `long double`、`sizeof(long double)`、`strtold`、`sqrtl` を確認しました。

両 Nim 版の C++、通常と release で、既存 `float128_test`、`int128_test`、`lazy_leftist_heap_int128_test`、`fractions_test`、`fractions_pow_overflow_test`、`fractions_infinity_order_test` を実行し、成功しました。既存 float128/int128 を C でビルドすると `importcpp` の制約で失敗することも確認しました。既存型の C 対応はこの変更に含めません。

Nim expander は通常、`--single-line`、`--compress`、`--compress --original-source` の全4形式を、両版・両 backend で、ライブラリへの `--path` を与えずビルド・実行しました。Python expander の通常・単行も同様に成功しました。既存 expander の unittest 4件（各展開形式を含む）も両版で成功しました。

## 対応範囲と既存の制約

保証の対象は上記の実測環境です。Windows/MSVC、macOS、ARM、32ビット環境、Clang、異なる libc、異なる long double ABI、異なる仮数精度・基数、非標準の compiler option は未検証です。`longDoubleInfo()` で実環境を確認し、必要なら同じ contract を実行してください。特に整数境界の実測は2進浮動小数点で行っています。

`const size = sizeof(LongDouble)` は両版・両 backend で `'sizeof' requires '.importc' types to be '.completeStruct'` と拒否されました。固定のサイズや空の completeStruct で回避していません。JS は両版とも明示的な error pragma で拒否します。Nim VM での演算・text 変換も対応外です。

標準の `clongdouble` probe は4構成すべてで次の結果でした。

```text
Nim sizeof(clongdouble)=8
C sizeof(clongdouble argument)=16
sum > original=false
```

生成コードで、その加算が `NF` へのキャストを経由することも確認しました。新しい型はこの alias を使いません。

旧 `expander.py --single-line --compress` は、この環境で既存の `base64 -b 0` が GNU base64 に拒否され、生成物がコンパイルできません。既存 `float128_test.nim` でも同じ失敗を再現したため、longdouble の変更とは独立した既存の問題です。今回は旧圧縮処理を変更していません。圧縮展開には検証済みの Nim expander `--compress` を使えます。Python の directory/raw 形式は未検証です。

## 再現コマンド・証跡

```sh
python3 src/verify/local/test_longdouble.py \
  --nim /workspace/cplib-env/nim-1.6.20/bin/nim \
  --build-dir /workspace/cplib-env/longdouble/1.6.20
python3 src/verify/local/test_longdouble.py \
  --nim /workspace/cplib-env/nim-2.2.4/bin/nim \
  --build-dir /workspace/cplib-env/longdouble/2.2.4
```

別環境では `--nim` と `--build-dir` を変更してください。スクリプトは Linux の GCC/G++、Python3、Nim と既存 expander の依存を前提とします。

この実行環境での証跡は `/workspace/cplib-env/longdouble/` に保存しています。

- `1.6.20/validation.log`, `2.2.4/validation.log`: 全コマンド、コンパイル出力、実行結果。
- 各版の `summary.txt`: 成功した40個のチェック一覧。
- 各版の `native-c`, `native-cpp`, `reference-*.o` と `*-contract-cache`: 独立 native 参照、Nim 生成コード。
- `clongdouble-<version>-<backend>.log` と対応する `*-cache`: alias の再現と生成コード。
- `static-<version>-<backend>.log`, `js-<version>.log`: 対応外機能をコンパイラが拒否した記録。
- `danger.log`: チェックを無効にした設定での contract 成功。
- `python_compress_probe/`, `python_compress_baseline/`: 旧圧縮形式の失敗と既存 float128 での再現。
- `longdouble.patch`: README、実装、verify、独立参照、再現スクリプト、説明とこの結果の差分。
