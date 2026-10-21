
CREATE TABLE "UserApiToken" (
    "id" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "tokenPrefix" TEXT NOT NULL,
    "scopes" TEXT NOT NULL DEFAULT 'read,write',
    "lastUsedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    "revokedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "UserApiToken_pkey" PRIMARY KEY ("id")
);


CREATE UNIQUE INDEX "UserApiToken_tokenHash_key" ON "UserApiToken"("tokenHash");


CREATE INDEX "UserApiToken_userId_revokedAt_createdAt_idx" ON "UserApiToken"("userId", "revokedAt", "createdAt");


CREATE INDEX "UserApiToken_tokenPrefix_idx" ON "UserApiToken"("tokenPrefix");


ALTER TABLE "UserApiToken" ADD CONSTRAINT "UserApiToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
