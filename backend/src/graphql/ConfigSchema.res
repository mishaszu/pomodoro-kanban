open NodeDefinition
open Graphqljs
open Relay

type configArgsInput = {"userId": simpleField<string>, ...Relay.argsInput}

type configArgsOutput = {"userId": Js.undefined<string>, ...Relay.argsOutput}

let someArgs = Relay.newConnectionArgs()

let configArgsInputValue: configArgsInput = Relay.newConnectionCustomArgs({
  "userId": {
    "type": graphQLIdType,
    "description": "The uuid of the user.",
  },
})

type configFields = {
  id: field<string>,
  pomodoroDuration: field<int>,
  shortBreakDuration: field<int>,
  longBreakDuration: field<int>,
  longBreakInterval: field<int>,
  autoStartBreak: field<bool>,
  autoStartPomodoro: field<bool>,
  showCompletedTasks: field<bool>,
  createdAt: field<int>,
  updatedAt: field<int>,
}

let configType = Graphqljs.newGraphqlObjectType({
  name: "Config",
  description: "User config for pomodoro timer"->Js.Undefined.return,
  interfaces: (() => [nodeDefinitions.nodeInterface])->Js.Undefined.return,
  fields: () => {
    id: {
      "type": graphQLIdType->newGraphQLNonNull,
      "description": "The uuid of the user.",
      "resolve": Js.Undefined.return(obj =>
        obj->Relay.customIdTypeCreator("config")->Js.Null.return
      ),
    },
    pomodoroDuration: {
      "type": graphQLIntType->newGraphQLNonNull,
      "description": "The duration of a pomodoro in minutes.",
      "resolve": Js.undefined,
    },
    shortBreakDuration: {
      "type": graphQLIntType->newGraphQLNonNull,
      "description": "The duration of a short break in minutes.",
      "resolve": Js.undefined,
    },
    longBreakDuration: {
      "type": graphQLIntType->newGraphQLNonNull,
      "description": "The duration of a long break in minutes.",
      "resolve": Js.undefined,
    },
    longBreakInterval: {
      "type": graphQLIntType->newGraphQLNonNull,
      "description": "The number of pomodoros before a long break.",
      "resolve": Js.undefined,
    },
    autoStartBreak: {
      "type": graphQLBooleanType->newGraphQLNonNull,
      "description": "Whether to automatically start a break after a pomodoro.",
      "resolve": Js.undefined,
    },
    autoStartPomodoro: {
      "type": graphQLBooleanType->newGraphQLNonNull,
      "description": "Whether to automatically start a pomodoro after a break.",
      "resolve": Js.undefined,
    },
    showCompletedTasks: {
      "type": graphQLBooleanType->newGraphQLNonNull,
      "description": "Whether to show completed tasks in the task list.",
      "resolve": Js.undefined,
    },
    createdAt: {
      "type": graphQLFloatType->newGraphQLNonNull,
      "description": "The timestamp of when the user was created.",
      "resolve": Js.undefined,
    },
    updatedAt: {
      "type": graphQLFloatType->newGraphQLNonNull,
      "description": "The timestamp of when the user was last updated.",
      "resolve": Js.undefined,
    },
  },
})

type addConfigMutationValues = {
  userId: string,
  pomodoroDuration: int,
  shortBreakDuration: int,
  longBreakDuration: int,
  longBreakInterval: int,
  autoStartBreak: bool,
  autoStartPomodoro: bool,
  showCompletedTasks: bool,
}

let addConfigMutationFields = {
  "userId": {
    "type": graphQLStringType->newGraphQLNonNull,
    "description": "The uuid of the user.",
  },
  "pomodoroDuration": {
    "type": graphQLIntType->newGraphQLNonNull,
    "description": "The duration of a pomodoro in minutes.",
  },
  "shortBreakDuration": {
    "type": graphQLIntType->newGraphQLNonNull,
    "description": "The duration of a short break in minutes.",
  },
  "longBreakDuration": {
    "type": graphQLIntType->newGraphQLNonNull,
    "description": "The duration of a long break in minutes.",
  },
  "longBreakInterval": {
    "type": graphQLIntType->newGraphQLNonNull,
    "description": "The number of pomodoros before a long break.",
  },
  "autoStartBreak": {
    "type": graphQLBooleanType->newGraphQLNonNull,
    "description": "Whether to automatically start a break after a pomodoro.",
  },
  "autoStartPomodoro": {
    "type": graphQLBooleanType->newGraphQLNonNull,
    "description": "Whether to automatically start a pomodoro after a break.",
  },
  "showCompletedTasks": {
    "type": graphQLBooleanType->newGraphQLNonNull,
    "description": "Whether to show completed tasks in the task list.",
  },
}

@get external message: graphQlObject => string = "message"
@get external error: graphQlObject => string = "error"

let addConfigMutationOutputFields: outputFieldsDef<string, string> = {
  message: {
    "type": graphQLStringType->newGraphQLNonNull,
    "description": "A message describing the result of the mutation.",
    "resolve": Js.Undefined.return(obj => obj->message->Js.Null.return),
  },
  error: {
    "type": graphQLStringType,
    "description": "An error message if the mutation failed.",
    "resolve": Js.Undefined.return(obj => obj->error->Js.Null.return),
  },
}
let addConfigMutation = mutationWithClientMutationId({
  name: "AddConfig",
  description: "Add a config for a user.",
  inputFields: addConfigMutationFields,
  outputFields: addConfigMutationOutputFields,
  mutateAndGetPayload: async input => {
    let userId = input.userId->Relay.parseCustomIdTypeId

    let result = switch userId {
    | Some(userId) => {
        let value = await DbManager.createConfig({
          "id": Uuid.uuidV4(),
          "pomodoroDuration": input.pomodoroDuration,
          "shortBreakDuration": input.shortBreakDuration,
          "longBreakDuration": input.longBreakDuration,
          "longBreakInterval": input.longBreakInterval,
          "autoStartBreak": input.autoStartBreak,
          "autoStartPomodoro": input.autoStartPomodoro,
          "showCompletedTasks": input.showCompletedTasks,
          "User": {
            "connect": {"id": userId},
          },
        })
        Ok(value)
      }
    | None => Error("Invalid user id.")
    }

    switch result {
    | Ok(_) => {
        message: "Config added successfully.",
        error: Js.Null.empty,
      }
    | Error(error) => {
        message: "",
        error: error->Js.Null.return,
      }
    }
  },
})

type deleteInputFields = {configId: string}

let deleteConfigMutation = mutationWithClientMutationId({
  name: "DeleteConfig",
  description: "Delete a config by its id.",
  inputFields: {
    "configId": {
      "type": graphQLIdType->newGraphQLNonNull,
      "description": "The uuid of the config.",
    },
  },
  outputFields: addConfigMutationOutputFields,
  mutateAndGetPayload: async input => {
    let configId = input.configId->Relay.parseCustomIdTypeId

    let result = switch configId {
    | Some(userId) => {
        let value = await DbManager.deleteConfig(userId)
        Ok(value)
      }
    | None => Error("Invalid user id.")
    }

    switch result {
    | Ok(_) => {
        message: "Config deleted successfully.",
        error: Js.Null.empty,
      }
    | Error(error) => {
        message: "",
        error: error->Js.Null.return,
      }
    }
  },
})
