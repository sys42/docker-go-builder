#!/bin/sh
docker run -ti --rm -v $PWD:/app -w /app $(cat REPO_AND_VERSION) \
       remapuser app $(id -u) $(id -g) goexec "$@"
