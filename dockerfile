FROM node:20-alpine AS deps

WORKDIR /app

ENV NODE_ENV=production

COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force

FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./
COPY server.js ./
COPY maybe-big-file.txt* ./

USER node

EXPOSE 3000

CMD ["node", "server.js"]