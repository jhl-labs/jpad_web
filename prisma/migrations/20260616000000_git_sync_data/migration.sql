
ALTER TABLE "WorkspaceSettings"
  ADD COLUMN "gitSyncIncludeData" BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN "gitSyncImportOnPull" BOOLEAN NOT NULL DEFAULT false;
