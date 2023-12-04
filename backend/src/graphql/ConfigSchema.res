open NodeDefinition
open Graphqljs

type configArgs = {userId: simpleField<string>}

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
      "type": graphQLIntType->newGraphQLNonNull,
      "description": "The timestamp of when the user was created.",
      "resolve": Js.undefined,
    },
    updatedAt: {
      "type": graphQLIntType->newGraphQLNonNull,
      "description": "The timestamp of when the user was last updated.",
      "resolve": Js.undefined,
    },
  },
})
