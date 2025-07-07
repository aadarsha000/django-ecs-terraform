#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

# Start Flower
celery -A core flower \
  --basic_auth=admin:Yamagod123a@
