open NodeDefinition
open Graphqljs
open UserSchema
open ConfigSchema

let userConnectionType = Relay.connectionDefinitions({
  name: "User",
  nodeType: userType,
})

let configConnectionType = Relay.connectionDefinitions({
  name: "Config",
  nodeType: configType,
})

type queryFields = {
  users: fieldWithArgs<array<DbSchema.user>>,
  configs: fieldWithArgs<array<DbSchema.config>>,
  node: RelayNode.nodeField,
  nodes: RelayNode.nodesField,
}

let queryType = Graphqljs.newGraphqlObjectType({
  name: "Query",
  description: "The query root of the system."->Js.Undefined.return,
  interfaces: Js.undefined,
  fields: () => {
    node: nodeDefinitions.nodeField,
    nodes: nodeDefinitions.nodesField,
    users: {
      "type": userConnectionType.connectionType,
      "description": Js.Undefined.return("A list of users."),
      "args": Relay.newConnectionArgs(),
      "resolve": async (_, args) => {
        let users = await DbManager.getUsers()
        Relay.connectionFromArray(users, args)
      },
    },
    configs: {
      "type": configConnectionType.connectionType,
      "description": Js.Undefined.return("A list of configs."),
      "args": Relay.newConnectionArgs(),
      "resolve": async (_, args) => {
        Js.log(args)
        let configs = await DbManager.getConfigs()
        Relay.connectionFromArray(configs, args)
      },
    },
  },
})

type mutationFields = {test: field<string>}

let mutationType = Graphqljs.newGraphqlObjectType({
  name: "Mutation",
  description: "The mutation root of the system."->Js.Undefined.return,
  interfaces: Js.undefined,
  fields: () => {
    test: {
      "type": graphQLStringType,
      "description": "A test mutation.",
      "resolve": (_ => "test"->Js.Null.return)->Js.Undefined.return,
    },
  },
})

let schema = Graphqljs.newGraphqlSchema({
  query: Js.Undefined.return(queryType),
  mutation: Js.Undefined.return(mutationType),
})
