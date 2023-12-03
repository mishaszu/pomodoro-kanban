open DbSchema
open Prisma
open InitPrisma

let findUser = async id => {
  await prisma -> user -> findUnique({ "where": { id } })
}

let getUsers = async () => {
  await prisma -> user -> findMany
}
