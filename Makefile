.PHONY: *

tidy:
	go mod tidy

setup:
	@make tidy
	go build -o build/master.exe cmd/master/main.go
	go build -o build/generate_payload.exe cmd/genload/main.go