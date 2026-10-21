
ALTER TABLE "WorkspaceSettings"
  ADD COLUMN "gitSyncDebounceMs" INTEGER,
  ADD COLUMN "gitSyncMaxWaitMs" INTEGER;
