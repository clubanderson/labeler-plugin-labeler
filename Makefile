build:
	go build -buildmode=plugin -o bin/labeler-plugin-labeler labeler-plugin-labeler.go

install:
	chmod +x bin/labeler-plugin-labeler
	sudo cp bin/labeler-plugin-labeler /usr/local/bin

run:
	go run labeler-plugin-labeler.go

compile:
	echo "Compiling for every OS and Platform"
	GOOS=linux GOARCH=arm go build -buildmode=plugin -o bin/labeler-plugin-labeler-linux-arm labeler-plugin-labeler.go
	GOOS=linux GOARCH=arm64 go build -buildmode=plugin -o bin/labeler-plugin-labeler-linux-arm64 labeler-plugin-labeler.go
	GOOS=linux GOARCH=386 go build -buildmode=plugin -o bin/labeler-plugin-labeler-linux-386 labeler-plugin-labeler.go
	GOOS=windows GOARCH=386 go build -buildmode=plugin -o bin/labeler-plugin-labeler-windows-386 labeler-plugin-labeler.go
	GOOS=freebsd GOARCH=386 go build -buildmode=plugin -o bin/labeler-plugin-labeler-freebsd-386 labeler-plugin-labeler.go

all: build install