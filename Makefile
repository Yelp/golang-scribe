THRIFT_PATH := $(CURDIR)/thrift
SCRIBE_PATH := $(CURDIR)/scribe-checkout
DOCKER_CONTAINER_NAME := scribe-go-builder

all: build-in-docker scribe fb303
.PHONY: build
build: gen/scribe/scribe.go fb303 scribe	


# =============
# Thrift building
# =============
$(THRIFT_PATH)/configure: | $(THRIFT_PATH)
	cd $(THRIFT_PATH); ./bootstrap.sh

$(THRIFT_PATH)/Makefile: $(THRIFT_PATH)/configure
	cd $(THRIFT_PATH) && ./configure --without-qt4 --without-c_glib --without-csharp --without-java --without-erlang --without-nodejs --without-lua --without-python --without-perl --without-php --without-php_extension --without-ruby --without-haskell --without-cpp

$(THRIFT_PATH)/compiler/cpp/thrift: $(THRIFT_PATH)/Makefile
	cd $(THRIFT_PATH); make
# ============


# ===========
# Git repos
# ===========
# Only clone the repos if they don't already exist
$(THRIFT_PATH):
	git clone http://git.apache.org/thrift.git/ $(THRIFT_PATH)
$(SCRIBE_PATH):
	git clone https://github.com/facebookarchive/scribe.git $(SCRIBE_PATH)
# ==========

gen/scribe/scribe.go: $(THRIFT_PATH)/compiler/cpp/thrift $(SCRIBE_PATH)
	mkdir -p $(CURDIR)/gen
	$(THRIFT_PATH)/compiler/cpp/thrift -out /src/gen --gen go:package_prefix="github.com/Yelp/golang-scribe/" -v -r -I $(THRIFT_PATH)/contrib $(SCRIBE_PATH)/if/scribe.thrift

scribe:
	cp -r gen/scribe/ .
fb303:
	cp -r gen/fb303/  .

.PHONY: build-in-docker
build-in-docker:
	docker build -t $(DOCKER_CONTAINER_NAME) .
	# Run make scribe.go within the docker container and restore file permissions
	docker run -it -v $(CURDIR):/src:rw $(DOCKER_CONTAINER_NAME) /bin/bash -c "make -C /src gen/scribe/scribe.go; chown -R $$(id -u):$$(id -g) /src"

.PHONY: clean
clean:
	rm -rf $(THRIFT_PATH) $(SCRIBE_PATH) gen scribe fb303
