#!/bin/bash
set -euo pipefail

until bash -c '</dev/tcp/postgres/5432' >/dev/null 2>&1; do
  echo "waiting for postgres..."
  sleep 2
done

dotnet ef database update \
  --project /workspace/ProjectLucy.Infrastructure/ProjectLucy.Infrastructure.csproj \
  --startup-project /workspace/ProjectLucy.API/ProjectLucy.API.csproj \
  --no-build

cd /app/publish
exec dotnet ProjectLucy.API.dll
