all: build_nimdoc.o run_formatter.o
build_nimdoc.o:
	nim c -o:build_nimdoc.o build_nimdoc/build_nimdoc.nim
run_formatter.o:
	nim c -o:run_formatter.o run_formatter/run_formatter.nim
clean:
	rm -f build_nimdoc.o run_formatter.o