CREATE TABLE "NotionMirrorConnection" (
  "id" TEXT NOT NULL, "workspaceId" TEXT NOT NULL, "ownerId" TEXT NOT NULL,
  "rootPageId" TEXT NOT NULL, "accessToken" TEXT NOT NULL,
  "enabled" BOOLEAN NOT NULL DEFAULT true, "nextSyncAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "lastSyncAt" TIMESTAMP(3), "lastError" TEXT, "failureCount" INTEGER NOT NULL DEFAULT 0,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "NotionMirrorConnection_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "NotionMirrorConnection_workspaceId_key" ON "NotionMirrorConnection"("workspaceId");
CREATE UNIQUE INDEX "NotionMirrorConnection_rootPageId_key" ON "NotionMirrorConnection"("rootPageId");
CREATE INDEX "NotionMirrorConnection_enabled_nextSyncAt_idx" ON "NotionMirrorConnection"("enabled", "nextSyncAt");
ALTER TABLE "NotionMirrorConnection" ADD CONSTRAINT "NotionMirrorConnection_workspaceId_fkey"
  FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE "NotionMirrorItem" (
  "id" TEXT NOT NULL, "connectionId" TEXT NOT NULL, "pageId" TEXT, "remoteId" TEXT,
  "kind" TEXT NOT NULL DEFAULT 'page', "remoteDatabaseId" TEXT, "propertyMap" JSONB NOT NULL DEFAULT '{}',
  "localBase" JSONB, "remoteBase" JSONB, "intent" JSONB, "conflict" JSONB,
  "status" TEXT NOT NULL DEFAULT 'pending', "message" TEXT, "lastSyncAt" TIMESTAMP(3),
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "NotionMirrorItem_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "NotionMirrorItem_pageId_key" ON "NotionMirrorItem"("pageId");
CREATE UNIQUE INDEX "NotionMirrorItem_connectionId_remoteId_key" ON "NotionMirrorItem"("connectionId", "remoteId");
CREATE INDEX "NotionMirrorItem_connectionId_status_idx" ON "NotionMirrorItem"("connectionId", "status");
ALTER TABLE "NotionMirrorItem" ADD CONSTRAINT "NotionMirrorItem_connectionId_fkey"
  FOREIGN KEY ("connectionId") REFERENCES "NotionMirrorConnection"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "NotionMirrorItem" ADD CONSTRAINT "NotionMirrorItem_pageId_fkey"
  FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE SET NULL ON UPDATE CASCADE;
