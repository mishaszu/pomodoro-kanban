type t

type middleware

module Response = {
  type t

  @send external send: (t, string) => unit = "send"
  @send external sendJson: (t, Js.Json.t) => unit = "json"
  @send external sendStatus: (t, int) => unit = "status"
}

module Request = {
  type t

  @get external path: t => string = "path"
  @get external method: t => string = "method"
  @get external query: t => Js.Dict.t<string> = "query"
  @get external params: t => Js.Dict.t<string> = "params"
  @get external body: t => Js.Json.t = "body"
}

module Middleware = {
  type t

  type callback = (Request.t, Response.t) => promise<unit>
}

@module external newApp: unit => t = "express"
@send external use: (t, Middleware.t) => unit = "use"
@send external useWithPath: (t, string, Middleware.t) => unit = "use"
@send external get: (t, string, Middleware.callback) => unit = "get"
@send external listen: (t, int, unit => unit) => unit = "listen"
