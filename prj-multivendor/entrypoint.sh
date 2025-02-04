#!/bin/sh

# Wait for PostgreSQL to be ready
while ! nc -z db 5432; do
  echo "Waiting for PostgreSQL..."
  sleep 1
done

echo "PostgreSQL is ready"

# Run migrations
python manage.py migrate

# Start the Django development server
python manage.py runserver 0.0.0.0:8000