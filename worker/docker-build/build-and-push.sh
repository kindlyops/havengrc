#!/bin/bash
set -e
docker build -t kindlyops/reporter:worker-base .

docker push kindlyops/reporter:worker-base
