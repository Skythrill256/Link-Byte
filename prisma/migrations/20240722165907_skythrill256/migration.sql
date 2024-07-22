-- CreateTable
CREATE TABLE "Link" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "keyword" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "ip" TEXT NOT NULL,
    "click" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Link_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Log" (
    "id" TEXT NOT NULL,
    "linkKeyword" TEXT NOT NULL,
    "referrer" TEXT NOT NULL,
    "userAgent" TEXT NOT NULL,
    "ip" TEXT NOT NULL,
    "countryCode" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Link_keyword_key" ON "Link"("keyword");

-- CreateIndex
CREATE INDEX "Log_linkKeyword_idx" ON "Log"("linkKeyword");

-- AddForeignKey
ALTER TABLE "Log" ADD CONSTRAINT "Log_linkKeyword_fkey" FOREIGN KEY ("linkKeyword") REFERENCES "Link"("keyword") ON DELETE CASCADE ON UPDATE CASCADE;
