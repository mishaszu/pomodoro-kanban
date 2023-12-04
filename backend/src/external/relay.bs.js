// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var GraphqlRelay = require("graphql-relay");

var newConnctionArgsFun = ((connectionArgs) => ({...connectionArgs}));

function newConnectionArgs(param) {
  return newConnctionArgsFun(GraphqlRelay.connectionArgs);
}

function customIdTypeCreator(obj, type_) {
  return type_ + "+" + obj.id;
}

function parseCustomIdType(id) {
  var idArr = id.split("+");
  if (idArr.length !== 2) {
    return ;
  }
  var type_ = idArr[0];
  var id$1 = idArr[1];
  return [
          type_,
          id$1
        ];
}

function parseCustomIdTypeId(id) {
  var match = parseCustomIdType(id);
  if (match !== undefined) {
    return match[1];
  }
  
}

exports.newConnctionArgsFun = newConnctionArgsFun;
exports.newConnectionArgs = newConnectionArgs;
exports.customIdTypeCreator = customIdTypeCreator;
exports.parseCustomIdType = parseCustomIdType;
exports.parseCustomIdTypeId = parseCustomIdTypeId;
/* graphql-relay Not a pure module */
