# START: begin
CONFIG_PATH=${HOME}/.distributedGoSvc/

.PHONY: init
init:
	mkdir -p ${CONFIG_PATH}

.PHONY: gencert
gencert:
	cfssl gencert \
		-initca security/ca-csr.json | cfssljson -bare ca

	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=security/ca-config.json \
		-profile=server \
		security/server-csr.json | cfssljson -bare server

	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=security/ca-config.json \
		-profile=client \
		security/client-csr.json | cfssljson -bare client

	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=security/ca-config.json \
		-profile=client \
		-cn="root" \
		security/client-csr.json | cfssljson -bare root-client

	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=security/ca-config.json \
		-profile=client \
		-cn="nobody" \
		security/client-csr.json | cfssljson -bare nobody-client

	mv *.pem *.csr ${CONFIG_PATH}


$(CONFIG_PATH)/model.conf:
	cp security/model.conf $(CONFIG_PATH)/model.conf

$(CONFIG_PATH)/policy.csv:
	cp security/policy.csv $(CONFIG_PATH)/policy.csv

.PHONY: test
test:	$(CONFIG_PATH)/policy.csv $(CONFIG_PATH)/model.conf
	go test -v -race ./...

.PHONY: compile
compile:
	protoc api/v1/*.proto --go_out=. --go-grpc_out=. --go_opt=paths=source_relative --go-grpc_opt=paths=source_relative --proto_path=.

.PHONY: run
run:
	go run cmd/server/main.go

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: cleancache
cleancache:
	go clean -modcache

