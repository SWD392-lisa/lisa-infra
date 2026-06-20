#!/bin/sh
set -eu

create_db() {
  db_name="$1"
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-SQL
    SELECT 'CREATE DATABASE "$db_name" OWNER "$POSTGRES_USER"'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$db_name')\gexec
SQL
}

create_db "$CURRICULUM_DB_NAME"
create_db "$REALTIME_DB_NAME"
create_db "$USER_PAYMENT_DB_NAME"
