-- CreateEnum
CREATE TYPE "CheckType" AS ENUM ('IN', 'OUT');

-- CreateEnum
CREATE TYPE "ItemTransactionType" AS ENUM ('BORROW', 'RETURN', 'LOST', 'DAMAGED', 'ADJUSTMENT');

-- CreateEnum
CREATE TYPE "GuestVisitType" AS ENUM ('IN', 'OUT');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phoneNumber" TEXT,
    "passwordHash" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Role" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserRole" (
    "userId" TEXT NOT NULL,
    "roleId" INTEGER NOT NULL,

    CONSTRAINT "UserRole_pkey" PRIMARY KEY ("userId","roleId")
);

-- CreateTable
CREATE TABLE "CheckLog" (
    "id" BIGSERIAL NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "CheckType" NOT NULL,
    "eventTime" TIMESTAMP(3) NOT NULL,
    "note" TEXT,
    "processedBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "CheckLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Item" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "totalQuantity" INTEGER NOT NULL,
    "availableQuantity" INTEGER NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "Item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemTransaction" (
    "id" BIGSERIAL NOT NULL,
    "itemId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "ItemTransactionType" NOT NULL,
    "eventTime" TIMESTAMP(3) NOT NULL,
    "qty" INTEGER NOT NULL,
    "note" TEXT,
    "processedBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "ItemTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Guest" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "phoneNumber" TEXT,
    "note" TEXT,

    CONSTRAINT "Guest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GuestVisit" (
    "id" BIGSERIAL NOT NULL,
    "guestId" UUID NOT NULL,
    "hostUserId" TEXT NOT NULL,
    "type" "GuestVisitType" NOT NULL,
    "eventTime" TIMESTAMP(3) NOT NULL,
    "note" TEXT,

    CONSTRAINT "GuestVisit_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_name_idx" ON "User"("name");

-- CreateIndex
CREATE INDEX "User_isActive_idx" ON "User"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Role_name_key" ON "Role"("name");

-- CreateIndex
CREATE INDEX "UserRole_userId_idx" ON "UserRole"("userId");

-- CreateIndex
CREATE INDEX "UserRole_roleId_idx" ON "UserRole"("roleId");

-- CreateIndex
CREATE INDEX "CheckLog_userId_eventTime_idx" ON "CheckLog"("userId", "eventTime" DESC);

-- CreateIndex
CREATE INDEX "CheckLog_eventTime_idx" ON "CheckLog"("eventTime" DESC);

-- CreateIndex
CREATE INDEX "Item_isActive_idx" ON "Item"("isActive");

-- CreateIndex
CREATE INDEX "Item_isActive_name_idx" ON "Item"("isActive", "name");

-- CreateIndex
CREATE INDEX "Item_name_idx" ON "Item"("name");

-- CreateIndex
CREATE INDEX "ItemTransaction_eventTime_idx" ON "ItemTransaction"("eventTime" DESC);

-- CreateIndex
CREATE INDEX "ItemTransaction_userId_eventTime_idx" ON "ItemTransaction"("userId", "eventTime" DESC);

-- CreateIndex
CREATE INDEX "ItemTransaction_itemId_eventTime_idx" ON "ItemTransaction"("itemId", "eventTime" DESC);

-- CreateIndex
CREATE INDEX "ItemTransaction_type_idx" ON "ItemTransaction"("type");

-- CreateIndex
CREATE INDEX "Guest_name_idx" ON "Guest"("name");

-- CreateIndex
CREATE INDEX "GuestVisit_eventTime_idx" ON "GuestVisit"("eventTime" DESC);

-- CreateIndex
CREATE INDEX "GuestVisit_guestId_eventTime_idx" ON "GuestVisit"("guestId", "eventTime" DESC);

-- CreateIndex
CREATE INDEX "GuestVisit_hostUserId_eventTime_idx" ON "GuestVisit"("hostUserId", "eventTime" DESC);

-- AddForeignKey
ALTER TABLE "UserRole" ADD CONSTRAINT "UserRole_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserRole" ADD CONSTRAINT "UserRole_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CheckLog" ADD CONSTRAINT "CheckLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CheckLog" ADD CONSTRAINT "CheckLog_processedBy_fkey" FOREIGN KEY ("processedBy") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemTransaction" ADD CONSTRAINT "ItemTransaction_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "Item"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemTransaction" ADD CONSTRAINT "ItemTransaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemTransaction" ADD CONSTRAINT "ItemTransaction_processedBy_fkey" FOREIGN KEY ("processedBy") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GuestVisit" ADD CONSTRAINT "GuestVisit_guestId_fkey" FOREIGN KEY ("guestId") REFERENCES "Guest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GuestVisit" ADD CONSTRAINT "GuestVisit_hostUserId_fkey" FOREIGN KEY ("hostUserId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
