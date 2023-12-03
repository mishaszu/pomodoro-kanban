const fs = require('fs');
const { printSchema } = require('graphql');
const schema = require('./src/graphql/graphqlSchema.bs');

fs.writeFileSync('./schema/schema.graphql', printSchema(schema.schema));
