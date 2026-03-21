# Stage 1: Angular build
FROM node:24.7.0-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci
COPY . .
# Angular build für Produktion
RUN npm run build -- --configuration=production

ARG BACKEND_API_URL
RUN ng build --configuration=production --output-path=dist/angular-conduit --base-href=/ --aot --prod

# Stage 2: NGINX nur zum Serven der statischen Dateien
FROM nginx:alpine AS runner
# nginx.conf nicht nötig, Standard reicht
COPY --from=builder /app/dist/angular-conduit/ /usr/share/nginx/html/
EXPOSE 80