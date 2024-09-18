# cplib

[![Actions Status](https://github.com/kemuniku/cplib/workflows/verify/badge.svg)](https://github.com/kemuniku/cplib/actions?branch=main)
[![GitHub Pages (oj)](https://img.shields.io/static/v1?label=GitHub+Pages&message=+&color=brightgreen&logo=github)](https://kemuniku.github.io/cplib/)
[![GitHub Pages (nimdoc)](https://img.shields.io/static/v1?label=GitHub+Pages&message=+&color=brightgreen&logo=github)](https://kemuniku.github.io/cplib/nimdoc/cplib.html)


競技プログラミング (AtCoder, yukicoderなど) の問題をNimで解くためのライブラリおよび `online-judge-tools` 実行用シェルスクリプト


# Requirement
インストールやスクリプトの実行には以下のツールが必要です。
あらかじめ各ソフトウェアのガイドに従ってインストールしてください。

- [Nim](https://github.com/nim-lang/Nim) (1.6.14)
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

ライブラリに関するバグ報告や提案などは、Issue, Pull Request を立ててください。
