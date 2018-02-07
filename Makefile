.PHONY: test clean

test:
	bats test.bats

clean:
	docker image ls --format '{{.ID}}' runas-* | xargs -r docker image rm
	rm -f debian fedora ubuntu alpine
