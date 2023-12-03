type t

@module("@prisma/client") @new external createClient: unit => t = "PrismaClient"

type model<'t>

type select<'m> = {"select": 'm}

type uniqueWhere = {"where": {"id": Uuid.t}}
type uniqueWhereSelect<'m> = {"where": {"id": Uuid.t}, "select": 'm}

@send external findMany: model<'t> => promise<array<'m>> = "findMany"
@send external findManySelect: (model<'t>, select<'m>) => promise<array<'n>> = "findMany"
@send external findUnique: (model<'t>, uniqueWhere) => promise<Js.Null.t<'m>> = "findUnique"
@send
external findUniqueSelect: (model<'t>, uniqueWhereSelect<'m>) => promise<Js.Null.t<'n>> =
  "findUnique"
@send external count: model<'t> => promise<int> = "findMany"
