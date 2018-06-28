#!/bin/bash
# vim: shiftwidth=4 expandtab

set -e -u -o pipefail

readonly BUILD_DIR=build

lint_bash() {
    git ls-files -z '*.bash' | xargs -0 shellcheck
}

configure() {
    if [[ ! -d ${BUILD_DIR} ]]; then
        cmake -GNinja -H. -B${BUILD_DIR}
    fi
}

build() {
    ninja -C ${BUILD_DIR}
}

format() {
    git ls-files -z '*.h' '*.cc' | xargs -0 clang-format-6.0 -i
    git diff --exit-code -- :!/hack
}

tidy() {
    git ls-files -z '*.h' '*.cc' | xargs -0 clang-tidy-6.0 -fix -p ${BUILD_DIR}
}

_main() {
    lint_bash
    configure
    build
    format
    tidy
}

_main "$@"
