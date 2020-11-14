GOFLAGS :=
GOVERSION=$(shell go version)
GOOS=$(word 1,$(subst /, ,$(lastword $(GOVERSION))))
GOARCH=$(word 2,$(subst /, ,$(lastword $(GOVERSION))))
BUILD_DIR=build/$(GOOS)-$(GOARCH)

.PHONY: all build clean deps package package-zip package-targz

all: build

build: deps
	mkdir -p $(BUILD_DIR)
	cd ${BUILD_DIR} && GOOS=$(GOOS) GOARCH=$(GOARCH) go build $(GOFLAGS) -o gcs-client ../../*.go

clean:
	rm -rf build package

package:
	$(MAKE) package-targz GOOS=linux GOARCH=amd64
	$(MAKE) package-targz GOOS=linux GOARCH=386
	$(MAKE) package-targz GOOS=linux GOARCH=arm64
	$(MAKE) package-targz GOOS=linux GOARCH=arm
	$(MAKE) package-zip GOOS=darwin GOARCH=amd64
	$(MAKE) package-zip GOOS=windows GOARCH=amd64
	$(MAKE) package-zip GOOS=windows GOARCH=386

package-zip: build
	mkdir -p package
	cd $(BUILD_DIR) && zip ../../package/gcs-client_$(GOOS)_$(GOARCH).zip gcs-client

package-targz: build
	mkdir -p package
	cd $(BUILD_DIR) && tar zcvf ../../package/gcs-client_$(GOOS)_$(GOARCH).tar.gz gcs-client