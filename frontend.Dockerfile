# Stage 1: Angular Build
FROM node:24.7.0-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

COPY . .

RUN npm run build -- --configuration=production --output-path=dist/angular-conduit --base-href=/ --aot

# Stage 2: NGINX
FROM nginx:alpine AS runner
COPY --from=builder /app/dist/angular-conduit/ /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]