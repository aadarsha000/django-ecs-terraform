#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

echo "Running migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting Django..."
exec gunicorn core.wsgi:application --bind 0.0.0.0:8000