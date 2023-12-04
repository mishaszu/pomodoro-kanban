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
external connectionFromArray: ('a, Graphqljs.connectionArgs) => Js.Null.t<'a> =
  "connectionFromArray"

type args = {
  before: Graphqljs.simpleField<string>,
  after: Graphqljs.simpleField<string>,
  first: Graphqljs.simpleField<int>,
  last: Graphqljs.simpleField<int>,
}

@module("graphql-relay") external connectionArgs: Graphqljs.connectionArgs = "connectionArgs"

let newConnctionArgsFun: Graphqljs.connectionArgs => Graphqljs.connectionArgs = %raw(`
  (connectionArgs) => ({...connectionArgs})
`)

let newConnectionArgs = () => newConnctionArgsFun(connectionArgs)

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
