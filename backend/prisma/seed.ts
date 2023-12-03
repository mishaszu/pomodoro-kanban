import { PrismaClient } from "@prisma/client";
import { v4 as uuidv4 } from "uuid";

const prisma = new PrismaClient();

async function main() {
  const admin = await prisma.user.upsert({
    where: { email: "admin1@test.com" },
    update: {},
    create: {
      id: uuidv4(),
      name: "Nice Admin",
      email: "admin1@test.com",
      password: "dev_only",
      isAdmin: true,
    },
  });
  console.log({ admin });
}

main()
  .then(() => {
    console.log("seeded");
    prisma.$disconnect();
  })
  .catch((e) => {
    console.error(e);
    prisma.$disconnect();
    process.exit(1);
  });
