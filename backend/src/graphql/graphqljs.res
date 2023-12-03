type t
type graphQLString
type graphQlObject
type connectionArgs

type fieldType

type field<'a> = {
  "type": fieldType,
  "description": string,
  "resolve": Js.undefined<graphQlObject => Js.Null.t<'a>>,
}

type fieldWithArgs<'a> = {
  "type": fieldType,
  "description": Js.undefined<string>,
  "args": connectionArgs,
  "resolve": (graphQlObject, connectionArgs) => promise<Js.Null.t<'a>>,
}

type objectInput<'t, 'c> = {
  name: string,
  description: Js.undefined<string>,
  interfaces: Js.undefined<unit => array<RelayNode.nodeInterface>>,
  fields: 'c => 't,
}

type graphqlQueryObject<'t> = {
  name: string,
  fields: unit => 't,
}

type mutation<'t, 'd> = {
  inputFields: 't,
  outputFields: 'd,
  mutateAndGetPayload: 't => 'd,
}

type schema<'t, 'f> = {
  query: Js.undefined<'t>,
  mutation: Js.undefined<'f>,
}

@module("graphql") @new
external newGraphqlSchema: schema<'q, 'm> => Yoga.Schema.t = "GraphQLSchema"

@module("graphql") @new
external newGraphqlObjectType: objectInput<'t, 'c> => graphQlObject = "GraphQLObjectType"

@module("graphql") external graphQLStringType: fieldType = "GraphQLString"
