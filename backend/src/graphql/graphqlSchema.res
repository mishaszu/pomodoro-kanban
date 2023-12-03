open NodeDefinition
open Graphqljs

type userFields = {
  id: field<string>,
  name: field<string>,
  email: field<string>,
}

@get external userName: graphQlObject => Js.Null.t<string> = "name"
@get external userEmail: graphQlObject => Js.Null.t<string> = "email"

let userType = Graphqljs.newGraphqlObjectType({
  name: "User",
  description: "A user in the system."->Js.Undefined.return,
  interfaces: Js.Undefined.return(() => [nodeDefinitions.nodeInterface]),
  fields: () => {
    id: Relay.globalIdField("User"),
    name: {
      "type": graphQLStringType,
      "description": "The name of the user.",
      "resolve": Js.undefined,
    },
    email: {
      "type": graphQLStringType,
      "description": "The email of the user.",
      "resolve": Js.undefined,
    },
  },
})

type queryFields = {
  users: fieldWithArgs<array<DbSchema.user>>,
  node: RelayNode.nodeField,
  nodes: RelayNode.nodesField,
}

let userConnectionType = Relay.connectionDefinitions({
  name: "User",
  nodeType: userType,
})

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
