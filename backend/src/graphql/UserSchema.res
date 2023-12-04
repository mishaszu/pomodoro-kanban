open NodeDefinition
open Graphqljs

type userFields = {
  id: field<string>,
  name: field<string>,
  email: field<string>,
  createdAt: field<int>,
  updatedAt: field<int>,
}

let userType = Graphqljs.newGraphqlObjectType({
  name: "User",
  description: "A user in the system."->Js.Undefined.return,
  interfaces: Js.Undefined.return(() => [nodeDefinitions.nodeInterface]),
  fields: () => {
    id: {
      "type": graphQLIdType->newGraphQLNonNull,
      "description": "The uuid of the user.",
      "resolve": Js.Undefined.return(obj => obj->Relay.customIdTypeCreator("user")->Js.Null.return),
    },
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
    createdAt: {
      "type": graphQLFloatType,
      "description": "The date the user was created.",
      "resolve": Js.undefined,
    },
    updatedAt: {
      "type": graphQLFloatType,
      "description": "The date the user was last updated.",
      "resolve": Js.undefined,
    },
  },
})
