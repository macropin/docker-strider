#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

TEST_CONTAINER='strider-test'
DOCKERFILE="Dockerfile.test"

echo ">> Using Temp Dockerfile: $DOCKERFILE"

cat << EOF > $DOCKERFILE
FROM jpetazzo/dind:latest
ADD * /build/
WORKDIR /build
CMD ["/build/run-tests.sh"]
EOF

echo ">> Building"
docker build -f $DOCKERFILE -t $TEST_CONTAINER .

echo ">> Running"
docker run --privileged -ti --rm $TEST_CONTAINER

echo ">> Removing"
docker rmi $TEST_CONTAINER