compile: 
	protoc api/v1/*.proto --go_out=. --go_opt=paths=source_relative --proto_path=.

compileGrpc:
	protoc api/v1/*.proto --go_out=. --go-grpc_out=. --go_opt=paths=source_relative --go-grpc_opt=paths=source_relative --proto_path=.

run:
	go run cmd/server/main.go

test:
	go test -v -race ./...

tidy:
	go mod tidy

cleancache:
	go clean -modcache

