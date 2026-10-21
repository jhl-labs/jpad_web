





DROP INDEX "Comment_pageId_idx";

CREATE INDEX "Comment_pageId_parentId_createdAt_idx" ON "Comment"("pageId", "parentId", "createdAt");



CREATE INDEX "Attachment_createdAt_idx" ON "Attachment"("createdAt");
