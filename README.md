# cplib

[![Actions Status](https://github.com/kemuniku/cplib/workflows/verify/badge.svg)](https://github.com/kemuniku/cplib/actions?branch=main)
[![GitHub Pages (oj)](https://img.shields.io/static/v1?label=GitHub+Pages&message=+&color=brightgreen&logo=github)](https://kemuniku.github.io/cplib/)
[![GitHub Pages (nimdoc)](https://img.shields.io/static/v1?label=GitHub+Pages&message=+&color=brightgreen&logo=github)](https://kemuniku.github.io/cplib/nimdoc/cplib.html)


競技プログラミング (AtCoder, yukicoderなど) の問題をNimで解くためのライブラリおよび `online-judge-tools` 実行用シェルスクリプト


# Requirement
インストールやスクリプトの実行には以下のツールが必要です。
あらかじめ各ソフトウェアのガイドに従ってインストールしてください。

- [Nim](https://github.com/nim-lang/Nim) (1.6.14)
- [Nim-ACL](https://github.com/zer0-star/Nim-ACL/tree/master)
- [online-judge-tools](https://github.com/online-judge-tools/oj)

# Getting Started

以下のコマンドでインストールしてください。

```bash
git clone https://github.com/kemuniku/cplib.git
cd cplib
nimble install -y
```

問題を解くときは、クローンしたディレクトリ内に `Main.nim` を作成し、解答コードを書きます。
公開されているテストケースに対して実行し結果を確かめるには以下のようにします。

```bash
./dl /url/of/problem
nim cpp -o:a.out Main.nim
oj t
```

解答を提出するには `sub` コマンドを使います。

```bash
./sub
```

# How to Contribute

Nim版expanderのバイナリ埋め込みモードと実行条件は [expanderの説明](docs/tools/expander.md) を参照してください。

ライブラリに関するバグ報告や提案などは、Issue, Pull Request を立ててください。

回帰テストは `src/verify` のNim verifyファイル（`*_test.nim`）に追加してください。
既存の `verify.yml` がNim 1.6.20 / 2.2.4で実行します。
CRTの実行手順は [docs/math/crt.md](docs/math/crt.md) を参照してください。
expanderの回帰は次のコマンドで実行できます。展開・コンパイルの検査は
verifyのコンパイル時に行い、生成物は一時ディレクトリへ保存します。

```sh
nim cpp --nimcache:/tmp/expander-verify-cache -o:/tmp/expander-verify -r src/verify/tools/expander_test.nim
```
