import macros,strutils
macro optimize*(arg: static string = """nim c -d:danger -d:second_compile -d:useMalloc --gc:arc --panics:on --opt:speed --checks:off --passC:"-flto -m64 -march=native -ffast-math" """) =
    let isSecond = defined(second_compile)
    let isDebug = defined(debug)

    if not isSecond and not isDebug:
        if "-d:second_compile" notin arg:
            error("plz add -d:second_compile")
        let info = instantiationInfo(fullPaths=true)
        let sourcePath = info.filename
        var cmd = "export PATH=$HOME/.nimble/bin:$PATH && " & arg
        cmd.add("-o:a.out " & sourcePath)

        echo "--- Self-Recompiling with optimized settings ---"
        echo "Command: ", cmd
        echo "\n\n\n"

        let output = staticExec(cmd)
        echo output
        echo "\n\n\n"
        quit(0)