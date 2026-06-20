#!/bin/sh
set -eu

until nc -z postgres 5432; do
  echo "waiting for postgres..."
  sleep 2
done

npx prisma db push --skip-generate
exec node dist/src/main
