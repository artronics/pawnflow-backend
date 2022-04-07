out_exe = ../build/pawnflow/pawnflow

build-aws:
	GOOS=linux GOARCH=amd64 go build -o $(out_exe)

build:
	GOOS=linux GOARCH=amd64 go build -o $(out_exe)

run: build
	$(out_exe)

.PHONY: build build-aws
