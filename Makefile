GO_VERSION := 1.21.5

.PHONY: install-go init-go

setup: install-go init-go install-lint copy-hooks
code-quality: test coverage report check-format static-check

install-go:
	wget "https://golang.org/dl/go$(GO_VERSION).linux-amd64.tar.gz"
	sudo tar -C /usr/local -xzf go$(GO_VERSION).linux-amd64.tar.gz		
	rm go$(GO_VERSION).linux-amd64.tar.gz

init-go:
	@echo 'export PATH=$$PATH:/usr/local/go/bin' >> $${HOME}/.bashrc
	@echo 'export PATH=$$PATH:$$HOME/go/bin' >> $${HOME}/.bashrc
	@source $${HOME}/.bashrc

upgrade-go:
	sudo rm -rf /usr/bin/go
	wget "https://golang.org/dl/go$(GO_VERSION).linux-amd64.tar.gz"
	sudo tar -C /usr/local -xzf go$(GO_VERSION).linux-amd64.tar.gz
	rm go$(GO_VERSION).linux-amd64.tar.gz

build:
	@echo "building..."
	go build -o api cmd/main.go

test:
	@echo "running tests..."
	go test ./... -coverprofile=coverage.out

coverage:
	go tool cover -func coverage.out \
	| grep "total:" | awk '{print ((int($$3) > 80) != 1) }'

report:
	go tool cover -html=coverage.out -o cover.html

check-format:
	@echo "running check-format..."
	test -z $$(go fmt ./...)

install-lint:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.55.2

static-check:
	@echo "running golangci-lint..."
	golangci-lint run

copy-hooks:
	chmod +x scripts/hooks/*
	cp -r scripts/hooks .git/.
