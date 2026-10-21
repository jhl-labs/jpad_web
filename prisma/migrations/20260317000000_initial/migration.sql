
CREATE SCHEMA IF NOT EXISTS "public";


CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "hashedPassword" TEXT,
    "oidcIssuer" TEXT,
    "oidcSubject" TEXT,
    "samlIssuer" TEXT,
    "samlSubject" TEXT,
    "isPlatformAdmin" BOOLEAN NOT NULL DEFAULT false,
    "lastLoginAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "SsoLoginToken" (
    "id" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT NOT NULL,

    CONSTRAINT "SsoLoginToken_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Organization" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "OrganizationMember" (
    "id" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'member',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "organizationId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "OrganizationMember_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "OrganizationDomain" (
    "id" TEXT NOT NULL,
    "domain" TEXT NOT NULL,
    "autoJoin" BOOLEAN NOT NULL DEFAULT false,
    "verificationToken" TEXT NOT NULL,
    "verifiedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "organizationId" TEXT NOT NULL,

    CONSTRAINT "OrganizationDomain_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "OrganizationScimToken" (
    "id" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "lastUsedAt" TIMESTAMP(3),
    "revokedAt" TIMESTAMP(3),
    "createdByUserId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "organizationId" TEXT NOT NULL,

    CONSTRAINT "OrganizationScimToken_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "OrganizationScimIdentity" (
    "id" TEXT NOT NULL,
    "externalId" TEXT,
    "userName" TEXT NOT NULL,
    "displayName" TEXT,
    "givenName" TEXT,
    "familyName" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "lastProvisionedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "organizationId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "OrganizationScimIdentity_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "OrganizationScimGroup" (
    "id" TEXT NOT NULL,
    "externalId" TEXT,
    "displayName" TEXT NOT NULL,
    "lastProvisionedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "organizationId" TEXT NOT NULL,

    CONSTRAINT "OrganizationScimGroup_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "OrganizationScimGroupMember" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "scimGroupId" TEXT NOT NULL,
    "scimIdentityId" TEXT NOT NULL,

    CONSTRAINT "OrganizationScimGroupMember_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Workspace" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "visibility" TEXT NOT NULL DEFAULT 'private',
    "publicWikiEnabled" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "organizationId" TEXT,

    CONSTRAINT "Workspace_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "WorkspaceMember" (
    "id" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'editor',
    "managedByScim" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,

    CONSTRAINT "WorkspaceMember_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "WorkspaceScimGroupMapping" (
    "id" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "createdByUserId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "scimGroupId" TEXT NOT NULL,

    CONSTRAINT "WorkspaceScimGroupMapping_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "WorkspaceScimProvisionedMember" (
    "id" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "scimGroupId" TEXT NOT NULL,

    CONSTRAINT "WorkspaceScimProvisionedMember_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Page" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT 'Untitled',
    "slug" TEXT NOT NULL,
    "icon" TEXT,
    "coverImage" TEXT,
    "accessMode" TEXT NOT NULL DEFAULT 'workspace',
    "position" INTEGER NOT NULL DEFAULT 0,
    "summary" TEXT,
    "isLocked" BOOLEAN NOT NULL DEFAULT false,
    "lockedById" TEXT,
    "lockedAt" TIMESTAMP(3),
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "deletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "parentId" TEXT,
    "workspaceId" TEXT NOT NULL,

    CONSTRAINT "Page_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "PageEmbeddingChunk" (
    "id" TEXT NOT NULL,
    "chunkIndex" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "contentHash" TEXT NOT NULL,
    "embedding" JSONB NOT NULL,
    "dimension" INTEGER NOT NULL,
    "provider" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "pageId" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,

    CONSTRAINT "PageEmbeddingChunk_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "SearchIndexJob" (
    "id" TEXT NOT NULL,
    "jobType" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "lastError" TEXT,
    "payload" JSONB,
    "summary" JSONB,
    "startedAt" TIMESTAMP(3),
    "processedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "pageId" TEXT,

    CONSTRAINT "SearchIndexJob_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "PagePermission" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "pageId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "PagePermission_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "PageShareLink" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "revokedAt" TIMESTAMP(3),
    "pageId" TEXT NOT NULL,

    CONSTRAINT "PageShareLink_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Backlink" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fromPageId" TEXT NOT NULL,
    "toPageId" TEXT NOT NULL,

    CONSTRAINT "Backlink_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Comment" (
    "id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "resolved" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "pageId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "parentId" TEXT,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Attachment" (
    "id" TEXT NOT NULL,
    "filename" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "path" TEXT NOT NULL,
    "storage" TEXT NOT NULL DEFAULT 'local',
    "securityStatus" TEXT NOT NULL DEFAULT 'not_scanned',
    "securityDisposition" TEXT,
    "securityScanner" TEXT,
    "securityFindings" JSONB,
    "securityCheckedAt" TIMESTAMP(3),
    "securityReviewedAt" TIMESTAMP(3),
    "securityReviewedByUserId" TEXT,
    "securityReviewNote" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "pageId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Attachment_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Favorite" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT NOT NULL,
    "pageId" TEXT NOT NULL,

    CONSTRAINT "Favorite_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "AiChat" (
    "id" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "pageId" TEXT,
    "workspaceId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AiChat_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'success',
    "requestId" TEXT,
    "actorId" TEXT,
    "actorEmail" TEXT,
    "actorName" TEXT,
    "actorRole" TEXT,
    "workspaceId" TEXT,
    "pageId" TEXT,
    "targetId" TEXT,
    "targetType" TEXT,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "AuditLogWebhookDelivery" (
    "id" TEXT NOT NULL,
    "auditLogId" TEXT NOT NULL,
    "destinationType" TEXT NOT NULL DEFAULT 'webhook',
    "destinationLabel" TEXT NOT NULL DEFAULT 'primary',
    "status" TEXT NOT NULL DEFAULT 'pending',
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "nextAttemptAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastAttemptAt" TIMESTAMP(3),
    "deliveredAt" TIMESTAMP(3),
    "responseStatus" INTEGER,
    "lastError" TEXT,
    "payload" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AuditLogWebhookDelivery_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "RetentionRun" (
    "id" TEXT NOT NULL,
    "mode" TEXT NOT NULL,
    "trigger" TEXT NOT NULL DEFAULT 'manual',
    "status" TEXT NOT NULL DEFAULT 'running',
    "config" JSONB NOT NULL,
    "summary" JSONB,
    "workspaceSummary" JSONB,
    "errorMessage" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),

    CONSTRAINT "RetentionRun_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "RetentionRunWorkspace" (
    "id" TEXT NOT NULL,
    "retentionRunId" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "purgedPageCount" INTEGER NOT NULL DEFAULT 0,
    "purgedAttachmentCount" INTEGER NOT NULL DEFAULT 0,
    "purgedShareLinkCount" INTEGER NOT NULL DEFAULT 0,
    "purgedAiChatCount" INTEGER NOT NULL DEFAULT 0,
    "purgedAuditLogCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RetentionRunWorkspace_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "BackupRun" (
    "id" TEXT NOT NULL,
    "mode" TEXT NOT NULL,
    "trigger" TEXT NOT NULL DEFAULT 'manual',
    "status" TEXT NOT NULL DEFAULT 'running',
    "backupRootDir" TEXT NOT NULL,
    "destinationPath" TEXT,
    "config" JSONB NOT NULL,
    "summary" JSONB,
    "manifest" JSONB,
    "errorMessage" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),

    CONSTRAINT "BackupRun_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "BackupArtifact" (
    "id" TEXT NOT NULL,
    "backupRunId" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'created',
    "filePath" TEXT,
    "sizeBytes" TEXT,
    "checksumSha256" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BackupArtifact_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "RestoreDrillRun" (
    "id" TEXT NOT NULL,
    "backupRunId" TEXT NOT NULL,
    "trigger" TEXT NOT NULL DEFAULT 'manual',
    "status" TEXT NOT NULL DEFAULT 'running',
    "summary" JSONB,
    "errorMessage" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),

    CONSTRAINT "RestoreDrillRun_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "SearchIndexWorkerRun" (
    "id" TEXT NOT NULL,
    "trigger" TEXT NOT NULL DEFAULT 'manual',
    "status" TEXT NOT NULL DEFAULT 'running',
    "workspaceScopeId" TEXT,
    "limit" INTEGER,
    "summary" JSONB,
    "errorMessage" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),

    CONSTRAINT "SearchIndexWorkerRun_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "SearchIndexWorkerRunWorkspace" (
    "id" TEXT NOT NULL,
    "searchIndexWorkerRunId" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "processedJobCount" INTEGER NOT NULL DEFAULT 0,
    "successJobCount" INTEGER NOT NULL DEFAULT 0,
    "errorJobCount" INTEGER NOT NULL DEFAULT 0,
    "pageReindexJobCount" INTEGER NOT NULL DEFAULT 0,
    "workspaceReindexJobCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SearchIndexWorkerRunWorkspace_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "WorkspaceSettings" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "aiEnabled" BOOLEAN NOT NULL DEFAULT true,
    "aiModel" TEXT NOT NULL DEFAULT 'claude-sonnet-4-20250514',
    "aiApiKey" TEXT,
    "aiMaxTokens" INTEGER NOT NULL DEFAULT 2048,
    "aiProfiles" JSONB,
    "aiTaskRouting" JSONB,
    "allowPublicPages" BOOLEAN NOT NULL DEFAULT true,
    "allowMemberInvite" BOOLEAN NOT NULL DEFAULT true,
    "defaultPageAccess" TEXT NOT NULL DEFAULT 'workspace',
    "maxFileUploadMb" INTEGER NOT NULL DEFAULT 10,
    "uploadDlpScanMode" TEXT,
    "uploadDlpDetectors" JSONB,
    "uploadDlpMaxExtractedCharacters" INTEGER,
    "googleCalendarClientId" TEXT,
    "googleCalendarClientSecret" TEXT,
    "gitRemoteUrl" TEXT,
    "gitRemoteToken" TEXT,
    "gitRemoteBranch" TEXT DEFAULT 'main',
    "gitSyncMode" TEXT,
    "gitSyncEnabled" BOOLEAN NOT NULL DEFAULT false,
    "gitAutoSyncOnSave" BOOLEAN NOT NULL DEFAULT true,
    "gitWebhookSecret" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "WorkspaceSettings_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "GitSyncLog" (
    "id" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "direction" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'running',
    "trigger" TEXT NOT NULL,
    "errorMessage" TEXT,
    "filesChanged" INTEGER NOT NULL DEFAULT 0,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),

    CONSTRAINT "GitSyncLog_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "CalendarEvent" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "startAt" TIMESTAMP(3) NOT NULL,
    "endAt" TIMESTAMP(3),
    "allDay" BOOLEAN NOT NULL DEFAULT false,
    "color" TEXT DEFAULT '#3b82f6',
    "location" TEXT,
    "recurrence" TEXT,
    "googleEventId" TEXT,
    "workspaceId" TEXT NOT NULL,
    "createdById" TEXT NOT NULL,
    "pageId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CalendarEvent_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Todo" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "priority" TEXT NOT NULL DEFAULT 'medium',
    "dueDate" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "workspaceId" TEXT NOT NULL,
    "assigneeId" TEXT,
    "createdById" TEXT NOT NULL,
    "pageId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Todo_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "readAt" TIMESTAMP(3),
    "link" TEXT,
    "userId" TEXT NOT NULL,
    "workspaceId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "GoogleCalendarConnection" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "workspaceId" TEXT NOT NULL,
    "accessToken" TEXT NOT NULL,
    "refreshToken" TEXT NOT NULL,
    "tokenExpiry" TIMESTAMP(3) NOT NULL,
    "calendarId" TEXT NOT NULL DEFAULT 'primary',
    "syncEnabled" BOOLEAN NOT NULL DEFAULT true,
    "lastSyncAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "GoogleCalendarConnection_pkey" PRIMARY KEY ("id")
);


CREATE TABLE "PageTemplate" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "content" TEXT NOT NULL,
    "category" TEXT NOT NULL DEFAULT 'custom',
    "isBuiltIn" BOOLEAN NOT NULL DEFAULT false,
    "workspaceId" TEXT NOT NULL,
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PageTemplate_pkey" PRIMARY KEY ("id")
);


CREATE UNIQUE INDEX "User_email_key" ON "User"("email");


CREATE UNIQUE INDEX "User_oidcIssuer_oidcSubject_key" ON "User"("oidcIssuer", "oidcSubject");


CREATE UNIQUE INDEX "User_samlIssuer_samlSubject_key" ON "User"("samlIssuer", "samlSubject");


CREATE UNIQUE INDEX "SsoLoginToken_tokenHash_key" ON "SsoLoginToken"("tokenHash");


CREATE INDEX "SsoLoginToken_provider_expiresAt_idx" ON "SsoLoginToken"("provider", "expiresAt");


CREATE INDEX "SsoLoginToken_userId_createdAt_idx" ON "SsoLoginToken"("userId", "createdAt");


CREATE UNIQUE INDEX "Organization_slug_key" ON "Organization"("slug");


CREATE INDEX "OrganizationMember_organizationId_idx" ON "OrganizationMember"("organizationId");


CREATE INDEX "OrganizationMember_userId_idx" ON "OrganizationMember"("userId");


CREATE UNIQUE INDEX "OrganizationMember_userId_organizationId_key" ON "OrganizationMember"("userId", "organizationId");


CREATE UNIQUE INDEX "OrganizationDomain_domain_key" ON "OrganizationDomain"("domain");


CREATE INDEX "OrganizationDomain_organizationId_createdAt_idx" ON "OrganizationDomain"("organizationId", "createdAt");


CREATE INDEX "OrganizationDomain_domain_verifiedAt_idx" ON "OrganizationDomain"("domain", "verifiedAt");


CREATE UNIQUE INDEX "OrganizationScimToken_tokenHash_key" ON "OrganizationScimToken"("tokenHash");


CREATE INDEX "OrganizationScimToken_organizationId_createdAt_idx" ON "OrganizationScimToken"("organizationId", "createdAt");


CREATE INDEX "OrganizationScimToken_organizationId_revokedAt_idx" ON "OrganizationScimToken"("organizationId", "revokedAt");


CREATE INDEX "OrganizationScimIdentity_organizationId_active_idx" ON "OrganizationScimIdentity"("organizationId", "active");


CREATE INDEX "OrganizationScimIdentity_organizationId_lastProvisionedAt_idx" ON "OrganizationScimIdentity"("organizationId", "lastProvisionedAt");


CREATE INDEX "OrganizationScimIdentity_userId_idx" ON "OrganizationScimIdentity"("userId");


CREATE UNIQUE INDEX "OrganizationScimIdentity_organizationId_userId_key" ON "OrganizationScimIdentity"("organizationId", "userId");


CREATE UNIQUE INDEX "OrganizationScimIdentity_organizationId_externalId_key" ON "OrganizationScimIdentity"("organizationId", "externalId");


CREATE UNIQUE INDEX "OrganizationScimIdentity_organizationId_userName_key" ON "OrganizationScimIdentity"("organizationId", "userName");


CREATE INDEX "OrganizationScimGroup_organizationId_lastProvisionedAt_idx" ON "OrganizationScimGroup"("organizationId", "lastProvisionedAt");


CREATE INDEX "OrganizationScimGroup_organizationId_createdAt_idx" ON "OrganizationScimGroup"("organizationId", "createdAt");


CREATE UNIQUE INDEX "OrganizationScimGroup_organizationId_externalId_key" ON "OrganizationScimGroup"("organizationId", "externalId");


CREATE UNIQUE INDEX "OrganizationScimGroup_organizationId_displayName_key" ON "OrganizationScimGroup"("organizationId", "displayName");


CREATE INDEX "OrganizationScimGroupMember_scimIdentityId_idx" ON "OrganizationScimGroupMember"("scimIdentityId");


CREATE UNIQUE INDEX "OrganizationScimGroupMember_scimGroupId_scimIdentityId_key" ON "OrganizationScimGroupMember"("scimGroupId", "scimIdentityId");


CREATE UNIQUE INDEX "Workspace_slug_key" ON "Workspace"("slug");


CREATE INDEX "Workspace_organizationId_idx" ON "Workspace"("organizationId");


CREATE INDEX "WorkspaceMember_userId_idx" ON "WorkspaceMember"("userId");


CREATE INDEX "WorkspaceMember_workspaceId_idx" ON "WorkspaceMember"("workspaceId");


CREATE INDEX "WorkspaceMember_workspaceId_managedByScim_idx" ON "WorkspaceMember"("workspaceId", "managedByScim");


CREATE UNIQUE INDEX "WorkspaceMember_userId_workspaceId_key" ON "WorkspaceMember"("userId", "workspaceId");


CREATE INDEX "WorkspaceScimGroupMapping_scimGroupId_createdAt_idx" ON "WorkspaceScimGroupMapping"("scimGroupId", "createdAt");


CREATE INDEX "WorkspaceScimGroupMapping_workspaceId_createdAt_idx" ON "WorkspaceScimGroupMapping"("workspaceId", "createdAt");


CREATE UNIQUE INDEX "WorkspaceScimGroupMapping_workspaceId_scimGroupId_key" ON "WorkspaceScimGroupMapping"("workspaceId", "scimGroupId");


CREATE INDEX "WorkspaceScimProvisionedMember_workspaceId_userId_idx" ON "WorkspaceScimProvisionedMember"("workspaceId", "userId");


CREATE INDEX "WorkspaceScimProvisionedMember_scimGroupId_createdAt_idx" ON "WorkspaceScimProvisionedMember"("scimGroupId", "createdAt");


CREATE UNIQUE INDEX "WorkspaceScimProvisionedMember_workspaceId_userId_scimGroup_key" ON "WorkspaceScimProvisionedMember"("workspaceId", "userId", "scimGroupId");


CREATE INDEX "Page_workspaceId_idx" ON "Page"("workspaceId");


CREATE INDEX "Page_parentId_idx" ON "Page"("parentId");


CREATE INDEX "Page_workspaceId_updatedAt_idx" ON "Page"("workspaceId", "updatedAt");


CREATE INDEX "Page_workspaceId_isDeleted_idx" ON "Page"("workspaceId", "isDeleted");


CREATE UNIQUE INDEX "Page_workspaceId_slug_key" ON "Page"("workspaceId", "slug");


CREATE INDEX "PageEmbeddingChunk_workspaceId_pageId_idx" ON "PageEmbeddingChunk"("workspaceId", "pageId");


CREATE INDEX "PageEmbeddingChunk_workspaceId_updatedAt_idx" ON "PageEmbeddingChunk"("workspaceId", "updatedAt");


CREATE INDEX "PageEmbeddingChunk_workspaceId_model_idx" ON "PageEmbeddingChunk"("workspaceId", "model");


CREATE UNIQUE INDEX "PageEmbeddingChunk_pageId_chunkIndex_key" ON "PageEmbeddingChunk"("pageId", "chunkIndex");


CREATE INDEX "SearchIndexJob_workspaceId_createdAt_idx" ON "SearchIndexJob"("workspaceId", "createdAt");


CREATE INDEX "SearchIndexJob_workspaceId_status_createdAt_idx" ON "SearchIndexJob"("workspaceId", "status", "createdAt");


CREATE INDEX "SearchIndexJob_pageId_createdAt_idx" ON "SearchIndexJob"("pageId", "createdAt");


CREATE INDEX "SearchIndexJob_jobType_status_createdAt_idx" ON "SearchIndexJob"("jobType", "status", "createdAt");


CREATE INDEX "PagePermission_userId_idx" ON "PagePermission"("userId");


CREATE UNIQUE INDEX "PagePermission_pageId_userId_key" ON "PagePermission"("pageId", "userId");


CREATE UNIQUE INDEX "PageShareLink_token_key" ON "PageShareLink"("token");


CREATE UNIQUE INDEX "PageShareLink_pageId_key" ON "PageShareLink"("pageId");


CREATE INDEX "PageShareLink_pageId_revokedAt_idx" ON "PageShareLink"("pageId", "revokedAt");


CREATE INDEX "Backlink_toPageId_idx" ON "Backlink"("toPageId");


CREATE UNIQUE INDEX "Backlink_fromPageId_toPageId_key" ON "Backlink"("fromPageId", "toPageId");


CREATE INDEX "Comment_pageId_idx" ON "Comment"("pageId");


CREATE INDEX "Comment_userId_idx" ON "Comment"("userId");


CREATE INDEX "Attachment_pageId_idx" ON "Attachment"("pageId");


CREATE INDEX "Attachment_securityStatus_securityDisposition_createdAt_idx" ON "Attachment"("securityStatus", "securityDisposition", "createdAt");


CREATE INDEX "Favorite_userId_idx" ON "Favorite"("userId");


CREATE UNIQUE INDEX "Favorite_userId_pageId_key" ON "Favorite"("userId", "pageId");


CREATE INDEX "AiChat_workspaceId_userId_createdAt_idx" ON "AiChat"("workspaceId", "userId", "createdAt");


CREATE INDEX "AiChat_pageId_idx" ON "AiChat"("pageId");


CREATE INDEX "AuditLog_workspaceId_createdAt_idx" ON "AuditLog"("workspaceId", "createdAt");


CREATE INDEX "AuditLog_actorId_createdAt_idx" ON "AuditLog"("actorId", "createdAt");


CREATE INDEX "AuditLog_pageId_createdAt_idx" ON "AuditLog"("pageId", "createdAt");


CREATE INDEX "AuditLog_action_createdAt_idx" ON "AuditLog"("action", "createdAt");


CREATE INDEX "AuditLog_requestId_createdAt_idx" ON "AuditLog"("requestId", "createdAt");


CREATE INDEX "AuditLogWebhookDelivery_status_nextAttemptAt_createdAt_idx" ON "AuditLogWebhookDelivery"("status", "nextAttemptAt", "createdAt");


CREATE INDEX "AuditLogWebhookDelivery_auditLogId_createdAt_idx" ON "AuditLogWebhookDelivery"("auditLogId", "createdAt");


CREATE UNIQUE INDEX "AuditLogWebhookDelivery_auditLogId_destinationType_destinat_key" ON "AuditLogWebhookDelivery"("auditLogId", "destinationType", "destinationLabel");


CREATE INDEX "RetentionRun_startedAt_idx" ON "RetentionRun"("startedAt");


CREATE INDEX "RetentionRun_status_startedAt_idx" ON "RetentionRun"("status", "startedAt");


CREATE INDEX "RetentionRunWorkspace_workspaceId_createdAt_idx" ON "RetentionRunWorkspace"("workspaceId", "createdAt");


CREATE INDEX "RetentionRunWorkspace_retentionRunId_createdAt_idx" ON "RetentionRunWorkspace"("retentionRunId", "createdAt");


CREATE UNIQUE INDEX "RetentionRunWorkspace_retentionRunId_workspaceId_key" ON "RetentionRunWorkspace"("retentionRunId", "workspaceId");


CREATE INDEX "BackupRun_startedAt_idx" ON "BackupRun"("startedAt");


CREATE INDEX "BackupRun_status_startedAt_idx" ON "BackupRun"("status", "startedAt");


CREATE INDEX "BackupArtifact_backupRunId_createdAt_idx" ON "BackupArtifact"("backupRunId", "createdAt");


CREATE INDEX "BackupArtifact_kind_createdAt_idx" ON "BackupArtifact"("kind", "createdAt");


CREATE INDEX "RestoreDrillRun_startedAt_idx" ON "RestoreDrillRun"("startedAt");


CREATE INDEX "RestoreDrillRun_backupRunId_startedAt_idx" ON "RestoreDrillRun"("backupRunId", "startedAt");


CREATE INDEX "RestoreDrillRun_status_startedAt_idx" ON "RestoreDrillRun"("status", "startedAt");


CREATE INDEX "SearchIndexWorkerRun_startedAt_idx" ON "SearchIndexWorkerRun"("startedAt");


CREATE INDEX "SearchIndexWorkerRun_status_startedAt_idx" ON "SearchIndexWorkerRun"("status", "startedAt");


CREATE INDEX "SearchIndexWorkerRun_workspaceScopeId_startedAt_idx" ON "SearchIndexWorkerRun"("workspaceScopeId", "startedAt");


CREATE INDEX "SearchIndexWorkerRunWorkspace_workspaceId_createdAt_idx" ON "SearchIndexWorkerRunWorkspace"("workspaceId", "createdAt");


CREATE INDEX "SearchIndexWorkerRunWorkspace_searchIndexWorkerRunId_create_idx" ON "SearchIndexWorkerRunWorkspace"("searchIndexWorkerRunId", "createdAt");


CREATE UNIQUE INDEX "SearchIndexWorkerRunWorkspace_searchIndexWorkerRunId_worksp_key" ON "SearchIndexWorkerRunWorkspace"("searchIndexWorkerRunId", "workspaceId");


CREATE UNIQUE INDEX "WorkspaceSettings_workspaceId_key" ON "WorkspaceSettings"("workspaceId");


CREATE INDEX "GitSyncLog_workspaceId_startedAt_idx" ON "GitSyncLog"("workspaceId", "startedAt");


CREATE INDEX "CalendarEvent_workspaceId_startAt_idx" ON "CalendarEvent"("workspaceId", "startAt");


CREATE INDEX "CalendarEvent_createdById_idx" ON "CalendarEvent"("createdById");


CREATE INDEX "CalendarEvent_workspaceId_googleEventId_idx" ON "CalendarEvent"("workspaceId", "googleEventId");


CREATE INDEX "Todo_workspaceId_completed_dueDate_idx" ON "Todo"("workspaceId", "completed", "dueDate");


CREATE INDEX "Todo_assigneeId_idx" ON "Todo"("assigneeId");


CREATE INDEX "Todo_createdById_idx" ON "Todo"("createdById");


CREATE INDEX "Notification_userId_read_createdAt_idx" ON "Notification"("userId", "read", "createdAt");


CREATE INDEX "Notification_workspaceId_idx" ON "Notification"("workspaceId");


CREATE INDEX "GoogleCalendarConnection_workspaceId_idx" ON "GoogleCalendarConnection"("workspaceId");


CREATE UNIQUE INDEX "GoogleCalendarConnection_userId_workspaceId_key" ON "GoogleCalendarConnection"("userId", "workspaceId");


CREATE INDEX "PageTemplate_workspaceId_category_idx" ON "PageTemplate"("workspaceId", "category");


ALTER TABLE "SsoLoginToken" ADD CONSTRAINT "SsoLoginToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationMember" ADD CONSTRAINT "OrganizationMember_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationMember" ADD CONSTRAINT "OrganizationMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationDomain" ADD CONSTRAINT "OrganizationDomain_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationScimToken" ADD CONSTRAINT "OrganizationScimToken_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationScimIdentity" ADD CONSTRAINT "OrganizationScimIdentity_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationScimIdentity" ADD CONSTRAINT "OrganizationScimIdentity_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationScimGroup" ADD CONSTRAINT "OrganizationScimGroup_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationScimGroupMember" ADD CONSTRAINT "OrganizationScimGroupMember_scimGroupId_fkey" FOREIGN KEY ("scimGroupId") REFERENCES "OrganizationScimGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "OrganizationScimGroupMember" ADD CONSTRAINT "OrganizationScimGroupMember_scimIdentityId_fkey" FOREIGN KEY ("scimIdentityId") REFERENCES "OrganizationScimIdentity"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Workspace" ADD CONSTRAINT "Workspace_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE "WorkspaceMember" ADD CONSTRAINT "WorkspaceMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceMember" ADD CONSTRAINT "WorkspaceMember_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceScimGroupMapping" ADD CONSTRAINT "WorkspaceScimGroupMapping_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceScimGroupMapping" ADD CONSTRAINT "WorkspaceScimGroupMapping_scimGroupId_fkey" FOREIGN KEY ("scimGroupId") REFERENCES "OrganizationScimGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceScimProvisionedMember" ADD CONSTRAINT "WorkspaceScimProvisionedMember_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceScimProvisionedMember" ADD CONSTRAINT "WorkspaceScimProvisionedMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceScimProvisionedMember" ADD CONSTRAINT "WorkspaceScimProvisionedMember_scimGroupId_fkey" FOREIGN KEY ("scimGroupId") REFERENCES "OrganizationScimGroup"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Page" ADD CONSTRAINT "Page_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "Page"("id") ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE "Page" ADD CONSTRAINT "Page_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageEmbeddingChunk" ADD CONSTRAINT "PageEmbeddingChunk_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageEmbeddingChunk" ADD CONSTRAINT "PageEmbeddingChunk_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "SearchIndexJob" ADD CONSTRAINT "SearchIndexJob_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "SearchIndexJob" ADD CONSTRAINT "SearchIndexJob_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE "PagePermission" ADD CONSTRAINT "PagePermission_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PagePermission" ADD CONSTRAINT "PagePermission_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageShareLink" ADD CONSTRAINT "PageShareLink_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Backlink" ADD CONSTRAINT "Backlink_fromPageId_fkey" FOREIGN KEY ("fromPageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Backlink" ADD CONSTRAINT "Backlink_toPageId_fkey" FOREIGN KEY ("toPageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Comment" ADD CONSTRAINT "Comment_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Comment" ADD CONSTRAINT "Comment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Comment" ADD CONSTRAINT "Comment_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "Comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Attachment" ADD CONSTRAINT "Attachment_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Attachment" ADD CONSTRAINT "Attachment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "AiChat" ADD CONSTRAINT "AiChat_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "AiChat" ADD CONSTRAINT "AiChat_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "AuditLogWebhookDelivery" ADD CONSTRAINT "AuditLogWebhookDelivery_auditLogId_fkey" FOREIGN KEY ("auditLogId") REFERENCES "AuditLog"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "RetentionRunWorkspace" ADD CONSTRAINT "RetentionRunWorkspace_retentionRunId_fkey" FOREIGN KEY ("retentionRunId") REFERENCES "RetentionRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "RetentionRunWorkspace" ADD CONSTRAINT "RetentionRunWorkspace_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "BackupArtifact" ADD CONSTRAINT "BackupArtifact_backupRunId_fkey" FOREIGN KEY ("backupRunId") REFERENCES "BackupRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "RestoreDrillRun" ADD CONSTRAINT "RestoreDrillRun_backupRunId_fkey" FOREIGN KEY ("backupRunId") REFERENCES "BackupRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "SearchIndexWorkerRunWorkspace" ADD CONSTRAINT "SearchIndexWorkerRunWorkspace_searchIndexWorkerRunId_fkey" FOREIGN KEY ("searchIndexWorkerRunId") REFERENCES "SearchIndexWorkerRun"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "SearchIndexWorkerRunWorkspace" ADD CONSTRAINT "SearchIndexWorkerRunWorkspace_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "WorkspaceSettings" ADD CONSTRAINT "WorkspaceSettings_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "GitSyncLog" ADD CONSTRAINT "GitSyncLog_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "CalendarEvent" ADD CONSTRAINT "CalendarEvent_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "CalendarEvent" ADD CONSTRAINT "CalendarEvent_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "CalendarEvent" ADD CONSTRAINT "CalendarEvent_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE "Todo" ADD CONSTRAINT "Todo_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Todo" ADD CONSTRAINT "Todo_assigneeId_fkey" FOREIGN KEY ("assigneeId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE "Todo" ADD CONSTRAINT "Todo_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Todo" ADD CONSTRAINT "Todo_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "Notification" ADD CONSTRAINT "Notification_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "GoogleCalendarConnection" ADD CONSTRAINT "GoogleCalendarConnection_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "GoogleCalendarConnection" ADD CONSTRAINT "GoogleCalendarConnection_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageTemplate" ADD CONSTRAINT "PageTemplate_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "PageTemplate" ADD CONSTRAINT "PageTemplate_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

