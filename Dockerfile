# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN if [ -f tailwind.config.js ]; then npm run build; fi

# Stage 2: Runtime
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=build /app ./
ENV NODE_ENV=production
ENV PORT=3000
RUN addgroup -g 1001 -S nodejs && adduser -S shopdemo -u 1001
USER shopdemo
EXPOSE 3000
CMD ["node", "server.js"]