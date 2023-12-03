type t = Express.Middleware.t
type graphiqlMiddleware

module Schema = {
  type t
}

@module("graphql-yoga") external createYoga: unit => t = "createYoga"

type configuration = {
  schema: Schema.t,
  renderGraphiQL: graphiqlMiddleware,
}

@module("graphql-yoga") external createYogaWithSchema: configuration => t = "createYoga"
@module("@graphql-yoga/render-graphiql")
external renderGraphiql: graphiqlMiddleware = "renderGraphiql"

@get external graphqlEndpoint: t => string = "graphqlEndpoint"
