type mapperParam = {"type": string, "id": string}

type globalIdToDb<'context> = (string, 'context) => promise<Js.Null.t<Graphqljs.graphQlObject>>
type dbToGraphql = Graphqljs.graphQlObject => Js.null<string>

@module("graphql-relay")
external createNodeDefinitions: (globalIdToDb<'c>, dbToGraphql) => RelayNode.nodeDefinitions =
  "nodeDefinitions"

@module("graphql-relay") external fromGlobalId: string => mapperParam = "fromGlobalId"
@module("graphql-relay") external globalIdField: string => Graphqljs.field<'a> = "globalIdField"
@module("graphql-relay") external globalIdFieldUnit: unit => Graphqljs.field<'a> = "globalIdField"
@module("graphql-relay")
external globalIdFieldCustomFetcher: (
  string,
  Graphqljs.graphQlObject => string,
) => Graphqljs.field<'a> = "globalIdField"

type connectionConfig = {
  name: string,
  nodeType: Graphqljs.graphQlObject,
}

type connectionOutput = {connectionType: Graphqljs.fieldType}

@module("graphql-relay")
external connectionDefinitions: connectionConfig => connectionOutput = "connectionDefinitions"
@module("graphql-relay")
external connectionFromArrayFn: ('a, 'b) => Js.Null.t<'a> = "connectionFromArray"

let connectionFromArray = (arr: 'a, args: 'b) =>
  connectionFromArrayFn(arr, Helper.jsUnwrapVariant(args))

type argsInput = {
  "before": Graphqljs.simpleField<string>,
  "after": Graphqljs.simpleField<string>,
  "first": Graphqljs.simpleField<int>,
  "last": Graphqljs.simpleField<int>,
}

type argsOutput = {"before": string, "after": string, "first": int, "last": int}

@module("graphql-relay") external connectionArgs: argsInput = "connectionArgs"

let newConnctionArgsFun: argsInput => argsInput = %raw(`
  (connectionArgs) => ({...connectionArgs})
`)

let mergeArgs: (argsInput, 'a) => 'b = %raw(`
  (connectionArgs, args) => ({...connectionArgs, ...args})
`)

let newConnectionArgs = () => newConnctionArgsFun(connectionArgs)
let newConnectionCustomArgs = a => mergeArgs(connectionArgs, a)

@get external userId: Graphqljs.graphQlObject => string = "id"
let customIdTypeCreator = (obj: Graphqljs.graphQlObject, type_: string) =>
  type_ ++ "+" ++ userId(obj)

type customTypeId = (string, string)

let parseCustomIdType = (id: string): option<customTypeId> => {
  let idArr = id->Js.String2.split("+")
  switch idArr {
  | [type_, id] => Some((type_, id))
  | _ => None
  }
}

let parseCustomIdTypeId = (id: string) =>
  switch parseCustomIdType(id) {
  | Some((_, id)) => Some(id)
  | None => None
  }

type outputFieldsDef<'a, 'b> = {
  message: Graphqljs.field<'a>,
  error: Graphqljs.field<'b>,
}

type outputFields<'a, 'b> = {
  message: 'a,
  error: Js.null<'b>,
}

type mutation<'a, 'b, 'c, 'd, 'e, 'f> = {
  name: string,
  description: string,
  inputFields: 'a,
  mutateAndGetPayload: 'b => promise<outputFields<'c, 'd>>,
  outputFields: outputFieldsDef<'e, 'f>,
}

@module("graphql-relay")
external mutationWithClientMutationId: mutation<'a, 'b, 'c, 'd, 'e, 'f> => Graphqljs.mutationField =
  "mutationWithClientMutationId"
