BUILD_OPTIONS = -d:release
all: build_nimdoc.o run_formatter.o expander.o ignore_atcoder_verify.o
build_nimdoc.o:
	nim c $(BUILD_OPTIONS) -d:nimDebugDlOpen -o:build_nimdoc.o build_nimdoc/build_nimdoc.nim
run_formatter.o:
	nim c $(BUILD_OPTIONS) -o:run_formatter.o run_formatter/run_formatter.nim
expander.o:
	nim c $(BUILD_OPTIONS) -o:expander.o expander/expander.nim
ignore_atcoder_verify.o:
	nim c $(BUILD_OPTIONS) -o:ignore_atcoder_verify.o ignore_atcoder_verify/ignore_atcoder_verify.nim
clean:
	rm -f build_nimdoc.o run_formatter.o expander.o