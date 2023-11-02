.PHONY: all clean build-32 build-64

all: clean build-32 build-64

build-32:
	@echo Building 32-bit DLL
	CGO_ENABLED=1 GOOS=windows GOARCH=386 go build -o jsonataxls-32.dll -buildmode=c-shared

build-64:
	@echo Building 64-bit DLL
	GOOS=windows GOARCH=amd64 CC=x86_64-w64-mingw32-gcc go build -o jsonataxls-64.dll -buildmode=c-shared

clean:
	@echo Cleaning up previous builds
	@rm -f jsonataxls-32.dll jsonataxls-64.dll
