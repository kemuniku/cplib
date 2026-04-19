import macros,strutils,std/compilesettings
macro optimize*(arg: static string = """nim c -d:danger -d:second_compile -d:useMalloc --gc:arc --panics:on --opt:speed --checks:off --passC:"-flto -m64 -march=native -ffast-math" --hints:off """) =
    let isSecond = defined(second_compile)
    let isDebug = defined(debug)

    if (not isSecond) and (not isDebug):
        if "-d:second_compile" notin arg:
            error("plz add -d:second_compile")
        let sourcePath = querySetting(SingleValueSetting.projectFull)
        let projectDir = sourcePath[0..<sourcePath.rfind('/')]
        let outFile = querySetting(SingleValueSetting.outFile)
        let outFlag = if outFile.len > 0: "-o:" & outFile & " " else: "-o:a.out "
        var cmd = "cd " & projectDir & " && export PATH=$HOME/.nimble/bin:$PATH && " & arg
        cmd.add(outFlag & sourcePath)

        echo "--- Self-Recompiling with optimized settings ---"
        echo "Command: ", cmd
        echo "\n\n\n"

        let output = staticExec(cmd)
        warning(output)
        echo "\n\n\n"

        quit(0)