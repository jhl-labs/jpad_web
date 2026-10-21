ALTER TABLE "AiChat" ADD COLUMN "citations" JSONB NOT NULL DEFAULT '[]';

CREATE TABLE "FormSubmission" (
  "id" TEXT NOT NULL, "formId" TEXT NOT NULL, "requestId" TEXT NOT NULL, "rowId" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "FormSubmission_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "FormSubmission_formId_fkey" FOREIGN KEY ("formId") REFERENCES "DatabaseForm"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "FormSubmission_formId_requestId_key" ON "FormSubmission"("formId", "requestId");
CREATE INDEX "FormSubmission_formId_createdAt_idx" ON "FormSubmission"("formId", "createdAt");

CREATE TABLE "AutomationRun" (
  "id" TEXT NOT NULL, "automationId" TEXT NOT NULL, "eventKey" TEXT NOT NULL, "context" JSONB NOT NULL, "actions" JSONB NOT NULL,
  "status" TEXT NOT NULL DEFAULT 'pending', "nextAction" INTEGER NOT NULL DEFAULT 0, "attempts" INTEGER NOT NULL DEFAULT 0,
  "leaseToken" TEXT, "leaseUntil" TIMESTAMP(3), "retryAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "lastError" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "AutomationRun_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "AutomationRun_automationId_fkey" FOREIGN KEY ("automationId") REFERENCES "Automation"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "AutomationRun_automationId_eventKey_key" ON "AutomationRun"("automationId", "eventKey");
CREATE INDEX "AutomationRun_status_retryAt_idx" ON "AutomationRun"("status", "retryAt");

CREATE TABLE "MeetingDraft" (
  "id" TEXT NOT NULL, "workspaceId" TEXT NOT NULL, "userId" TEXT NOT NULL, "title" TEXT NOT NULL, "transcript" TEXT NOT NULL,
  "summary" JSONB NOT NULL, "consentAt" TIMESTAMP(3) NOT NULL, "appliedAt" TIMESTAMP(3), "pageId" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "MeetingDraft_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "MeetingDraft_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "MeetingDraft_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX "MeetingDraft_workspaceId_userId_createdAt_idx" ON "MeetingDraft"("workspaceId", "userId", "createdAt");

CREATE TABLE "PageSource" (
  "id" TEXT NOT NULL, "workspaceId" TEXT NOT NULL, "userId" TEXT NOT NULL, "pageId" TEXT NOT NULL, "url" TEXT NOT NULL,
  "fetchedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP, "sourceHash" TEXT NOT NULL,
  CONSTRAINT "PageSource_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "PageSource_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "PageSource_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "PageSource_pageId_fkey" FOREIGN KEY ("pageId") REFERENCES "Page"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "PageSource_pageId_key" ON "PageSource"("pageId");
CREATE INDEX "PageSource_workspaceId_userId_idx" ON "PageSource"("workspaceId", "userId");


ALTER TABLE "Automation" ADD COLUMN "activatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;
