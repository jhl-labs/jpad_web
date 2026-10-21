
ALTER TABLE "Comment" ADD COLUMN     "anchor" JSONB;


ALTER TABLE "Page" ADD COLUMN     "tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
ADD COLUMN     "type" TEXT NOT NULL DEFAULT 'document';


CREATE TABLE "Database" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT 'Untitled Database',
    "properties" JSONB NOT NULL DEFAULT '[]',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "pageId" TEXT NOT NULL,

    CONSTRAINT "Database_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "DatabaseRow" (
    "id" TEXT NOT NULL,
    "values" JSONB NOT NULL DEFAULT '{}',
    "position" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "databaseId" TEXT NOT NULL,
    "pageId" TEXT NOT NULL,

    CONSTRAINT "DatabaseRow_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "DatabaseView" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'Table',
    "type" TEXT NOT NULL DEFAULT 'table',
    "config" JSONB NOT NULL DEFAULT '{}',
    "position" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "databaseId" TEXT NOT NULL,

    CONSTRAINT "DatabaseView_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "DatabaseForm" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT 'Form',
    "config" JSONB NOT NULL DEFAULT '{}',
    "publicToken" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "databaseId" TEXT NOT NULL,

    CONSTRAINT "DatabaseForm_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Automation" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'Automation',
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "trigger" JSONB NOT NULL,
    "action" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "workspaceId" TEXT NOT NULL,

    CONSTRAINT "Automation_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Webhook" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "secret" TEXT NOT NULL,
    "events" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "workspaceId" TEXT NOT NULL,

    CONSTRAINT "Webhook_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "WebhookDelivery" (
    "id" TEXT NOT NULL,
    "event" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "statusCode" INTEGER,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "lastError" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "webhookId" TEXT NOT NULL,

    CONSTRAINT "WebhookDelivery_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "WorkspaceGroup" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "workspaceId" TEXT NOT NULL,

    CONSTRAINT "WorkspaceGroup_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "WorkspaceGroupMember" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "groupId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "WorkspaceGroupMember_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "PageGroupPermission" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "pageId" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,

    CONSTRAINT "PageGroupPermission_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "GuestInvite" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'viewer',
    "email" TEXT,
    "createdById" TEXT NOT NULL,
    "acceptedByUserId" TEXT,
    "acceptedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "pageId" TEXT NOT NULL,

    CONSTRAINT "GuestInvite_pkey" PRIMARY KEY ("id")
);


CREATE UNIQUE INDEX "Database_pageId_key" ON "Database"("pageId");


CREATE INDEX "Database_workspaceId_idx" ON "Database"("workspaceId");


CREATE UNIQUE INDEX "DatabaseRow_pageId_key" ON "DatabaseRow"("pageId");


CREATE INDEX "DatabaseRow_databaseId_position_idx" ON "DatabaseRow"("databaseId", "position");


CREATE INDEX "DatabaseView_databaseId_position_idx" ON "DatabaseView"("databaseId", "position");


CREATE UNIQUE INDEX "DatabaseForm_publicToken_key" ON "DatabaseForm"("publicToken");


CREATE INDEX "DatabaseForm_databaseId_idx" ON "DatabaseForm"("databaseId");


CREATE INDEX "Automation_workspaceId_enabled_idx" ON "Automation"("workspaceId", "enabled");


CREATE INDEX "Webhook_workspaceId_enabled_idx" ON "Webhook"("workspaceId", "enabled");


CREATE INDEX "WebhookDelivery_webhookId_createdAt_idx" ON "WebhookDelivery"("webhookId", "createdAt");


CREATE INDEX "WorkspaceGroup_workspaceId_idx" ON "WorkspaceGroup"("workspaceId");


CREATE UNIQUE INDEX "WorkspaceGroup_workspaceId_name_key" ON "WorkspaceGroup"("workspaceId", "name");


CREATE INDEX "WorkspaceGroupMember_userId_idx" ON "WorkspaceGroupMember"("userId");


CREATE UNIQUE INDEX "WorkspaceGroupMember_groupId_userId_key" ON "WorkspaceGroupMember"("groupId", "userId");


CREATE INDEX "PageGroupPermission_groupId_idx" ON "PageGroupPermission"("groupId");


CREATE UNIQUE INDEX "PageGroupPermission_pageId_groupId_key" ON "PageGroupPermission"("pageId", "groupId");


CREATE UNIQUE INDEX "GuestInvite_token_key" ON "GuestInvite"("token");


CREATE INDEX "GuestInvite_pageId_idx" ON "GuestInvite"("pageId");


ALTER TABLE "Database" ADD CONSTRAINT "Database_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Database" ADD CONSTRAINT "Database_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "DatabaseRow" ADD CONSTRAINT "DatabaseRow_databaseId_fkey" FOREIGN KEY ("databaseId") REFERENCES "Database"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "DatabaseRow" ADD CONSTRAINT "DatabaseRow_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "DatabaseView" ADD CONSTRAINT "DatabaseView_databaseId_fkey" FOREIGN KEY ("databaseId") REFERENCES "Database"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "DatabaseForm" ADD CONSTRAINT "DatabaseForm_databaseId_fkey" FOREIGN KEY ("databaseId") REFERENCES "Database"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Automation" ADD CONSTRAINT "Automation_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Webhook" ADD CONSTRAINT "Webhook_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WebhookDelivery" ADD CONSTRAINT "WebhookDelivery_webhookId_fkey" FOREIGN KEY ("webhookId") REFERENCES "Webhook"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceGroup" ADD CONSTRAINT "WorkspaceGroup_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceGroupMember" ADD CONSTRAINT "WorkspaceGroupMember_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "WorkspaceGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceGroupMember" ADD CONSTRAINT "WorkspaceGroupMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageGroupPermission" ADD CONSTRAINT "PageGroupPermission_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageGroupPermission" ADD CONSTRAINT "PageGroupPermission_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "WorkspaceGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "GuestInvite" ADD CONSTRAINT "GuestInvite_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;

