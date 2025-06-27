#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

postgres_ready() {
python << END
import sys
import psycopg
try:
    psycopg.connect(
        dbname="${POSTGRES_DB}",
        user="${POSTGRES_USER}",
        password="${POSTGRES_PASSWORD}",
        host="${POSTGRES_HOST}",
        port="${POSTGRES_PORT}",
    )
except psycopg.OperationalError:
    sys.exit(-1)
sys.exit(0)
END
}

until postgres_ready; do
  >&2 echo 'Waiting for PostgreSQL to become available...'
  sleep 1
done

>&2 echo 'PostgreSQL is available'

if [ "${RUN_MODE:-django}" = "celery" ]; then
  exec bash ./celery_worker_start.sh
else
  exec bash ./django_start.sh
fi