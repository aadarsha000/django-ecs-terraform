#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

postgres_ready() {
python << END
import sys
import psycopg
import os

try:
    dbname = os.environ["POSTGRES_DB"]
    user = os.environ["POSTGRES_USER"]
    password = os.environ["POSTGRES_PASSWORD"]
    host = os.environ["POSTGRES_HOST"]
    port = os.environ["POSTGRES_PORT"]

    print("Environment variables being used:")
    print("POSTGRES_DB:", dbname)
    print("POSTGRES_USER:", user)
    print("POSTGRES_PASSWORD:", password)
    print("POSTGRES_HOST:", host)
    print("POSTGRES_PORT:", port)

    conn = psycopg.connect(
        dbname=dbname,
        user=user,
        password=password,
        host=host,
        port=port,
    )

except psycopg.Error as e:
    print("Postgres connection failed:", e)
    sys.exit(-1)

print("Postgres connection succeeded.")
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