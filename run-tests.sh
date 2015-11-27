#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

#
# Config
#

TEST_IMAGE='strider'
TEST_PORT=3000

#
# Functions
#

function rm_container {
    set +e
    docker rm -fv "$@" > /dev/null 2>&1
    set -e
}

function cleanup {
    echo "=> Clean up"
    rm_container $TEST_IMAGE mongo smtp
}

function wait_on_http {
    TIMEOUT=$1
    shift
    for (( i=0;; i++ )); do
        if [ ${i} -eq ${TIMEOUT} ]; then
            break
        fi
        sleep 1
        curl --insecure --location "$@" > /dev/null 2>&1 && break
    done
}

function start_docker {
    echo "=> Starting docker"
    if ! docker version > /dev/null 2>&1; then
        wrapdocker > /dev/null 2>&1 &
        sleep 5
    fi
}

function check_docker {
    echo "=> Checking docker daemon"
    docker version > /dev/null 2>&1 || (echo "Failed to start docker (did you use --privileged when running this container?)" && exit 1)
}

function check_environment {
    echo "=> Testing environment"
    docker version
    which curl > /dev/null
}

function build_image {
    echo "=> Building $TEST_IMAGE image"
    docker build -t $TEST_IMAGE .
}

function run_tests {
    echo "==> Running tests"
    echo "=> Test running"
    docker run -d --name mongo mongo:latest
    docker run -d --name smtp -e MAILNAME=test panubo/postfix:latest
    docker run -d --name $TEST_IMAGE -p $TEST_PORT:$TEST_PORT --link mongo --link smtp $TEST_IMAGE
    echo "=> Test container is up"
    wait_on_http 30 localhost:3000
    curl -s localhost:$TEST_PORT | grep 'Strider: Brilliant Continuous Deployment' > /dev/null
}

#
# Begin main
#

echo "=> Starting $0"
start_docker
check_docker
check_environment
cleanup
build_image
run_tests
cleanup
echo "=> Done!"