# Copied from
# https://github.com/vincentbernat/hellogopher/blob/master/Makefile
PACKAGE  = infynyxx_com
DATE    ?= $(shell date +%FT%T%z)
#VERSION ?= $(shell git describe --tags --always --dirty --match=v* 2> /dev/null || \
#			cat $(CURDIR)/.version 2> /dev/null || echo v0)
GOPATH   = $(CURDIR)/.gopath~
BIN      = $(GOPATH)/bin
BASE     = $(GOPATH)/src/$(PACKAGE)
PKGS     = $(or $(PKG),$(shell cd $(BASE) && env GOPATH=$(GOPATH) $(GO) list ./... | grep -v "^$(PACKAGE)/vendor/"))
TESTPKGS = $(shell env GOPATH=$(GOPATH) $(GO) list -f '{{ if .TestGoFiles }}{{ .ImportPath }}{{ end }}' $(PKGS))

GO      = go
GODOC   = godoc
GOFMT   = gofmt

V = 0
Q = $(if $(filter 1,$V),,@)
M = $(shell printf "\033[34;1m▶\033[0m")

.PHONY: all
all: fmt | $(BASE) ; $(info $(M) building executable…) @ ## Build program binary
	$Q cd $(BASE) && $(GO) build \
		-tags release \
		-ldflags '-X $(PACKAGE)/cmd.Version=$(VERSION) -X $(PACKAGE)/cmd.BuildDate=$(DATE)' \
		-o bin/$(PACKAGE) main.go

$(BASE): ; $(info $(M) setting GOPATH…)
			@mkdir -p $(dir $@)
			@ln -sf $(CURDIR) $@

# Tools
GOLINT = $(BIN)/golint
$(BIN)/golint: | $(BASE) ; $(info $(M) building golint...)
			$Q go get -v github.com/golang/lint/golint

#.PHONY: lint
#lint: vendor | $(BASE) $(GOLINT) ; $(info $(M) running golint...) @ ## Run golint
#				$Q cd $(BASE) && ret=0 && for pkg in $(PKGS); do \
#					test -z "$$($(GOLINT) $$pkg | tee /dev/stderr)" || ret=1 ; \
#				 done ; exit $$ret

.PHONY: fmt
fmt: ; $(info $(M) running gofmt…) @ ## Run gofmt on all source files
				 	@ret=0 && for d in $$($(GO) list -f '{{.Dir}}' ./... | grep -v /vendor/); do \
				 		$(GOFMT) -l -w $$d/*.go || ret=$$? ; \
				 	 done ; exit $$ret

 .PHONY: clean
 clean: ; $(info $(M) cleaning…)	@ ## Cleanup everything
					 	@rm -rf $(GOPATH)
					 	@rm -rf bin

.PHONY: help
help:
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
