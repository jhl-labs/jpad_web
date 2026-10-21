


ALTER TABLE "Page" ADD COLUMN     "passwordHash" TEXT,
ADD COLUMN     "passwordHint" TEXT,
ADD COLUMN     "passwordSetById" TEXT,
ADD COLUMN     "passwordSetAt" TIMESTAMP(3);
