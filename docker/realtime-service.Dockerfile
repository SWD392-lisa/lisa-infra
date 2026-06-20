FROM node:22-alpine AS build
WORKDIR /app

COPY lisa-realtime-service/package*.json ./
COPY lisa-realtime-service/prisma.config.ts ./
COPY lisa-realtime-service/tsconfig*.json ./
COPY lisa-realtime-service/nest-cli.json ./
COPY lisa-realtime-service/prisma ./prisma
RUN npm ci

COPY lisa-realtime-service/src ./src
RUN npx prisma generate
RUN npm run build

FROM node:22-alpine AS runtime
WORKDIR /app

COPY lisa-realtime-service/package*.json ./
COPY lisa-realtime-service/prisma.config.ts ./
COPY lisa-realtime-service/tsconfig*.json ./
COPY lisa-realtime-service/nest-cli.json ./
COPY lisa-realtime-service/prisma ./prisma
RUN npm ci

COPY --from=build /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=build /app/dist ./dist
COPY lisa-infra/docker/realtime-service-start.sh /usr/local/bin/realtime-service-start.sh

RUN chmod +x /usr/local/bin/realtime-service-start.sh

EXPOSE 3000

CMD ["/usr/local/bin/realtime-service-start.sh"]
