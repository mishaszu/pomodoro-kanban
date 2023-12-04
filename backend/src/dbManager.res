open DbSchema
open Prisma
open InitPrisma

let findUser = async id => {
  await prisma->user->findUnique({"where": {id}})
}

let getUsers = async () => {
  await prisma->user->findMany
}

let getConfigs = async () => {
  await prisma->config->findMany
}

let getConfigsBuyUserIds = async userIds => {
  await prisma->config->findManyWhere({"where": {"userId": {"in": userIds}}})
}

let createConfig = async config => {
  await prisma
  ->DbSchema.config
  ->createWithRef({
    "data": config,
  })
}

let deleteConfig = async id => {
  await prisma
  ->DbSchema.config
  ->delete({
    "where": {"id": id},
  })
}
