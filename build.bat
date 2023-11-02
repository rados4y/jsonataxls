SET GOARCH=386
go build -o jsonataxls_32bit.dll -buildmode=c-shared main.go
SET GOARCH=amd64
go build -o jsonataxls.dll -buildmode=c-shared main.go