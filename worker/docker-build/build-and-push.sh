#!/bin/bash
set -e
docker build -t kindlyops/reporter .
docker push kindlyops/reporter:latest
