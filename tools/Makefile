BUILD_OPTIONS = -d:release
all: build_nimdoc.o run_formatter.o expander.o
build_nimdoc.o:
	nim c $(BUILD_OPTIONS) -o:build_nimdoc.o build_nimdoc/build_nimdoc.nim
run_formatter.o:
	nim c $(BUILD_OPTIONS) -o:run_formatter.o run_formatter/run_formatter.nim
expander.o:
	nim c $(BUILD_OPTIONS) -o:expander.o expander/expander.nim
clean:
	rm -f build_nimdoc.o run_formatter.o expander.o