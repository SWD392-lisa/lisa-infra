/Users/phamhongphuc/Documents/Lisa/lisa-frontend-app# lisa-infra

Infrastructure repo duy nhất để chạy toàn bộ hệ thống local bằng `docker compose`.

## Setup

```bash
cp .env.example .env
docker compose up -d
```

## Logs

```bash
docker compose logs -f
```

## Rebuild

```bash
docker compose up -d --build
```

## Stop

```bash
docker compose down
```

## Services

- `postgres` → `localhost:5432`
- `curriculum-service` → `localhost:8080`
- `realtime-service` → `localhost:3000`
- `user-payment-service` → `localhost:5000`
- `frontend-app` → `localhost:5173`

## Notes

- Tất cả inter-service calls dùng Docker hostname, không dùng `localhost`.
- Frontend build trong Docker từ `../lisa-frontend-app`, nhưng browser gọi backend qua các port public trên `localhost`.
- PostgreSQL dùng 1 server, 3 database riêng: `lisadb`, `realtime_db`, `user_payment_db`.
- `user-payment-service` tự chạy EF Core migration khi container start.
- `realtime-service` tự chạy `prisma db push` khi container start vì repo chưa có migration đầy đủ.
- Nếu cần tính năng Agora / Cloudflare / SePay thật, điền thêm biến trong `.env`.
