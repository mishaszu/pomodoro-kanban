open Relay

let toDb: globalIdToDb<'c> = async (id, _b) => {
  switch parseCustomIdType(id) {
  | Some(("user", id)) => {
      let user = await DbManager.findUser({
        "id": id,
      })
      user
    }
  | _ => Js.Null.empty
  }
}

@get external email: Graphqljs.graphQlObject => Js.Null.t<string> = "email"

let objToType: dbToGraphql = obj => {
  let isUser = obj->email->Js.Null.toOption
  switch isUser {
  | Some(_) => "User"->Js.Null.return
  | None => Js.null
  }
}

let nodeDefinitions = createNodeDefinitions(toDb, objToType)
