type mapperParam = {"type": string, "id": string}

type globalIdToDb<'context> = (string, 'context) => promise<Js.Null.t<Graphqljs.graphQlObject>>
type dbToGraphql = Graphqljs.graphQlObject => Js.null<string>

@module("graphql-relay")
external createNodeDefinitions: (globalIdToDb<'c>, dbToGraphql) => RelayNode.nodeDefinitions =
  "nodeDefinitions"

@module("graphql-relay") external fromGlobalId: string => mapperParam = "fromGlobalId"
@module("graphql-relay") external globalIdField: string => Graphqljs.field<'a> = "globalIdField"
@module("graphql-relay") external globalIdFieldUnit: unit => Graphqljs.field<'a> = "globalIdField"

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
@module("graphql-relay") external connectionArgs: Graphqljs.connectionArgs = "connectionArgs"

let newConnctionArgsFun: Graphqljs.connectionArgs => Graphqljs.connectionArgs = %raw(`
  (connectionArgs) => ({...connectionArgs})
`)

let newConnectionArgs = () => newConnctionArgsFun(connectionArgs)
