when not declared CPLIB_UTILS_AUTO_ROLLBACK:
    const CPLIB_UTILS_AUTO_ROLLBACK* = 1
    import macros
    import cplib/utils/private/auto_rollback

    macro withAutoRollback*(update: typed, body: untyped): untyped =
        ## ブロック内ではupdateを同名の履歴付き関数へ置き換え、snapshot()とrollback(position)を用意する。
        ## snapshotはO(1)、rollbackは復元する値の合計サイズに比例する時間。終了・例外時も開始前へ戻す。
        ## snapshotは同じブロック内の現在の履歴上にある位置のみ使用でき、取り消した先の位置は再利用しないこと。
        ## 記録対象はupdate経由の変更のみ。変更先はブロック終了まで生存し、他の処理から変更・解放しないこと。
        ## 数値・それらのタプル・固定長配列の更新に対応する。seqの伸縮など未対応の操作はコンパイルエラー。
        newCall(bindSym"withAutoRollbackImpl", update, body)

    macro Temporary*(body: untyped): untyped =
        ## ブロック内の代入と静的な呼び出し先の変更を記録し、終了・例外時に開始前へ戻す。
        ## let answer = Temporary: ... の形では、末尾の式の値を保存してから状態を復元する。
        ## 戻り値は数値・それらのタプル・固定長配列に限る。出力はブロック外で行うこと。
        ## 入れ子も可能。ブロック内で宣言した一時変数はそのブロックの履歴対象に含めない。
        ## 同じスコープ・判定領域では変更先の最初の値だけ保存する。入れ子は内側の開始時点へ戻す。
        ## 値は連続バッファへ保存し、変更先ごとのクロージャ確保を行わない。
        ## 単純なseq・array要素への書き込みは添字で重複判定する。その他はハッシュ表を使う。
        ## 判定領域は同じTemporaryの呼び出し間でスレッドごとに再利用し、復元時に訪問した添字だけを戻す。
        ## 各判定領域の最大配列長をNとすると確保・初期化は合計O(N)、追加領域O(N)。毎回の全初期化は行わない。
        ## 配列の混在や再入などで判定領域を共有できない場合はハッシュ表へ戻す。
        ## 添字判定とハッシュ判定をまたぐ更新では、同じ場所をそれぞれに保存する場合がある。
        ## 書き込みごとの判定は通常O(1)、ハッシュ表では期待O(1)。値の保存・復元は初回に記録する値の合計サイズに比例する。
        ## 変更先はブロック終了まで生存すること。配列全体と要素のように範囲が重なる書き込みも復元できる。
        ## 数値・それらのタプル・固定長配列の更新に対応する。seqの伸縮など未対応の操作はコンパイルエラー。
        newCall(bindSym"temporaryImpl", prepareTemporary(body))
