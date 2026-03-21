FROM node:18-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .

ARG BACKEND_API_URL
ENV BACKEND_API_URL=${BACKEND_API_URL}

RUN node src/scripts/generate-env.js
RUN npm run build --prod


FROM nginx:stable-alpine

COPY --from=build /app/dist/angular-conduit /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]