when not declared CPLIB_TMPL_OPTIMIZE:
    const CPLIB_TMPL_OPTIMIZE* = 1
    import macros, strutils, os, std/compilesettings
    macro optimize*(arg: static string = """nim c -d:danger -d:second_compile -d:useMalloc --gc:arc --panics:on --opt:speed --checks:off --passC:"-flto -m64 -march=native -ffast-math -funroll-loops -fipa-pta" --passL:"-flto" --hints:off """) =
        ## 最適化設定で再コンパイルし、失敗時は呼び出し元のコンパイルも失敗させる。
        let isSecond = defined(second_compile)
        let isDebug = defined(debug)

        if (not isSecond) and (not isDebug):
            if "-d:second_compile" notin arg:
                error("plz add -d:second_compile")
            let sourcePath = querySetting(SingleValueSetting.projectFull)
            let outFile = querySetting(SingleValueSetting.outFile)
            let outDir = querySetting(SingleValueSetting.outDir)
            let outPath = outDir / outFile
            let searchPaths = querySettingSeq(MultipleValueSetting.searchPaths)
            var cmd = arg & " "
            # --path は先頭に追加されるため、元の探索順を保つよう逆順で渡す。
            for i in countdown(searchPaths.high, 0):
                cmd.add("--path:" & quoteShell(searchPaths[i]) & " ")
            cmd.add("-o:" & quoteShell(outPath) & " " & quoteShell(sourcePath))

            echo "--- Self-Recompiling with optimized settings ---"
            echo "Command: ", cmd
            echo "\n\n\n"

            let execution = gorgeEx(cmd)
            if execution.exitCode != 0:
                error("Optimized compilation failed (exit code " & $execution.exitCode & "):\n" & execution.output)
            warning(execution.output)
            echo "\n\n\n"

            quit(0)

    template optimizeCpp*(arg: static string = """nim cpp -d:danger -d:second_compile -d:useMalloc --gc:arc --panics:on --opt:speed --checks:off --passC:"-flto -m64 -march=native -ffast-math -funroll-loops -fipa-pta" --passL:"-flto" --hints:off """) =
        ## C++バックエンドで最適化して再コンパイルし、失敗時は呼び出し元も失敗させる。
        optimize(arg)
