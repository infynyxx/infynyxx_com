# https://gist.github.com/azer/7c83d0b59de8328355ad
GOPATH=$(shell pwd)/vendor:$(shell pwd)
GOBIN=$(shell pwd)/bin
GOFILES=$(wildcard *.go)
GONAME=$(shell basename "$(PWD)")
VERSION ?= $(shell git describe --tags --always --dirty --match=v* 2> /dev/null || \
			cat $(CURDIR)/.version 2> /dev/null || echo v0)
PACKAGE=infynyxx_com
GOFMT=gofmt
GO=go

build:
	@echo "Building $(GOFILES) to ./bin"
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go build \
	-tags release \
	-ldflags '-X $(PACKAGE)/cmd.Version=$(VERSION) -X $(PACKAGE)/cmd.BuildDate=$(DATE)' \
	-o bin/$(PACKAGE) $(GOFILES)

get:
  @GOPATH=$(GOPATH) GOBIN=$(GOBIN) go get .

fmt:
	@echo "running gofmt" ## Run gofmt on all source files
				 	@ret=0 && for d in $$($(GO) list -f '{{.Dir}}' ./... | grep -v /vendor/); do \
				 		$(GOFMT) -l -w $$d/*.go || ret=$$? ; \
				 	 done ; exit $$ret

install:
  @GOPATH=$(GOPATH) GOBIN=$(GOBIN) go install $(GOFILES)

run:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go run $(GOFILES)

clear:
	@clear

clean:
	@echo "Cleaning"
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go clean

.PHONY: build get install fmt run clean
