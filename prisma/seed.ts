import 'dotenv/config';
import bcrypt from 'bcryptjs';
import { prisma } from './prisma';

async function main() {
  const { ADMIN_EMAIL, ADMIN_PASSWORD, ADMIN_NAME } = process.env;

  if (!ADMIN_EMAIL || !ADMIN_PASSWORD || !ADMIN_NAME) {
    throw new Error('ADMIN Information must be set in .env');
  }

  // 1. Seed roles
  const roles = ['Admin', 'Resident'];
  const roleRecords = await prisma.$transaction(
    roles.map((name) =>
      prisma.role.upsert({
        where: { name },
        update: {},
        create: { name },
      }),
    ),
  );

  const adminRole = roleRecords.find((r) => r.name === 'Admin');
  if (!adminRole) throw new Error('Admin role not found');

  // 2. Upsert admin user
  const passwordHash = await bcrypt.hash(ADMIN_PASSWORD, 10);

  const adminUser = await prisma.user.upsert({
    where: { email: ADMIN_EMAIL },
    update: {},
    create: {
      name: ADMIN_NAME,
      email: ADMIN_EMAIL,
      passwordHash,
      isActive: true,
    },
  });

  // 3. Attach Admin role (idempotent)
  await prisma.userRole.upsert({
    where: {
      userId_roleId: {
        userId: adminUser.id,
        roleId: adminRole.id,
      },
    },
    update: {},
    create: {
      userId: adminUser.id,
      roleId: adminRole.id,
    },
  });

  console.log('✅ Roles seeded:', roles.join(', '));
  console.log('✅ Admin user ready:', adminUser.email);
}

main()
  .catch((e) => {
    console.error('❌ Seed failed', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
