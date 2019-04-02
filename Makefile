PREFIX?=/usr/local

TEMPORARY_FOLDER=./tmp_portable_circle2polyline

build:
	swift build --disable-sandbox -c release

test:
	swift test

clean:
	swift package clean

xcode:
	swift package generate-xcodeproj

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/circle2polyline" "$(PREFIX)/bin/circle2polyline"
