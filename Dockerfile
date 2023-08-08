# syntax = docker/dockerfile:1

# Adjust NODE_VERSION as desired
ARG NODE_VERSION=16.19.0
ENV NODE_ENV production
FROM node:${NODE_VERSION}-slim as builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Bundle static assets with nginx
FROM nginx:1.21.0-alpine as production
# Copy built assets from `builder` image
COPY --from=builder /app/dist/angular-conduit /usr/share/nginx/html
# Add your nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port
EXPOSE 80
# Start nginx
CMD ["nginx", "-g", "daemon off;"]
