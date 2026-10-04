# expanderのバイナリ埋め込み

`tools/expander/expander.nim` の `--binary` は、解答ソースを展開してローカルで実行ファイルへコンパイルし、その実行ファイルを埋め込んだNimソースを出力します。提出操作は行いません。従来の `--compress` はコンパイル時にNimソースを復元する機能で、バイナリ埋め込みとは異なります。

```sh
nim cpp -d:release -o:expander tools/expander/expander.nim
./expander --binary --nim-compiler:nim --lib:. --output-file:combined.nim Main.nim
nim cpp -d:release -o:solution combined.nim
./solution < input.txt
```

`--nim-compiler` (`-n`) は生成時に使うNim実行ファイルです。既定値はPATH上の `nim`。`--nim-option` (`-f`) で追加オプションを1引数ずつ渡せます。

```sh
./expander --binary --lib:. --nim-option:-d:MY_DEFINE --nim-option:--passL:-s Main.nim
```

生成時の既定コマンドは `nim cpp -d:release --opt:speed --multimethods:on --hints:off --warning[SmallLshouldNotBeUsed]:off`。入力ソースのディレクトリと呼出元の作業ディレクトリを検索パスに追加し、生成物とnimcacheは一時ディレクトリへ置きます。追加オプションはこれらの既定設定の後に渡しますが、実行・出力先・nimcache変更のオプションは拒否します。コンパイル失敗時は既存の出力ファイルを上書きしません。

`--binary` と `--single-line` / `--compress` / `--original-source` は併用できません。`--nim-compiler` / `--nim-option` は `--binary` 時だけ有効です。

## 対象環境と制約

- 生成側・実行側ともLinux用です。生成時にELFのmagicを確認します。埋め込む解答のOS、CPU命令セット、ELF loader、libc、libstdc++等のABIと依存ライブラリは、実行先と一致させてください。ライブラリの同梱、cross toolchainの準備、ABIの自動検証は行いません。既定で `-march=native` は追加しません。
- [AtCoder公式の言語表](https://atcoder.jp/contests/language-test-202505/rules) ではNim 1.6.20 / 2.2.4が `Main.nim` をC++ backendでコンパイルし、`./a.out` を実行します。これは埋め込みwrapperの受理・実行を保証する記述ではありません。対象コンテストのルール、言語、ソース容量、CPU/ABI、ファイル・プロセスの制約を確認してください。AtCoderへの実提出による確認はしていません。
- wrapperは作業ディレクトリに専用ディレクトリを作り、通常のファイルへ復元して実行権限を付け、子プロセスを起動します。作業ディレクトリへの書き込みと通常ファイルの実行、子プロセス生成が必要です。実行を禁止する環境に対する代替経路はありません。
- stdin / stdout / stderrはwrapperで読み書きせずそのまま継承します。環境変数、cwd、引数1以降も継承します。対話型のflushは解答側が行います。解答のPIDと `argv[0]` / 実行ファイルのパスは元のwrapperとは異なります。
- 解答の通常終了コード0..255を返します。解答がシグナル終了した場合は、復元ファイルを削除して同じシグナルでwrapperも終了します。wrapper自体の強制終了、SIGKILL、OS停止等では削除を保証できません。wrapperへの外部シグナルの転送やプロセスグループの管理は行いません。
- ソースは独立した一時ファイルからコンパイルします。元のproject固有 `.nim.cfg` / `.nims`、ソース相対の `staticRead`、`currentSourcePath` 等の同一性は保証しません。必要な設定は明示的に指定し、実行先で使うデータ・共有ライブラリは別途用意してください。

埋め込む実行ファイルをB bytes、展開済みソースをS bytesとすると、コンパイラ処理を除く生成は時間・領域O(S+B)。Base64部分は `4 * ceil(B/3)` bytesで、wrapperの固定部分が加わります。実行前の復元は時間・領域O(B)、復元ファイルもB bytesです。wrapperプロセスと起動・復元の時間およびメモリも制限に算入され得ます。ソース容量に収まることや実行時間の改善は保証しません。

## 検証

テストは `src/verify` 内のみです。`expander_binary_test.nim` は生成・コンパイルをコンパイル時に行い、実行時に独立の期待出力と通常の解答実行を照合します。

```sh
NIM=nim nim cpp -r --path:src src/verify/tools/expander_binary_test.nim
NIM=nim nim cpp -r --path:src src/verify/tools/expander_test.nim
```

別のNimでも同じ生成ソースをコンパイルする場合は `NIM_BINARY_OTHER=/path/to/other/nim` を併せて指定できます。ローカル検証とAtCoder上の受理・ACは別です。
