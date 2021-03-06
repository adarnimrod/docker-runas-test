_test_user () {
    name="${1:-$BATS_TEST_DESCRIPTION}"
    tag="${2:-latest}"
    user="$(id -u)"
    group="$(id -g)"
    docker build -t "runas-$name" --build-arg "image=$name:$tag" ./
    docker run -u "$user:$group" --rm -v "$BATS_TEST_DIRNAME:/data" "runas-$name" touch "$name.user"
    test "$user" = "$(stat -c '%u' $name.user)"
    test "$user" = "$(stat -c '%g' $name.user)"
}

teardown () {
    docker image ls --format '{{.ID}}' runas-* | xargs -r docker image rm
    rm -f *.touch
}

@test "ubuntu" { _test_user buildpack-deps bionic; }
@test "debian" { _test_user buildpack-deps stretch; }
@test "centos" { _test_user; }
@test "fedora" { _test_user; }
@test "alpine" { _test_user; }
