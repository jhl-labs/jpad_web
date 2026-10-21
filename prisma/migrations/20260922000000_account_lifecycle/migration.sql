ALTER TABLE "User" ADD COLUMN "isOidcPlatformAdmin" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN "disabledAt" TIMESTAMP(3),
ADD COLUMN "sessionVersion" INTEGER NOT NULL DEFAULT 0;


UPDATE "User" SET "isOidcPlatformAdmin" = true, "isPlatformAdmin" = false
WHERE "oidcSubject" IS NOT NULL AND "isPlatformAdmin" = true;
