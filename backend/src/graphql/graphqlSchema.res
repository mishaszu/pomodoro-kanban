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

type appArgsInput =
  | RelayDefault(Relay.argsInput)
  | WithUserId(configArgsInput)

type outputArgs = [
  | #RelayDefaultOut
  | #WithUserIdOut
]

type queryFields = {
  users: fieldWithArgs<array<DbSchema.user>, appArgsInput, outputArgs>,
  configs: fieldWithArgs<array<DbSchema.config>, appArgsInput, outputArgs>,
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
      "args": Relay.newConnectionArgs()->RelayDefault->Helper.jsUnwrapVariant,
      "resolve": async (_, args) => {
        let users = await DbManager.getUsers()
        Relay.connectionFromArray(users, args)
      },
    },
    configs: {
      "type": configConnectionType.connectionType,
      "description": Js.Undefined.return("A list of configs."),
      "args": configArgsInputValue->WithUserId->Helper.jsUnwrapVariant,
      "resolve": async (_, args) => {
        let args: configArgsOutput = args->Helper.jsFakeUnwrapVariant
        let userId = args["userId"]
        let configs = switch Js.Undefined.toOption(userId) {
        | Some(userId) => await DbManager.getConfigsBuyUserIds(Relay.parseCustomIdTypeId(userId))
        | None => await DbManager.getConfigs()
        }
        Relay.connectionFromArray(configs, args)
      },
    },
  },
})

type mutationFields = {test: field<string>, addConfig: mutationField, deleteConfig: mutationField}

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
    addConfig: addConfigMutation,
    deleteConfig: deleteConfigMutation,
  },
})

let schema = Graphqljs.newGraphqlSchema({
  query: Js.Undefined.return(queryType),
  mutation: Js.Undefined.return(mutationType),
})
