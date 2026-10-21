


CREATE TABLE "PageVersion" (
    "id" TEXT NOT NULL,
    "pageId" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "versionNo" INTEGER NOT NULL,
    "label" TEXT,
    "description" TEXT,
    "content" TEXT NOT NULL,
    "contentHash" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "gitCommitSha" TEXT,
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PageVersion_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "PageVersionContributor" (
    "versionId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "editCount" INTEGER NOT NULL DEFAULT 1,
    "firstEditAt" TIMESTAMP(3) NOT NULL,
    "lastEditAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PageVersionContributor_pkey" PRIMARY KEY ("versionId","userId")
);


CREATE TABLE "PageEditActivity" (
    "id" TEXT NOT NULL,
    "pageId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "windowStart" TIMESTAMP(3) NOT NULL,
    "editCount" INTEGER NOT NULL DEFAULT 1,
    "lastEditAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PageEditActivity_pkey" PRIMARY KEY ("id")
);


CREATE UNIQUE INDEX "PageVersion_pageId_versionNo_key" ON "PageVersion"("pageId", "versionNo");


CREATE UNIQUE INDEX "PageVersion_pageId_label_key" ON "PageVersion"("pageId", "label");


CREATE INDEX "PageVersion_workspaceId_idx" ON "PageVersion"("workspaceId");


CREATE INDEX "PageVersion_pageId_createdAt_idx" ON "PageVersion"("pageId", "createdAt");


CREATE INDEX "PageVersionContributor_userId_idx" ON "PageVersionContributor"("userId");


CREATE UNIQUE INDEX "PageEditActivity_pageId_userId_windowStart_key" ON "PageEditActivity"("pageId", "userId", "windowStart");


CREATE INDEX "PageEditActivity_pageId_lastEditAt_idx" ON "PageEditActivity"("pageId", "lastEditAt");


ALTER TABLE "PageVersion" ADD CONSTRAINT "PageVersion_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageVersion" ADD CONSTRAINT "PageVersion_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "PageVersionContributor" ADD CONSTRAINT "PageVersionContributor_versionId_fkey" FOREIGN KEY ("versionId") REFERENCES "PageVersion"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageVersionContributor" ADD CONSTRAINT "PageVersionContributor_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "PageEditActivity" ADD CONSTRAINT "PageEditActivity_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageEditActivity" ADD CONSTRAINT "PageEditActivity_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
