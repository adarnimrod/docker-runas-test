#!/usr/bin/env bats

_test () {
    name="${1:-$BATS_TEST_DESCRIPTION}"
    tag="${2:-latest}"
    userland="${3:-gnu}"
    docker build -t "runas-$name" --build-arg "image=$name:$tag" --build-arg "userland=$userland" ./
    docker run --rm -v "$BATS_TEST_DIRNAME:/volume" "runas-$name" touch "$name"
    test "$(id -u)" = "$(stat -c '%u' $name)"
    test "$(id -g)" = "$(stat -c '%g' $name)"
}

@test "ubuntu" { _test; }
@test "debian" { _test debian stable-slim; }
@test "centos" { _test; }
@test "fedora" { _test; }
@test "alpine" { _test alpine latest busybox; }
