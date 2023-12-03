open Express
open Yoga

let app = newApp()
let yoga = Yoga.createYogaWithSchema({
  schema: GraphqlSchema.schema,
  renderGraphiQL: renderGraphiql,
})

app->get("/test", async (_req, res) => {
  res->Response.send("Hello World!")
})

app->useWithPath(Yoga.graphqlEndpoint(yoga), yoga)

app->listen(3000, () => {
  Js.log("Server started on port 3000")
})
