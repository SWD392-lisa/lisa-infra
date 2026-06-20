FROM node:22-alpine AS build
WORKDIR /app

ARG VITE_API_BASE_URL
ARG VITE_API_URL
ARG VITE_LMS_API_URL
ARG VITE_REALTIME_URL

ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
ENV VITE_API_URL=$VITE_API_URL
ENV VITE_LMS_API_URL=$VITE_LMS_API_URL
ENV VITE_REALTIME_URL=$VITE_REALTIME_URL

COPY lisa-frontend-app/package*.json ./
RUN npm ci

COPY lisa-frontend-app/. ./
RUN npm run build

FROM nginx:alpine AS runtime
COPY --from=build /app/dist /usr/share/nginx/html
COPY lisa-infra/docker/frontend-nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
