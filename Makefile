APP=$(shell basename $(shell git remote get-url origin))
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux | darwin | windows
TARGETARCH=amd64 #amd64 | arm64

linux: 
	TARGETOS=linux
	build
	image

macos: 
	TARGETOS=darwin
	build
	image	

windows: 
	TARGETOS=windows
	build
	image

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -V

deps:
	go get	

build: format deps
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/vkletsko/kbot/cmd.Version=${VERSION}	

image:
	docker build . -t ${REGISTRY}/${USERNAME}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${USERNAME}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -f kbot
	docker rmi ${REGISTRY}/${USERNAME}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}	