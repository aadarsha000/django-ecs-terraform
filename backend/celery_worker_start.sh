#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

# Patch gevent before any imports
python ./core/celery_gevent_patch.py

# Start Celery with gevent pool
celery -A core worker -P gevent -c 100 --loglevel=info -Ofair