FROM dhi.io/node:24-alpine3.23-dev AS dev

WORKDIR /app

RUN --mount=type=cache,target=/root/.npm \
    --mount=type=bind,source=package.json,target=package.json \
    npm install

COPY . .
RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "dev"]


FROM dhi.io/node:24-alpine3.23-dev AS deps
WORKDIR /app
RUN --mount=type=cache,target=/root/.npm \
    --mount=type=bind,source=package.json,target=package.json \
    npm install --omit=dev

FROM dhi.io/node:24-alpine3.23 AS runner
ENV PATH=/app/node_modules/.bin:$PATH
WORKDIR /app
COPY --from=deps --chown=node:node /app/node_modules ./node_modules
COPY --from=dev --chown=node:node /app/dist ./dist

EXPOSE 3000
CMD ["node", "dist/index.js"]


FROM dev AS test

ENV CI=true

CMD ["npm", "test"]