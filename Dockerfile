FROM oven/bun:1.4.2@sha256:9114c058aeae42162ee16dd5084b95fe9473970bb6bcb5b232ab1630f0546895 AS base
WORKDIR /app

FROM base AS native
ENV PYTHON=/usr/bin/python3
RUN apt-get update && apt-get install -y --no-install-recommends python3 make g++ ca-certificates openssl && rm -rf /var/lib/apt/lists/*
COPY package.json bun.lock prisma.config.js ./
COPY prisma ./prisma

FROM native AS dependencies
RUN bun install --frozen-lockfile

FROM native AS production-dependencies
RUN bun install --frozen-lockfile --production && rm -rf node_modules/@next node_modules/next node_modules/typescript
RUN mkdir -p /nm-big && cd node_modules && for p in @prisma prisma mermaid @blocknote lucide-react; do mkdir -p "/nm-big/$(dirname "$p")"; if [ -e "$p" ]; then mv "$p" "/nm-big/$p"; else mkdir -p "/nm-big/$p"; fi; done

FROM dependencies AS build
ARG NEXT_PUBLIC_BASE_PATH=""
ARG JPAD_RELEASE_SHA=""
ENV NEXT_TELEMETRY_DISABLED=1 NEXT_PUBLIC_BASE_PATH=$NEXT_PUBLIC_BASE_PATH JPAD_RELEASE_SHA=$JPAD_RELEASE_SHA
COPY . .
RUN DATABASE_URL=postgresql://build:build@localhost:5432/build NEXTAUTH_SECRET=build-placeholder NEXTAUTH_URL=http://localhost:3000 APP_ENCRYPTION_KEY=build-placeholder REDIS_URL=redis://localhost:6379 bun run build

FROM cgr.dev/chainguard/wolfi-base@sha256:d59fd2d1d21e913b12a8d56064e9aaf61f818289bd18b17132a0c4fde2358cea
WORKDIR /app
ARG NEXT_PUBLIC_BASE_PATH=""
ARG JPAD_RELEASE_SHA=""
ENV NODE_ENV=production JPAD_DATA_DIR=/app/data HOME=/tmp BUN_INSTALL_CACHE_DIR=/tmp/bun-cache NEXT_PUBLIC_BASE_PATH=$NEXT_PUBLIC_BASE_PATH JPAD_RELEASE_SHA=$JPAD_RELEASE_SHA
RUN apk add --no-cache libstdc++ ca-certificates openssl && mkdir -p /app/data && chown -R 10001:10001 /app/data
COPY --from=base /usr/local/bin/bun /usr/local/bin/bun
COPY --from=production-dependencies /app/node_modules ./node_modules
COPY --from=production-dependencies /nm-big/@prisma ./node_modules/@prisma
COPY --from=production-dependencies /nm-big/prisma ./node_modules/prisma
COPY --from=production-dependencies /nm-big/mermaid ./node_modules/mermaid
COPY --from=production-dependencies /nm-big/@blocknote ./node_modules/@blocknote
COPY --from=production-dependencies /nm-big/lucide-react ./node_modules/lucide-react
COPY --from=build --chown=10001:10001 /app/.next/standalone ./.next/standalone
COPY --from=build --chown=10001:10001 /app/.next/static ./.next/standalone/.next/static
COPY --from=build --chown=10001:10001 /app/public ./.next/standalone/public
COPY --from=build /app/package.json /app/prisma.config.js ./
COPY --from=build /app/prisma ./prisma
COPY --from=build /app/src/m ./src/m
COPY --from=build /app/runtime ./runtime
COPY --from=build /app/LICENSE /app/NOTICE ./
USER 10001:10001
RUN ["/usr/local/bin/bun","-e","import{ServerBlockNoteEditor as e}from\"@blocknote/server-util\";import{editorSchema as o}from\"./src/m/e40524caf1e42103beac.js\";import{parseMarkdownWithCustomBlocks as t}from\"./src/m/ae98dfef66156e70f566.js\";import{blocksToMarkdown as r}from\"./src/m/de9fa136c2d7be145b7d.js\";const c=e.create({schema:o});const a=\"[database](#database=runtime-check)\";const s=await t(c,a);const m=c.blocksToYDoc(s,\"blocknote\");try{const e=c.yXmlFragmentToBlocks(m.getXmlFragment(\"blocknote\"));if(e[0]?.type!==\"database\"||r(e).trim()!==a){throw new Error(\"Runtime editor schema did not preserve the database block\")}console.log(\"Runtime editor schema check passed\")}finally{m.destroy()}\n"]
EXPOSE 3000 1234
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 CMD ["/usr/local/bin/bun", "-e", "fetch(`http://localhost:3000${process.env.NEXT_PUBLIC_BASE_PATH||''}/api/health`).then(r=>{if(!r.ok)process.exit(1)}).catch(()=>process.exit(1))"]
CMD ["/usr/local/bin/bun", "runtime/entry.js"]
