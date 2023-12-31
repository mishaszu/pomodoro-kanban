// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Express = require("express");
var GraphqlYoga = require("graphql-yoga");
var GraphqlSchema = require("./graphql/graphqlSchema.bs.js");
var RenderGraphiql = require("@graphql-yoga/render-graphiql");

var app = Express();

var yoga = GraphqlYoga.createYoga({
      schema: GraphqlSchema.schema,
      renderGraphiQL: RenderGraphiql.renderGraphiql
    });

app.get("/test", (async function (_req, res) {
        res.send("Hello World!");
      }));

app.use(yoga.graphqlEndpoint, yoga);

app.listen(3000, (function (param) {
        console.log("Server started on port 3000");
      }));

exports.app = app;
exports.yoga = yoga;
/* app Not a pure module */
