#!/usr/bin/env bats

_test () {
    name="${1:-$BATS_TEST_DESCRIPTION}"
    tag="${2:-latest}"
    userland="${3:-gnu}"
    docker build -t "runas-$name" --build-arg "image=$name:$tag" --build-arg "userland=$userland" ./
    docker run --rm -v "$BATS_TEST_DIRNAME:/data" "runas-$name" touch "$name.touch"
    test "$(id -u)" = "$(stat -c '%u' $name.touch)"
    test "$(id -g)" = "$(stat -c '%g' $name.touch)"
}

teardown () {
    docker image ls --format '{{.ID}}' runas-* | xargs -r docker image rm
    rm -f *.touch
}

@test "ubuntu" { _test; }
@test "debian" { _test debian stable-slim; }
@test "centos" { _test; }
@test "fedora" { _test; }
@test "alpine" { _test alpine latest busybox; }
